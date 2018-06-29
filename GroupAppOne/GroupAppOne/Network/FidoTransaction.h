//
//  FidoTransaction.h
//  GroupAppOne
//
//  Created by 두베아이맥 on 2018. 3. 5..
//  Copyright © 2018년 두베아이맥. All rights reserved.
//

#import <Foundation/Foundation.h>



#define SHIC_ONEPASS_SITEID       @"SHG00000000000"
#define SHIC_ONEPASS_SVCID        @"SHG11111111111"

#define SHIC_ONEPASS_SITEID_2       @"SHG00000000001"
#define SHIC_ONEPASS_SVCID_2        @"SHG11111111112"


#define SHIC_BIZ_URL_SERVER @"http://1.237.181.61:8080"
//#define SHIC_BIZ_URL_SERVER_2 @"http://13.125.27.166:8080"
#define SHIC_BIZ_URL_SERVER_2 @"http://1.237.181.65:8080"

//도메인
#define SHIC_ONEPASS_DOMAIN_SERVER      @"http://1.237.181.62:8080"
//#define SHIC_ONEPASS_DOMAIN_SERVER_2    @"http://13.125.21.27:8080"
#define SHIC_ONEPASS_DOMAIN_SERVER_2 @"http://1.237.181.66:8080"
//#define SHIC_ONEPASS_DOMAIN_SERVER_2 @"http://1.237.181.61:9080"

#define SHIC_BIZ_SERVER       @"http://1.237.181.61:8080"
//#define SHIC_BIZ_SERVER_2     @"http://13.125.27.166:8080"
#define SHIC_BIZ_SERVER_2 @"http://1.237.181.65:8080"

//그룹사 Domain
#define SHIC_OAUTH_BANK            @"https://sbk16.shinhan.com"                //신한은행(운영) (OAuth)
#define SHIC_OAUTH_DEV_BANK        @"https://dev-sbk16.shinhan.com"            //신한은행(개발) (OAuth)
#define SHIC_OAUTH_CARD            @"https://sharedplatform.shinhancard.com"   //신한카드(운영) (OAuth)
//#define SHIC_OAUTH_DEV_CARD        @"https://smttest.shinhanlife.co.kr:8414"   //신한카드(개발) (OAuth)
#define SHIC_OAUTH_DEV_CARD        @"https://tst-sharedplatform.shinhancard.com"   //신한카드(개발) (OAuth)
#define SHIC_OAUTH_INVESTMENT      @"https://open.shinhaninvest.com"           //신한금융투자(운영) (OAuth)
#define SHIC_OAUTH_DEV_INVESTMENT  @"https://mdev1.shinhaninvest.com"          //신한금융투자(개발) (OAuth)
#define SHIC_OAUTH_INSURANCE       @"https://smt.shinhanlife.co.kr"            //신한생명(운영) (OAuth)
#define SHIC_OAUTH_DEV_INSURANCE   @"https://smttest.shinhanlife.co.kr:8414"   //신한생명(개발) (OAuth)

#ifdef TEST_GROUP1
    //#define WEBURL_SERVICEFINGERTERM [NSString stringWithFormat:@"%@%@",SHIC_BIZ_URL_SERVER,@"/shic/res/html/joi/joip0010.html"] //   지문이용안내
    #define WEBURL_SERVICEFINGERTERM SHIC_BIZ_URL_SERVER @"/shic/res/html/joi/joip0010.html" //   지문이용안내
    #define WEBURL_SERVICEPASSWORDTERM [NSString stringWithFormat:@"%@%@",SHIC_BIZ_URL_SERVER,@"/shic/res/html/joi/joip0020.html"] //   비밀번호 이용 안내
    #define WEBURL_SERVICETERM [NSString stringWithFormat:@"%@%@",SHIC_BIZ_URL_SERVER,@"/shic/res/html/joi/joim0010.html"] //  신한 올패스 이용안내
    #define WEBURL_SERVICEEULA [NSString stringWithFormat:@"%@%@",SHIC_BIZ_URL_SERVER,@"/shic/res/html/joi/joim0020.html"]  // 신한 올패스 약관 및 이용동의
    #define WEBURL_SERVICEEULADETAIL [NSString stringWithFormat:@"%@%@",SHIC_BIZ_URL_SERVER,@"/shic/res/html/joi/joim0030.html"]  // 신한 올패스 약관 및 이용동의 상세
    #define WEBURL_SERVICEREGISTCOMPLETE [NSString stringWithFormat:@"%@%@",SHIC_BIZ_URL_SERVER,@"/shic/res/html/joi/joim0040.html"]  // 신한 올패스 가입 완료
    #define WEBURL_SERVICEPAUSE [NSString stringWithFormat:@"%@%@",SHIC_BIZ_URL_SERVER,@"/shic/res/html/sto/stom0010.html"]  // 신한 올패스 서비스 정지 안내
    #define WEBURL_SERVICEPAUSEFINISH [NSString stringWithFormat:@"%@%@",SHIC_BIZ_URL_SERVER,@"/shic/res/html/sto/stom0020.html"]  // 신한 올패스 정지 완료
    #define WEBURL_SERVICEDISPOSAL [NSString stringWithFormat:@"%@%@",SHIC_BIZ_URL_SERVER,@"/shic/res/html/can/canm0010.html"]  // 신한 올패스 해지 안내
    #define WEBURL_SERVICEDISPOSALFINISH [NSString stringWithFormat:@"%@%@",SHIC_BIZ_URL_SERVER,@"/shic/res/html/can/canm0020.html"]  // 신한 올패스 해지 완료
