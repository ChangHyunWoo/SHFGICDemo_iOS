//
//  AuthenticatorSupport.h
//  uafprotocol-1.0
//
//  Created by raon on 2016. 4. 27..
//  Copyright © 2016년 SuJungPark. All rights reserved.
//

#import <Foundation/Foundation.h>


#define DEF_AUTHINDEX 0
#define DEF_AUTHINDEX_0007 0    //인증장치 : 0012#0007 //default, //사용된 부분 : ClientUrlScheme : getreg, reg, auth, dereg
#define DEF_AUTHINDEX_0008 1    //인증장치 : 0012#0008
#define DEF_AUTHINDEX_0009 2    //인증장치 : 0012#0009
#define DEF_AUTHINDEX_0010 3    //인증장치 : 0012#0010
#define DEF_AUTHINDEX_0011 4    //인증장치 : 0012#0011, TK, note:TKVerifyViewController에 편의상 하드코딩 되어 있음.
#define DEF_AUTHINDEX_F002 5    //인증장치 : 0012#F002
#define DEF_AUTHINDEX_0031 6    //인증장치 : 0012#0031, Voice(powervoice)
#define DEF_AUTHINDEX_0051 7    //인증장치 : 0012#0051, Pattern(secuve)
#define DEF_AUTHINDEX_0107 8    //인증장치 : 0012#0107
#define DEF_AUTHINDEX_0060 9    //인증장치 : 0012#0060, Face(oezsoft)
#define DEF_AUTHINDEX_0062 10   //인증장치 : 0012#0062  FaceId
#define DEF_AUTHINDEX_0081 11   //인증장치 : 0012#0081  HandPrint(AAID 변경)
#define DEF_AUTHINDEX_0053 12   //인증장치 : 0012#0053  Pattern(AuthLabs)
#define DEF_AUTHINDEX_0091 13   //인증장치 : 0012#0091  Silent
#define DEF_AUTHINDEX_0012 14   //인증장치 : 0012#0012  PIN(Bio Certification)

@interface AuthenticatorSupport : NSObject

+ (NSString *)getAAIDStr:(int)index error:(NSError **)error;
+ (int)getAAIDIndex:(NSString *)str error:(NSError **)error;

@end
