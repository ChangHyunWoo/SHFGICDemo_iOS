//
//  SHICUser.h
//  IntergratedCertification
//
//  Created by 60000733 on 2016. 9. 21..
//  Copyright © 2016년 60000720. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHICUser : NSObject

@property (strong, nonatomic) NSMutableDictionary* status;

+ (SHICUser*)defaultUser;
- (void)reset;
- (void)put:(NSString*)key value:(id)value;
- (id)get:(NSString*)key;
- (NSString*)getString:(NSString*)key;
- (BOOL)getBoolean:(NSString*)key;
- (NSArray*)getArray:(NSString*)key;
- (BOOL)isLogin;
- (BOOL)isLoginOther;
- (BOOL)isCustomer:(NSString*)target;
- (BOOL)isUnderconstruction:(NSString*)target;

extern NSString * const KEY_ISREGISTFIDO;//지문 등록 여부
extern NSString * const KEY_CI;
extern NSString * const KEY_ICID;
extern NSString * const KEY_KEYOWRD;
extern NSString * const KEY_NAME;
extern NSString * const KEY_AGREE;
extern NSString * const KEY_LOGIN;       //통합로그인
extern NSString * const KEY_LOGIN_OTHER; //통합로그인 외
extern NSString * const KEY_LOGIN_TYPE;
extern NSString * const KEY_LAST_LOGIN_TIME;	//마지막 로그인 시간
extern NSString * const KEY_MEMBER_BANK;		//은행
extern NSString * const KEY_MEMBER_CARD;		//카드
extern NSString * const KEY_MEMBER_INVESTMENT;	//금융
extern NSString * const KEY_MEMBER_INSURANCE;	//생명
extern NSString * const KEY_MEMBER_SALIMI;		//알리미
extern NSString * const KEY_BANK_USER_INFO;		//은행 사용자 정보
extern NSString * const KEY_TARGET_APP_TYPE;	//타겟앱 타입

@end
