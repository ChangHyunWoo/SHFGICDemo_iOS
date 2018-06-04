//
//  CXICDownloader.h
//  IntergratedCertification
//
//  Created by 60000733 on 2016. 9. 21..
//  Copyright © 2016년 60000720. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CXICDownloader;

@protocol CXICDownloaderDelegate <NSObject>

@optional
- (void)onDownloadFailed:(CXICDownloader*)downloader error:(NSError *)error;
- (void)onDownloadFinished:(CXICDownloader*)downloader stream:(NSData*)stream;

@end


@interface CXICDownloader : NSObject <NSURLConnectionDelegate>

@property (strong, nonatomic) NSString*					downLoaderTag;
@property (strong, nonatomic) NSString*                 path;
@property (strong, nonatomic) id<CXICDownloaderDelegate>	delegate;

- (id)initWithTag:(NSString*)tag;
- (void)download:(NSString*)path;

@end
