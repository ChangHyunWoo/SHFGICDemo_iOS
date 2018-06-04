//
//  ErrorCode.h
//  raon_rpclient
//
//  Created by raon on 2015. 11. 27..
//  Copyright © 2015년 h. All rights reserved.
//

#ifndef ErrorCode_h
#define ErrorCode_h

#import <Foundation/Foundation.h>

#define SUCCESS 0
#define START_VALUE -1
#define INTERVAL_VALUE 1

#define INVALID_OPERATION   START_VALUE
#define NO_SUCH_VERSION     (INVALID_OPERATION - INTERVAL_VALUE)        //fe (-2)
#define ERROR_MANDANTORY    (NO_SUCH_VERSION - INTERVAL_VALUE)          //fd (-3)
#define NO_SUCH_ALGORITHM   (ERROR_MANDANTORY - INTERVAL_VALUE)         //fc (-4)
#define NO_MANDATORY_FIELD  (NO_SUCH_ALGORITHM - INTERVAL_VALUE)        //fb (-5)
#define NOT_IMPLEMENTED     (NO_MANDATORY_FIELD - INTERVAL_VALUE)       //fa (-6)
#define VERIFICATION_FAILED (NOT_IMPLEMENTED - INTERVAL_VALUE)          //f9 (-7)
#define EMPTY_VALUE         (VERIFICATION_FAILED - INTERVAL_VALUE)      //f8 (-8)
#define NULL_VALUE          (EMPTY_VALUE - INTERVAL_VALUE)              //f7 (-9)
#define MISSING_VALUE       (NULL_VALUE - INTERVAL_VALUE)               //f6 (-10)
#define BUFFER_SIZE_OUT     (MISSING_VALUE - INTERVAL_VALUE)            //f5 (-11)
#define INVALID_VALUE       (BUFFER_SIZE_OUT - INTERVAL_VALUE)          //f4 (-12)
#define INVALID_JSON        (INVALID_VALUE - INTERVAL_VALUE)            //f3 (-13)
#define INVALID_FACETID     (INVALID_JSON - INTERVAL_VALUE)             //f2 (-14)
#define ERROR_TRYOVER       (INVALID_FACETID - INTERVAL_VALUE)          //0xf1 (-15) : 인증 장치 시도 횟수 오버로 실패
#define ERROR_WRAPKEY       (ERROR_TRYOVER - INTERVAL_VALUE)            //0xf0 (-16) : not found wrapKey
#define ERROR_PRIKEY        (ERROR_WRAPKEY - INTERVAL_VALUE)            //0xef (-17) : not found priKey
#define ERROR_TRYOVER_OS    (ERROR_PRIKEY - INTERVAL_VALUE)             //0xee (-18) : 인증 장치 시도 횟수 오버로 실패 (OS의 TouchID를 사용했을 경우)


#define ERROR_BIO_PIN_Fail                          0x270F
#define ERROR_BIO_PIN_Database_Error                0x238D
#define ERROR_BIO_PIN_Json_Type_Error               0x238E
#define ERROR_BIO_PIN_Undefined_Command             0x044C
#define ERROR_BIO_PIN_Does_Not_Exist_Key_Info       0x044D
#define ERROR_BIO_PIN_Empty_Params                  0x0834
#define ERROR_BIO_PIN_Empty_Params_Command          0x0835
#define ERROR_BIO_PIN_Empty_Params_Encrypt_Data     0x0836
#define ERROR_BIO_PIN_Empty_Params_Tr_Id            0x0837
#define ERROR_BIO_PIN_Empty_Params_Device_Id        0x0838
#define ERROR_BIO_PIN_Empty_Params_Key_Id           0x0839
#define ERROR_BIO_PIN_Empty_Params_Bio_Data         0x083A
#define ERROR_BIO_PIN_Empty_Params_Os               0x083B
#define ERROR_BIO_PIN_Verify_Fail_Auth              0x0C1D
#define ERROR_BIO_PIN_Verify_Fail_Decrypt_Key       0x0C1E
#define ERROR_BIO_PIN_Verify_Fail_Decrypt_Data      0x0C1F





// uafclient
#define NO_ERROR                    0x00
#define WAIT_USER_ACTION            0x01
#define INSECURE_TRANSPORT          0x02
#define USER_CANCELLED              0x03
#define UNSUPPORTED_VERSION         0x04
#define NO_SUITABLE_AUTHENTICATOR   0x05
#define PROTOCOL_ERROR              0x06
#define UNTRUSTED_FACET_ID          0x07
#define NO_AVAILABLE_AUTHENTICATOR  0x08

#define UNKNOWN                     0xff

@interface ErrorCode : NSObject

+(NSString *) getErrorMessage:(int) errorCode;
    
@end

#endif
