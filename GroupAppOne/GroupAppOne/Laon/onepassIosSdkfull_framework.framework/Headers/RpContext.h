//
//  RpContext.h
//  test
//
//  Created by SuJungPark on 2015. 8. 31..
//  Copyright (c) 2015년 SuJungPark. All rights reserved.
//

#import <Foundation/Foundation.h>

#define UAF_DEVICEID            @"deviceId"
#define UAF_USERNAME            @"userName"
#define UAF_TRANSACTION_TEXT    @"transactionText"


@interface RpContext : NSObject{
    NSString* deviceId;
    NSString* userName;
    NSString* tranText;
    NSString* facetId;
}

- (RpContext*) fromJson : (id) json;
- (NSString*) toJson;

@property (nonatomic, strong) NSString* deviceId;
@property (nonatomic, strong) NSString* userName;
@property (nonatomic, strong) NSString* tranText;
@property (nonatomic, strong) NSString *facetId;

@end
