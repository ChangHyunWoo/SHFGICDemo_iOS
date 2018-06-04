//
//  UIViewController+PopupWebview.h
//  GroupAppOne
//
//  Created by INBEOM on 2018. 4. 4..
//  Copyright © 2018년 두베아이맥. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopupWebviewController:UIViewController
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

@property(nonatomic, strong)IBOutlet NSLayoutConstraint* viewTopLayoutHeightConstraint;     ///< iPhone X Top 대응 HeightConstraint
@property(nonatomic, strong)IBOutlet NSLayoutConstraint* viewBottomLayoutHeightConstraint;  ///< iPhone X Bottom 대응 HeightConstraint

@property (nonatomic, retain) IBOutlet UIView *viewTopLayout;
@property (nonatomic, retain) IBOutlet UIView *viewBodyLayout;
@property (nonatomic, retain) IBOutlet UIView *viewBottomLayout;
@property (nonatomic, retain) IBOutlet UIView *viewFlexible;
@property (nonatomic, retain) IBOutlet UIView *viewContents;

@property (nonatomic,strong) NSString* strSetUrl;
@property (nonatomic,strong) NSString* strTitle;

@end
