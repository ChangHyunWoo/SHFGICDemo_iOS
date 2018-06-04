//
//  CXICSocket.h
//  CXICNetwork
//
//  Created by Kalce on 2015. 1. 10..
//  Copyright © 2015년 Cruxware Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CXICSocket : NSObject

@property (readonly, nonatomic) NSString*		identifier;
@property (readonly, nonatomic) id				delegate;

@property (strong  , nonatomic) NSString*		target;

@property (          nonatomic) NSTimeInterval	connectionTimeout;
@property (          nonatomic) NSTimeInterval	requestTimeout;

@property (          nonatomic) NSTimeInterval	keepAliveInterval;
@property (          nonatomic) NSTimeInterval	linkDeadInterval;

@property (readonly, nonatomic) NSMutableData*	streamBuffer;

@property (readonly, nonatomic) BOOL			isLinked;
@property (readonly, nonatomic) NSTimeInterval	latency;

- (BOOL)connectWithDelegate:(id)delegate;
- (void)disconnect;
- (void)keepAliveFinished;

- (void)transmitData:(NSData*)data;

@end

@protocol CXICSocketDelegate <NSObject>

- (void)socket:(CXICSocket*)socket didFailWithError:(NSError*)error;

- (void)socketWillKeepAlive:(CXICSocket*)socket;

- (void)socketDidConnected:(CXICSocket*)socket;
- (void)socketDidDisconnected:(CXICSocket*)socket;

- (NSInteger)socket:(CXICSocket*)socket receivedData:(NSData*)data;

@end
