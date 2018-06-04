//
//  SHICAPISession.h
//  IntergratedCertification
//
//  Created by 60000733 on 2016. 9. 21..
//  Copyright © 2016년 60000720. All rights reserved.
//

#import "CXICURLSession.h"

typedef NS_ENUM(NSInteger, SHICNetworkErrorCode) {
	SHIC_ERROR_UNAUTHORIZED = 1000,
    SHIC_ERROR_ACCESSTOKEN,
    SHIC_ERROR_NONCUSTOMER,
	SHIC_ERROR_API,
	SHIC_REQUEST_FAILED,
	SHIC_ERROR_UNDERCONSTRUCTION,
	SHIC_ERROR_GATEWAY
};

@interface SHICAPISession : CXICURLSession

@property (nonatomic, strong) NSString* _key;
@property (           assign) BOOL		customer;
@property (           assign) BOOL		underconstruction;
@property (readonly,  assign) BOOL      isStatusUpdated;

+ (SHICAPISession*)defaultSession;

//- (void)updateAuthWithCompletion:(void (^ __nullable)(SHICAPISession* session))completion;
- (void)reset;

@end
