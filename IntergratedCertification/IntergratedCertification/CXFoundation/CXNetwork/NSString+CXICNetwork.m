//
//  NSString+CXICNetwork.m
//  IntergratedCertification
//
//  Created by 60000732 on 2016. 9. 26..
//  Copyright © 2016년 60000720. All rights reserved.
//

#import "NSString+CXICNetwork.h"

@implementation NSString (CXICNetwork)

+ (NSString*)stringConvertEncodingToIANACharSetName:(NSStringEncoding)encoding {
    return CFStringConvertEncodingToIANACharSetName(CFStringConvertNSStringEncodingToEncoding(encoding));
}

- (NSString *)URLEncodedString {
    NSString *result = Nil;
    
    result = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                   (CFStringRef)self,
                                                                                   NULL,
                                                                                   CFSTR("!*'();:@&=+$,/?%#[]"),
                                                                                   kCFStringEncodingUTF8));
    
    
    return result;
}

@end
