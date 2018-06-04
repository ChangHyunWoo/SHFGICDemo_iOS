//
//  FDURLInfo.h
//  fidoclient
//
//  Created by SuJungPark on 2015. 9. 10..
//  Copyright (c) 2015년 SuJungPark. All rights reserved.
//

#import <Foundation/Foundation.h>

#define UAFKey      @"key"
#define UAFState    @"state"
#define UAFJSON     @"json"
#define CUSTOM_RESULTCODE @"resultCode"


@interface UAFURLInfo : NSObject
- (BOOL) setURL : (id) url;
    
@property (nonatomic , assign)NSString* uafreqtype;
@property (nonatomic , retain)NSMutableDictionary* parameters;

@end
