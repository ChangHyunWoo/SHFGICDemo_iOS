//
//  NSObject+CommonZone.m
//  www
//
//  Created by DEV-iOS on 2015. 7. 15..
//  Copyright (c) 2015년 KIZM. All rights reserved.
//

#import "CommonZone.h"
#import "PopupWebviewController.h"

static CommonZone *sharedCommonZoneManager = nil;

@implementation CommonZone
{
    BOOL isAlertView;
    UserInfo *objUserInfo;
}
+(AppDelegate*)sharedAppDelegate
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

+(CommonZone*)sharedCommonZone {
    @synchronized(self) {
        if (sharedCommonZoneManager == nil)
        {
            sharedCommonZoneManager = [[self alloc] init];
        }
    }
    
    return sharedCommonZoneManager;
}

+(id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        if (sharedCommonZoneManager == nil) {
            sharedCommonZoneManager = [super allocWithZone:zone];
            return sharedCommonZoneManager;
        }
    }
    return nil;
}

-(id)copyWithZone:(NSZone *)zone {
    return self;
}

//**** 공통 버튼속성 적용 함수
-(UIColor*)colorWithHexString:(NSString*)hex
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];

    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];

    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];

    if ([cString length] != 6) return  [UIColor grayColor];

    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];

    range.location = 2;
    NSString *gString = [cString substringWithRange:range];

    range.location = 4;
    NSString *bString = [cString substringWithRange:range];

    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];

    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

-(void)setButtonBorder:(UIButton*)button setBorderColor:(NSString*)hexColor
{
    //라운드 처리
    button.layer.cornerRadius=3.0f;
    button.layer.masksToBounds=YES;

    if(hexColor.length  > 0){//컬러 값이 있을때만 Border Set
        button.layer.borderWidth=1.0f;//선 색,두께 조정
        button.layer.borderColor=[[self colorWithHexString:hexColor] CGColor];
    }
}


//*********** Shared Webview
-(void)createWebview:(UIView*)targerView setUrl:(NSString*)url
{
    [self performSelector:@selector(initWebview:) withObject:[NSArray arrayWithObjects:targerView,url, nil] afterDelay:0.0];
}

-(void)initWebview:(NSArray*)withObject
{
    UIView *targerView = [withObject objectAtIndex:0];
    NSString *url = [withObject objectAtIndex:1];

    UIWebView* webview = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, targerView.frame.size.width, targerView.frame.size.height)];
    [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    webview.delegate=self;
    [targerView addSubview:webview];
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *requestURL = [[request URL] absoluteString];
    NSLog(@"%@- requestURL %@",[self.class description],requestURL);
    NSLog(@"[_webViewMain.request.URL absoluteString] : %@",[webView.request.URL absoluteString]);

    if ([requestURL hasPrefix:@"jscall://"]) {
        NSString *requestString = [[request URL] absoluteString];
        NSArray *components = [requestString componentsSeparatedByString:@"goUrl?"];

        NSString *gotoUrl = [components objectAtIndex:1];
        NSLog(@"gotoUrl : %@",gotoUrl);

        //========== 팝업 Webview
        PopupWebviewController *popWebview = [[PopupWebviewController alloc] init];
        if([gotoUrl isEqualToString:@"pageNo=1"]){      // 지문이용안내
            popWebview.strSetUrl=WEBURL_SERVICEFINGERTERM;
            UIViewController *rootController = [[UIApplication sharedApplication] keyWindow].rootViewController;
            popWebview.strTitle=@"지문 이용 안내";
            [rootController presentViewController:popWebview animated:YES completion:nil];
        }
        else if([gotoUrl isEqualToString:@"pageNo=2"]){     // 비밀번호 이용 안내
            popWebview.strSetUrl=WEBURL_SERVICEPASSWORDTERM;
            UIViewController *rootController = [[UIApplication sharedApplication] keyWindow].rootViewController;
            popWebview.strTitle=@"비밀번호 이용 안내";
            [rootController presentViewController:popWebview animated:YES completion:nil];
        }

        return NO;
    }
    return YES;
}

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"webViewDidStartLoad");
    [self showLoading];
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"didFailLoadWithError");
    [self hideLoading];
}
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"webViewDidFinishLoad");
    [self hideLoading];
}


//*********** Loading
-(void)showLoading
{
    UIViewController *rootController = [[UIApplication sharedApplication] keyWindow].rootViewController;
    [rootController.view showActivityView];
}

-(void)hideLoading
{
    UIViewController *rootController = [[UIApplication sharedApplication] keyWindow].rootViewController;
    [rootController.view hideActivityView];
}

//Shared Userinfo 반환.
-(UserInfo*)getUserInfo
{
    if(!objUserInfo){
        objUserInfo=[[UserInfo alloc] init];
    }

    return objUserInfo;
}



//******************* Onepass처리 (가입과 동일하게 처리)
-(BOOL)isTouchValiable
{
    LAContext *context = [[LAContext alloc] init];
    NSError *error;

    if([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]  ){
        NSLog(@"11111");
        //FaceID 제외
        if (@available(iOS 11.0, *)) {
            NSLog(@"context.biometryType : %ld",context.biometryType);
            if (context.biometryType == LABiometryTypeFaceID) {
                return NO;
            }
        }

        return YES;
    }
//    else if([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]  ){
    else{
        NSLog(@"22222");
        return NO;
    }

    return YES;
}

#pragma mark -날짜정보 처리(숫자를 yyyy. mm. dd로 변경)
+(NSString *)DateFormate:(NSString *)strDate
{
    if( [strDate isKindOfClass:[NSNull class]] )
        return @"";

    if(strDate == nil || [strDate length] == 0 )
        return @"";
    
    // 문자열에서 년을 뽑아낸다
    NSString *strYYYY = [strDate substringWithRange:NSMakeRange(0, 4)];
    // 문자열에서 월을 뽑아낸다
    NSString *strMM = [strDate substringWithRange:NSMakeRange(4, 2)];
    // 문자열에서 일을 뽑아낸다
    NSString *strDD = [strDate substringWithRange:NSMakeRange(6, 2)];
    
    NSString *strAddString = [NSString stringWithFormat:@"%@.%@.%@", strYYYY, strMM, strDD];
    
    return strAddString;
}

+(NSString *)getCurrDate {
    NSDate * date = [NSDate date];
    NSDateFormatter * dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    [dateFormat setDateFormat:@"yyyyMMdd"];
    NSString * dateString = [dateFormat stringFromDate:date];

    return dateString;
}
@end


