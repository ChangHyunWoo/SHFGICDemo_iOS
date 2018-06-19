//
//  UafHelper.h
//  raon_rpclient
//
//  Created by h on 2015. 9. 22..
//  Copyright © 2015년 h. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UafHelper : NSObject

+(NSMutableDictionary *) getHeaderFromResponse:(NSString *)uafResponse;
+(NSString*) objectToJson:(id)mutable;
+(NSString *) setHeaderToResponse:(NSString *)uafMessage header:(NSMutableDictionary*) header;

@end
