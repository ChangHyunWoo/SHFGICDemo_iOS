//
//  CXICSession.h
//  CXICNetwork
//
//  Created by Kalce on 2015. 1. 10..
//  Copyright © 2015년 Cruxware Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, CXICSessionSendType) {
    CXICSessionSendTypeSync,
    CXICSessionSendTypeAsync
};


@class CXICTransaction;

@interface CXICSession : NSObject

@property (weak    , nonatomic) id						delegate;
@property (readonly, nonatomic) NSMutableDictionary*	transactions;
@property (strong  , nonatomic) NSString*				target;
@property (          nonatomic) NSTimeInterval          connectionTimeout;

// Session command method //
- (void)cancelAllTransactions;
- (void)transmitTransaction:(CXICTransaction*)transaction;
- (void)transmitSynchronousTransaction:(CXICTransaction*)transaction;
- (void)incomingResponse:(NSData*)response ofIdentifier:(NSString*)identifier;

// Child abstract method //
- (CXICSessionSendType)doSendingWithTransaction:(CXICTransaction*)transaction;
- (BOOL)willTransmit:(CXICTransaction*)transaction;
- (BOOL)willResponse:(CXICTransaction*)transaction;
- (void)performErrorOnMainThread:(NSError*)error;
- (void)willTransmitException:(CXICTransaction*)transaction exception:(NSException*)exception;
- (NSString*)stringForError:(NSError*)error;


@end

@protocol CXICSessionDelegate <NSObject>

@optional

- (void)session:(CXICSession*)session transmitTransaction:(CXICTransaction*)transaction;
- (void)session:(CXICSession*)session incomingTransaction:(CXICTransaction*)transaction;
- (void)session:(CXICSession*)session didFailWithError:(NSError *)error;

@end

