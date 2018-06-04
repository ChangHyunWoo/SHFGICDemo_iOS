//
//  CXICURLSession.h
//  CXICNetwork
//
//  Created by Kalce on 2015. 1. 10..
//  Copyright © 2015년 Cruxware Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <IntergratedCertification/CXICSession.h>

@interface CXICURLSession : CXICSession

@property (strong  , nonatomic) NSString*        method;
@property (          nonatomic) NSStringEncoding encodingTarget;
@property (          nonatomic) NSStringEncoding encodingLocal;

+ (void)testModeEnabled;

@end
