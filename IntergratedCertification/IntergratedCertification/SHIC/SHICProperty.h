//
//  SHICProperty.h
//  IntergratedCertification
//
//  Created by 두베아이맥 on 2018. 2. 14..
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SHICLogLevel) {
    SHICLogLevelNone,
    SHICLogLevelSimple,
    SHICLogLevelFull
};
@interface SHICProperty : NSObject


//개발, 운영 서버로 접속 여부 설정 (YES:개발, NO:운영)
@property(assign, nonatomic)	BOOL		isReal;                   //DEFAULT: NO;
//로그 표시 여부
@property(assign, nonatomic)	BOOL		logging;                    //DEFAULT: NO;
//운영 서비스 도메인 or PATH
@property(strong, nonatomic)	NSString*	domainForService;
//개발 서비스 도메인 or PATH
@property(strong, nonatomic)	NSString*	domainForDevelopment;
//로그 표시 여부
@property(assign, nonatomic)    SHICLogLevel networkLogLevel;            //DEFAULT: SHSPLogLevelFull;

//게이트웨이 Client ID
@property(strong, nonatomic)	NSString*	clientID;
//게이트웨이 Client Secret
@property(strong, nonatomic)	NSString*	clientSecret;
//앱 구분 채널값 (예시: 01:써니뱅크, 02:S뱅크, 03:알리미)
@property(strong, nonatomic)	NSString*	subChannel;
//단말기 고유값
@property(strong, nonatomic)	NSString*	udid;
//전문 헤더에서 필요한 앱 이름
@property(strong, nonatomic)	NSString*	appName;


@end
