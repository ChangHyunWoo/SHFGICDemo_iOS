//
//  OPLoadingViewController.h
//  onepassIosSdkfull
//
//  Created by Eliot Choi on 2016. 7. 14..
//  Copyright © 2016년 h. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OPLoadingViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *topImageView;

@property (weak, nonatomic) IBOutlet UIImageView *loadingImageView;

+ (void)funcBugFix;

@end
