//
//  OnePassErrorCode.h
//  onepassIosSdkfull
//
//  Created on 2016. 2. 17..
//  Copyright © 2016년 h. All rights reserved.
//

#ifndef OnePassErrorCode_h
#define OnePassErrorCode_h

#define OK_CODE                                 0
#define RESULT_CODE_DEVICE_ID                   333

#define ERROR_UNSUPPORTED_BIZ_TYPE              555

//인증장치 에러 코드.
#define ERROR_TOUCHID_TRYOVER_OS                        -18

#define ERROR_NETWORK                           7019
#define ERROR_NOTSUPPORTED                      7026
#define ERROR_UNKNOWN                           7027

//설정 오류.7031 ~ 7039
#define ERROR_NOT_SERVERURL                     7031
#define ERROR_NOT_SITEID                        7032
#define ERROR_NOT_SVCID                         7033
#define ERROR_NOT_LOGINID                       7034

//단말 지원 가능 여부. 7040 ~
#define ERROR_FAIL_UNSUPPORT_LOW_VER            7040
#define ERROR_FAIL_FIND_DEVICE_TYPE             7041
#define ERROR_INSTALL_AUTH_REG                  7042
#define ERROR_FAIL_FIND_AAID                    7043
#define ERROR_TOUCHID_CAN_NOT_AVAILABLE         7044
#define ERROR_NOT_SET_PASSCODE                  7045
#define ERROR_TOUCHID_NOT_ENROLLED              7046
#define ERROR_BELOW_OS_9                        7047


////// 인증 툴킷 연동 관련 에러코드.
//생성, 저장 , 삭제
#define ERROR_AUTH_KEY_MAKE_KEYPAIR                      8300
#define ERROR_AUTH_KEY_NOT_FOUND_KEYPAIR                      8301
#define ERROR_AUTH_KEY_NOT_FOUND_LOCALTOKEN                   8302
#define ERROR_AUTH_KEY_DEL_DEVICEKEYPAIR                 8311
#define ERROR_AUTH_KEY_DEL_DB                            8312

#define ERROR_AUTH_KEY_SAVE_DB                                8313

//프로토콜 관련 실패.
#define ERROR_AUTH_KEY_DECRYPT_SERVERTOKEN               8320
#define ERROR_AUTH_KEY_INVALID_MAC                            8321

//get data 실패.

#define ERROR_AUTH_KEY_GET_CERTSERIAL_FAIL                    8330
#define ERROR_AUTH_KEY_GET_DEVICEPUBKEY_FAIL                  8331
#define ERROR_AUTH_KEY_GET_SERVERPUBKEY_FAIL                  8332
#define ERROR_AUTH_KEY_GET_LOCALTOKEN_FAIL                    8333
#define ERROR_AUTH_KEY_GET_DEVICEPRIVATEKEY_FAIL              8334

//delete token 실패
#define ERROR_AUTH_KEY_SERVER_TOKEN_DELETE_FAIL         8335

//인코딩 , 디코딩 관련 실패.
#define ERROR_AUTH_KEY_NONCE_DECODE                      8340
#define ERROR_AUTH_KEY_RSAENCRYPT_SERVERPUBKEY           8341
#define ERROR_AUTH_KEY_MAKE_PUBKEY_HEAD                  8342
#define ERROR_AUTH_KEY_BASE64_ENCODE                     8343
#define ERROR_AUTH_KEY_BASE64_DECODE                     8344

#define ERROR_AUTH_KEY_AES_DCRYPT                        8345
#define ERROR_AUTH_KEY_MAKE_SERVERTOKEN                  8346
#define ERROR_AUTH_KEY_MAKE_LOCALTOKEN_AES               8347
#define ERROR_AUTH_KEY_MAKE_LOCALTOKEN_RSA               8348
#define ERROR_AUTH_KEY_RSA_DECRYPT                       8349
#define ERROR_AUTH_KEY_RSA_INVALID_SIZE                  8350

#define ERROR_OWN_AUTH_NOT_EXIST_HP_NUM                  9000
//#define ERROR_OWN_AUTH_NOT_EXIST_HP_NUM_MESSAGE @"휴대폰 번호가 세팅되지 않았습니다. 서버 설정에 따라 SDK에 휴대폰 번호를 설정해야 합니다."

//생체 인증서 에러코드
#define ERROR_BIO_CERT_GENERATE_KEYPAIR     10000
#define ERROR_BIO_CERT_GET_POP_SIGN         10001
#define ERROR_BIO_CERT_FAIL_CMS_SIGN        10002
#define ERROR_DISMATCH_PLAIN                6057    //for matching with android - by choi
#define ERROR_BIO_CERT_NOT_SUPPORTED_CA     10003

#define ERROR_DISMATCH_PLAIN_MSG            @"Plain Data do not match"


//AppToAppLib 관련 12000
#define ERROR_CAN_NOT_OPEN_APP                          12000
#define ERROR_NOT_FOUND_APPNAME                         12001
#define ERROR_NOT_EXIST_APPNAME                         12002

#define ERROR_CAN_NOT_OPEN_APP_MESSAGE                  @"원패스 앱을 열수 없습니다.\n앱 이름 등을 확인해 주세요."

#endif /* OnePassErrorCode_h */
