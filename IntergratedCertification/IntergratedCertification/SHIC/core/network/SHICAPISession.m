//
//  SHICAPISession.m
//  IntergratedCertification
//
//  Created by 60000733 on 2016. 9. 21..
//  Copyright © 2016년 60000720. All rights reserved.
//

#import "NSString+CXICNetwork.h"
#import "SHICAPISession.h"
#import "SHICTransaction.h"
#import "SHICConstants.h"
#import "CXICNetworkError.h"

//#import "SHICAccessTokenTransaction.h"
//#import "SHICAPISessionContainer.h"
//#import "SHICSecureKeyTransaction.h"
//#import "SHICActionAuth.h"
//#import "SHICActionNavigator.h"

#define ERROR_ACCESS_TOKEN_EXPIRED		@"89"
#define ERROR_NON_CUSTOMER				@"90"

static const NSString* __SHICAPISessionSynchronized = @"synchronized";
static const NSString* __SHICAccessTokenSynchronizedBank = @"__SHICAccessTokenSynchronizedBank";
static const NSString* __SHICAccessTokenSynchronizedCard = @"__SHICAccessTokenSynchronizedCard";
static const NSString* __SHICAccessTokenSynchronizedInvestment = @"__SHICAccessTokenSynchronizedInvestment";
static const NSString* __SHICAccessTokenSynchronizedInsurace = @"__SHICAccessTokenSynchronizedInsurace";


@interface SHICAPISession ()

@property (readonly, nonatomic) NSString*   accessToken;
@property (readonly, nonatomic) NSString*   refreshToken;
@property (copy    , nonatomic) void (^completion)(SHICAPISession* session);

@end


@implementation SHICAPISession


+ (SHICAPISession*)defaultSession {
    static SHICAPISession* session = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        session = [[self alloc] init];
    });
    
    return session;
}

- (id)init {
    self = [super init];
    if( self ) {
        _isStatusUpdated = NO;
    }
    
    return self;
}

- (void)reset{
    _isStatusUpdated = NO;
	_accessToken = @"";
	_refreshToken = @"";
    _customer = NO;
	_underconstruction	= NO;
}

