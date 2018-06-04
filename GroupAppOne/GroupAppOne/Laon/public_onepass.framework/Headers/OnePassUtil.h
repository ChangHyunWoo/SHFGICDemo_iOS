//
//  OnePassUtil.h
//  public_onepass
//
//  Created by ChoiEliot on 2016. 4. 18..
//  Copyright © 2016년 RAONSECURE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OnePassDefine.h"

@interface OnePassUtil : NSObject

+ (NSString *)UUID;
+ (NSString *)changeIdentifierUUID;
+ (NSString *)randomAlphanumericStringWithLength:(NSInteger)length;
+ (void)opLog:(NSString*)format, ...;
+ (void)opLog:(const char*)funcName line:(int)line :(NSString*)format, ... ;
+ (void) printBin: (NSString*)title bytes:(char *)bytes len:(int)len;

+ (NSMutableDictionary *)explodeToDictionaryInnerGlue_base64_2:(NSString *)inputStr innerGlue:(NSString *)innerGlue outterGlue:(NSString *)outterGlue;
+ (NSInteger)deviceAvailableState:(NSArray*)aaidList;
/** 원패스 지원 가능 여부 체크
 @param (NSArray*)aaidList nil로 넘겨줄 경우 사용 가능 인증장치 체크(AAID 리스트 체크)는 하지 않음.
 @return (NSInteger) 에러코드 참고.
 */
+ (NSInteger)checkDeviceAvailable:(NSArray*)aaidList;
/** 원패스 지원 가능 여부 체크
 @param (NSArray*)aaidList nil로 넘겨줄 경우 사용 가능 인증장치 체크(AAID 리스트 체크)는 하지 않음.
 @return (NSInteger) 에러코드 참고.
 */
+ (NSInteger)canUseOnePassSDK:(NSArray*)aaidList;
/** 지문 등록 및 사용 가능 여부 체크
 @return (NSInteger) 에러코드 참고.
 */
+ (NSInteger)canUseFingerPrintAuthenticator;

/** 라이브러리에서 사용하는 키체인 저장 정보를 지우는 함수. 테스트 용도.
 */
+ (void)deleteKeychain;

+ (BOOL)isTouchIDReg;
+ (NSInteger)touchidAvailableState;
+ (NSDictionary*)getTelephonyInfo;
+ (NSString *)getTelecomString;
+ (NSDictionary*)getOsInfo;
+ (BOOL)isIPhoneX;

+ (void)returnOnePassMessageWithResponseDic:(NSDictionary *)responseDic;
+ (void)returnOnePassMessageForDic:(NSDictionary *)dic;
+ (NSString *)getHMacForData:(NSString *)data key:(NSString *)key;
+ (NSString *) hashString :(NSString *) data withSalt: (NSString *) salt;
+ (void)alert:(NSString*)format, ...;

+ (ONEPASS_OPERATION)operationForReqBizType:(BIZ_REQ_COMMAND_TYPE)bizReqCommandType;

@end
