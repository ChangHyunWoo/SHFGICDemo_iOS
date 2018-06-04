//
//  OnepassKdf.h
//  onepassIosSdkfull
//
//  Created by h on 2016. 3. 28..
//  Copyright © 2016년 h. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OnepassKdf : NSObject
+ (NSData *)pbkdf2:(NSData *)data;
+ (void)clearNSData:(NSData *)data;
+ (NSData *)customPbkdf2:(NSString *)str;
+ (NSData *)customPbkdf2d:(NSData *)data;
@end
