//
//  SHICActionAuth.m
//  IntergratedCertification
//
//  Created by 60000733 on 2016. 11. 2..
//  Copyright © 2016년 60000720. All rights reserved.
//

#import "SHICActionAuth.h"

@implementation SHICActionAuth

- (void)extendSession{
	NSMutableDictionary* param = [NSMutableDictionary dictionary];
	param[@"ACTION"] = @"Auth.extendSession";
	
	[self request:param completion:nil];
}

- (void)isFIDOEnabled:(RunBlockAfterAction)block {
    NSMutableDictionary* param = [NSMutableDictionary dictionary];
    param[@"ACTION"] = @"Auth.isFIDOEnabled";
    
    [self request:param completion:block];
    
}

- (void)verifyFIDO:(NSDictionary*)parameter block:(RunBlockAfterAction)block {
    NSMutableDictionary* param = [NSMutableDictionary dictionary];
    param[@"ACTION"] = @"Auth.verifyFIDO";
    param[@"TRAN_ID"] = parameter[@"fidoNo"];

    [self request:param completion:block];
}

- (NSDictionary*)onAuthorized {
    NSMutableDictionary* param = [NSMutableDictionary dictionary];
    param[@"ACTION"] = @"Auth.onAuthorized";
    
    return [self request:param completion:nil];
}

- (NSDictionary*)onTransmitWithTarget:(NSString*)target {
    NSMutableDictionary* param = [NSMutableDictionary dictionary];
    param[@"ACTION"] = @"Auth.onTransmitWithTarget";
    param[@"TARGET"] = target;
    
    return [self request:param completion:nil];
}

- (NSDictionary*)update{
    NSMutableDictionary* param = [NSMutableDictionary dictionary];
    param[@"ACTION"] = @"Auth.update";
    
    return [self request:param completion:nil];
}

@end
