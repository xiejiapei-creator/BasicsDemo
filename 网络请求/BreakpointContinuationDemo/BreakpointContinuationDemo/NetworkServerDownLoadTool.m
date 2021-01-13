//
//  NetworkServerDownLoadTool.m
//  合并两个有序链表
//
//  Created by 谢佳培 on 2020/7/27.
//  Copyright © 2020 xiejiapei. All rights reserved.
//

#import "NetworkServerDownLoadTool.h"
#import <AFNetworking.h>

@interface NetworkServerDownLoadTool ()

@property (nonatomic,copy) NSString *fileHistoryPath;// 文件本地存储路径

@end

@implementation NetworkServerDownLoadTool

// 获取到网络请求单例对象
// 将下载功能交给一个单例管理类管理，下载的功能由他控制，再次进入下载页面的时候，读取他的信息，然后显示UI
static NetworkServerDownLoadTool* tool = nil;
+ (instancetype)sharedTool
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tool =  [[self alloc] init];
    });
    return tool;
}

#pragma mark - Life Circle

// 初始化
- (instancetype)init
{
    self = [super init];
    if (self)
    {
        // 创建一个SessionConfiguration对象，其允许HTTP和HTTPS在后台进行下载或者上传
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"com.quarkdata.emm"];
        
        // 如果是做下载工具或者使用的默认的defaultConfig的话，iOS默认的限制同一个服务器tcp连接的并发数量限制
        // 否则会发现 ，无论创建多少下载任务，都是4个或者6个在运行，其他的在排队，甚至还最后直接超时了
        // 默认配置下，iOS对于同一个IP服务器的并发最大为4，OS X为6
        // 如果用户设置了最大并发数，则按照用户设置的最大并发数执行(我设置最大20，最小为1，均可以执行)
        configuration.HTTPMaximumConnectionsPerHost = 8;
        
        // 设置请求超时为10秒钟
        configuration.timeoutIntervalForRequest = 10;
        
        // 在蜂窝网络情况下是否继续请求（上传或下载）
        configuration.allowsCellularAccess = NO;
        
        // 创建SessionManager对象
        self.manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
        
        // task完成时的回调
        __weak typeof(self) weakSelf = self;
        [self.manager setTaskDidCompleteBlock:^(NSURLSession * _Nonnull session, NSURLSessionTask * _Nonnull task, NSError * _Nullable error) {
            
            NSLog(@"manager的setTaskDidCompleteBlock：downLoadTask的成功 失败 中断(Home键、闪退、崩溃)等都会回调该代码块，该Task为：%@",task);
            // 下载地址
            NSString *urlHost = [task.currentRequest.URL absoluteString];
            
            // 判断是否有错误，有错误说明下载没有完成就被中断了
            if (error)
            {
                if (error.code == -1001)
                {
                    NSLog(@"下载出错，请查看一下网络是否正常");
                }
                
                // 可以通过key:NSURLSessionDownloadTaskResumeData去获取续传时候的data，因为AF源码中将其存储进入了这个key中
                NSData *resumeData = [error.userInfo objectForKey:@"NSURLSessionDownloadTaskResumeData"];
                
                // 当我退出这个页面再次进入的时候，如何自动获取最新的下载进度？
                // 将urlHost和resumeData存到本地，用作下载续传时候用到的值
                [weakSelf saveHistoryWithKey:urlHost DownloadTaskResumeData:resumeData];
            }
            else
            {
                NSLog(@"下载全部完成才会进入这里");
                // 判断当前是否存在这个urlHost:resumeData，存在的话看一下长度是否大于零
                if ([weakSelf.downLoadHistoryDictionary valueForKey:urlHost])
                {
                    // 下载完成移除存储容器中的内容
                    [weakSelf.downLoadHistoryDictionary removeObjectForKey:urlHost];
                    // AF在下载的时候(其实是调用的系统的下载方法)，会将文件先下载到沙盒目录下的temp文件夹中，生成一个后缀为tmp的文件
                    // 下载完的时候，系统会将tmp文件删除掉释放占用的内存，然后移动文件到我们下载时设置的路径下，这样下载任务就完成了
                    [weakSelf.downLoadHistoryDictionary writeToFile:weakSelf.fileHistoryPath atomically:YES];
                }
            }
        }];
        
        // 文件本地存储路径
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        self.fileHistoryPath = [path stringByAppendingPathComponent:@"fileDownLoadHistory.plist"];
        if ([[NSFileManager defaultManager] fileExistsAtPath:self.fileHistoryPath])// 文件已经存在
        {
            // 用之前存在的文件来初始化downLoadHistoryDictionary，即是之前的下载历史记录
            self.downLoadHistoryDictionary = [NSMutableDictionary dictionaryWithContentsOfFile:self.fileHistoryPath];
        }
        else
        {
            // 新创建downLoadHistoryDictionary
            self.downLoadHistoryDictionary = [NSMutableDictionary dictionary];
            // 将dictionary中的数据写入plist文件中，此时也新建了plist文件
            [self.downLoadHistoryDictionary writeToFile:self.fileHistoryPath atomically:YES];
        }
        NSLog(@"处于%s方法中，self.manager.session = %@ 支持后台下载/上传",__func__,self.manager.session);
    }
    return self;
}

#pragma mark - 存储文件到本地

