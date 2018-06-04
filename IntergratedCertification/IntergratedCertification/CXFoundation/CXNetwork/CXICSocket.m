//
//  CXICSocket.m
//  CXICNetwork
//
//  Created by Kalce on 2015. 1. 10..
//  Copyright © 2015년 Cruxware Co., Ltd. All rights reserved.
//

#import "CXICSocket.h"
#import "CXICNetworkError.h"

#import <sys/types.h>
#import <sys/socket.h>
#import <netinet/in.h>
#import <netinet6/in6.h>
#import <arpa/inet.h>
#import <ifaddrs.h>
#import <netdb.h>
#import <errno.h>
//#import "SHSPConstants.h"

@interface CXICSocket () {
	int					_nativeSocket;
	CFSocketRef			_socketCF;
	
	NSThread*			_receiveThread;
	
	NSTimer*			_keepAliveTimer;
	NSTimer*			_timeoutTimer;
}

@end

@implementation CXICSocket

- (id)init {
	self = [super init];
	if( self ) {
		_identifier 					= [[NSUUID UUID] UUIDString];
		_connectionTimeout				= 30;
		_requestTimeout					= 15;
		
		_keepAliveInterval				= 30;
		_linkDeadInterval				= 30;
		
		_isLinked						= NO;
		_latency						= 0;
	}
	
	return self;
}

- (void)dealloc {
	if( _socketCF != NULL )
		CFRelease(_socketCF);
	
	[_receiveThread		cancel];
	_receiveThread = nil;
}

- (NSDictionary*)addressByTargetString:(NSString*)target {
	NSString* ip	= @"";
	NSNumber* port	= [NSNumber numberWithInt:0];
	
	if( [target rangeOfString:@"http"].length != 0 || [target rangeOfString:@"URL"].length != 0 ) {
		NSArray* array = [target componentsSeparatedByString:@"//"];
		if( array.count <= 1 ) {
			@throw [CXICNetworkError exceptionWithCode:MSConnectionInvalidAddress detail:target];
		}
		
		array = [array[1] componentsSeparatedByString:@":"];
		
		NSString* URL = array[0];
	
		struct hostent* hp = gethostbyname([URL cStringUsingEncoding:NSASCIIStringEncoding]);
		
		if( hp == NULL ) {
			@throw [CXICNetworkError exceptionWithCode:MSConnectionInvalidAddress detail:@"DNS error"];
		}
		
		struct sockaddr_in targetAddress;
		memcpy(&targetAddress.sin_addr, hp->h_addr, hp->h_length);
		
		struct KADDRESS {
			union {
				struct { unsigned char s_b1, s_b2, s_b3, s_b4; } S_un_b;
				in_addr_t s_addr;
			};
		};
		typedef struct KADDRESS KADDRESS;
		
		KADDRESS addrtemp;
		
		addrtemp.s_addr = targetAddress.sin_addr.s_addr;
		
		ip   = [NSString stringWithFormat:@"%d.%d.%d.%d"
				,addrtemp.S_un_b.s_b1
				,addrtemp.S_un_b.s_b2
				,addrtemp.S_un_b.s_b3
				,addrtemp.S_un_b.s_b4];
		
		if( array.count > 1 ) {
			port = [NSNumber numberWithInt:[array[1] intValue]];
		}
	} else {
		NSArray* array = [target componentsSeparatedByString:@":"];
		if( array.count <= 0 ) {
			@throw [CXICNetworkError exceptionWithCode:MSConnectionInvalidAddress detail:target];
		}
		
		ip = array[0];
		
		if( array.count > 1 ) {
			port = [NSNumber numberWithInt:[array[1] intValue]];
		}
	}
	
	return @{@"IP":ip, @"PORT":port};
}

- (void)throwError:(NSError*)error {
	if( [_delegate respondsToSelector:@selector(socket:didFailWithError:)] ) {
		[_delegate socket:self didFailWithError:error];
	}
}

