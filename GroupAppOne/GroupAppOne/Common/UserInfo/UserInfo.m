//
//  NSObject+UerInfo.m
//  GroupAppOne
//
//  Created by INBEOM on 2018. 3. 12..
//  Copyright © 2018년 두베아이맥. All rights reserved.


#import "UserInfo.h"
#import "PasswordViewController.h"
#import <IntergratedCertification/IntergratedCertification.h>

#define ICID_SAVE @"ICID_Shaared "
#define ICID_LIST_SAVE @"ICID_LIST_SAVE"

NSMutableDictionary *userList;

@implementation UserInfo

- (id)init
{
    self = [super init];

    if(!userList)
        userList = [[NSMutableDictionary alloc] init];

    [self testUserInit];

    return self;
}

-(NSArray*)getUserList
{
    if(!userList){
        userList = [[NSMutableDictionary alloc] init];
        [self testUserInit];
    }
    

    return [userList allKeys];
}

-(void)testUserInit
{
//    [userList setDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:ICID_LIST_SAVE]];
//
//    //저장된 IC정보가 없으면 Init
//    if(userList.count <= 0){
//        [self clearICList];
//    }

    [self createUserList];
    

#if ICClear_FLAG //초기화 Flag 확인
    [self clearICList];
#endif

}


-(NSString*)getUserCI:(NSString*)userName
{
    _userCI = [userList objectForKey:userName];

    return _userCI;
}

+(void)saveUesrInfo:(NSDictionary*)dicUserInfo
{
    NSMutableDictionary *saveDic = [[NSMutableDictionary alloc] initWithDictionary:dicUserInfo];
    [[NSUserDefaults standardUserDefaults] setObject:saveDic forKey:USERINFO_DEVICEUESRINFO];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSMutableDictionary*)getUserInfo
{
    NSMutableDictionary *dicUserInfo = [[NSUserDefaults standardUserDefaults] objectForKey:USERINFO_DEVICEUESRINFO];

    if(dicUserInfo){
        //Shared Value Set.
        NSString* icid = [dicUserInfo objectForKey:KEY_ICID];
        [[SHICUser defaultUser] put:KEY_CI value:[dicUserInfo objectForKey:KEY_CI]];
        [[SHICUser defaultUser] put:KEY_NAME value:[dicUserInfo objectForKey:KEY_NAME]];
//        [[SHICUser defaultUser] put:KEY_LOGIN value:@(NO)];
        [[SHICUser defaultUser] put:KEY_LOGIN_OTHER value:@(NO)];
        [[SHICUser defaultUser] put:KEY_ICID value:icid];

        return dicUserInfo;
    }
    else{
//        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"알림"
//                                                          message:@"통합인증서비스에 가입되어 있지 않습니다."
//                                                         delegate:nil
//                                                cancelButtonTitle:@"확인"
//                                                otherButtonTitles:nil];
//
//        [message show];

        return nil;
    }
}

+(void)removeUserInfo
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USERINFO_DEVICEUESRINFO];
}



+(void)checkFingerRegist:(UIViewController*)target setDelegate:(id)delegate
{
    NSMutableDictionary *dicUserInfo = [UserInfo getUserInfo];

    //*** FaceID는 메세지 출력
    BOOL available = [D_CA isTouchValiable];
    if(!available){
        RUN_ALERT_PANEL(@"지문사용 불가상태 입니다.");
        return;
    }

    // 기존 지문인증 등록이 되어 있는경우. (LocalPreference)
    if([[dicUserInfo objectForKey:KEY_ISREGISTFIDO] isEqualToString:@"01"]){
        FidoTransaction* transaction = [[FidoTransaction alloc] init];
        transaction.delegate = delegate;
        transaction.verifyType=SERVERCODE_VERIFYTYPE_FIDO;
        NSInteger requestType = [[NSUserDefaults standardUserDefaults] integerForKey:@"REQUEST_TYPE"];
        [transaction requestFido:(FidoCommandType)requestType];
    }
    // 기존 지문인증 등록이 되어 있지 않은 경우 = 등록절차 진행  (LocalPreference)
    else{
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"OnePass"
                                      message:@"신한통합인증 지문이 등록되어 \n 있지 않습니다. \n 신한통합인증 로그인을 지문으로 설정 하시겠습니까?"
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
                                 [alert dismissViewControllerAnimated:YES completion:nil];

                                 [[NSUserDefaults standardUserDefaults] setInteger:FidoCommandForUserFingerRegistAuth forKey:@"REQUEST_TYPE"];
                                 [[NSUserDefaults standardUserDefaults] synchronize];

                                 PasswordViewController* passwordView = [[PasswordViewController alloc] init];
                                 passwordView.viewType=PASSWORDVIEWTYPE_ADDFINGER;
                                 [target.navigationController pushViewController:passwordView animated:YES];

                             }];

        [alert addAction:cancel];
        [alert addAction:ok];
        [target presentViewController:alert animated:YES completion:nil];
    }
}

//난수로 매번 변경되는 IC값 생성.
-(void)clearICList
{
    NSUserDefaults * defs = [NSUserDefaults standardUserDefaults];
    NSDictionary * dict = [defs dictionaryRepresentation];
    for (id key in dict) {
        [defs removeObjectForKey:key];
    }
    [defs synchronize];

    //기존 저장된 ICLIST 초기화. ()
    NSMutableArray* array = [[NSMutableArray alloc] initWithCapacity:0];
    [[NSUserDefaults standardUserDefaults] setObject:array forKey:@"ICID_LIST"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


//유지되는 IC값
-(void)createUserList
{
    [userList setObject:[NSString stringWithFormat:@"Z180503daslhyzkLxq4+8XpAWPbF41pBFyN+c/k8qJBGXcaBs6RGrXWvNKi0KLrHmv5UxH2XTAG2LjRkHu1200=="] forKey:@"자감금"];
    [userList setObject:[NSString stringWithFormat:@"Z180503uRgXrrS633LuUk4ui381l77t7CwsbFIcOhf32Dkl4MbvHzsQRv3GRrVFlQYtJSjtPVxTcjPm3Pp1210=="] forKey:@"궉지연"];
    [userList setObject:[NSString stringWithFormat:@"Z180503SPPpNR7rrUtTql2NBrVvbUJuK7sx8EZunuZbs6ptNTbQ6pXiDJFVlie1bjxskLD39FGZstmm1VU1220=="] forKey:@"후수천"];
    [userList setObject:[NSString stringWithFormat:@"Z180503kLvQTc60lCMZ/w92bxglvOPqWxocmdRBm7T8PwfKtr/D9W4mb8J25s/E0KkIhlO9HFT89HB58Py1230=="] forKey:@"영재문"];
    [userList setObject:[NSString stringWithFormat:@"Z180503LM7q4MnMgwzuBQSueUoi6UtNj0fOIAeZO8U5aUaomt2Nqc78vlWDgmRn0caSkxj00zecPbackIk1240=="] forKey:@"후장곤"];
}



@end
