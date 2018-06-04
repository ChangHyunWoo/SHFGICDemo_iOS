//
//  KeyChainUtils.h
//  fidoclient
//
//  Created by raon on 2015. 10. 29..
//  Copyright © 2015년 SuJungPark. All rights reserved.
//

#import <Foundation/Foundation.h>
#define DEIVCE_UNIQUE_PIN_SUPPORTDATA @"DEIVCE_UNIQUE_PIN_SUPPORTDATA"  //transkey pin 작업 시, encrypt 할 data

@import LocalAuthentication;    // LAContext
@import UIKit;

@interface KeyChainUtils : NSObject

//- (BOOL)addData:(int)index data:(NSData *)data;
- (BOOL)addData:(int)index data:(NSData *)data keyidBase64Url:(NSString*)keyidBase64Url;

- (BOOL)addOpenSDKItem:(NSData *)data;         //KeyChain Item 추가 (openSDK)

//- (void)updatePinItemAsync:(NSData *)data withSucccessBlock:(void (^)(void))successBlock withFailedBlock:(void (^)(void))failedBlock;
- (void)updatePinItemAsync:(NSData *)data keyIdBase64:(NSString*)keyIdBase64  withSucccessBlock:(void (^)(void))successBlock withFailedBlock:(void (^)(void))failedBlock;

//- (void)deletePinItemAsync;                //KeyChain Pwd Item 삭제 (transkey)
- (void)deletePinItemAsyncWithKeyid:(NSData*)keyidData;

- (void)doAsyncTask:(BOOL (^)(void))taskBlock withSucccessBlock:(void (^)(void))successBlock withFailedBlock:(void (^)(int))failedBlock;   //비동기 작업을 해주는 함수

- (void)getDataInKeyChain_Async:(int)index successBlk:(void (^)(NSData *)
                                                       )successBlk failedBlk:(void (^)(int))failedBlk cancelBlk:(void (^)(void))cancelBlk;
- (void)getDataInKeyChain_AsyncTouchID:(void (^)(NSData *))successBlock withFailedBlock:(void (^)(int))failedBlock withCancelBlock:(void (^)(void))CancelBlock;
- (void)getDataInKeyChain_AsyncTouchID107:(void (^)(NSData *))successBlock withFailedBlock:(void (^)(int))failedBlock withCancelBlock:(void (^)(void))CancelBlock;
- (void)getDataInKeyChain_AsyncUnique:(void (^)(NSData *))successBlock withFailedBlock:(void (^)(int))failedBlock withCancelBlock:(void (^)(void))CancelBlock;
- (void)getDataInKeyChain_AsyncPin:(NSString*)keyidBase64Url successBlock:(void (^)(NSData *))successBlock withFailedBlock:(void (^)(int))failedBlock withCancelBlock:(void (^)(void))CancelBlock;
- (void)getDataInKeyChain_AsyncOpenSDK:(void (^)(NSData *))successBlock withFailedBlock:(void (^)(int))failedBlock withCancelBlock:(void (^)(void))CancelBlock;
- (void)getDataInKeyChain_AsyncFaceID0062:(void (^)(NSData *))successBlock withFailedBlock:(void (^)(int))failedBlock withCancelBlock:(void (^)(void))CancelBlock;
- (void)getDataInKeyChain_AsyncSilentAuthenticator:(void (^)(NSData *))successBlock withFailedBlock:(void (^)(int))failedBlock withCancelBlock:(void (^)(void))CancelBlock;

- (void)canEvaluatePolicyWithPassErr:(void (^)(void))SuccessBlock withFailBlock:(void (^)(int))FailBlock;
- (bool)canEvaluatePolicy;      //Touch ID 사용가능 여부 확인

//- (void)canEvaluatePinPolicy:(void (^)(void))okBlock notBlock:(void (^)(void))notBlock;   //Pin 사용가능 여부 확인
- (void)canEvaluatePinPolicy:(NSString*)keyIdBase64 okBlock:(void (^)(void))okBlock notBlock:(void (^)(void))notBlock;

@end
