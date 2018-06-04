//
//  CXICURLTransaction.h
//  IntergratedCertification
//
//  Created by 60000732 on 2016. 9. 8..
//  Copyright © 2016년 60000720. All rights reserved.
//

#import <IntergratedCertification/CXICTransaction.h>

@interface CXICURLTransaction : CXICTransaction

@property (readonly, nonatomic) NSDictionary*       httpHeader;
@property (strong  , nonatomic) NSString*           method;
@property (strong  , nonatomic) NSString*           target;
@property (          nonatomic) NSStringEncoding    encodingTarget;
@property (          nonatomic) NSStringEncoding    encodingLocal;

- (void)putValue:(NSString*)value forHTTPHeader:(NSString*)key;

@end