#else
    #define WEBURL_SERVICEFINGERTERM [NSString stringWithFormat:@"%@%@",SHIC_BIZ_URL_SERVER_2,@"/shic/res/html/joi/joip0010.html"] //   지문이용안내
    #define WEBURL_SERVICEPASSWORDTERM [NSString stringWithFormat:@"%@%@",SHIC_BIZ_URL_SERVER_2,@"/shic/res/html/joi/joip0020.html"] //   비밀번호 이용 안내
    #define WEBURL_SERVICETERM [NSString stringWithFormat:@"%@%@",SHIC_BIZ_URL_SERVER_2,@"/shic/res/html/joi/joim0010.html"] //  신한 올패스 이용안내
    #define WEBURL_SERVICEEULA [NSString stringWithFormat:@"%@%@",SHIC_BIZ_URL_SERVER_2,@"/shic/res/html/joi/joim0020.html"]  // 신한 올패스 약관 및 이용동의
    #define WEBURL_SERVICEEULADETAIL [NSString stringWithFormat:@"%@%@",SHIC_BIZ_URL_SERVER_2,@"/shic/res/html/joi/joim0030.html"]  // 신한 올패스 약관 및 이용동의 상세
    #define WEBURL_SERVICEREGISTCOMPLETE [NSString stringWithFormat:@"%@%@",SHIC_BIZ_URL_SERVER_2,@"/shic/res/html/joi/joim0040.html"]  // 신한 올패스 가입 완료
    #define WEBURL_SERVICEPAUSE [NSString stringWithFormat:@"%@%@",SHIC_BIZ_URL_SERVER_2,@"/shic/res/html/sto/stom0010.html"]  // 신한 올패스 서비스 정지 안내
    #define WEBURL_SERVICEPAUSEFINISH [NSString stringWithFormat:@"%@%@",SHIC_BIZ_URL_SERVER_2,@"/shic/res/html/sto/stom0020.html"]  // 신한 올패스 정지 완료
    #define WEBURL_SERVICEDISPOSAL [NSString stringWithFormat:@"%@%@",SHIC_BIZ_URL_SERVER_2,@"/shic/res/html/can/canm0010.html"]  // 신한 올패스 해지 안내
    #define WEBURL_SERVICEDISPOSALFINISH [NSString stringWithFormat:@"%@%@",SHIC_BIZ_URL_SERVER_2,@"/shic/res/html/can/canm0020.html"]  // 신한 올패스 해지 완료
#endif


//******************** 서버 체크코드 목록.

//인증장치 타입
#define SERVERCODE_VERIFYTYPE_PIN @"512"    //인증장치 타입 (핀)
#define SERVERCODE_VERIFYTYPE_FIDO @"2"     //인증장치 타입 (지문)

//그룹사별 코드
#ifdef TEST_GROUP1
#define GROUP_CODE  @"001"
#else
#define GROUP_CODE  @"002"
#endif


#define SERVERCODE_STATECODE_SUC @"1" // 인증서 상태 코드 (정상)
#define SERVERCODE_STATECODE_DISSPOSAL @"2" // 인증서 상태 코드 (해지)
#define SERVERCODE_AFFILIATESCODES_SUC @"1" //정상상태 (그룹사별)
#define SERVERCODE_AFFILIATESCODES_DISPOSSAL @"2" //해지상태 (그룹사별)
#define SERVERCODE_AFFILIATESCODES_PAUSE @"3" //정지상태 (그룹사별)



