//
//  UINavigationController+MainNavigationController.m
//  www
//
//  Created by DEV-iOS on 2016. 3. 11..
//  Copyright © 2016년 KIZM. All rights reserved.
//

#import "MainNavigationController.h"
#import "SSOViewController.h"
#import "IntCertManagementViewController.h"
#import "QRReqderViewcontroller.h"

@implementation MainNavigationController:UINavigationController
    UINavigationController *naviController;



+(void)setNavigationBackButton:(UINavigationController*)naviVeiw setItems:(UINavigationItem*)items setDelegate:(id)delegate isBack:(BOOL)bBack isRightMenu:(BOOL)bRightMenu
{
    //네비게이션 타겟 지정
    naviController=naviVeiw;


    //**** Back Event Init
    if(naviController.viewControllers.count > 1 && bBack){// 뒤로 이동 될 팝업이 있는 경우에만 생성.
        UIView *backView = [[UIView alloc] init];

        UIButton *btnBack = [[UIButton alloc] initWithFrame:CGRectMake(5, 0, 20, 25)];
        [btnBack setBackgroundImage:[UIImage imageNamed:@"gnb_ico_back"] forState:UIControlStateNormal];
        [btnBack addTarget:self action:@selector(doGoback) forControlEvents:UIControlEventTouchUpInside];

        CGRect backFrame = backView.frame;
        backFrame.size.width = btnBack.frame.size.width + 10;
        backFrame.size.height = 44/2;
        backView.frame = backFrame;

        [backView addSubview:btnBack];
        UIBarButtonItem* labelButton = [[UIBarButtonItem alloc] initWithCustomView:backView];

        //라벨 크기 조정
        CGRect frame = labelButton.customView.frame;
        frame.size.width += 10;
        labelButton.customView.frame = frame;


        //아이템 셋
        items.leftBarButtonItems=@[labelButton];

        //슬라이드 백이벤트 생성
        if ([naviVeiw respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            naviVeiw.interactivePopGestureRecognizer.delegate = delegate;
            naviVeiw.interactivePopGestureRecognizer.enabled = YES;
        }
    }
    else{
        naviVeiw.interactivePopGestureRecognizer.delegate = delegate;
        naviVeiw.interactivePopGestureRecognizer.enabled = NO;
        [items setHidesBackButton:YES];
    }


    //Right Button Init
    if(bRightMenu){
        UIView *backView2 = [[UIView alloc] init];

        UIButton *btnMenu = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, 30, 30)];
        [btnMenu setBackgroundImage:[UIImage imageNamed:@"gnb_ico_menu"] forState:UIControlStateNormal];
        [btnMenu addTarget:self action:@selector(goRightMenu) forControlEvents:UIControlEventTouchUpInside];

        CGRect backFrame2 = backView2.frame;
        backFrame2.size.width = btnMenu.frame.size.width + 10;
        backFrame2.size.height = 44/2;
        backView2.frame = backFrame2;

        [backView2 addSubview:btnMenu];
        UIBarButtonItem* labelButton2 = [[UIBarButtonItem alloc] initWithCustomView:backView2];

        //라벨 크기 조정
        CGRect frame2 = labelButton2.customView.frame;
        frame2.size.width += 10;
        labelButton2.customView.frame = frame2;


        //아이템 셋
        items.rightBarButtonItems=@[labelButton2];
    }
}

+(void)doGoback
{
    [naviController popViewControllerAnimated:YES];

    NSArray* array = [naviController viewControllers];

    for(UIViewController* controller in array)
    {
        if([controller isKindOfClass:[QRReqderViewcontroller class]])
        {
            [naviController popViewControllerAnimated:YES];
        }
    }
}

+(void)goRightMenu
{
//    NSLog(@"goRightMenu");
//    IntCertManagementViewController* settingViewController = [[IntCertManagementViewController alloc] init];
//    [naviController pushViewController:settingViewController animated:YES];

    BOOL isLogin = [[SHICUser defaultUser] getBoolean:KEY_LOGIN];
    if(isLogin){
        SSOViewController* ssoViewController =[[SSOViewController alloc] init];
        [naviController pushViewController:ssoViewController animated:YES];
    }
    else{
        RUN_ALERT_PANEL(@"로그인이 필요합니다.");
    }

}


@end
