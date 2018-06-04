//
//  UrlScheme.h
//  fidoclient
//
//  Created by h on 2015. 9. 16..
//  Copyright © 2015년 SuJungPark. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "UAFURLInfo.h"


//  FIDO Client
//  - UAFxType
#define STRING_UAF_OPERATION                            @"UAF_OPERATION"
#define STRING_UAF_OPERATION_RESULT                     @"UAF_OPERATION_RESULT"
#define STRING_DISCOVER                                 @"DISCOVER"
#define STRING_DISCOVER_RESULT                          @"DISCOVER_RESULT"
#define STRING_CHECK_POLICY                             @"CHECK_POLICY"
#define STRING_CHECK_POLICY_RESULT                      @"CHECK_POLICY_RESULT"
#define STRING_UAF_OPERATION_COMPLETION_STATUS          @"UAF_OPERATION_COMPLETION_STATUS"


//  FIDO Client
//  - issueInfo
#define STRING_ISSUE_INFO           @"issueInfo"
#define STRING_ISSUE_TYPE           @"issueType"
#define STRING_REFERENCE_NUMBER     @"refNumber"
#define STRING_AUTH_CODE            @"authCode"
#define STRING_CA_CODE              @"caCode"
#define STRING_PUBKEY_HASH          @"pukHash"
#define STRING_EVID                 @"evid"


//  FIDO ASM
//  - requestType
#define STRING_GetInfo          @"GetInfo"
#define STRING_Register         @"Register"
#define STRING_Authenticate     @"Authenticate"
#define STRING_Deregister       @"Deregister"
#define STRING_GetRegistrations @"GetRegistrations"
#define STRING_OpenSettings     @"OpenSettings"

//  FIDO ASM
//  - StatusCode
#define UAF_ASM_STATUS_OK               0x00
#define UAF_ASM_STATUS_ERROR            0x01
#define UAF_ASM_STATUS_ACCESS_DENIED    0x02
#define UAF_ASM_STATUS_USER_CANCELLED   0x03

@interface UrlScheme : NSObject

+ (id)sharedInstance;
- (NSString *) handle:(UAFURLInfo *)url ;

@end
