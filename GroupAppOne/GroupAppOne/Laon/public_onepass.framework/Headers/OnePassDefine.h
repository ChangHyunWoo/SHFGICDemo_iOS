//
//  OnePassDefine.h
//  onepassIosSdk
//
//  Created by mins on 2016. 1. 21..
//  Copyright © 2016년 h. All rights reserved.
//

#ifndef OnePassDefine_h
#define OnePassDefine_h

//버전.
#define ONEPASS_VERSION @"1.0.20.6296"


//서버 url 관련
#define RPSERVER_REQUEST_RESOURCE @"fido/deviceUaf/processUafRequest.do"
#define RPSERVER_RESPONSE_RESOURCE @"fido/deviceUaf/processUafResponse.do"
#define RPSERVER_JOB_REQUEST_RESOURCE @"interfDeviceBiz/processRequest.do"
#define RPSERVER_SERVICE_REQUEST_RESOURCE @"interfBiz/processRequest.do"
#define RPSERVER_TOKEN_REQUEST_RESOURCE @"/interfToken/processRequest.do"

#define ONEPASS_RESOURCE_FILE_NAME @"OnepassLocalizable"

//Onepass Keyword

#define ONEPASS_KEY_RESULT_CODE @"result_code"
#define ONEPASS_KEY_RESULT_MESSAGE @"result_message"
#define ONEPASS_KEY_RESULT_TRID @"tr_id"
#define ONEPASS_KEY_OPERATION @"operation"
#define ONEPASS_KEY_TOKEN @"token"
#define ONEPASS_KEY_P7SIGN_DATA @"p7SignedData"
#define ONEPASS_KEY_P7SIGN_DATA_LIST @"p7SignedDataList"
#define ONEPASS_KEY_R_VALUE @"RValue"
#define ONEPASS_KEY_TRANDATA_ARRAY @"tranDataArray"
#define ONEPASS_KEY_PDFSIGN_DATA @"pdfSignedData"
#define ONEPASS_KEY_PDFSIGN_DATA_LIST @"pdfSignedDataList"

//기능 타입.
typedef enum {
    ONEPASS_OPERATION_REGISTRATION = 1,
    ONEPASS_OPERATION_INIT_USER_ID,
    ONEPASS_OPERATION_DEREGISTRATION,
    ONEPASS_OPERATION_CHANGE_AUTHENTICATOR,
    ONEPASS_OPERATION_AUTHENTICATION,
    ONEPASS_OPERATION_INIT_AUTHENTICATOR,
    ONEPASS_OPERATION_SAVE_TOKEN,
    ONEPASS_OPERATION_GET_TOKEN,
    ONEPASS_OPERATION_CHECK_TOKEN,
    ONEPASS_OPERATION_DELETE_TOKEN,
    ONEPASS_OPERATION_ISSUE_CERT,
    ONEPASS_OPERATION_UPDATE_CERT,
    ONEPASS_OPERATION_REISSUE_CERT,
    ONEPASS_OPERATION_P7SIGN_CERT,
    ONEPASS_OPERATION_REVOKE_CERT,
    ONEPASS_OPERATION_RESULTCONFIRM
} ONEPASS_OPERATION;

#define ObjectOrEmptyString(A) (A ?: @"")

//Service Commands
#define ONEPASS_SERVICE_COMMAND_NAME_REGISTRATION @"requestServiceRegist"
#define ONEPASS_SERVICE_COMMAND_NAME_INIT_USER_ID @"requestServiceInitDevice"
#define ONEPASS_SERVICE_COMMAND_NAME_AUTHENTICATION @"requestServiceAuth"
#define ONEPASS_SERVICE_COMMAND_NAME_INIT_AUTHENTICATOR @"requestServiceInitAuthnr"
#define ONEPASS_SERVICE_COMMAND_NAME_DEREGISTRATION @"requestServiceRelease"
#define ONEPASS_SERVICE_COMMAND_NAME_CHANGE_AUTHENTICATOR @"requestServiceReReg"

#define ONEPASS_SERVICE_COMMAND_NAME_ISSUE_CERT @"requestIssueCert"
#define ONEPASS_SERVICE_COMMAND_NAME_REISSUE_CERT @"requestIssueInitCert"
#define ONEPASS_SERVICE_COMMAND_NAME_P7SIGN_CERT @"requestP7Sign"
#define ONEPASS_SERVICE_COMMAND_NAME_REVOKE_CERT @"requestRevokeCert"
#define ONEPASS_SERVICE_COMMAND_NAME_UPDATE_CERT @"requestUpdateCert"

#define ONEPASS_SERVICE_COMMAND_NAME_RESULTCONFIRM @"trResultConfirm"

//Device Commands
#define ONEPASS_DEVICE_COMMAND_NAME_GET_JOB_LIST @"bizReqCheck"
#define ONEPASS_DEVICE_COMMAND_NAME_REG_DEVICE_INFO @"deviceInfoReg"
#define ONEPASS_DEVICE_COMMAND_NAME_VERSION_CHECK @"versionCheck"
#define ONEPASS_DEVICE_COMMAND_NAME_LOCAL_AUTH_FAIL @"reportLocalAuthFail"
#define ONEPASS_DEVICE_COMMAND_NAME_P7SIGN @"reportP7Sign"

