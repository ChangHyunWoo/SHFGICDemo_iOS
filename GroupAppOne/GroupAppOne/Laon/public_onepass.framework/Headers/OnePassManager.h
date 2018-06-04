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
#import "OnePassErrorCode.h"


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
@property (nonatomic) int pinMaxLength;


+ (OnePassManager*) sharedSingleton;
/** 서버 주소, 결과값 반환을 위한 delegate 설정. (인증툴킷 사용 시 사용 못함.)
 */
- (void)setInitInfo:(NSString*)serverUrl delegate:(id)delegate;
/** 인증 툴킷연동등으로 서비스 서버와 바로 통신할 경우 사용.
 */
- (void)setInitInfo:(NSString*)serverUrl siteId:(NSString*)siteId serviceId:(NSString*)serviceId userId:(NSString *)userId delegate:(id)delegate;
/** 사용자 정보(휴대폰번호)가 필요할 경우 사용.
 */
- (void)setInitInfo:(NSString*)serverUrl siteId:(NSString*)siteId serviceId:(NSString*)serviceId userId:(NSString *)userId delegate:(id)delegate hpNum:(NSString *)hpNum;
/** PinBioServerURL 이 필요할 경우 사용.
 */
- (void)setInitInfo:(NSString*)serverUrl siteId:(NSString*)siteId serviceId:(NSString*)serviceId userId:(NSString *)userId delegate:(id)delegate hpNum:(NSString *)hpNum pinBioServerUrl:(NSString *)pinBioServerUrl;


/** trId값으로 원패스 서비스(등록,재등록, 인증,해지 등)를 실행하는 함수.
 @param trId 거래에 필요한 세션 ID
 @return `YES` trid 요청 실행.
 `NO` 중복 실행 등으로 실행 안됨.
 */
- (BOOL)requestWithTrId:(NSString*)trId;
//- (BOOL)requestWithTrId:(NSString*)trId plainData:(NSData *)plainData; //added 1.0.18 //deprecated 1.0.18
- (BOOL)requestWithTrId:(NSString*)trId operation:(ONEPASS_OPERATION)operation; //deprecated 1.0.18

/** pc연동 시 QR code를 스캔한 값으로 원패스 서비스를 실행하는 함수.
 @param inputData QR code를 디코딩한 문자열.
 @return `YES` trid 요청 실행.
 `NO` 중복 실행 등으로 실행 안됨.
 */
- (BOOL)requestWithQRCode:(NSString*)inputData;
/** Push 연동으로 원패스서비스를 실행하는 함수.
 @param inputDic push에서 받은 값
 @return `YES` trid 요청 실행.
 `NO` 중복 실행 등으로 실행 안됨.
 */
- (BOOL)requestWithPush:(NSDictionary*)inputDic;

/** Custom LoadingView 를 사용하기 위해 호출.화면객체를 전달.
 @param (UIViewController*)loadingVC :로딩화면ViewController
 */
- (void)setLoadingViewController:(UIViewController *)loadingVC;
/** Default LoadingView표시여부를 설정. 기본값은 NO(표시).
 @param (BOOL)isHiding :Default LoadingView 표시 여부.
 */
- (void)setIsHidingLoadingView:(BOOL)isHiding;
/** 거래원문 요청하는 함수
 @param (NSString *)trid : trid
 */
- (void)getPlainData:(NSString *)trid;
- (void)getTransactionContent:(NSString *)trid;

/** 원문비교를 위한 원문데이터 설정
 @param (NSData *)plainDataToCompare:원문 데이터.
 */
- (void)setPlainDataVisible:(BOOL)isVisible characterSet:(NSUInteger)characterSet;

- (void)sendFailResultToServerWithOperation:(ONEPASS_OPERATION)operation;

/** TouchId 창에서 사용자에게 보여줄 문구.
 @param touchIdString TouchId 창에서 사용자에게 보여줄 문구.
 */
- (void)setTouchIdString:(NSString *)touchIdString;
/** 원패스 iOS 라이브러리의 버전.
 */
- (NSString *)getVersion;
/** 지문 변경(추가, 제거 등) 시 사용 가능 여부 설정.
 지문 변경할 경우 ERROR_WRAPKEY(-16)에러 발생.
 */