- (void)refreshAccessToken {
//	@try {
//		NSString* contentType = [NSString stringWithFormat:@"application/x-www-form-urlencoded;charset=%@", [NSString stringConvertEncodingToIANACharSetName:self.encodingTarget]];
//		SHICAccessTokenTransaction* accessTokenTR = [[SHICAccessTokenTransaction alloc] init];
//        accessTokenTR.category = self._key;
//
//        if([[SHSharedPlatform instance].property[@"customerValidation"] boolValue]) {
//			accessTokenTR.target = [NSString stringWithFormat:@"%@%@", self.target, @"/oauth/accesstoken"];
//		} else {
//			accessTokenTR.target = [NSString stringWithFormat:@"%@%@", self.target, @"/auth/oauth/v2/token"];
//		}
//        
//		[accessTokenTR putValue:contentType forHTTPHeader:@"Content-Type"];
//		
//		//					[tr putValue:SAML forBody:@"assertion"];
//		
//		[accessTokenTR putValue:[SHSharedPlatform instance].property[@"clientID"] forBody:@"client_id"];
//		[accessTokenTR putValue:[SHSharedPlatform instance].property[@"clientSecret"] forBody:@"client_secret"];
//		//					[tr putValue:@"urn:ietf:params:oauth:grant-type:saml2-bearer" forBody:@"grant_type"];
//		[accessTokenTR putValue:@"oob" forBody:@"scope"];
//		
//		if( _refreshToken != nil && _refreshToken.length > 0 ) {
//			SHICLog(@"!!!! Send RefreshToken == %@ !!!!", _refreshToken);
//			
//			[accessTokenTR putValue:_refreshToken forBody:@"refresh_token"];
//			[accessTokenTR putValue:@"refresh_token" forBody:@"grant_type"];
//		} else {
//			[accessTokenTR putValue:[SHICAPISessionContainer defaultContainer].SAMLToken forBody:@"assertion"];
//			[accessTokenTR putValue:@"urn:ietf:params:oauth:grant-type:saml2-bearer" forBody:@"grant_type"];
//		}
//		
//		NSMutableDictionary* parameter = [NSMutableDictionary dictionary];
//		parameter[@"TARGET"] = self._key;
//		
//		[self transmitSynchronousTransaction:accessTokenTR];
//		
//		NSString* category			= accessTokenTR.responseHead[@"category"];
//		NSString* resultCode		= (accessTokenTR.responseHead[@"resultCode"] != nil) ? accessTokenTR.responseHead[@"resultCode"] : @"";
//		NSString* resultMessage		= (accessTokenTR.responseHead[@"resultMessage"] != nil) ? accessTokenTR.responseHead[@"resultMessage"] : @"";
//		
//		_accessToken				= accessTokenTR.responseBody[@"access_token"];
//		_refreshToken				= accessTokenTR.responseBody[@"refresh_token"];
//		
//		if( resultCode != nil && resultCode.length > 0 ) {
//			if( [resultCode isEqualToString:ERROR_NON_CUSTOMER] ) {
//                _isStatusUpdated = YES;
//				_customer        = NO;
//			} else {
//				_underconstruction = YES;
//				@throw [CXNetworkError exceptionWithCode:SHIC_ERROR_ACCESSTOKEN detail:[NSString stringWithFormat:@"[%@:%@] %@", category, resultCode, resultMessage]];
//			}
//		}
//		else {
//			if (_accessToken == nil){
//				_underconstruction = YES;
//				@throw [CXNetworkError exceptionWithCode:SHIC_ERROR_ACCESSTOKEN detail:@"Invalid Access Token"];
//			}
//			
//			if (_refreshToken == nil){
//				_underconstruction = YES;
//				@throw [CXNetworkError exceptionWithCode:SHIC_ERROR_ACCESSTOKEN detail:@"Invalid RefreshToken Token"];
//			}
//			
//            _isStatusUpdated = YES;
//			_customer        = YES;
//		}
//	}
//	@catch (NSException *exception) {
//		_accessToken     = nil;
//		_refreshToken    = nil;
//		_underconstruction = YES;
//		@throw [CXNetworkError exceptionWithCode:SHIC_ERROR_ACCESSTOKEN detail:exception.reason];
//	}
}