#define ONEPASS_DEVICE_COMMAND_NAME_REQUEST_TOKEN_UPDATE @"requestTokenUpdate"
#define ONEPASS_DEVICE_COMMAND_NAME_REQUEST_TOKEN_SELECT @"requestTokenSelect"
#define ONEPASS_DEVICE_COMMAND_NAME_REQUEST_TOKEN_CHECK @"checkTokenStatus"
#define ONEPASS_DEVICE_COMMAND_NAME_REQUEST_TOKEN_DELETE @"deleteTokens"

//request type
#define BIZ_REQUEST_TYPE_APP @"app"
#define BIZ_REQUEST_TYPE_SERVER @"server"

#define TELE_TYPE_LG @"1"
#define TELE_TYPE_SK @"2"
#define TELE_TYPE_KT @"3"

#define APP_BUNDDLE_ID_PREFIX @"ios:bundle-id:"

//os 및 지원 가능 관련.
#define MIN_SUPPORT_IOSVERSION 9.0
#define ONEPASS_IOS_TYPE @"2"

//지문(touch id) 등록 후 변경(지문 추가/제거)시 허용 여부.
#define ONEPASS_ALLOW_FINGERPRINT_STATE_CHANGE          0
#define ONEPASS_NOT_ALLOW_FINGERPRINT_STATE_CHANGE      1

#define JOB_NAME_REGIST @"Reg"
#define JOB_NAME_DEREGIST @"Dereg"
#define JOB_NAME_AUTHENTICATE @"Auth"
#define JOB_NAME_USIM_REGIST @"UsimReg" //점유인증 시 사용
#define JOB_NAME_USIM_AUTHENTICATE @"UsimAuth" //점유인증 시 사용
#define APPEND_JOB_NAME_TOKEN_SAVE @"tokenSave"
#define APPEND_JOB_NAME_TOKEN_SELECT @"tokenSelect"
#define APPEND_JOB_NAME_DEVICE_INFO_REG @"deviceInfoReg"
#define APPEND_JOB_NAME_SIMPLE_CERT @"simpleCert"
#define JOB_NAME_P7SIGN @"p7Sign"

#define APPEND_JOB_NAME_ISSUE_CERT @"issueCert"
#define APPEND_JOB_NAME_UPDATE_CERT @"updateCert"
#define APPEND_JOB_NAME_REVOKE_CERT @"revokeCert"
#define APPEND_JOB_NAME_BIO_TOKEN_SAVE @"bioTokenSave"
#define APPEND_JOB_NAME_BIO_TOKEN_SELECT @"bioTokenSelect"

#define EXPAND_COMMAND_VALUE_COMMAND_SAVE_BIO_TOKEN @"bioTokenSave"
#define EXPAND_COMMAND_VALUE_COMMAND_SELECT_BIO_TOKEN @"bioTokenSelect"

extern bool onepass_debug;


typedef enum {
    BIZ_REQ_COMMAND_TYPE_REG = 1,
    BIZ_REQ_COMMAND_TYPE_DEREG = 2,
    BIZ_REQ_COMMAND_TYPE_FIST_AUTH = 3,
    BIZ_REQ_COMMAND_TYPE_CHANGE_AUTHENTICATOR = 4,
    BIZ_REQ_COMMAND_TYPE_INIT_AUTHENTICATOR = 5,
    BIZ_REQ_COMMAND_TYPE_INIT_USERID = 6,
    BIZ_REQ_COMMAND_TYPE_SECOND_AUTH = 7,
    BIZ_REQ_COMMAND_TYPE_SAVE_TOKEN = 8,
    BIZ_REQ_COMMAND_TYPE_GET_TOKEN = 9,
    BIZ_REQ_COMMAND_TYPE_SPASS_ISSUE = 10,
    BIZ_REQ_COMMAND_TYPE_SPASS_SIGN = 11,
    BIZ_REQ_COMMAND_TYPE_SPASS_ROVOKE = 12,
    BIZ_REQ_COMMAND_TYPE_SPASS_REISSUE = 13,
    BIZ_REQ_COMMAND_TYPE_ISSUE = 14,
    BIZ_REQ_COMMAND_TYPE_SIGN = 15,
    BIZ_REQ_COMMAND_TYPE_REISSUE = 16,
    BIZ_REQ_COMMAND_TYPE_REVOKE = 17,
    BIZ_REQ_COMMAND_TYPE_UPDATE = 18,
    BIZ_REQ_COMMAND_TYPE_SPASS_UPDATE = 19
} BIZ_REQ_COMMAND_TYPE;


#define CA_CODE_YESSIGN @"32"
#define CA_CODE_SIGNKOREA @"33"

#define STRING_ENCODING_EUC_KR      50

#ifdef MODULE_FRAMEWORK
#define BUNDLE_PUBLIC [NSBundle bundleForClass:[self class]]
#else
#define BUNDLE_PUBLIC [NSBundle bundleWithPath:[[NSBundle mainBundle] bundlePath]]
#endif


#endif /* OnePassDefine_h */
