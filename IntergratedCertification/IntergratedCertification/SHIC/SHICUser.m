//
//  SHICUser.m
//  IntergratedCertification
//
//  Created by 60000733 on 2016. 9. 21..
//  Copyright © 2016년 60000720. All rights reserved.
//

#import "SHICUser.h"
#import "SHICConstants.h"

@interface SHICUser(){
	NSMutableDictionary* _status;
}

@end



@implementation SHICUser

NSString * const KEY_CI                 = @"CI";
NSString * const KEY_ICID               = @"ICID";
NSString * const KEY_ISREGISTFIDO       = @"FIDO_REGIST";;//지문 등록 여부
NSString * const KEY_KEYOWRD			= @"KEYOWRD";
NSString * const KEY_NAME				= @"NAME";
NSString * const KEY_AGREE				= @"AGREE";
NSString * const KEY_LOGIN              = @"LOGIN";       //통합로그인
NSString * const KEY_LOGIN_OTHER        = @"LOGIN_OTHER"; //통합로그인 외
NSString * const KEY_LOGIN_TYPE         = @"LOGIN_TYPE"; // NO :PIN | YES :Fido
NSString * const KEY_LAST_LOGIN_TIME	= @"LAST_LOGIN_TIME";
NSString * const KEY_MEMBER_BANK		= @"MEMBER_BANK";
NSString * const KEY_MEMBER_CARD		= @"MEMBER_CARD";
NSString * const KEY_MEMBER_INVESTMENT	= @"MEMBER_INVESTMENT";
NSString * const KEY_MEMBER_INSURANCE	= @"MEMBER_INSURANCE";
NSString * const KEY_MEMBER_SALIMI		= @"MEMBER_SALIMI";
NSString * const KEY_BANK_USER_INFO		= @"BANK_USER_INFO";
NSString * const KEY_TARGET_APP_TYPE	= @"TARGET_APP_TYPE";

+ (SHICUser*)defaultUser {
	static SHICUser* instance = nil;
	static dispatch_once_t oncePredicate;
	dispatch_once(&oncePredicate, ^{
		instance = [[self alloc] init];
	});
	
	return instance;
}

- (NSMutableDictionary*)status{
	SHICLog(@"get status == %@", _status);
	return _status;
}

- (void)setStatus:(NSMutableDictionary *)status{
	SHICLog(@"set status == %@", status);
	_status = status;
}

- (void)reset{
	self.status	= [NSMutableDictionary dictionary];
}

- (void)put:(NSString*)key value:(id)value{
	SHICLog(@"put status == %@ // %@", key, value);
	if (_status == nil) {
		[self reset];
	}
	
	[_status setObject:value forKey:key];
}

- (id)get:(NSString*)key{
	if (_status) {
		if (key != nil) {
			return _status[key];
		}
	}

	return nil;
}

- (NSString*)getString:(NSString*)key{
	if (_status) {
		if (key != nil) {
			if ([_status[key] isKindOfClass:[NSString class]]) {
				return _status[key];
			}else{
				return @"";
			}
		}
	}

	return @"";
}

- (BOOL)getBoolean:(NSString*)key{
	if (_status) {
		if (key != nil) {
			return [_status[key] boolValue];
		}
	}

	return NO;
}

- (NSArray*)getArray:(NSString*)key{
	if (_status) {
		if (key != nil) {
			if ([_status[key] isKindOfClass:[NSArray class]]) {
				return _status[key];
			}
		}
	}

	return [NSArray array];
    }

- (BOOL)isLogin {
    return [_status[KEY_LOGIN] boolValue];
}

- (BOOL)isLoginOther {
    return [_status[KEY_LOGIN_OTHER] boolValue];
}

@end