/** FIDO CommandType */
typedef enum _FidoCommand {
    FidoCommandForUserChange,           //사용자변경
    FidoCommandForDeviceRegister,       //디바이스변경
    FidoCommandForResultConfirm,
    FidoCommandForAllowedDevice,        //허용단말 리스트
    /* 3/21 변경분 반영 다시 정의*/
    FidoCommandForUserJoin = 100,         //가입 ( 최초 가입시 )
    FidoCommandForUserRegist = 101,       //등록 ( 그룹사 가입시 )
//    FidoCommandForUserFingerRegist = 102, //지문등록 (   )
    FidoCommandForUserFingerRegistAuth = 110, //지문등록 (인증)
    FidoCommandForUserFingerRegistSend = 111, //지문등록 (등록)
    FidoCommandForUserRejoin = 103,       //재가입 ( 해지후 가입시 )
    FidoCommandForUserRe_Regist = 104,    //재등록 ( 정지후 재사용시, 앱재설치시, 기기 변경시  )
    FidoCommandForUserAuth = 200 ,         //인증(Pin)
    FidoCommandForUserQRAuth = 201 ,         //인증(QR)
    FidoCommandForUserSSOAuth = 203 ,         //인증(SSO)
    FidoCommandForUserRelease = 300,      //해지
    FidoCommandForUserPause = 301,        //정지
    FidoCommandForElectronicSign = 500,        //전자서명
    FidoCommandForPasswordChangeAuth = 600, // 비밀번호 변경 인증
    FidoCommandForPasswordChange = 601, // 비밀번호 변경 요청
} FidoCommandType;

/** FIDO VerifyType */
typedef enum _FidoVerify {
    FidoVerifyAuth = 200,     //인증
    FidoVerifyDisposal = 300,     //해지
    FidoVerifyPause = 301,     //정지
    FidoVerifyRegist,        //등록
    FidoVerifyInquire = 400,       //조회
    FidoVerifyOtherLoginRelease = 302, // 타인증수단 해지
    FidoVerifyOtherLoginPause  =303, // 타인증수단 정지
    FidoVerifyPasswordChangeAuth = 600, // 비밀번호 변경 인증
    FidoVerifyPasswordChange = 601, // 비밀번호 변경 요청
} FidoVerifyType;

@protocol FidoTransactionDelegate;

@interface FidoTransaction : NSObject
@property (assign, nonatomic) id<FidoTransactionDelegate> delegate;

-(void)verifyCertification:(NSString*)ciOrIcid type:(FidoVerifyType)type;
-(void)inquireCertification:(NSString*)icid;
-(void)requestPinCheck:(NSString*)pin;
-(void)requestFido:(FidoCommandType)commandType;
-(void)requestFidoConfirm:(FidoCommandType)confirmType;
-(void)requestSSOData;

//************* 표인범 주임 변경 된 구조의 Instance Value
@property(nonatomic,assign) BOOL isOK;
@property(nonatomic,assign) NSInteger rtnOnepassCode;
@property(nonatomic,strong) NSString* rtnMsg;
@property(nonatomic,assign) NSInteger cmdType;
@property(nonatomic,assign) NSDictionary* rtnResultData;
@property(nonatomic,assign) NSString* rtnResultCode;
@property(nonatomic,assign) NSDictionary* rtnicData;

@property(nonatomic,strong) NSString* verifyType;
@property(nonatomic,strong) NSString* requestType;

//SSO
@property(nonatomic,strong) NSString* ssoData;
@property(nonatomic,strong) NSString* affiliatesCode;


@end

@protocol FidoTransactionDelegate <NSObject>
@optional

//결과
- (void)verifyResult:(BOOL)isOK message:(NSString*)msg data:(NSDictionary*)resultData;
- (void)inquireResult:(FidoTransaction*)fidoTransaction ;
- (void)pinCheckResult:(BOOL)isOK message:(NSString*)msg data:(NSDictionary*)resultData;

- (void)cancelFido;
- (void)updateicData:(FidoTransaction*)fidoTransaction ; // icData정보 콜백 분리.
- (void)fidoConfirmResult:(FidoTransaction*)fidoTransaction ;
- (void)fidoResult:(FidoTransaction*)fidoTransaction ;


@end
