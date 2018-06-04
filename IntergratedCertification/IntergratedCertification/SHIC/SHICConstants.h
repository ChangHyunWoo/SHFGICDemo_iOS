//
//  SHICConstants.h
//  IntergratedCertification
//
//  Created by 두베아이맥 on 2018. 2. 14..
//
//


#import <Foundation/Foundation.h>
#import "IntCertInterface.h"

//그룹사앱의 앱델리게이트 취득
#define SHIC_APPDELEGATE     ((AppDelegate *)[[UIApplication sharedApplication] delegate])

//도메인
#define SHIC_DOMAIN_AZURE_1         @"https://52.231.26.80"                     //MS-Azure Group 1 (OAuth)
#define SHIC_DOMAIN_AZURE_2         @"https://52.231.37.114"                    //MS-Azure Group 2 (OAuth)
#define SHIC_DOMAIN_BANK            @"https://sbk16.shinhan.com"                //신한은행(운영) (OAuth)
#define SHIC_DOMAIN_DEV_BANK        @"https://dev-sbk16.shinhan.com"            //신한은행(개발) (OAuth)
#define SHIC_DOMAIN_CARD            @"https://sharedplatform.shinhancard.com"   //신한카드(운영) (OAuth)
#define SHIC_DOMAIN_DEV_CARD        @"https://smttest.shinhanlife.co.kr:8414"   //신한카드(개발) (OAuth)
#define SHIC_DOMAIN_INVESTMENT      @"https://open.shinhaninvest.com"           //신한금융투자(운영) (OAuth)
#define SHIC_DOMAIN_DEV_INVESTMENT  @"https://mdev1.shinhaninvest.com"          //신한금융투자(개발) (OAuth)
#define SHIC_DOMAIN_INSURANCE       @"https://smt.shinhanlife.co.kr"            //신한생명(운영) (OAuth)
#define SHIC_DOMAIN_DEV_INSURANCE   @"https://smttest.shinhanlife.co.kr:8414"   //신한생명(개발) (OAuth)

// NSLog 매크로
#define SHIC_DEBUG
#ifdef SHIC_DEBUG//_DEBUG_
#define SHICLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define SHICLog(...)
#endif

#define SHIC_KEY_BANK        @"BANK"
#define SHIC_KEY_CARD        @"CARD"
#define SHIC_KEY_INVEST      @"INVESTMENT"
#define SHIC_KEY_INSURANCE   @"INSURANCE"

@interface SHICConstants : NSObject

+ (NSString*)address:(NSString*)path ;
+ (NSString *)deviceModel ;
@end

