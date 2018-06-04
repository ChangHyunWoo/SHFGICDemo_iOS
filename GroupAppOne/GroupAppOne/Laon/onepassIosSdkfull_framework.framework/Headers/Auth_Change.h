//
//  Auth_Change.h
//  onepassIosSdkfull
//
//  Created by raon on 2016. 5. 2..
//  Copyright © 2016년 h. All rights reserved.
//
#import <Foundation/Foundation.h>
@class AuthDBHelper;

@interface Auth_Change : NSObject

//- (void) process:(AuthDBHelper*)dbHelper preWrap:(NSData *)pre newWrap:(NSData *)new index:(int)index;
- (void) process:(AuthDBHelper*)dbHelper preWrap:(NSData *)pre newWrap:(NSData *)new index:(int)index withKeyid:(NSData*)keyId;

@end
