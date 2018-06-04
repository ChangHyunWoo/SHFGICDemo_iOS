//
//  SHICConstants.m
//  IntergratedCertification
//
//  Created by 두베아이맥 on 2018. 2. 14..
//
//

#import "SHICConstants.h"
#include <sys/types.h>
#include <sys/sysctl.h>

@implementation SHICConstants

+ (NSString*)address:(NSString*)path {
    NSString* domain = @"";
    if( [[IntCertInterface sharedInstance].property[@"isReal"] boolValue] )
        domain = [IntCertInterface sharedInstance].property[@"domainForService"];
    else
        domain = [IntCertInterface sharedInstance].property[@"domainForDevelopment"];
    
    return [NSString stringWithFormat:@"%@/%@", domain, path];
}

+ (NSString *)deviceModel {
    
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *model = (char *)malloc(size);
    sysctlbyname("hw.machine", model, &size, NULL, 0);
    NSString *deviceModel = [NSString stringWithCString:model encoding:NSUTF8StringEncoding];
    free(model);
    
    return deviceModel;
}
@end
