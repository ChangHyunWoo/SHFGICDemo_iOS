//
//  pinBio_0012_ServerManager.h
//  onepassIosSdkfull_framework
//
//  Created by raonsecure on 2018. 4. 9..
//  Copyright © 2018년 h. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface pinBio_0012_Manager : NSObject

+ (id)sharedInstance;
- (BOOL)addDataPinBio0012:(int)index data:(NSData *)data keyidBase64Url:(NSString*)keyidBase64Url success:(void(^)(NSString *))success failedBlock:(void(^)(int ))failedBlock;
- (void)getDataPinBioServer:(NSString*)keyidBase64Url data:(NSData *)data successBlock:(void (^)(NSData *))successBlock withFailedBlock:(void (^)(int))failedBlock withCancelBlock:(void (^)(void))CancelBlock;
- (void)deRegDataPinBioServer:(NSString*)keyidBase64Url successBlock:(void (^)(NSData *))successBlock withFailedBlock:(void (^)(int))failedBlock withCancelBlock:(void (^)(void))CancelBlock;
//- (void)changeDataPinBioServer:(NSString*)keyidBase64Url oldData:(NSData *)oldData newData:(NSData *)newData successBlock:(void (^)(NSData *))successBlock withFailedBlock:(void (^)(int))failedBlock withCancelBlock:(void (^)(void))CancelBlock;

@end