- (BOOL)connectWithDelegate:(id)delegate {
	if( _isLinked ) {
		return _isLinked;
	}
	
	NSDictionary*	address	= [self addressByTargetString:self.target];
	int				port	= [address[@"PORT"] intValue];
	NSString*		ip		= address[@"IP"];
	
	_delegate = delegate;
	
	NSException* ex = nil;
	
	while (1) {
		BOOL retry = NO;
		@try {
			[self connectForIP:ip withPort:port];
			_isLinked = YES;

			[_receiveThread cancel];
			// TODO:       .
			
			[_keepAliveTimer invalidate];
			_keepAliveTimer = nil;
			
			_receiveThread = [[NSThread alloc] initWithTarget:self selector:@selector(receiveWorker) object:nil];
			[_receiveThread setName:[NSString stringWithFormat:@"CXICSocket(%@) [%@] receive", self.identifier, self.target]];
			[_receiveThread start];
			
//			[self fireKeepAliveTimer];
			[self performSelectorOnMainThread:@selector(fireKeepAliveTimer) withObject:nil waitUntilDone:NO];
			
			if( [_delegate respondsToSelector:@selector(socketDidConnected:)] ) {
				[_delegate socketDidConnected:self];
			}
		}
		@catch (NSException *exception) {
			NSError* errorInstance = nil;
			if( [exception.name isEqualToString:CXICNetworkException] ) {
				errorInstance = exception.userInfo[@"error"];
				
				switch (errorInstance.code) {
					case MSConnectionWANLost : {
						if( [self wakeup] ) {
							retry = YES;
						}
					}break;
				}
			}
			
//			[self loggingException:exception];
			
			if( [_delegate respondsToSelector:@selector(socket:didFailWithError:)] ) {
				[_delegate socket:self didFailWithError:errorInstance];
			}
			
			if( !retry ) {
				ex			= exception;
				_isLinked	= NO;
			}
		}
		@finally {
			if( !retry )
				break;
		}
	}
	
	if( ex != nil )
		@throw ex;
	
	return _isLinked;
}

- (void)disconnect {
	if( !_isLinked ) {
		return;
	}
	
	@try {
		_isLinked = NO;
		[self closeSocket];
		
		if( [_delegate respondsToSelector:@selector(socketDidDisconnected:)] ) {
			[_delegate socketDidDisconnected:self];
		}
		
		//SHSPLog( @"Connection is disconnected" );
	}
	@catch (NSException *exception) {
		NSError* error = nil;
		if( [exception.name isEqualToString:CXICNetworkException] ) {
			error = exception.userInfo[@"error"];
		}
		
		//SHSPLog( @"Connection disconnect error [%@]", error.localizedDescription );
		
//		[self loggingException:exception];
		
		if( [_delegate respondsToSelector:@selector(socket:didFailWithError:)] ) {
			[_delegate socket:self didFailWithError:error];
		}
	}
	@finally {
		[self reset];
	}
}

- (void)reset {
	_isLinked = NO;
	
	[_receiveThread cancel];
	_receiveThread = nil;
	
	[_keepAliveTimer invalidate];
	_keepAliveTimer = nil;
	
	[_timeoutTimer invalidate];
	_timeoutTimer = nil;
	
	_delegate = nil;
}

- (void)closeSocket {
	if( _nativeSocket != -1 )
		shutdown( _nativeSocket, SHUT_RDWR );
	
	if( _socketCF != NULL ) {
		CFRelease(_socketCF);
		_socketCF = NULL;
	}
	
	if( _nativeSocket != -1 ) {
		close( _nativeSocket );
		_nativeSocket = -1;
	}
}

- (void)keepAliveFinished {
	_latency = _timeoutTimer.timeInterval;
	
	[_timeoutTimer invalidate];
	_timeoutTimer = nil;
	
	[self fireKeepAliveTimer];
}

