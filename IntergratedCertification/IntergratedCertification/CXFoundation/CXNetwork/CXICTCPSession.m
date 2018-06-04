//
//  CXICTCPSession.m
//  CXICNetwork
//
//  Created by Kalce on 2015. 1. 10..
//  Copyright © 2015년 Cruxware Co., Ltd. All rights reserved.
//

#import "CXICNetworkError.h"
#import "CXICTCPSession.h"
#import "CXICTransaction.h"
//#import "SHSPConstants.h"

@interface CXICTCPSession () {
	CXICSocket*	_socket;
}

@end

@implementation CXICTCPSession

- (id)init {
	self = [super init];
	if( self ) {
		_socket = [[CXICSocket alloc] init];
	}
	
	return self;
}

- (BOOL)isLinked {
	return _socket.isLinked;
}

- (void)connect {
	@try {
		_socket = [[CXICSocket alloc] init];
        _socket.connectionTimeout   = self.connectionTimeout;
		_socket.target              = self.target;
		[_socket connectWithDelegate:self];
		
		if( [self.delegate respondsToSelector:@selector(sessionDidConnected:)] ) {
			[self.delegate performSelectorOnMainThread:@selector(sessionDidConnected:) withObject:self waitUntilDone:NO];
		}
	}
	@catch (NSException *exception) {
		@throw exception;
	}
	@finally {
	}

}

- (void)disconnect {
	[_socket disconnect];
	_socket = nil;
}

- (CXICSessionSendType)doSendingWithTransaction:(CXICTransaction*)transaction {
	[_socket transmitData:transaction.data];
    return CXICSessionSendTypeAsync;
}

- (void)socket:(CXICSocket*)socket didFailWithError:(NSError*)error {
	[self performErrorOnMainThread:error];
}

- (void)successKeepAlive {
	[_socket keepAliveFinished];
}

- (void)failedKeepAlive {
	//SHSPLog( @"failedKeepAlive" );
	
	[_socket disconnect];
}

- (void)socketWillKeepAlive:(CXICSocket*)socket {
	[self socketWillKeepAlive];
}

- (void)socketDidConnected:(CXICSocket*)socket {
	
}

- (void)socketDidDisconnected:(CXICSocket*)socket {
	if( [self.delegate respondsToSelector:@selector(sessionDidDisconnected:)] ) {
		[self.delegate performSelectorOnMainThread:@selector(sessionDidDisconnected:) withObject:self waitUntilDone:NO];
	}
}

- (NSInteger)socket:(CXICSocket*)socket receivedData:(NSData*)data {
	return [self socketWillReceivedData:data];
}

- (void)socketWillKeepAlive {
}

- (NSInteger)socketWillReceivedData:(NSData*)data {
	return data.length;
}

@end
