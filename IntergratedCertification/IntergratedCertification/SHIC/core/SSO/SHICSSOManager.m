//
//  NSObject+SHICSSOManager.m
//  IntergratedCertification
//
//  Created by INBEOM on 2018. 4. 12..
//

#import "SHICSSOManager.h"

@implementation SHICSSOManager


/* SSO 요청
    구분 코드 , 타겟앱, 구분코드
    요청앱 보안코드
 */
-(void)requestSSO:(NSString*)strAPICode setCode:(NSString*)code setTarget:(NSString*)targetID
{
//    SHICTransaction* tr = [[SHICTransaction alloc] initWithDelegate:self];
//    [tr putUri:@"/shic/v1.0/verifyShic"];
//
//    [tr transmitWithFinished:^(SHICTransaction *tr) {
//        NSMutableDictionary * resultDict = tr.response;
//        NSString* resultCode = resultDict[@"dataBody"][@"resultCode"];
//        //성공
//        if(resultCode != nil && [resultCode isEqualToString:@"000"]){
//
//        }//Error 처리
//        else{
//
//        }
//
//    } failed:^(SHICTransaction *tr) {
//
//    } cancel:^(SHICTransaction *tr) {
//    }];

    NSLog(@"requestSSO");
    [self requestSamlToken];
}

-(void)requestSamlToken
{
    NSLog(@"requestSamlToken");

//    SHICTransaction* tr = [[SHICTransaction alloc] initWithDelegate:self];
//    [tr putUri:@"/shic/v1.0/verifyShic"];
//
//    [tr transmitWithFinished:^(SHICTransaction *tr) {
//        NSMutableDictionary * resultDict = tr.response;
//        NSString* resultCode = resultDict[@"dataBody"][@"resultCode"];
//        //성공
//        if(resultCode != nil && [resultCode isEqualToString:@"000"]){
//
//        }//Error 처리
//        else{
//
//        }
//    } failed:^(SHICTransaction *tr) {
//
//    } cancel:^(SHICTransaction *tr) {
//    }];


    if([_delegate respondsToSelector:@selector(doOpenURL:)])
        [_delegate doOpenURL:[NSString stringWithFormat:@"%@%@",SHICSSOMANAGER_KEY,@"asdjlkasdjaklsdjlaksjdklas13"]];
}

// SamlToken 인증
-(void)requestSamlTokenAuth
{

}

//로그인 페이지 호출 콜백?
-(void)requestLogin
{

}


@end
