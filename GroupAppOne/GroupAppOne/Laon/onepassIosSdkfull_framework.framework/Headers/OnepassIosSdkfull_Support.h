//
//  OnepassIosSdkfull_Support.h
//  onepassIosSdkfull
//
//  Created by raon on 2016. 1. 29..
//  Copyright © 2016년 h. All rights reserved.
//

#import <Foundation/Foundation.h>

#define JSON_KEY_RESULT_CODE @"result_code"
#define JSON_KEY_RESULT_MESSAGE @"result_message"
#define JSON_KEY_RESULT_P7SIGN_DATA @"p7SignedData"
#define JSON_KEY_RESULT_P7SIGN_DATA_LIST @"p7SignedDataList"
#define JSON_KEY_RESULT_PDFSIGN_DATA @"pdfSignedData"
#define JSON_KEY_RESULT_PDFSIGN_DATA_LIST @"pdfSignedDataList"
#define JSON_KEY_RESULT_R_VALUE @"RValue"

@protocol RpUafDelegate <NSObject>
- (void)support_openURL_clientToRp:(NSURL *)url;
- (void)support_setSelectedAaid:(NSString *)aaid;
- (void)support_setDeregAaid:(NSString *)aaid;
- (void)support_setDeregKeyId:(NSString *)keyId;
- (void)support_setSelectedKeyId:(NSString *)keyId;
@end

@protocol RpManagerDelegate <NSObject>
- (NSString*)support_getTouchIDStr;
- (NSString*)support_getFaceLicense;
//- (NSArray*)support_getAuthnrSetList;
- (NSInteger)support_getKeychainUtilsAccessFlag;
- (NSInteger)support_changeAuthnrFlag;
- (BOOL)support_getUseSamePin;
- (BOOL)support_getUseConsecutivePin;
- (int)support_getPinMaxLength;
- (BOOL) support_isIPhoneX;
- (BOOL) support_isExistAaidFaceId;
@end


@interface OnepassIosSdkfull_Support : NSObject

@property (nonatomic, strong) id<RpUafDelegate> m_uafDelegate;
@property (nonatomic, strong) id<RpManagerDelegate> m_managerDelegate;


+ (id)sharedInstance;
- (void)setUAFdele:(id)dele1 ManagerDele:(id)dele2;

//FIDOClient에서 RPClient의 SDK형태를 지원하기 위해 통신하는 함수 (Not use x-callback)
+ (BOOL) openURL_rpToClient:(NSURL *)url;
- (BOOL) openURL_clientToRp:(NSURL *)url;


//인증장치의 TouchID 안내 String을 호출하는 함수 (함수 호출 전, OnePassManager.touchidStr가 세팅되어 있어야 한다.) / FC에서 사용
- (NSString*) getTouchIDStr;
- (NSString*) getIsItYouLicense;
+ (NSArray*) getAuthnrSetList;
- (NSInteger) getKeychainUtilsAccessFlag;
- (void) setSelectedAaid:(NSString *)aaid;
- (void) setSelectedKeyId:(NSString *)keyId;
- (void) setDeregAaid:(NSString *)aaid;
- (void) setDeregKeyId:(NSString *)keyId;

- (BOOL) getUseSamePin;
- (BOOL) getUseConsecutivePin;
- (int) getPinMaxLengthFromOnePassManager;
- (int) getPinMaxLengthFromTKtoAsmProc;

- (BOOL) isIPhoneX;
- (BOOL) isExistAaidFaceId;



//인증장치의 Setting를 호출하는 함수 (Not use OpenSetting Operation) / RP에서 사용
+ (void) openView_openSetting:(NSString *)aaid;


//Authnr목록얻어오는 함수(Not use Discovery Operation) / RP에서 사용
+(NSMutableArray *) getAuthenticatorInDevice:(NSString *)appId;

@end
