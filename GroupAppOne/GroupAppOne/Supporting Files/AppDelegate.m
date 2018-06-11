//
//  AppDelegate.m
//  GroupAppOne
//
//  Created by 두베아이맥 on 2018. 1. 25..
//  Copyright © 2018년 두베아이맥. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "NSData+Base64.h"

#import "InformationUseViewController.h"
#import <IntergratedCertification/IntergratedCertification.h>

//RGB
#define D_RGB(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0f]
#define D_RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a/255.0f]


@interface AppDelegate ()<FidoTransactionDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] ;
    
    // Override point for customization after application launch.
    
    self.window.backgroundColor = [UIColor whiteColor];

    MainViewController *beginViewController = [[MainViewController alloc]init];
    UINavigationController *beginNavigationViewContrlr = [[UINavigationController alloc]initWithRootViewController:beginViewController];

    [self.window setRootViewController:beginNavigationViewContrlr];
    [self.window makeKeyAndVisible];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options{
    NSLog(@" openURL = %@", url);
    NSString* urlQuery = [url query];
    if(urlQuery == nil || [urlQuery length] == 0)
        return NO;

    NSLog(@" openURL: dataQuery:%@", urlQuery);


    //===================== 앱 Target URL 셋팅.
    [MainViewController updateProperty];


    //========================== 통합인증 SSO 요청을 구분하기 위한 키값 매칭.
    if([urlQuery hasPrefix:SSOSCHEMSKEY]){
        /*

         점검 항목
        1. 다른 로그인 수단 로그인 여부
        2. 통합인증 로그인 여부
        3. 통합인증서 정보가 없는 경우

         ?
            - 앱에 다른 인증서가 깔린 경우?
         */

        BOOL isLogin = [[SHICUser defaultUser] getBoolean:KEY_LOGIN];


        /*============1. 다른 로그인 수단 로그인 여부
            로그아웃 처리, SSO로그인 요청
        */
        if(0){
            UIViewController *rootController = [[UIApplication sharedApplication] keyWindow].rootViewController;
            //=================== 3. 통합인증서 정보가 없는 경우
            UIAlertController * alert=   [UIAlertController
                                          alertControllerWithTitle:@"알림"
                                          message:@"신한통합인증 서비스를 바로 이용 하시려면 앱 로그아웃 후 이용 가능 합니다. 신한통합인증으로 로그인 하시겠습니까?"
                                          preferredStyle:UIAlertControllerStyleAlert];

            UIAlertAction* cancel = [UIAlertAction
                                     actionWithTitle:@"취소"
                                     style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction * action){
                                         [alert dismissViewControllerAnimated:YES completion:nil];
                                     }];

            UIAlertAction* ok = [UIAlertAction
                                 actionWithTitle:@"확인"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     /*************************** 로그아웃 시퀀스 진행.
                                        ********** url정보를 별도 변수로 저장 후 , 시퀀 스 진행 후 SSOAuth를 보내도록 처리 필요 *********8
                                     */
                                     [self doSSOAuth:url];
                                 }];

            [alert addAction:cancel];
            [alert addAction:ok];
            [rootController presentViewController:alert animated:YES completion:nil];
        }


        //============ 2. 통합인증 로그인 여부
        if(isLogin){
            return NO;
        }


        NSMutableDictionary *userInfo= [UserInfo getUserInfo];
        if(userInfo){
            [self doSSOAuth:url];
        }
        else{
            //=================== 3. 통합인증서 정보가 없는 경우
            UIAlertController * alert=   [UIAlertController
                                          alertControllerWithTitle:@"알림"
                                          message:@"신한통합인증 가입 정보가 없습니다. 신한통합인증 서비스를 이용하시려면 가입 또는 등록해 주시기 바랍니다."
                                          preferredStyle:UIAlertControllerStyleAlert];

            UIAlertAction* cancel = [UIAlertAction
                                     actionWithTitle:@"취소"
                                     style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction * action){
                                         [alert dismissViewControllerAnimated:YES completion:nil];
                                     }];

            UIAlertAction* ok = [UIAlertAction
                                 actionWithTitle:@"확인"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     InformationUseViewController* infoUseViewController = [[InformationUseViewController alloc] init];
                                     [(UINavigationController*)self.window.rootViewController pushViewController:infoUseViewController animated:YES];
                                     [alert dismissViewControllerAnimated:YES completion:nil];

                                 }];

            [alert addAction:cancel];
            [alert addAction:ok];
            [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
        }
    }
        /*
        NSString *strIcid = [[[[urlQuery componentsSeparatedByString:@"&icid="] objectAtIndex:1] componentsSeparatedByString:@"&ssoData="] objectAtIndex:0];

        [[SHICUser defaultUser] put:KEY_ICID value:strIcid];
        
        NSString* strSSOData = [[[[urlQuery componentsSeparatedByString:@"&ssoData="] objectAtIndex:1] componentsSeparatedByString:@"&affiliatesCode="] objectAtIndex:0];

        NSString* strAffiliatesCode = [[[[urlQuery componentsSeparatedByString:@"&affiliatesCode="] objectAtIndex:1] componentsSeparatedByString:@"&goPage="] objectAtIndex:0];


        
        [[NSUserDefaults standardUserDefaults] setInteger:FidoCommandForUserSSOAuth forKey:@"REQUEST_TYPE"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        FidoTransaction* transaction = [[FidoTransaction alloc] init];
        transaction.delegate = self;
        transaction.verifyType=SERVERCODE_VERIFYTYPE_PIN;
        transaction.ssoData=strSSOData;
        transaction.affiliatesCode=strAffiliatesCode;
        [transaction requestFido:FidoCommandForUserSSOAuth];
         */


    //base64 스트링을 디코딩
