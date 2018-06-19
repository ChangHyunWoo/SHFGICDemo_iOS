//
//  onepassIosSdk.h
//  onepassIosSdk
//
//  Created by mins on 2016. 1. 14..
//  Copyright © 2016년 h. All rights reserved.
//

#ifndef onepassIosSdk_h
#define onepassIosSdk_h

#import <UIKit/UIKit.h>
#import "OnePassDefine.h"
#import "OnePassUaf.h"
#import "OnePassErrorCode.h"
#import <onepassIosSdkfull_framework/OnepassIosSdkfull_Support.h>
#import "OPAuthKeyManager.h"

@protocol OnePassMangerAppDelegate <NSObject>
- (void)receiveOnePassMessage:(NSDictionary *)msgDict;
@end

@interface OnePassManager :NSObject {
}

#define AUTHENTICATOR_TYPE_PRESENCE @"01"
#define AUTHENTICATOR_TYPE_FINGERPRINT @"02"
#define AUTHENTICATOR_TYPE_PASSCODE @"04"
#define AUTHENTICATOR_TYPE_VOICEPRINT @"08"
#define AUTHENTICATOR_TYPE_FACEPRINT @"16"
#define AUTHENTICATOR_TYPE_LOCATION @"32"
#define AUTHENTICATOR_TYPE_EYEPRINT @"64"
#define AUTHENTICATOR_TYPE_PATTERN @"128"
#define AUTHENTICATOR_TYPE_HANDPRINT @"256"
#define AUTHENTICATOR_TYPE_NONE @"512"

@property (nonatomic, retain) NSString *server_uaf_request;
@property (nonatomic, retain) NSString *server_uaf_response;
@property (nonatomic, retain) NSString *server_job_request;
@property (nonatomic, retain) NSString *server_service_request;
@property (nonatomic, retain) NSString *deviceId;
@property (nonatomic, retain) NSString *userId;
@property (nonatomic, retain) NSString *facetId;
@property (nonatomic, retain) NSString *transactionText;
@property (nonatomic, retain) NSString *tranData;
@property (nonatomic, retain) NSString *trId;
@property (nonatomic, retain) NSString *svcId;
@property (nonatomic, retain) NSString *siteId;
@property (nonatomic, retain) NSString *deviceToken;
@property (nonatomic, retain) id delegate;

@property BOOL requstFlag;
@property (nonatomic, retain) NSString *touchIdStr;
@property int operation;
@property (nonatomic, retain) NSString *hpNum;

@property (nonatomic, retain) NSString *customChallenge;
@property (nonatomic, retain) NSString *authenticatorType;

@property (nonatomic, retain) NSDictionary *issueInfo;

@property (nonatomic, retain) NSString *issueType;
@property (nonatomic, retain) NSString *refNum;
@property (nonatomic, retain) NSString *authCode;
@property (nonatomic, retain) NSString *caCode;
@property (nonatomic, retain) NSString *caCert;
@property (nonatomic, retain) NSString *tranHash;
@property (nonatomic, retain) NSData   *plainDataToCompare;
@property (nonatomic, retain) NSArray  *plainDataListToCompare;
@property (nonatomic, readwrite) BOOL isPlainDataVisible;
@property (nonatomic, readwrite) NSUInteger characterSet;

@property (nonatomic, retain) NSData *plainData;

@property (nonatomic, readwrite) BOOL isUseSamePin;
@property (nonatomic, readwrite) BOOL isUseConsecutivePin;
@property int pinMaxLength;


+ (OnePassManager*) sharedSingleton;
- (void)setTouchIdString:(NSString *)touchIdString;
- (void)setInitInfo:(NSString*)serverUrl delegate:(id)delegate;
- (void)setInitInfo:(NSString*)serverUrl siteId:(NSString*)siteId serviceId:(NSString*)serviceId userId:(NSString *)userId delegate:(id)delegate;
- (void)setInitInfo:(NSString*)serverUrl siteId:(NSString*)siteId serviceId:(NSString*)serviceId userId:(NSString *)userId delegate:(id)delegate hpNum:(NSString *)hpNum;


//[Onepass Protocol]
- (BOOL)requestWithTrId:(NSString*)trId;
//- (BOOL)requestWithTrId:(NSString*)trId plainData:(NSData *)plainData; //added 1.0.18 //deprecated 1.0.18
- (BOOL)requestWithTrId:(NSString*)trId operation:(ONEPASS_OPERATION)operation; //deprecated 1.0.18

- (BOOL)requestWithQRCode:(NSString*)inputData;
- (BOOL)requestWithPush:(NSDictionary*)inputDic;

- (void)setLoadingViewController:(UIViewController *)loadingVC;
- (void)setIsHidingLoadingView:(BOOL)isHiding;

- (void)getPlainData:(NSString *)trid;

- (void)setPlainDataVisible:(BOOL)isVisible characterSet:(NSUInteger)characterSet;

- (void)sendFailResultToServerWithOperation:(ONEPASS_OPERATION)operation;

//[util]
- (NSString *)getVersion;
- (void)setTouchidChangeForbid;
- (void)canChangeFingerPrintState:(BOOL)allow;

//[AuthToken]
- (void)saveToken:(NSString *)token tokenKey:(NSString*)tokenKey authenticatorType:(NSString *)authenticatorType;
- (void)getTokenForKey:(NSString *)tokenKey authenticatorType:(NSString *)authenticatorType success:(void(^)(NSString *token))success;
- (NSInteger)checkTokenForKey:(NSString *)tokenKey;
- (void)deleteTokenForKey:(NSString *)tokenKey;
- (void)deleteTokenAll;
- (NSDictionary *)doRemainingWorkForAuthToken:(NSInteger)workType;

//[BioCert]
- (BOOL)deleteBioCertDBAll;

- (void)setLog:(bool)flag;

//[PIN Policy]
- (void)setUseSamePin:(BOOL)isUseSamePin;
- (void)setUseConsecutivePin:(BOOL)isUseConsecutivePin;
- (void)setPinMaxLength:(int)length;

@end

#endif /* onepassIosSdk_h */
