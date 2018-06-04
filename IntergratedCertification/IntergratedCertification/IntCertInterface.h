//
//  IntCertInterface.h
//  IntergratedCertification
//
//  Created by 두베아이맥 on 2018. 1. 24..
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface IntCertInterface : NSObject
{
    
}
@property(readonly, nonatomic) NSMutableDictionary* property;

+ (instancetype) sharedInstance;
- (BOOL)isInitialized;
- (void)initialize:(void*)property;
- (NSString*)tagetBundle;


@end


