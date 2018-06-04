//
//  CXICURLTransaction.m
//  IntergratedCertification
//
//  Created by 60000732 on 2016. 9. 8..
//  Copyright © 2016년 60000720. All rights reserved.
//

#import "CXICURLTransaction.h"

@implementation CXICURLTransaction

- (void)initialize {
    [super initialize];

    _httpHeader = [NSMutableDictionary dictionary];
        
    self.method         = @"POST";
    self.encodingTarget = NSUTF8StringEncoding;
    self.encodingLocal  = NSUTF8StringEncoding;
}

- (void)putValue:(NSString*)value forHTTPHeader:(NSString*)key {
    ((NSMutableDictionary*)_httpHeader)[key] = value;
}

@end