- (void)fireKeepAliveTimer {
	_keepAliveTimer = [NSTimer scheduledTimerWithTimeInterval:self.keepAliveInterval
													   target:self
													 selector:@selector(keepAliveProcess)
													 userInfo:nil
													  repeats:NO];
}

- (void)keepAliveProcess {
	if( [_delegate respondsToSelector:@selector(socketWillKeepAlive:)] )
		[_delegate socketWillKeepAlive:self];
	
	_timeoutTimer = [NSTimer scheduledTimerWithTimeInterval:self.linkDeadInterval
													 target:self
												   selector:@selector(socketWillTimeout)
												   userInfo:nil
													repeats:NO];
}

- (void)socketWillTimeout {
	[self performSelectorOnMainThread:@selector(throwError:)
						   withObject:[CXICNetworkError errorWithCode:MSConnectionLinkDead detail:nil]
						waitUntilDone:YES];
	
	[self performSelectorOnMainThread:@selector(disconnect) withObject:nil waitUntilDone:NO];
}

- (void)transmitData:(NSData*)data {
	if( !self.isLinked ) return;
	
	if( _nativeSocket != -1 ) {
		int error = [@(send( _nativeSocket, data.bytes, data.length, 0 )) intValue];
		//SHSPLog( @"%d", error );
	}
}

- (void)connectForIP:(NSString*)ip withPort:(int)port {
	if( ip == nil ) {
		@throw [CXICNetworkError exceptionWithCode:MSConnectionInvalidAddress detail:self.target];
	}
	
	_nativeSocket = socket( AF_INET, SOCK_STREAM, 0 );
	
	if( _nativeSocket < 0 ) {
		@throw [CXICNetworkError exceptionWithCode:MSConnectionInvalidSocket detail:[NSString stringWithFormat:@"errno:%d", errno]];
	}
	
	int opt_val = 1;
	setsockopt( _nativeSocket, IPPROTO_TCP, 1/*It's Nodealy Number -_-;;*/, &opt_val, sizeof(opt_val) );
	
	const int on = 1;
	setsockopt( _nativeSocket, SOL_SOCKET, SO_REUSEADDR, (const void*)&on, sizeof(on) );
	
	fcntl(_nativeSocket, F_SETFL, O_NONBLOCK);
	
	_socketCF = CFSocketCreateWithNative( kCFAllocatorDefault, _nativeSocket, kCFSocketNoCallBack, NULL, NULL );
	
	if( _socketCF == NULL ) {
		@throw [CXICNetworkError exceptionWithCode:MSConnectionInvalidCFSocket];
	}
	
	struct sockaddr_in targetAddress;
	bzero( &targetAddress, sizeof(targetAddress) );
	
	const char* strTargetIP = [ip cStringUsingEncoding:NSASCIIStringEncoding];
	
	targetAddress.sin_family      = AF_INET;
	targetAddress.sin_port        = htons( port );
	targetAddress.sin_addr.s_addr = inet_addr( strTargetIP );
	
	CFDataRef     addressData = CFDataCreate( NULL, (UInt8*)&targetAddress, sizeof( struct sockaddr_in ) );
	CFSocketError error       = CFSocketConnectToAddress( _socketCF, addressData, self.connectionTimeout );
	
	if( addressData != NULL )
		CFRelease( addressData );
	
	switch (error) {
		case kCFSocketError		: {
			if( _socketCF != NULL )
				CFRelease(_socketCF);
			
			if( _nativeSocket != -1 ) {
				close( _nativeSocket );
				_nativeSocket = -1;
			}
			
			int error = errno;
			switch(error) {
				case EHOSTUNREACH :
					@throw [CXICNetworkError exceptionWithCode:MSConnectionWANLost detail:[NSString stringWithFormat:@"%@:%d", ip, port]];
					break;
					
				default :
					@throw [CXICNetworkError exceptionWithCode:MSConnectionSocketError detail:[NSString stringWithFormat:@"errno:%d", error]];
					break;
			}
		}break;
			
		case kCFSocketTimeout	: {
			@throw [CXICNetworkError exceptionWithCode:MSConnectionTimeout];
		}break;
			
		default: break;
	}
}

