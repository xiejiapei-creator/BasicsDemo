//
//  NetworkServerDownLoadTool.h
//  合并两个有序链表
//
//  Created by 谢佳培 on 2020/7/27.
//  Copyright © 2020 xiejiapei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFURLSessionManager.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^DonwLoadSuccessBlock)(NSURL* fileUrlPath ,NSURLResponse* response);
typedef void (^DownLoadfailBlock)(NSError* error ,NSInteger statusCode);
typedef void (^DowningProgress)(CGFloat progress);

@interface NetworkServerDownLoadTool : NSObject

@property (nonatomic,strong) AFURLSessionManager *manager;

/** 下载历史记录 */
@property (nonatomic,strong) NSMutableDictionary *downLoadHistoryDictionary;

/** 获取到网络请求单例对象 */
+ (instancetype)sharedTool;

/**
 文件下载
 @param urlHost 下载地址
 @param progress 下载进度
 @param localUrl 本地存储路径
 @param success 下载成功
 @param failure 下载失败
 @return downLoadTask
 */
- (NSURLSessionDownloadTask  *)AFDownLoadFileWithUrl:(NSString*)urlHost
                                            progress:(DowningProgress)progress
                                        fileLocalUrl:(NSURL *)localUrl
                                             success:(DonwLoadSuccessBlock)success
                                             failure:(DownLoadfailBlock)failure;

/** 停止所有的下载任务 */
- (void)stopAllDownLoadTasks;

@end

NS_ASSUME_NONNULL_END
