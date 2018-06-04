//
//  TKExtension.h
//  onepassIosSdkfull
//
//  Created by Eliot Choi on 2016. 12. 5..
//  Copyright © 2016년 h. All rights reserved.
//

#ifndef TKExtension_h
#define TKExtension_h

#define TK_CALLER_ASM      @"byASM"
//#define TK_CALLER_SET      @"bySET"

#define TK_RES_OK 1
#define TK_RES_CANCEL 2

@interface TKExtension : NSObject
//+ (BOOL) resetEnrollment:(int)index;
//+ (void) isEnrollment:(void (^)(void))successBlock withFailedBlock:(void (^)(void))failedBlock;
+ (BOOL) resetPinEnrollment:(int)index keyId:(NSData *)keyId;
@end

#endif /* TKExtension_h */
