//
//  SHICProperty.m
//  IntergratedCertification
//
//  Created by 두베아이맥 on 2018. 2. 14..
//
//

#import "SHICProperty.h"

@implementation SHICProperty
- (id)init
{
    self = [super init];
    if (self) {
        self.isReal                 = NO;
        self.logging				= NO;
        self.networkLogLevel        = SHICLogLevelFull;
        self.domainForService       = @"https://sbk16.shinhan.com";
        self.domainForDevelopment   = @"https://dev-sbk16.shinhan.com";
        self.clientID				= @"";
        self.clientSecret			= @"";
        self.subChannel				= @"";
        self.udid					= @"";
        self.appName                = @"";
        
    }
    return self;
}

@end
