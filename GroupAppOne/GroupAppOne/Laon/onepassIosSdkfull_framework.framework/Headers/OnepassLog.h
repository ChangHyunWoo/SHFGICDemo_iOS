//
//  OnepassLog.h
//  raon_rpclient
//
//  Created by h on 2015. 10. 16..
//  Copyright © 2015년 h. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;



@interface OnepassLog : NSObject <UIAlertViewDelegate>

+(void) OpLog:(NSString*)format, ...;
+(void) OpAlert:(NSString*)format, ...;
+(void) OpThrowException:(NSString*)format, ...;

@end
