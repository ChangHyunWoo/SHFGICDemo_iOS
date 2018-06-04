//
//  BioPinManager.h
//  public_onepass
//
//  Created by Sungha Ji on 2018. 4. 17..
//  Copyright © 2018년 라온시큐어_이민수. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <onepassIosSdkfull_framework/OnepassIosSdkfull_Support.h>


@interface BioPinManager : NSObject

+ (BioPinManager *)sharedSingleton;
- (void)showTKChangeView;

@property (nonatomic, retain) NSString *keyId;

@end
