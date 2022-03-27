//
//  DownloadNetworkTool.h
//  BreakpointContinuationDemo
//
//  Created by 谢佳培 on 2021/2/20.
//  Copyright © 2021 xiejiapei. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DownLoadDelegate <NSObject>

@optional
- (void)backDownprogress:(float)progress tag:(NSInteger)tag;
- (void)downSucceed:(NSURL*)url tag:(NSInteger)tag;
- (void)downError:(NSError*)error tag:(NSInteger)tag;

@end

@interface DownloadNetworkTool : NSObject

@property (nonatomic, copy) NSString* fileName;
@property (nonatomic, weak) id<DownLoadDelegate> myDeleate;
@property (nonatomic, assign) NSInteger tag;// 某个文件下载的的标记

- (void)downFile:(NSString*)fileUrl;
- (void)suspendDownload;
- (void)suspendAndSaveFileDownload;

@end
