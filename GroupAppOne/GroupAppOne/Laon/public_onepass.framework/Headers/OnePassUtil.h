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
+ (NSString *)randomAlphanumericStringWithLength:(NSInteger)length;
+ (void)opLog:(NSString*)format, ...;
+ (void)opLog:(const char*)funcName line:(int)line :(NSString*)format, ... ;
+ (void) printBin: (NSString*)title bytes:(char *)bytes len:(int)len;

+ (NSMutableDictionary *)explodeToDictionaryInnerGlue_base64_2:(NSString *)inputStr innerGlue:(NSString *)innerGlue outterGlue:(NSString *)outterGlue;
+ (NSInteger)deviceAvailableState:(NSArray*)aaidList;
+ (NSInteger)checkDeviceAvailable:(NSArray*)aaidList;
+ (NSInteger)canUseOnePassSDK:(NSArray*)aaidList;
+ (NSInteger)canUseFingerPrintAuthenticator;

+ (void)deleteKeychain;

+ (BOOL)isTouchIDReg;
+ (NSInteger)touchidAvailableState;
+ (NSDictionary*)getTelephonyInfo;
+ (NSString *)getTelecomString;
+ (NSDictionary*)getOsInfo;
+ (BOOL)isIPhoneX;
+ (NSString *)stringFromJsonDictionary:(NSDictionary *)dict;

+ (void)returnOnePassMessageWithResponseDic:(NSDictionary *)responseDic;
+ (void)returnOnePassMessageForDic:(NSDictionary *)dic;
+ (NSString *)getHMacForData:(NSString *)data key:(NSString *)key;
+ (NSString *) hashString :(NSString *) data withSalt: (NSString *) salt;
+ (void)alert:(NSString*)format, ...;

+ (ONEPASS_OPERATION)operationForReqBizType:(BIZ_REQ_COMMAND_TYPE)bizReqCommandType;

@end
