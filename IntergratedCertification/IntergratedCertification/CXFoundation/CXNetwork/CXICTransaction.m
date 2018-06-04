//
//  CXICTransaction.m
//  CXICNetwork
//
//  Created by Kalce on 2015. 1. 10..
//  Copyright © 2015년 Cruxware Co., Ltd. All rights reserved.
//

#import "CXICTransaction.h"
#import "CXICSession.h"

@implementation CXICTransaction

static NSString* __synchronizer = @"__synchronizer";
unsigned int __identifierHandler = 0;

- (id)init {
    self  = [super init];
    if( self ) {
        [self initialize];
    }
    
    return self;
}

- (id)initWithDelegate:(id)delegate {
	self = [super init];
	
	if( self ) {
		_delegate		= delegate;
        [self initialize];
	}
	
	return self;
}

- (void)initialize {
	@synchronized (__synchronizer) {
		_identifier		= [NSString stringWithFormat:@"%08x", __identifierHandler];
		_timeout		= 60;
		_synchronous	= NO;
		_indicatorEnabled	= YES;
		self.userInfo	= [NSMutableDictionary dictionary];
		
		__identifierHandler++;
		if( __identifierHandler == 0xffffffff ) {
			__identifierHandler = 0;
		}
	}
}

- (void)putUserInfo:(NSString*)key value:(id)value{
	_userInfo[key] = value;
}

- (id)getUserInfo:(NSString*)key{
	return _userInfo[key];
}

@end