- (void)setTouchidChangeForbid;
/** 지문 변경(추가, 제거 등) 시 사용 가능 여부 설정.
 지문 변경할 경우 ERROR_WRAPKEY(-16)에러 발생.
 @param allow Allow : YES 일 경우 변경이 허용 됨.
 NO 일 경우 변경이 금지 됨. 지문 변경 시 재등록 필요.
 아무 설정을 안 할 경우 지문 변경(추가, 제거)이 금지 됨.
 */
- (void)canChangeFingerPrintState:(BOOL)allow;
/** device id 저장하는 키체인 영역을 바꿈. device id 변경등 이상동작이 있을 경우 사용.
 */
- (void)changeDeviceId;

/** fido 키를 저장하는 db의 경로를 바꿈. 기본적으로 NSDocumentDirectory 의 경로를 사용.
 @param oldNSSearchPathDirectory : 기존 경로. 0을 입력하면 NSDocumnetDirectory. NSSearchPathForDirectoriesInDomains 의 NSSearchPathDirectory directory 파라미터 참고.
 newNSSearchPathDirectory : 원하는 경로를 지정. 0을 입력하면 NSLibraryDirectory.
 @return `YES` db 파일 옮기기 성공.
 `NO` db 파일 옮기기 실패. 로그 메시지 참고.
 */
-(BOOL)moveAuthnrDB:(NSInteger)oldNSSearchPathDirectory replaceNSSearchPathDirectory:(NSInteger)replaceNSSearchPathDirectory;

/** 인증툴킷과 연동 할 수 있는 토큰을 저장.
 @param (NSString *)token : 서버에서 받은 토큰값.
 (NSString*)tokenKey : 인증서등 고유값으로 사용할 수 있는 시리얼 값.
 (NSString*)authenticatorType : 토큰 저장에 사용하고자 하는 인증장치를 제약할 경우 사용
 */
- (void)saveToken:(NSString *)token tokenKey:(NSString*)tokenKey authenticatorType:(NSString *)authenticatorType;
/** 인증툴킷과 연동 할 수 있는 저장된 토큰을 가져옴.
 @param (NSString*)tokenKey :인증서등고유값으로 사용할 수 있는 시리얼 값.
 (NSString*)authenticatorType : 토큰 가져올 때 인증장치를 제약할 경우 사용
 (void(^)(NSString *token))success : 성공 시 수행할 코드 입력.
 */
- (void)getTokenForKey:(NSString *)tokenKey authenticatorType:(NSString *)authenticatorType success:(void(^)(NSString *token))success;
/** 입력한 시리얼 넘버에 해당하는 토큰이 있는지 확인.
 @param (NSString*)tokenKey : 인증서등 고유값으로 사용할 수 있는 시리얼 값.
 */
- (NSInteger)checkTokenForKey:(NSString *)tokenKey;
/** 입력한 시리얼 넘버에 해당하는 토큰을 삭제.
 @param (NSString*)tokenKey : 인증서등 고유값으로 사용할 수 있는 시리얼 값.
 */
- (void)deleteTokenForKey:(NSString *)tokenKey;
/** 입력한 시리얼 넘버에 해당하는 토큰을 모두 삭제.
 */
- (void)deleteTokenAll;
- (NSDictionary *)doRemainingWorkForAuthToken:(NSInteger)workType;

//[BioCert]
- (BOOL)deleteBioCertDBAll;

/** 출력창에 로그를 남길지 설정하는 함수.
 @param (bool)flag YES : 로그 남김. NO : 로그를 남기지 않음.
 */
- (void)setLog:(bool)flag;

//[PIN Policy]
/** PIN 인증장치에서 같은 번호(ex. 1111) 사용 여부 설정
 @param (BOOL)isUseSamePin : 같은 번호 사용여부 Flag
 */
- (void)setUseSamePin:(BOOL)isUseSamePin;
/** PIN 인증장치에서 연속적인 번호(ex. 1234) 사용 여부 설정
 @param (BOOL)isUseConsecutivePin : 연속적인 번호 사용여부 Flag
 */
- (void)setUseConsecutivePin:(BOOL)isUseConsecutivePin;
/** PIN 인증장치의 길이 설정
 @param (int)length : 설정할 PIN의 길이
 */
- (void)setPinMaxLength:(int)length;

@end

#endif /* onepassIosSdk_h */