// 将key和resumeData存到本地，用作下载续传时候用到的值
- (void)saveHistoryWithKey:(NSString *)key DownloadTaskResumeData:(NSData *)data
{
    // 开始下载的时候，去判断当前是否存在这个url:resumeData
    if (!data)
    {
        // 当用户开始下载的时候，如果什么都没下载到，就会中断下载
        // 此时resumeData是nil，如果直接写入plist是会崩溃的
        // 可以写一个NSString对象，虽然不是一个Data类型，但是length都可以使用，不会有太大影响
        NSString *emptyData = [NSString stringWithFormat:@""];
        [self.downLoadHistoryDictionary setObject:emptyData forKey:key];
    }
    else
    {
        // 有数据就直接写入即可
        [self.downLoadHistoryDictionary setObject:data forKey:key];
    }
    
    // 将下载好的部分存储到本地
    [self.downLoadHistoryDictionary writeToFile:self.fileHistoryPath atomically:NO];
    NSLog(@"文件路径%@",self.fileHistoryPath);
}

#pragma mark - 网络下载 downloadTask
/**
文件下载
@param urlHost 下载地址
@param progress 下载进度
@param localUrl 本地存储路径
@param success 下载成功
@param failure 下载失败
@return downLoadTask
*/
- (NSURLSessionDownloadTask *)AFDownLoadFileWithUrl:(NSString *)urlHost
                                           progress:(DowningProgress)progress
                                       fileLocalUrl:(NSURL *)localUrl
                                            success:(DonwLoadSuccessBlock)success
                                            failure:(DownLoadfailBlock)failure
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlHost]];
    NSURLSessionDownloadTask *downloadTask = nil;
    // 取出之前下载好的部分
    NSData *downLoadHistoryData = [self.downLoadHistoryDictionary objectForKey:urlHost];
    NSLog(@"之前下载好的部分数据长度为 %ld",downLoadHistoryData.length);
    
    if (downLoadHistoryData.length > 0)
    {
        // 其length大于零就使用resumeData调用downloadTaskWithResumeData这个方法，去继续我们的下载任务
        NSLog(@"继续旧任务");
        downloadTask = [self.manager downloadTaskWithResumeData:downLoadHistoryData progress:^(NSProgress * _Nonnull downloadProgress) {
            // typedef void (^DowningProgress)(CGFloat progress);
            // 调用下载进度block
            if (progress)
            {
                progress(1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
                NSLog(@"下载进度 %F",(1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount));
            }
        } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
            // 返回本地存储路径
            return localUrl;
        } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
            NSLog(@"AFDownLoadFileWithUrl的completionHandler：downLoadTask的成功 失败 中断(Home键、闪退、崩溃)等都会回调该代码块");
            
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            
            // 特殊处理404，删除垃圾文件
            if (httpResponse.statusCode == 404)
            {
                [[NSFileManager defaultManager] removeItemAtURL:filePath error:nil];
            }
            
            if (error)
            {
                // typedef void (^DownLoadfailBlock)(NSError* error ,NSInteger statusCode);
                // 调用下载失败block
                if (failure)
                {
                    //将下载失败存储起来，提交到下面的的网络监管类里面
                    failure(error, httpResponse.statusCode);
                }
            }
            else
            {
                // typedef void (^DonwLoadSuccessBlock)(NSURL* fileUrlPath ,NSURLResponse* response);
                // 调用下载成功block
                if (success)
                {
                    //将下载成功存储起来，提交到下面的的网络监管类里面
                    success(filePath, response);
                }
            }
        }];
    }
    else// 否则调用downloadTaskWithRequest去开辟新任务
    {
        NSLog(@"开辟新任务");
        downloadTask = [self.manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
            // typedef void (^DowningProgress)(CGFloat progress);
            // 调用下载进度block
            if (progress)
            {
                progress(1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
                NSLog(@"下载进度 %F",(1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount));
            }
        } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
            // 返回本地存储路径
            return localUrl;
        } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
            NSLog(@"downloadTaskWithRequest的completionHandler得到回调");
            
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            
            // 特殊处理404，删除垃圾文件
            // 404页面是HTTP协议响应状态码，当我们的用户对网站某个不存在的页面进行访问时
            if (httpResponse.statusCode == 404)
            {
                [[NSFileManager defaultManager] removeItemAtURL:filePath error:nil];
            }
            
            if (error)
            {
                // typedef void (^DownLoadfailBlock)(NSError* error ,NSInteger statusCode);
                // 调用下载失败block
                if (failure)
                {
                    //将下载失败存储起来，提交到appDelegate的的网络监管类里面
                    failure(error, httpResponse.statusCode);
                }
            }
            else
            {
                // typedef void (^DonwLoadSuccessBlock)(NSURL* fileUrlPath ,NSURLResponse* response);
                // 调用下载成功block
                if (success)
                {
                    //将下载成功存储起来，提交到appDelegate的的网络监管类里面
                    success(filePath, response);
                }
            }
        }];
    }
    // 启动下载任务
    [downloadTask resume];
    return downloadTask;
}

// 可以主动去将task提前结束来触发通知或者完成的回调，一般不允许蜂窝下载的时候，会用到这个方法
- (void)stopAllDownLoadTasks
{
    if ([[self.manager downloadTasks] count] == 0)
    {
        return;
    }
    
    //停止所有的下载
    for (NSURLSessionDownloadTask *task in  [self.manager downloadTasks])
    {
        // 处于允许状态中的下载任务
        if (task.state == NSURLSessionTaskStateRunning)
        {
            // 取消掉
            [task cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
                NSLog(@"可以主动去将task提前结束来触发通知或者完成的回调，一般不允许蜂窝下载的时候，会用到这个方法");
            }];
        }
    }
}

@end
