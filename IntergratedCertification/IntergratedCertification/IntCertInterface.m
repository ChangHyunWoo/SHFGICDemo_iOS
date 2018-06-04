//
//  IntCertInterface.m
//  IntergratedCertification
//
//  Created by 두베아이맥 on 2018. 1. 24..
//
//

#import "IntCertInterface.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import "SHICProperty.h"
#import "SHICTransaction.h"
#import "SHICAPISession.h"
#import "SHICConstants.h"

@interface IntCertInterface()
@property(nonatomic) BOOL initialized;

@end

@implementation IntCertInterface


//초기화
- (instancetype) init
{
    if(self=[super init]){
        self.initialized = YES;
    }
    return self;
}

//싱글톤 오브젝트
+ (id)sharedInstance
{
    static IntCertInterface * _sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        _sharedInstance=[[self alloc] init];
    });
    return _sharedInstance;
}
//초기화여부
- (BOOL)isInitialized
{
    return self.initialized ? YES:NO;
}

- (void)initialize:(void*)property{
    SHICProperty * ptr = (__bridge SHICProperty*)property;
    _property	= [NSMutableDictionary dictionaryWithDictionary:@{@"isReal":@(ptr.isReal),
                                                                  @"logging":@(ptr.logging),
                                                                  @"domainForService":ptr.domainForService,
                                                                  @"domainForDevelopment":ptr.domainForDevelopment,
                                                                  @"clientID":ptr.clientID,
                                                                  @"clientSecret":ptr.clientSecret,
                                                                  @"subChannel":ptr.subChannel,
                                                                  @"udid":ptr.udid,
#if TARGET_OS_SIMULATOR
                                                                  @"carrier":@"SKTelecom",
#else
                                                                  @"carrier":[self getCarrier],
#endif
                                                                  @"deviceModel":[SHICConstants deviceModel],
                                                                  @"deviceOs":[NSString stringWithFormat:@"iOS %@", [[UIDevice currentDevice] systemVersion]],
                                                                  @"appVersion":[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"],
                                                                  @"appName":ptr.appName}];
    //운영
    if(ptr.isReal){
        [SHICAPISession defaultSession].target = ptr.domainForService;
    }//개발
    else{
        [SHICAPISession defaultSession].target = ptr.domainForDevelopment;
    }
    SHICLog(@"target = %@",[SHICAPISession defaultSession].target);

}
- (NSString*)tagetBundle
{
    return [[NSBundle mainBundle] bundleIdentifier];
}
- (NSString *)getCarrier
{
    
    NSString * result = Nil;
    
    CTTelephonyNetworkInfo *netInfo = [[CTTelephonyNetworkInfo alloc] init];
    
    CTCarrier *pCarrier = [netInfo subscriberCellularProvider];
    
    if( pCarrier != Nil ) {
        result = [pCarrier carrierName];
    }
    
    if( result == Nil ){
        result = @"";
    }
    
    return result;
    
}


@end