- (BOOL)willTransmit:(CXICTransaction*)transaction {
    //return YES;
    
    if (![transaction isKindOfClass:[SHICTransaction class]]) return YES;
    
    SHICTransaction* tr = (SHICTransaction*)transaction;
    
//    NSString* charset = api[@"charset"];
//    if( [charset length] > 0) {
//        charset = [charset uppercaseString];
//        
//        NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(CFStringConvertIANACharSetNameToEncoding((CFStringRef)charset));
//        tr.encodingTarget = encoding;
//        tr.encodingLocal  = encoding;
//    }
    
    //tr.target = [NSString stringWithFormat:@"%@%@", self.target, api[@"url"]];
    tr.target = [NSString stringWithFormat:@"%@%@", self.target, tr.uri];//테스트 URL
    
//    if( [charset length] > 0)
//        [tr putValue:[NSString stringWithFormat:@"application/json;charset=%@", charset] forHTTPHeader:@"Content-Type"];
//    else
        [tr putValue:[NSString stringWithFormat:@"application/json;charset=%@", [NSString stringConvertEncodingToIANACharSetName:self.encodingTarget]] forHTTPHeader:@"Content-Type"];
    
    [tr putValue:[IntCertInterface sharedInstance].property[@"clientID"] forHTTPHeader:@"apikey"];
    return YES;
   
    
//	if (![transaction isKindOfClass:[SHICSecureKeyTransaction class]]) {
//		if (![transaction isKindOfClass:[SHICTransaction class]]) return YES;
//
//		NSString* SAML = nil;
//		SHICTransaction* tr = (SHICTransaction*)transaction;
//		NSDictionary* api = nil;
//		
//		BOOL auth = YES;
//		
//        if( ![tr.code isEqualToString:@"AUTH"] ) {
//            api = [[SHICAPISessionContainer defaultContainer] apiWithCode:tr.code];
//            if( api == nil ) {
//                [NSException raise:@"Exception" format:@"Invalid API [%@]", tr.code];
//            }
//            if( [@"FREE" isEqualToString:api[@"auth"]]){
//                auth = NO;
//            }
//        }
//		
//		if(auth) {
//            
//            @synchronized(__SHICAPISessionSynchronized) {
//                SAML = [SHICAPISessionContainer defaultContainer].SAMLToken;
//                if( SAML == nil || [SAML length] <= 0 ) {
//                    @try {
//                        [[SHICAPISessionContainer defaultContainer] refreshSAML];
//                        SAML = [SHICAPISessionContainer defaultContainer].SAMLToken;
//						[NSThread sleepForTimeInterval:1];
//						
//                    }@catch (NSException *exception) {
//                        @throw [CXNetworkError exceptionWithCode:SHIC_ERROR_UNAUTHORIZED detail:[NSString stringWithFormat:@"%@ SAML request error", exception.reason]];
//                    }
//                }
//            }
//			
//			if( !_underconstruction ) {
//                if( [__key isEqualToString:KEY_BANK] ) {
//                    @synchronized(__SHICAccessTokenSynchronizedBank) {
//                        if( [self.accessToken length] <= 0 ) {
//                            [self refreshAccessToken];
//                        }
//                    }
//                } else if( [__key isEqualToString:KEY_CARD] ) {
//                    @synchronized(__SHICAccessTokenSynchronizedCard) {
//                        if( [self.accessToken length] <= 0 ) {
//                            [self refreshAccessToken];
//                        }
//                    }
//                } else if( [__key isEqualToString:KEY_INVEST] ) {
//                    @synchronized(__SHICAccessTokenSynchronizedInvestment) {
//                        if( [self.accessToken length] <= 0 ) {
//                            [self refreshAccessToken];
//                        }
//                    }
//                } else if( [__key isEqualToString:KEY_INSURANCE] ) {
//                    @synchronized(__SHICAccessTokenSynchronizedInsurace) {
//                        if( [self.accessToken length] <= 0 ) {
//                            [self refreshAccessToken];
//                        }
//                    }
//                }
//			}
//			
//			if(_underconstruction) {
//				@throw [CXNetworkError exceptionWithCode:SHIC_ERROR_UNDERCONSTRUCTION detail:@"Under construction"];
//			}
//		}
//
//        if( api != nil ) {
//            NSString* charset = api[@"charset"];
//            if( [charset length] > 0) {
//                charset = [charset uppercaseString];
//                
//                NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(CFStringConvertIANACharSetNameToEncoding((CFStringRef)charset));
//                tr.encodingTarget = encoding;
//                tr.encodingLocal  = encoding;
//            }
//            
//            tr.target = [NSString stringWithFormat:@"%@%@", self.target, api[@"url"]];
//            
//            if( [charset length] > 0)
//                [tr putValue:[NSString stringWithFormat:@"application/json;charset=%@", charset] forHTTPHeader:@"Content-Type"];
//            else
//                [tr putValue:[NSString stringWithFormat:@"application/json;charset=%@", [NSString stringConvertEncodingToIANACharSetName:self.encodingTarget]] forHTTPHeader:@"Content-Type"];
//                
//            [tr putValue:[SHSharedPlatform instance].property[@"clientID"] forHTTPHeader:@"apikey"];
//
//            if( auth ) {
//                
//                if( _customer == NO )
//                    @throw [CXNetworkError exceptionWithCode:SHIC_ERROR_NONCUSTOMER detail:@"NonCustomer"];
//                    
//                if (_accessToken == nil)
//                    @throw [CXNetworkError exceptionWithCode:SHIC_ERROR_ACCESSTOKEN detail:@"Invalid Access Token"];
//
//                [tr putValue:[NSString stringWithFormat:@"Bearer %@", self.accessToken] forHTTPHeader:@"Authorization"];
//				tr.accessToken = self.accessToken;
//            }
//
//            tr.method = api[@"method"];
//
//            if( api[@"timeout"] != nil ) {
//                double timeout	= [api[@"timeout"] doubleValue];
//                tr.timeout		=  timeout;
//            }
//            
//            if( tr.option[@"timeout"] != nil ) {
//                double timeout	= [tr.option[@"timeout"] doubleValue];
//                tr.timeout		= timeout;
//            }
//            
//            NSDictionary* additional = [[[SHICActionAuth alloc] init] onTransmitWithTarget:self._key];
//            if(additional != nil) {
//                NSDictionary* httpHeader = additional[@"httpHeader"];
//                NSDictionary* dataHeader = additional[@"dataHeader"];
//                NSDictionary* dataBody   = additional[@"dataBody"];
//                
//                
//                NSArray* keys = [httpHeader allKeys];
//                for (NSString* key in keys) {
//                    [tr putValue:httpHeader[key] forHTTPHeader:key];
//                }
//                
//                [tr putForHeaderDictionary:dataHeader];
//                [tr putDictionary:dataBody];
//                
//            } else {
//                if ([self._key isEqualToString:@"BANK"]) {
//                    [tr putValue:[[SHICUser defaultUser] getString:KEY_KEYOWRD] forHeader:@"세션ID"];
//                }else if ([self._key isEqualToString:@"CARD"]) {
//                }else if ([self._key isEqualToString:@"INVESTMENT"]) {
//                }else if ([self._key isEqualToString:@"INSURANCE"]) {
//                }
//            }
//            
//            NSMutableDictionary* parameter = [NSMutableDictionary dictionary];
//            parameter[@"TARGET"] = self._key;
//
//    //		NSDictionary* additional = [action setAdditionalRequestData:parameter];
//    //
//    //		if(additional != nil) {
//    //			NSDictionary* head = additional[@"dataHeader"];
//    //			NSDictionary* body = additional[@"dataBody"];
//    //			
//    //			[tr putForHeaderDictionary:head];
//    //			[tr putDictionary:body];
//    //		}
//        
//            return YES;
//
//        } else {
//            
//            NSDictionary* emptyDic = @{@"dataHeader":@{}, @"dataBody":@{}};
//            NSError *error;
//            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:emptyDic
//                                                               options:NSJSONWritingPrettyPrinted
//                                                                 error:&error];
//            [self incomingResponse:jsonData ofIdentifier:tr.identifier];
//        }
//    } else {
//        return YES;
//    }
//	
//    return NO;
}

