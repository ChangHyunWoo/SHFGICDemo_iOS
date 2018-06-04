//
//  ReturnUAFRequest.h
//  test
//
//  Created by SuJungPark on 2015. 8. 31..
//  Copyright (c) 2015년 SuJungPark. All rights reserved.
//

#import <Foundation/Foundation.h>

#define UAF_REQUEST         @"uafRequest"
#define UAF_LIFETIMEMILLIS  @"lifetimeMillis"


@interface ReturnUAFRequest : NSObject{
    long _statusCode;
    NSString* _uafRequest;
    NSString* _op;
    long _lifetimeMillis;
    NSError* error;
}

- (ReturnUAFRequest*) fromJson : (id) json;
- (NSString*) toJson;

@property (nonatomic , assign) long statusCode;
@property (nonatomic , assign) NSString* uafRequest;
@property (nonatomic , assign) NSString* op;
@property (nonatomic , assign) long lifetimeMillis;
@property (nonatomic , assign) NSError* error;


@end
