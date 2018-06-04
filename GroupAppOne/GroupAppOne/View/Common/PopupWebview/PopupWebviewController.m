//
//  UIViewController+PopupWebview.m
//  GroupAppOne
//
//  Created by INBEOM on 2018. 4. 4..
//  Copyright © 2018년 두베아이맥. All rights reserved.
//

#import "PopupWebviewController.h"

@implementation PopupWebviewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    self.lblTitle.text=self.strTitle;

    [D_CA createWebview:self.viewContents setUrl:self.strSetUrl];
}

//AutoLayout 제약조건 적용 후 WebViewLoad
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    if (IOS_VERSION_GREATER_THAN(11) && IS_IPHONE_X){
        /***** TopLayout / BottomLayou GuideViewHeight *****/
        [_viewTopLayoutHeightConstraint setConstant:self.topLayoutGuide.length];
        [_viewBottomLayoutHeightConstraint setConstant: self.bottomLayoutGuide.length ];
    }
}


- (IBAction)btnCloseTouchUpInside:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