- (BOOL)willResponse:(CXICTransaction*)transaction {
	if(!([transaction isKindOfClass:[SHICTransaction class]])) {
		return true;
	}
	
	SHICTransaction* tr = (SHICTransaction*)transaction;
	if( tr.responseHead != nil ) {
		NSDictionary* header = tr.responseHead;
		
		NSString* category = header[@"category"];
		NSString* successCode = [NSString stringWithFormat:@"%d", [header[@"successCode"] intValue]];
		NSString* resultCode = nil;
		
		if ([header[@"resultCode"] isKindOfClass:[NSString class]]) {
			resultCode = header[@"resultCode"];
		}else if ([header[@"resultCode"] isKindOfClass:[NSNull class]]) {
			resultCode = @"";
		}else{
			resultCode = [NSString stringWithFormat:@"%d", [header[@"resultCode"] intValue]];
		}
		
		if (successCode == nil ) successCode = @"0";
		if (resultCode == nil ) resultCode = @"0";

		if (![successCode isEqualToString:@"0"]) {
			if( [@"G/W" isEqualToString:category] ) {
				if( [ERROR_ACCESS_TOKEN_EXPIRED isEqualToString:resultCode] ) {
                    if( [__key isEqualToString:SHIC_KEY_BANK] ) {
                        @synchronized(__SHICAccessTokenSynchronizedBank) {
                            if([self.accessToken isEqualToString:tr.accessToken] ) {
                                _accessToken = @"";
                                [self refreshAccessToken];
                            }
                        }
                    } else if( [__key isEqualToString:SHIC_KEY_CARD] ) {
                        @synchronized(__SHICAccessTokenSynchronizedCard) {
                            if([self.accessToken isEqualToString:tr.accessToken] ) {
                                _accessToken = @"";
                                [self refreshAccessToken];
                            }
                        }
                    } else if( [__key isEqualToString:SHIC_KEY_INVEST] ) {
                        @synchronized(__SHICAccessTokenSynchronizedInvestment) {
                            if([self.accessToken isEqualToString:tr.accessToken] ) {
                                _accessToken = @"";
                                [self refreshAccessToken];
                            }
                        }
                    } else if( [__key isEqualToString:SHIC_KEY_INSURANCE] ) {
                        @synchronized(__SHICAccessTokenSynchronizedInsurace) {
                            if([self.accessToken isEqualToString:tr.accessToken] ) {
                                _accessToken = @"";
                                [self refreshAccessToken];
                            }
                        }
                    }
					
					[tr putForOptionDictionary:@{@"indicator":@(NO), @"errorPopup":(tr.option[@"errorPopup"] == nil) ? @(YES) : @([tr.option[@"errorPopup"] boolValue])}];
					[self transmitTransaction:tr];
					return NO;
				}else{
					_underconstruction = YES;
					@throw [CXICNetworkError exceptionWithCode:SHIC_ERROR_GATEWAY detail:header[@"resultMessage"]];
				}
			} else {
				@throw [CXICNetworkError exceptionWithCode:SHIC_ERROR_API detail:header[@"resultMessage"]];
			}
		}
	}
	
	return true;
}

