//
//  CXICNetworkError.h
//  CXICNetwork
//
//  Created by Kalce on 2015. 1. 10..
//  Copyright © 2015년 Cruxware Co., Ltd. All rights reserved.
//

#import "CXICNetworkError.h"

NSString *const CXICNetworkException		= @"CXICNetworkException";
NSString *const CXICNetworkErrorDomain	= @"CXICNetworkErrorDomain";

@implementation CXICNetworkError : NSObject

static CXICNetworkError* __CXICNetworkErrorInstance = nil;

+ (CXICNetworkError*)error {
	if( __CXICNetworkErrorInstance == nil ) {
		@synchronized(self) {
			if(__CXICNetworkErrorInstance == nil) {
				__CXICNetworkErrorInstance = [[self alloc] init];
			}
		}
	}
	
	return __CXICNetworkErrorInstance;
}

+ (void)registerInstance:(CXICNetworkError*)error {
	@synchronized(self) {
		__CXICNetworkErrorInstance = error;
	}
}


- (NSString*)descriptionWithCode:(NSInteger)code detail:(NSString*)detail {
	NSString* string = @"";
	switch (code) {
		case MSConnectionAlreadyConnected		: string = NSLocalizedStringFromTable(@"CXICConnectionAlreadyConnected"	, @"CXICNetwork", @""); break;
		case MSConnectionWANLost				: string = NSLocalizedStringFromTable(@"CXICConnectionWANLost"			, @"CXICNetwork", @""); break;
		case MSConnectionWeakupFailed			: string = NSLocalizedStringFromTable(@"CXICConnectionWeakupFailed"		, @"CXICNetwork", @""); break;
		case MSConnectionTimeout				: string = NSLocalizedStringFromTable(@"CXICConnectionTimeout"			, @"CXICNetwork", @""); break;
		case MSConnectionSocketError			: string = NSLocalizedStringFromTable(@"CXICConnectionSocketError"		, @"CXICNetwork", @""); break;
		case MSConnectionInvalidAddress			: string = NSLocalizedStringFromTable(@"CXICConnectionInvalidAddress"		, @"CXICNetwork", @""); break;
		case MSConnectionInvalidSocket			: string = NSLocalizedStringFromTable(@"CXICConnectionInvalidSocket"		, @"CXICNetwork", @""); break;
		case MSConnectionInvalidCFSocket		: string = NSLocalizedStringFromTable(@"CXICConnectionInvalidCFSocket"	, @"CXICNetwork", @""); break;
		case MSConnectionConnectFailed			: string = NSLocalizedStringFromTable(@"CXICConnectionConnectFailed"		, @"CXICNetwork", @""); break;
		case MSConnectionLinkDead				: string = NSLocalizedStringFromTable(@"CXICConnectionLinkDead"			, @"CXICNetwork", @""); break;
		case CXICSessionInvalidRequest			: string = NSLocalizedStringFromTable(@"CXICSessionInvalidRequest"		, @"CXICNetwork", @""); break;
		case MSTransceiverWasTimeout			: string = NSLocalizedStringFromTable(@"CXICTransceiverWasTimeout"		, @"CXICNetwork", @""); break;
		default : string = @"Invalid error code"; break;
	}
	
	if( [detail length] > 0 ) {
//		string = [NSString stringWithFormat:@"%@ (%@) [CODE:%li]", string, detail, code];
		string = [NSString stringWithFormat:@"%@", detail];
	}
	else {
		string = [NSString stringWithFormat:@"%@ [CODE:%li]", string, (long)code];
	}
	
	return string;
}

+ (NSError*)errorWithCode:(NSInteger)code detail:(NSString*)detail {
	return [NSError errorWithDomain:CXICNetworkErrorDomain
							   code:code
						   userInfo:@{NSLocalizedDescriptionKey:[[CXICNetworkError error] descriptionWithCode:code detail:detail]}];
}

+ (NSException*)exceptionWithCode:(NSInteger)code {
	return [CXICNetworkError exceptionWithCode:code detail:nil];
}

+ (NSException*)exceptionWithCode:(NSInteger)code detail:(NSString*)detail {
	NSError* error = [CXICNetworkError errorWithCode:code detail:detail];
	return [NSException exceptionWithName:CXICNetworkException reason:[error localizedDescription] userInfo:@{@"error":error}];
}

@end
