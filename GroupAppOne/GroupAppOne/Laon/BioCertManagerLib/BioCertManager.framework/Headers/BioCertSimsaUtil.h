//
//  OnePassDevUtil.h
//  public_onepass
//
//  Created by Eliot Choi on 2017. 7. 11..
//  Copyright © 2017년 라온시큐어_이민수. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BioCertSimsaUtil : NSObject

void RSKSW_print_bin_bioCertManager(char *title, unsigned char *data, int len);
+ (void)printAndSave:(NSString *)title data:(NSData *)data fileName:(NSString *)fileName;

@end