- (NSString*)stringForError:(NSError*)error {
    switch (error.code) {
        case SHIC_ERROR_UNAUTHORIZED :{
            return @"회원정보 확인중 오류가 발생 하였습니다.\n다시 로그인 후 거래 해주시기 바랍니다.";
        }break;
            
        case SHIC_ERROR_UNDERCONSTRUCTION :{
            return @"서비스 지연으로 이용에 불편을 드려 죄송합니다.\n잠시후 서비스를 이용해 주시길 바랍니다.";
        }break;
            
        case SHIC_ERROR_GATEWAY :{
            return @"서비스 지연으로 이용에 불편을 드려 죄송합니다.\n잠시후 서비스를 이용해 주시길 바랍니다.";
        }break;
            
        case SHIC_ERROR_ACCESSTOKEN : {
            return @"서비스 지연으로 이용에 불편을 드려 죄송합니다.\n잠시후 서비스를 이용해 주시길 바랍니다.";
        }break;
            
        case NSURLErrorTimedOut :{
            return @"서버와의 응답이 지연되고 있습니다.";
        }break;
            
        case SHIC_ERROR_API : {
            return [error localizedDescription];
        }break;
            
        case NSURLErrorCannotConnectToHost :
        case NSURLErrorNetworkConnectionLost :
        case NSURLErrorNotConnectedToInternet :{
            return @"서버에 접속 할 수 없습니다.";
        }break;
    }
    
    return @"처리중 오류가 발생 하였습니다.\n잠시후 서비스를 이용해 주시길 바랍니다.";
}
//
//- (void)updateAuthWithCompletion:(void (^ __nullable)(SHICAPISession* session))completion {
//    if( self.isStatusUpdated ) {
//        if( completion != nil ) {
//            completion(self);
//            return;
//        }
//    }
//    
//    self.completion = completion;
//    
//    SHICTransaction* tr = [[SHICTransaction alloc] initWithDelegate:self];
//    [tr putForOptionDictionary:@{@"errorPopup":@(NO)}];
//    
//    tr.code = @"AUTH";
//    [self transmitTransaction:tr];
//}
//
//#pragma mark - CXTransactionDelegate
//
//- (void)transactionDidCanceled:(CXICTransaction*)transaction {
//    SHICTransaction* tr = (SHICTransaction*)transaction;
//    if( [tr.code isEqualToString:@"AUTH"] ) {
//        if( self.completion != nil ) {
//            self.completion(self);
//        }
//    }
//}
//
//- (void)transactionDidFailed:(CXICTransaction*)transaction {
//    SHICTransaction* tr = (SHICTransaction*)transaction;
//    if( [tr.code isEqualToString:@"AUTH"] ) {
//        if( self.completion != nil ) {
//            self.completion(self);
//        }
//    }
//}
//
//- (void)transactionDidFinished:(CXICTransaction*)transaction {
//    SHICTransaction* tr = (SHICTransaction*)transaction;
//    if( [tr.code isEqualToString:@"AUTH"] ) {
//        if( self.completion != nil ) {
//            self.completion(self);
//        }
//    }
//}


@end
