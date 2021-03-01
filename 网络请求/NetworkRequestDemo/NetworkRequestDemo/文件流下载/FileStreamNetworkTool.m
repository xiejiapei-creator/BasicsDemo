//
//  FileStreamNetworkTool.m
//  NetworkRequestDemo
//
//  Created by 谢佳培 on 2021/2/22.
//  Copyright © 2021 xiejiapei. All rights reserved.
//

#import "FileStreamNetworkTool.h"

NSInteger fileDownProgress = 0;
NSInteger fileTotalProgress = 0;

@interface FileStreamNetworkTool()<NSURLSessionDelegate>

@property (nonatomic, strong) NSMutableData *receiveData;
@property (nonatomic, strong) NSOutputStream *outpustream;

@end

@implementation FileStreamNetworkTool

- (instancetype)init
{
    if (self = [super init])
    {
        // 下面这种直接拼接的方式会造成内存暴增导致APP崩溃
        //_receiveData = [[NSMutableData alloc] init];
        return self;
    }
    return nil;
}

#pragma mark - 网络请求

- (NSURLSessionDataTask *)getDownFileUrl:(NSString *)fileUrl backBlock:(fileHandleBlock)handleBlock
{
    if (fileUrl == nil || handleBlock == nil)
    {
        return nil;
    }
    
    self.handleBlock = handleBlock;

    NSURL *requestUrl = [NSURL URLWithString:fileUrl];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:requestUrl];
    request.HTTPMethod = @"GET";
    request.timeoutInterval = 30.0;
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue   mainQueue]];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request];
    [dataTask resume];
    
    return dataTask;
}

#pragma mark -- NSURLSessionDataDelegate

// 接收到服务器的响应：http的head数据
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler
{
    fileTotalProgress = response.expectedContentLength;
    completionHandler(NSURLSessionResponseAllow);
}

// 接收到http的body数据
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    // 下面这种直接拼接的方式会造成内存暴增导致APP崩溃
    //[self.receiveData appendData:data];
    
    // 创建输出流。append为YES的话，每次写入都是追加到文件尾部
    // outpustream 好像没用上
    self.outpustream = [NSOutputStream outputStreamToFileAtPath:[self getSaveFilePath] append:YES];

    // 细水流长，一点一点地将数据流存入到文件中
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self saveFile:data];
    });
    
    // 计算下载进度
    fileDownProgress = fileDownProgress +  data.length;
    float downProgress = fileDownProgress/(fileTotalProgress * 1.0) * 100;
    NSString *progress = [NSString stringWithFormat:@"%.2f%@",downProgress,@"%"];
    
    NSURL *saveFileURL = [NSURL URLWithString:[self getSaveFilePath]];
    self.handleBlock(saveFileURL, progress);
}

// 下载任务完成时调用
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    NSLog(@"下载完成");
    
    if (!error)
    {
        // 下面这种直接拼接的方式会造成内存暴增导致APP崩溃
        //[self.receiveData writeToFile:[self getSaveFilePath] atomically:YES];
    }
}

#pragma mark - 文件

// 将下载的数据流一点点写入文件
- (void)saveFile:(NSData *)data
{
    // 保存文件的路径
    NSString *filePath = [self getSaveFilePath];
    // 如果文件不存在，返回的是nil
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:filePath];
    // 判断文件存不存在
    if (fileHandle == nil)
    {
        // 如果文件不存在，会自动创建文件
        [data writeToFile:filePath atomically:YES];
    }
    else
    {
        // 让offset指向文件的末尾
        [fileHandle seekToEndOfFile];
        // 在文件的末尾再继续写入文件
        [fileHandle writeData:data];
        // 同步一下防止操作混乱
        [fileHandle synchronizeFile];
        // 关闭文件
        [fileHandle closeFile];
    }
}

// 获取文件存储路径
- (NSString *)getSaveFilePath
{
    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"video.mp4"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {
        [[NSFileManager defaultManager] createFileAtPath:filePath contents:nil attributes:nil];
    }
    return filePath;
}

@end
