//
//  NSObject+UerInfo.h
//  GroupAppOne
//
//  Created by INBEOM on 2018. 3. 12..
//  Copyright © 2018년 두베아이맥. All rights reserved.
//

#import <Foundation/Foundation.h>

#define USERINFO_DEVICEUESRINFO @"DeviceUserInfo"// 기기에 관리되는 유저정보 저장 UserDefault

@interface  UserInfo:NSObject


@property (nonatomic,strong) NSString* userName;
@property (nonatomic,strong) NSString* userCI;
@property (nonatomic,strong) NSString* KEY_CI;
@property (nonatomic,strong) NSString* KEY_ICID;
@property (nonatomic,strong) NSString* KEY_NAME;
@property (nonatomic,strong) NSString* KEY_AGREE;
@property (nonatomic,strong) NSString* KEY_LOGIN;
@property (nonatomic,strong) NSString* KEY_LOGIN_TYPE;

//전자서명 거래원문 값.
@property (nonatomic,strong) NSString* ElectronicSignData;



-(NSArray*)getUserList;
-(NSString*)getUserCI:(NSString*)userName;
-(void)clearICList;


//유저정보 관리.
+(void)saveUesrInfo:(NSDictionary*)dicUserInfo;
+(NSMutableDictionary*)getUserInfo;
+(void)removeUserInfo;


//지문 체크 후 단계 진행
+(void)checkFingerRegist:(UIViewController*)target setDelegate:(id)delegate;

//extern NSString * const KEY_ISREGISTFIDO;//지문 등록 여부
//extern NSString * const KEY_CI;
//extern NSString * const KEY_ICID;
//extern NSString * const KEY_NAME;
//extern NSString * const KEY_AGREE;
//extern NSString * const KEY_LOGIN;


@end
