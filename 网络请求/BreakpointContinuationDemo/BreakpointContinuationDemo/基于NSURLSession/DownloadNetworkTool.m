//
//  DownloadNetworkTool.m
//  BreakpointContinuationDemo
//
//  Created by 谢佳培 on 2021/2/20.
//  Copyright © 2021 xiejiapei. All rights reserved.
//

#import "DownloadNetworkTool.h"
#import <CommonCrypto/CommonDigest.h>

@interface DownloadNetworkTool()<NSURLSessionDelegate>

@property (nonatomic) BOOL  isSuspend;
@property (nonatomic, copy) NSString* fileName;
@property (nonatomic, strong) NSData *myResumeData;

@end

@implementation DownloadNetworkTool

#pragma mark - 接口方法

- (void)downFile:(NSString*)fileUrl
{
    if (!fileUrl || fileUrl.length == 0 || ![self checkIsUrlAtString:fileUrl])
    {
        NSLog(@"fileUrl 无效");
        return ;
    }
    
    NSURL *url = [[NSURL alloc] initWithString:fileUrl];
    if (!self.session)
    {
        // 创建网络会话
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:[self currentDateStr]];
        config.allowsCellularAccess = YES;
        config.timeoutIntervalForRequest = 30;
        self.session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    }
    
    NSFileManager *fileManager = NSFileManager.defaultManager;
    if (![fileManager fileExistsAtPath:[self getTmpFileUrl]])
    {
        // 下载文件不存在则新建下载任务
        self.downloadTask = [self.session downloadTaskWithURL:url];
    }
    else
    {
        // 下载文件已经存在则继续
        [self downloadWithResumeData];
    }
    [self.downloadTask resume];
    
    // 保存下载进度的另外一种方式：预防下载过程中突然杀掉app需要开启定时器提前保存临时文件
    [self saveTmpFile];
}

// 暂停下载
- (void)suspendDownload
{
    if (self.isSuspend)
    {
        [self.downloadTask resume];
    }
    else
    {
        [self.downloadTask suspend];
    }
    self.isSuspend = !self.isSuspend;
}

// 暂停并保存下载进度
- (void)suspendAndSaveFileDownload
{
    // 点击暂停的时候需要保存目前已经下载的data
    [self.downloadTask cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
        [resumeData writeToFile:[self getTmpFileUrl] atomically:YES];
        self.downloadTask = nil;
    }];
}

#pragma mark - NSURLSessionDelegate

// 每传一个数据包则调用一次该函数
- (void)URLSession:(nonnull NSURLSession *)session downloadTask:(nonnull NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    // 根据tag记录每个任务的下载进度，用于继续下载
    float downloadProgress = 1.0 * totalBytesWritten/totalBytesExpectedToWrite;

    if(self.myDeleate && [self.myDeleate respondsToSelector:@selector(backDownprogress:tag:)])
    {
        [self.myDeleate backDownprogress:downloadProgress tag:self.tag];
    }
}

// 下载完成之后调用该方法
- (void)URLSession:(nonnull NSURLSession *)session downloadTask:(nonnull NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(nonnull NSURL *)location
{
    NSLog(@"下载文件的临时路径：%@",location.path);
    
    // 下载文件的更换路径
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) lastObject];
    NSString *file = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4",self.fileName]];

    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath: file])
    {
        // 如果文件夹下有同名文件则将其删除
        [manager removeItemAtPath:file error:nil];
    }
    
    // 将视频资源从原有路径移动到自己指定的路径
    NSError *saveError;
    [manager moveItemAtURL:location toURL:[NSURL URLWithString:file] error:&saveError];
    BOOL success = [manager copyItemAtPath:location.path toPath:file error:nil];
    if (success)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            // 回传移动后的文件路径的url
            NSURL *url = [[NSURL alloc] initFileURLWithPath:file];
            if(self.myDeleate && [self.myDeleate respondsToSelector:@selector(downSucceed:tag:)])
            {
                [self.myDeleate downSucceed:url tag:self.tag];
            }
        });
    }
    
    // 已经拷贝则删除临时缓存文件
    [manager removeItemAtPath:location.path error:nil];
    [manager removeItemAtPath:[self getTmpFileUrl] error:nil];
}

// 下载失败调用
- (void)URLSession:(nonnull NSURLSession *)session task:(nonnull NSURLSessionTask *)task didCompleteWithError:(nullable NSError *)error
{
    // 根据不同错误反馈不同
    if(error && self.myDeleate && [self.myDeleate respondsToSelector:@selector(downError:tag:)] && error.code != -999)
    {
        [self.myDeleate downError:error tag:self.tag];
    }
}

- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session
{
    NSLog(@"所有后台任务已经完成: %@",session.configuration.identifier);
}

#pragma mark - 断点续传

// 断点下载
- (void)downloadWithResumeData
{
    if (!self.session)
    {
        return;
    }
    
    // 通过之前保存的数据创建下载任务继续下载
    NSFileManager *fileManager = NSFileManager.defaultManager;
    NSData *dowloadData = [fileManager contentsAtPath:[self getTmpFileUrl]];
    self.downloadTask = [self.session downloadTaskWithResumeData:dowloadData];
    self.resumeData = nil;
}

// 未下载完的临时文件的url地址
- (NSString*)getTmpFileUrl
{
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [docPath stringByAppendingPathComponent:@"download.tmp"];
    NSLog(@"未下载完的临时文件的url地址：%@",filePath);

    return filePath;
}

// 预防下载过程中突然杀掉app需要开启定时器提前保存临时文件
- (void)saveTmpFile
{
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(downloadTmpFile) userInfo:nil repeats:YES];
}

// 由于通过计时器提前保存了临时文件，杀掉app后不至于下载的部分文件全部丢失
- (void)downloadTmpFile
{
    if (self.isSuspend)
    {
        return;
    }
    
    [self.downloadTask cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
        [resumeData writeToFile:[self getTmpFileUrl] atomically:YES];
        self.downloadTask = nil;
        self.downloadTask = [self.session downloadTaskWithResumeData:resumeData];
        [self.downloadTask resume];
    }];
}

#pragma mark - 辅助方法

// 可以对文件名称进行MD5加密
- (NSString *)md5:(NSString *)string
{
    const char *cStr = [string UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(cStr, (CC_LONG)strlen(cStr), digest);
    
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02X", digest[i]];
    }
    
    return result;
}

// 获取当前时间用于创建下载id标识
- (NSString *)currentDateStr
{
    NSDate *currentDate = [NSDate date];
    NSTimeInterval timeInterval = [currentDate timeIntervalSince1970];
    return [NSString stringWithFormat:@"%.f",timeInterval];
}

// 检查URL是否有效
- (BOOL)checkIsUrlAtString:(NSString *)url
{
    NSString *pattern = @"http(s)?://([\\w-]+\\.)+[\\w-]+(/[\\w- ./?%&=]*)?";
    
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:nil];
    NSArray *regexArray = [regex matchesInString:url options:0 range:NSMakeRange(0, url.length)];
    
    if (regexArray.count > 0)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (void)dealloc
{
    [self.session invalidateAndCancel];
    self.session = nil;
    [self.downloadTask cancel];
    self.downloadTask = nil;
}

@end
