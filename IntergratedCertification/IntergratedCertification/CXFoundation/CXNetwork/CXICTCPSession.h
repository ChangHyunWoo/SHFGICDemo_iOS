//
//  CXICTCPSession.h
//  CXICNetwork
//
//  Created by Kalce on 2015. 1. 10..
//  Copyright © 2015년 Cruxware Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <IntergratedCertification/CXICSession.h>
#import <IntergratedCertification/CXICSocket.h>

@interface CXICTCPSession : CXICSession

- (BOOL)isLinked;

- (void)connect;
- (void)disconnect;

- (void)successKeepAlive;
- (void)failedKeepAlive;

- (void)socketWillKeepAlive;
- (NSInteger)socketWillReceivedData:(NSData*)data;

@end

@protocol CXICTCPSessionDelegate <CXICSessionDelegate>

- (void)sessionDidConnected:(CXICTCPSession*)session;
- (void)sessionDidDisconnected:(CXICTCPSession*)session;

@end