- (void)receiveWorker {
	int            receiveSize   = 0;
	unsigned char  receiveBuffer[8192];
	
	int			   cursor        = 0;
	int			   remainSize    = 0;
	
	NSMutableData* stream = nil;
	
	while(1) {
		if( !self.isLinked ) {
			stream = nil;
			break;
		}
		
		memset( receiveBuffer, 0, 8192 );
		receiveSize = (int)recv( _nativeSocket, receiveBuffer, 8192, 0 );
		
		if( receiveSize <= 0 ) {
			if( self.isLinked ) {
				switch(errno) {
						/*case ENETRESET	  :
						 case ECONNABORTED :
						 case ECONNRESET	  :*/
						
					case EWOULDBLOCK  :	break;
					case ETIMEDOUT    : break; //     ?
						
					case ECONNRESET   :
					case ECONNABORTED : {
						if( self.isLinked ) {
//							if( self.exceptionLogEnabled )
								//SHSPLog( @"Link Dead[Code:%d]", errno );
							
							_isLinked = NO;
							if( [_delegate respondsToSelector:@selector(socketDidDisconnected:)] ) {
								[_delegate performSelectorOnMainThread:@selector(socketDidDisconnected:) withObject:self waitUntilDone:YES];
							}
							
							[self performSelectorOnMainThread:@selector(throwError:)
												   withObject:[CXICNetworkError errorWithCode:MSConnectionLinkDead detail:nil]
												waitUntilDone:YES];
							
							[self closeSocket];
							[self reset];
						}
					}break;
						
					default           : {
						if( self.isLinked ) {
//							if( self.exceptionLogEnabled )
								//SHSPLog( @"Receive Error[Code:%d]", errno );
							
							_isLinked = NO;
							if( [_delegate respondsToSelector:@selector(socketDidDisconnected:)] ) {
								[_delegate performSelectorOnMainThread:@selector(socketDidDisconnected:) withObject:self waitUntilDone:YES];
							}
							
							[self performSelectorOnMainThread:@selector(throwError:)
												   withObject:[CXICNetworkError errorWithCode:MSConnectionLinkDead detail:nil]
												waitUntilDone:YES];
							[self closeSocket];
							[self reset];
						}
					}break;
				}
			}
			
			if( !self.isLinked ) {
				stream = nil;
				break;
			}
			
			[NSThread sleepForTimeInterval:0.01];
			continue;
		}
		
		if( stream == nil ) stream = [[NSMutableData alloc] init];
		[stream appendBytes:receiveBuffer length:receiveSize];
		
		remainSize = (int)stream.length;
		cursor     = 0;
		
		if( [_delegate respondsToSelector:@selector(socket:receivedData:)] ) {
			while(remainSize > 0)
			{
				NSInteger parsing = [_delegate socket:self receivedData:[NSData dataWithBytes:((const char*)stream.bytes) + cursor length:remainSize]];
				if( parsing == 0 )
					break;
				
				if( parsing < 0 ) { // error
					remainSize = 0;
					break;
				}
				
				remainSize -= parsing;
				cursor     += parsing;
			}
		}
		else {
			remainSize = 0;
		}
		
		if( remainSize > 0 ) {
			const char* temp = (const char*)stream.bytes;
			NSMutableData* remain = [[NSMutableData alloc] initWithBytes:temp + cursor length:remainSize];
			stream = remain;
		}
		else {
			stream = nil;
		}
		
		[NSThread sleepForTimeInterval:0.005];
		if( [_receiveThread isCancelled] ) {
			stream = nil;
			break;
		}
	}
	
	[NSThread exit];
}

- (BOOL)wakeup {
	return YES;
}

@end
