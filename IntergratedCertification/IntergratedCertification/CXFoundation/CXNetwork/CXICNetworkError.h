//
//  CXICNetworkError.h
//  CXICNetwork
//
//  Created by Kalce on 2015. 1. 10..
//  Copyright © 2015년 Cruxware Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const CXICNetworkException;
extern NSString *const CXICNetworkErrorDomain;

typedef NS_ENUM(NSInteger, CXICNetworkErrorCode) {
	MSConnectionAlreadyConnected,
	MSConnectionWANLost,
	MSConnectionWeakupFailed,
	MSConnectionTimeout,
	MSConnectionSocketError,
	MSConnectionInvalidAddress,
	MSConnectionInvalidSocket,
	MSConnectionInvalidCFSocket,
	MSConnectionConnectFailed,
	MSConnectionLinkDead,
	
	CXICSessionInvalidRequest,
	
	MSTransceiverWasTimeout,
};

@interface CXICNetworkError : NSObject

+ (CXICNetworkError*)error;
+ (void)registerInstance:(CXICNetworkError*)error;

- (NSString*)descriptionWithCode:(NSInteger)code detail:(NSString*)detail;
+ (NSError*)errorWithCode:(NSInteger)code detail:(NSString*)detail;
+ (NSException*)exceptionWithCode:(NSInteger)code;
+ (NSException*)exceptionWithCode:(NSInteger)code detail:(NSString*)detail;

@end
