//
//  SHICTransaction.m
//  IntergratedCertification
//
//  Created by 60000733 on 2016. 11. 18..
//  Copyright © 2016년 60000720. All rights reserved.
//

#import <CommonCrypto/CommonHMAC.h>
#import <CommonCrypto/CommonDigest.h>
#import "SHICTransaction.h"
#import "SHICAPISession.h"
#import "SHICConstants.h"
#import "SHICProperty.h"


@interface SHICTransaction ()

@property (nonatomic, copy   ) void (^finished)(SHICTransaction* tr);
@property (nonatomic, copy   ) void (^failed)(SHICTransaction* tr);
@property (nonatomic, copy   ) void (^cancel)(SHICTransaction* tr);

@end

@implementation SHICTransaction

- (NSMutableDictionary*)requestHead {
	return _request[@"dataHeader"];
}

- (NSMutableDictionary*)requestBody {
	return _request[@"dataBody"];
}

- (NSDictionary*)responseHead {
	return _response[@"dataHeader"];
}

- (NSDictionary*)responseBody {
	return _response[@"dataBody"];
}

- (void)initialize {
	[super initialize];
	
    //self.target = [IntCertInterface sharedInstance].property[@"apiKey"];
    self.errorPopupEnabled	= YES;
    self.authority  = @"AUTH";
    
	_request    = [[NSMutableDictionary alloc] init];
	_response   = [[NSMutableDictionary alloc] init];
	_option		= [[NSMutableDictionary alloc] init];
	
	_request[@"dataHeader"] = [[NSMutableDictionary alloc] init];
	_request[@"dataBody"]   = [[NSMutableDictionary alloc] init];
	
    _request[@"dataHeader"][@"apiKey"]          = @"0000";//[IntCertInterface sharedInstance].property[@"apiKey"];      //기존에 없던 값 추가
    _request[@"dataHeader"][@"subChannel"]      = [IntCertInterface sharedInstance].property[@"subChannel"];
	_request[@"dataHeader"][@"deviceModel"]     = [IntCertInterface sharedInstance].property[@"deviceModel"];
	_request[@"dataHeader"][@"deviceOs"]        = [IntCertInterface sharedInstance].property[@"deviceOs"];
	_request[@"dataHeader"][@"carrier"]         = [IntCertInterface sharedInstance].property[@"carrier"];
	_request[@"dataHeader"][@"connectionType"]  = @"MOBILE";
	_request[@"dataHeader"][@"appName"]         = [IntCertInterface sharedInstance].property[@"appName"];
	_request[@"dataHeader"][@"appVersion"]      = [IntCertInterface sharedInstance].property[@"appVersion"];
	_request[@"dataHeader"][@"udId"]            = [IntCertInterface sharedInstance].property[@"udid"];
	_request[@"dataHeader"][@"scrNo"]           = @"..";//[SHICNavigator defaultNavigator].currentMenuID;
	
	[self putValue:self.identifier forHTTPHeader:@"reqKey"];
}

- (NSData*)data {
    if (_request != nil) {
        NSError* error = nil;
        NSData* data = [NSJSONSerialization dataWithJSONObject:_request options:kNilOptions error:&error];
        
        if( error != nil ) {
            [NSException raise:@"Exception" format:@"%@", error.localizedDescription];
        }
        
        NSString* string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        data = [string dataUsingEncoding:self.encodingTarget];
        
        NSString* key = @"";
        if( [[IntCertInterface sharedInstance].property[@"isReal"] boolValue] )
            key = @"REAL@#SHBSECURITY@HANFAN1128$";
        else
            key = @"$SHBSECURITY@SHARED1128$";
        
        unsigned char cHMAC[CC_SHA256_DIGEST_LENGTH];
        
        const char* pKey = [key cStringUsingEncoding:NSUTF8StringEncoding];
        
        CCHmac(kCCHmacAlgSHA256, pKey, strlen(pKey), data.bytes, data.length, cHMAC);
        NSData* steam = [[NSData alloc] initWithBytes:cHMAC length:CC_SHA256_DIGEST_LENGTH];
        NSString* hash = [steam base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithCarriageReturn];
        
        [self putValue:hash forHTTPHeader:@"hsKey"];
        
        if( [[IntCertInterface sharedInstance].property[@"logging"] boolValue] ) {
            NSData* temp = [NSJSONSerialization dataWithJSONObject:_request options:(NSJSONWritingOptions)NSJSONWritingPrettyPrinted error:nil];
            NSString* log = [[NSString alloc] initWithData:temp encoding:NSUTF8StringEncoding];
            
            switch ([[IntCertInterface sharedInstance].property[@"networkLogLevel"] intValue]) {
                case SHICLogLevelFull:
                    SHICLog(@"\n\n * IntergratedCertification Open API request\n * id   : %@\n * code : %@\n * url  : %@\n * HTTP BODY\n%@", self.identifier, self.code, self.target, log);
                    break;
                    
                case SHICLogLevelSimple:
                    SHICLog(@" * IntergratedCertification Open API request : %@", self.code);
                    break;
                    
                default:
                    break;
            }
            
        }
        return data;
    }else{
        return nil;
    }
}

