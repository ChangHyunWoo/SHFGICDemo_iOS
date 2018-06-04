//
//  NSString+CXICNetwork.h
//  IntergratedCertification
//
//  Created by 60000732 on 2016. 9. 26..
//  Copyright © 2016년 60000720. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (CXICNetwork)

+ (NSString*)stringConvertEncodingToIANACharSetName:(NSStringEncoding)encoding;

- (NSString *)URLEncodedString;

@end
