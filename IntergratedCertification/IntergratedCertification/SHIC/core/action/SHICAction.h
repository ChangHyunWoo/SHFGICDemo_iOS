//
//  SHICAction.h
//  IntergratedCertification
//
//  Created by 60000733 on 2016. 9. 21..
//  Copyright © 2016년 60000720. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void (^RunBlockAfterAction)(NSDictionary* resultParameter);



@interface SHICAction : NSObject

@property (nonatomic,readonly) NSString*			 action;
@property (nonatomic, copy   ) RunBlockAfterAction   actionAfterProcessBlock;
@property (nonatomic, strong ) NSDictionary*         deliveryParameter;

/**
 * 액션 호출
 */
- (NSDictionary*)request:(NSDictionary*)parameter completion:(RunBlockAfterAction)block;
- (void)didResultActionWithResult:(NSDictionary*)resultData;

@end
