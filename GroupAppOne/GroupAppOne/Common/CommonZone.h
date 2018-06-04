//
//  NSObject+CommonZone.h
//  www
//
//  Created by DEV-iOS on 2015. 7. 15..
//  Copyright (c) 2015년 KIZM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import "MainNavigationController.h"
#import "UserInfo.h"

#include <sys/utsname.h>

#import <LocalAuthentication/LocalAuthentication.h>

#define IOS_VERSION_GREATER_THAN(x) ([[[UIDevice currentDevice] systemVersion] floatValue] >= x)
#define IS_IPHONE_X  ([[UIScreen mainScreen] bounds].size.height <= 812.0f)        // 아이폰 X 여부
#define D_IS_DEVICE_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

#define D_CA [CommonZone sharedCommonZone]
#define D_CD [CommonZone sharedAppDelegate]

//RGB
#define D_RGB(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0f]
#define D_RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a/255.0f]
//GETVERSION


//USERDEFAULT
#define D_UD [NSUserDefaults standardUserDefaults]


//#define TEST_GROUP1  //prefix 분리해서 타겟 1에서만 정의 해서 사용
#define ICClear_FLAG 0

@class CommonZone ;

@interface CommonZone:NSObject<UIAlertViewDelegate,UIWebViewDelegate>

/**
 * 싱글톤 객체 반환
 * @return 싱글톤 객체
 */
+(CommonZone*)sharedCommonZone;
/**
 * AppDelegate 반환
 * @return 현재 앱의 Delegate 반환
 */
+(AppDelegate*)sharedAppDelegate;


//ALERT
#ifndef RUN_ALERT_PANEL
#define RUN_ALERT_PANEL(MSG) \
UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" \
message:(MSG) \
delegate:nil \
cancelButtonTitle:@"확인" \
otherButtonTitles:nil]; \
[alertView show]
#endif



//버튼 공통속성 적용.
-(UIColor*)colorWithHexString:(NSString*)hex;
-(void)setButtonBorder:(UIButton*)button setBorderColor:(NSString*)hexColor;
//공용 웹뷰 생성 밑 해당 뷰에 초기화.
-(void)createWebview:(UIView*)targerView setUrl:(NSString*)url;

//Loading
-(void)showLoading;
-(void)hideLoading;
//유저정보 Instance
-(UserInfo*)getUserInfo;
//지문인증 가능여부 체크,
-(BOOL)isTouchValiable;

+(NSString *)DateFormate:(NSString *)strDate;
+(NSString *)getCurrDate ;
@end
