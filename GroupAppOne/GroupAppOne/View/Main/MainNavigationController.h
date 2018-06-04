//
//  UINavigationController+MainNavigationController.h
//  www
//
//  Created by DEV-iOS on 2016. 3. 11..
//  Copyright © 2016년 KIZM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainNavigationController:UINavigationController

+(void)setNavigationBackButton:(UINavigationController*)naviVeiw setItems:(UINavigationItem*)items setDelegate:(id)delegate isBack:(BOOL)bBack isRightMenu:(BOOL)bRightMenu;

@end