//    NSData* decodingData = [NSData dataFromBase64String:urlQuery];
//    NSString* ssoIDStr = [[NSString alloc] initWithData:decodingData encoding:NSUTF8StringEncoding];
//
//     NSLog(@" ssoIDStr : %@", ssoIDStr);
//
//    if([ssoIDStr componentsSeparatedByString:SHICSSOMANAGER_KEY].count > 1){
//        NSLog(@"link SSOID = %@", ssoIDStr);
//        RUN_ALERT_PANEL([[ssoIDStr componentsSeparatedByString:SHICSSOMANAGER_KEY] objectAtIndex:1]);
//    }


    
    return YES;
}

/* SSO인증 요청
    openURL 에서 가져온 URL을 Key값으로 추출하여 Auth Request.
 */
-(void)doSSOAuth:(NSURL*)url
{
    NSURLComponents *urlComponents = [NSURLComponents componentsWithURL: url resolvingAgainstBaseURL: NO];
    NSDictionary *urlParameters = [self parseUrlComponents: urlComponents.queryItems];
    NSLog(@"Parameters\t:%@", urlParameters);
    NSLog(@"param1 = %@", [urlParameters objectForKey: @"ssoData"]);
    NSLog(@"param2 = %@", [urlParameters objectForKey: @"affiliatesCode"]);

    NSMutableDictionary *userInfo= [UserInfo getUserInfo];
    NSString* icid = [userInfo objectForKey:KEY_ICID];
    [[SHICUser defaultUser] put:KEY_ICID value:icid];

    [[NSUserDefaults standardUserDefaults] setInteger:FidoCommandForUserSSOAuth forKey:@"REQUEST_TYPE"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    FidoTransaction* transaction = [[FidoTransaction alloc] init];
    transaction.delegate = self;
    transaction.verifyType=SERVERCODE_VERIFYTYPE_PIN;
    transaction.ssoData=[urlParameters objectForKey: @"ssoData"];
    transaction.affiliatesCode=[urlParameters objectForKey: @"affiliatesCode"];
    [transaction requestFido:FidoCommandForUserSSOAuth];
}

/* URL Key값 추출.
 */
- (NSDictionary *) parseUrlComponents: (NSArray *) queryItems {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    //
    for(NSURLQueryItem *item in queryItems) {
        [dict setValue: item.value forKey: item.name];
    }
    //
    return dict;
}


#pragma mark - FidoTransactionDelegate
- (void)fidoResult:(FidoTransaction*)fidoTransaction{
    NSLog(@"fidoResult : <><><> %@ <><><>",fidoTransaction.rtnResultData);

    if(fidoTransaction.isOK){
        NSInteger requestType = [[NSUserDefaults standardUserDefaults] integerForKey:@"REQUEST_TYPE"];
        FidoTransaction* transaction = [[FidoTransaction alloc] init];
        transaction.verifyType = fidoTransaction.verifyType; // 현재 verifyType 핀,지문 을 Confirm에서 확인 후 Sign 시 Verify값을 전달하기 위해 Set.
        transaction.delegate = self;
        [transaction requestFidoConfirm:(FidoCommandType)requestType];
    }
    else{
        /* 18.06.11 변경
            SSO 요청 전 앱에서 인증서 상태에 대한 메세지를 출력 함으로, 인증서 상태관련 메세지 대신 실패 메세지 출력.
         [CertificateManager checkRequestFido:fidoTransaction];
         */
        RUN_ALERT_PANEL(@"SSO 인증에 실패 하였습니다.");

    }
}

- (void)fidoConfirmResult:(FidoTransaction*)fidoTransaction
{
    if(fidoTransaction.isOK){
        RUN_ALERT_PANEL(fidoTransaction.rtnMsg);
        [[SHICUser defaultUser] put:KEY_LOGIN value:@(YES)];

        //======================= 로그인상태를 업데이트 (MainViewController 로그인 버튼 상태 업데이트)
        for (UIViewController *view in [(UINavigationController*)self.window.rootViewController viewControllers]){
            if([view isKindOfClass:[MainViewController class]]){
                [view viewDidAppear:YES];
                break;
            }
        }
    }
    else{
        RUN_ALERT_PANEL(fidoTransaction.rtnMsg);
    }
}


@end
