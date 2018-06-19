//
//  OPTokenData.h
//  public_onepass
//
//  Created by ChoiEliot on 2016. 4. 25..
//  Copyright © 2016년 RAONSECURE. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OPTokenData : NSObject

@property (nonatomic, retain) NSData* localTokenData;
@property (nonatomic, retain) NSData* secureTokenData;
@property (nonatomic, retain) NSData* serverTokenData;
@property (nonatomic, retain) NSString* localTokenBase64;
@property (nonatomic, retain) NSString* secureTokenBase64;
@property (nonatomic, retain) NSString* serverTokenBase64;
@property (nonatomic, retain) NSString* devicePublicKeyBase64;
@property (nonatomic, retain) NSString* certPin;

@property NSInteger errorCode;
@property (nonatomic, retain) NSString* errorMsg;

@end
