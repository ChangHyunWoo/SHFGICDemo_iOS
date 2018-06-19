//
//  OPLoadingManager.h
//  onepassIosSdkfull
//
//  Created by Eliot Choi on 2016. 7. 14..
//  Copyright © 2016년 h. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

@interface OPLoadingManager : NSObject

+ (OPLoadingManager *_Nullable)sharedLoadingManager;
- (void)startLoading;
- (void)stopLoadingWithCompletion:(void (^ __nullable)(void))completion;

// Set Loading View using Custom View from Client
- (void)setLoadingViewController:(UIViewController *_Nullable) viewController;

// Set flag about hiding default Loading View
- (void)setFlagHidingLoadingView:(BOOL)isHiding;



@end
