//
//  OnepassSha256.h
//  raon_rpclient
//
//  Created by h on 2015. 9. 24..
//  Copyright © 2015년 h. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BioCertSha256 : NSObject

+ (NSData *)sha256:(NSData *)data;
+ (NSData *)hmacSha256 :(NSData * )key inputData:(NSData *)data;
@end
