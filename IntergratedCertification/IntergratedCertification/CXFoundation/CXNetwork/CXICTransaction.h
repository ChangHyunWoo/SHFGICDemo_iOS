//
//  CXICTransaction.h
//  CXICNetwork
//
//  Created by Kalce on 2015. 1. 10..
//  Copyright © 2015년 Cruxware Co., Ltd. All rights reserved.
//


#import <Foundation/Foundation.h>

@class CXICSession;

@interface CXICTransaction : NSObject

@property (readonly, nonatomic) NSString*		identifier;
@property (          nonatomic) BOOL			synchronous;
@property (          nonatomic) BOOL			indicatorEnabled;
@property (strong  , nonatomic) id				delegate;
@property (strong  , nonatomic) NSError*		error;
@property (          nonatomic) NSTimeInterval	timeout;
@property (strong  , nonatomic) NSCondition*	condition;
@property (strong  , nonatomic) NSData*         data;
@property (strong  , nonatomic) NSMutableDictionary*	userInfo;

- (id)initWithDelegate:(id)delegate;
- (void)initialize;
- (void)putUserInfo:(NSString*)key value:(id)value;
- (id)getUserInfo:(NSString*)key;
	
@end

@protocol CXICTransactionDelegate <NSObject>

@optional

- (void)transactionDidCanceled:(CXICTransaction*)transaction;
- (void)transactionDidFailed:(CXICTransaction*)transaction;
- (void)transactionDidFinished:(CXICTransaction*)transaction;

@end
