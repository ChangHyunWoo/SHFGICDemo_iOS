//
//  GetUAFRequest.h
//  test
//
//  Created by SuJungPark on 2015. 8. 31..
//  Copyright (c) 2015년 SuJungPark. All rights reserved.
//

#import <Foundation/Foundation.h>

#define UAF_PREVIOUSREQUEST     @"previousRequest"
#define UAF_CONTEXT             @"context"

@class UAFContext;
@interface GetUAFRequest : NSObject {
    NSString* op;
    NSString* previousRequest;
    UAFContext* context;

}

- (void) setUserName : (id) name;
- (void) setDeviceId : (id) deviceId;
- (void) setTranText : (id) tranText;
- (GetUAFRequest*) fromJson : (id) json;
- (NSString*) toJson;

- (void) setFacetId  : (id) facetId;

@property (nonatomic, strong) NSString* op;
@property (nonatomic, strong) NSString* previousRequest;
@property (nonatomic, strong) UAFContext* context;
@property NSError* error;


@end