- (void)setData:(NSData *)data {
    NSString* string = [[NSString alloc] initWithData:data encoding:self.encodingLocal];
    
    NSError* error = nil;
    _response = [NSJSONSerialization JSONObjectWithData:[string dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
    
    if( error != nil ) {
        [NSException raise:@"Exception" format:@"%@", error.localizedDescription];
    }
    
    if( [[IntCertInterface sharedInstance].property[@"logging"] boolValue] && ![self.code isEqualToString:@"AUTH"] ) {
        NSData* temp = [NSJSONSerialization dataWithJSONObject:_response options:(NSJSONWritingOptions)NSJSONWritingPrettyPrinted error:nil];
        NSString* log = [[NSString alloc] initWithData:temp encoding:NSUTF8StringEncoding];
        
        switch ([[IntCertInterface sharedInstance].property[@"networkLogLevel"] intValue]) {
            case SHICLogLevelFull:
                SHICLog(@"\n\n * IntergratedCertification Open API Response\n * id   : %@\n * code : %@\n * url  : %@\n * HTTP BODY\n%@", self.identifier, self.code, self.target, log);
                break;
                
            case SHICLogLevelSimple:
                SHICLog(@" * IntergratedCertification Open API Response : %@", self.code);
                break;
                
            default:
                break;
        }
    }
}

- (void)putForOptionDictionary:(NSDictionary*)dictionary {
	if (dictionary == nil) {
		self.indicatorEnabled	= YES;
		self.errorPopupEnabled	= YES;
		
		return;
	}
	
	for (NSString* key in [dictionary allKeys]) {
		id value = dictionary[key];
		_option[key] = value;
	}
	
	self.indicatorEnabled	=(_option[@"indicator"] != nil) ? [_option[@"indicator"] boolValue] : YES;
	self.errorPopupEnabled	=(_option[@"errorPopup"] != nil) ? [_option[@"errorPopup"] boolValue] : YES;
}

- (void)putValue:(NSString*)value forHeader:(NSString*)key {
	_request[@"dataHeader"][key] = value;
}

- (void)putForHeaderDictionary:(NSDictionary*)dictionary {
	NSMutableDictionary* head = _request[@"dataHeader"];
	
	for (NSString* key in [dictionary allKeys]) {
		id value = dictionary[key];
		head[key] = value;
	}
}

- (void)putValue:(id)value forBody:(NSString*)key{
	_request[@"dataBody"][key] = value;
}

- (void)putDictionary:(NSDictionary*)dictionary {
	NSArray* keys = [dictionary allKeys];
	for( NSString* key in keys ) {
		_request[@"dataBody"][key] = dictionary[key];
	}
}

- (void)putUri:(NSString*)uri {
    self.uri = uri;
}
- (void)transmit {
    SHICAPISession* session = [SHICAPISession defaultSession];
	[session transmitTransaction:self];
}

- (void)transmitWithFinished:(void (^ __nullable)(SHICTransaction* tr))finished failed:(void (^ __nullable)(SHICTransaction* tr))failed cancel:(void (^ __nullable)(SHICTransaction* tr))cancel {
    self.delegate   = self;
    self.finished   = finished;
    self.failed     = failed;
    self.cancel     = cancel;
    

    SHICAPISession* session = [SHICAPISession defaultSession];
    [session transmitTransaction:self];
}

- (void)transactionDidCanceled:(CXICTransaction*)transaction {
    if( self.cancel != nil )
        self.cancel((SHICTransaction*)transaction);
    
    self.delegate = nil;
}

- (void)transactionDidFailed:(CXICTransaction*)transaction {
    if( self.failed != nil )
        self.failed((SHICTransaction*)transaction);
    
    self.delegate = nil;
}

- (void)transactionDidFinished:(CXICTransaction*)transaction {
    if( self.finished != nil )
        self.finished((SHICTransaction*)transaction);
    
    self.delegate = nil;
}
@end
