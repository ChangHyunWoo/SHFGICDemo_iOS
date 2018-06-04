//
//  AddAuthorizationViewController.h
//  GroupAppOne
//
//  Created by 두베아이맥 on 2018. 2. 26..
//  Copyright © 2018년 두베아이맥. All rights reserved.
//

#import <UIKit/UIKit.h>
#define AUTHORIZATIONVIEWTYPEADD_PASSWORDSEARCH @"PasswordSearch" //비밀번호 찾기

@interface AddAuthorizationViewController : UIViewController

@property(nonatomic, strong)IBOutlet NSLayoutConstraint* viewTopLayoutHeightConstraint;     ///< iPhone X Top 대응 HeightConstraint
@property(nonatomic, strong)IBOutlet NSLayoutConstraint* viewBottomLayoutHeightConstraint;  ///< iPhone X Bottom 대응 HeightConstraint


@property (nonatomic, strong) NSString *viewType;
@property (nonatomic, retain) IBOutlet UIView *viewTopLayout;
@property (nonatomic, retain) IBOutlet UIView *viewBodyLayout;
@property (nonatomic, retain) IBOutlet UIView *viewBottomLayout;
@property (nonatomic, retain) IBOutlet UIView *viewFlexible;
@property (nonatomic, retain) IBOutlet UIView *viewContents;

@end
