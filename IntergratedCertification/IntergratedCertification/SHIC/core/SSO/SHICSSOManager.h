//
//  NSObject+SHICSSOManager.h
//  IntergratedCertification
//
//  Created by INBEOM on 2018. 4. 12..
//

#import <Foundation/Foundation.h>

#define SHICSSOMANAGER_KEY @"SHICSSOMANAGER_KEY"

@protocol SSOManagerDelegate;

@interface SHICSSOManager:NSObject

@property (assign, nonatomic) id<SSOManagerDelegate> delegate;
-(void)requestSSO:(NSString*)strAPICode setCode:(NSString*)code setTarget:(NSString*)targetID;
@end


@protocol SSOManagerDelegate <NSObject>
@optional

-(void)doOpenURL:(NSString*)strSamlToken;
-(void)doSSOLogin;

@end
