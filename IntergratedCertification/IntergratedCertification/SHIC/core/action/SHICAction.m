//
//  SHICAction.m
//  IntergratedCertification
//
//  Created by 60000733 on 2016. 9. 21..
//  Copyright © 2016년 60000720. All rights reserved.
//

#import "SHICAction.h"
#import "SHICActionManager.h"
#import "SHSharedPlatform.h"
#import "SHICActionResponder.h"

// dynamic block
#import <objc/runtime.h>


static char ACTION_AFTER_RUN_BLOCK_IDENTIFER = 0;

@implementation SHICAction

- (NSDictionary*)request:(NSDictionary*)parameter completion:(RunBlockAfterAction)block {
	_action = parameter[@"ACTION"];
    
    self.actionAfterProcessBlock = block;
    self.deliveryParameter       = parameter;
    
    NSString* key = [[SHICActionManager defaultManager] registerAction:self];
    NSMutableDictionary* param = [[NSMutableDictionary alloc] initWithDictionary:parameter];
    param[@"ACTION_ID"] = key;
    param[@"BLOCK"] = self.actionAfterProcessBlock;
    
    return [[[SHSharedPlatform instance] responder] onReceive:param];
}

- (void)didResultActionWithResult:(NSDictionary*)resultData {
	
}

#pragma mark - block

- (RunBlockAfterAction)actionAfterProcessBlock
{
    return objc_getAssociatedObject(self, &ACTION_AFTER_RUN_BLOCK_IDENTIFER);
}

- (void)setActionAfterProcessBlock:(RunBlockAfterAction)block
{
    @synchronized(self) {
        if (block == nil) {
            objc_removeAssociatedObjects(self);
        } else {
            objc_setAssociatedObject(self, &ACTION_AFTER_RUN_BLOCK_IDENTIFER, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
        }
    }
}

@end
