//
//  StringEncoder.h
//  KeySharpBAgent
//
//  Created by choi sung hoon on 12. 11. 5..
//  Copyright (c) 2012년 lumensoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StringEncoder : NSObject

+(NSString*)encodeWithEncoding:(NSString*)encoding source:(unsigned char*)source length:(int)sourceLen;
+(NSString*)encodeBase64:(unsigned char*)source length:(int)sourceLen;
+(NSString*)encodeBase64URL:(unsigned char*)source length:(int)sourceLen;
+(NSString*)encodeHexUpper:(unsigned char*)source length:(int)sourceLen;
+(NSString*)encodeHexLower:(unsigned char*)source length:(int)sourceLen;
+(NSData*) decodeBase64URLToData:(NSString*) base64String ;
+(NSString*)decodeBase64URL:(NSString*) base64String;

@end
