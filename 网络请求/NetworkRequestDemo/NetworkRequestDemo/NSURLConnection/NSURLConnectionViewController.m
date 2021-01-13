//
//  NSURLConnectionViewController.m
//  NetworkRequestDemo
//
//  Created by 谢佳培 on 2020/8/24.
//  Copyright © 2020 xiejiapei. All rights reserved.
//

#import "NSURLConnectionViewController.h"

/// 两种请求方式
typedef enum {
    MethodGET,
    MethodPOST
} Method;

@interface NSURLConnectionViewController () <NSURLConnectionDataDelegate>

/// 文件下载完毕之后,在本地保存的路径
@property (nonatomic, copy) NSString *filePath;
/// 需要下载的文件的总大小!
@property (nonatomic, assign) long long serverFileLength;
/// 当前已经下载长度
@property (nonatomic, assign) long long localFileLength;

@end

@implementation NSURLConnectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - 网络请求(json、xml数据)

/// 请求成功后，直接将jsonData转为jsonDict
+ (void)connectionRequestWithMethod:(Method)method   URLString:(NSString *)URLString parameters:(NSDictionary *)dict success:(void (^)(id JSON))success fail:(void (^)(NSError *error))fail {
    // 简单的转码，如果参数带有?&特殊字符，下面方法不适合
    URLString = [URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    // 1.创建请求
    NSURL *url = [NSURL URLWithString:URLString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];

    // 请求方式，默认为GET
    if (method == MethodPOST) {
        request.HTTPMethod = @"POST";
    }

    // 根据需要设置
    [request setValue:@"text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8" forHTTPHeaderField:@"Accept"];
    
    // 2.设置请求头 Content-Type  返回格式
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    // 3.设置请求体 NSDictionary --> NSData
    if (dict != nil) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
        request.HTTPBody = data;
    }

    // 4.发送请求
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if ((data != nil) && (connectionError == nil)) {
            NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            if (success) {
                success(jsonDict);
            }
        } else {
            if (fail) {
                fail(connectionError);
            }
        }
    }];
}

#pragma mark - 文件下载

/// 点击屏幕事件
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self downloadFile];
}
/// 下载文件
- (void)downloadFile {
    // 文件存储路径
    self.filePath = @"/Users/username/Desktop//陶喆 - 爱很简单.mp3";
    // 要下载的网络文件，采用Apache搭建的本地服务器
    NSString *urlStr = @"http://localhost/陶喆 - 爱很简单.mp3";

    // 简单的转码，如果参数带有?&特殊字符，下面方法不适合
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];

    // 设置请求方法为 HEAD 方法，这里只是头，数据量少，用同步请求也可以，不过最好还是用异步请求
    request.HTTPMethod = @"HEAD";
    // 无论是否会引起循环引用，block里面都使用弱引用
    __weak typeof(self) weakSelf = self;
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        // 出错则返回
        if (connectionError != nil) {
            NSLog(@"connectionError = %@",connectionError);
            return ;
        }

        // 记录需要下载的文件总长度
        long long serverFileLength = response.expectedContentLength;
        weakSelf.serverFileLength = serverFileLength;

        // 初始化已下载文件大小
        weakSelf.localFileLength = 0;
        
        NSDictionary *dict = [[NSFileManager defaultManager] attributesOfItemAtPath:weakSelf.filePath error:NULL];
        
        long long  localFileLength = [dict[NSFileSize] longLongValue];
        
        // 如果没有本地文件,直接下载!
        if (!localFileLength) {
            // 下载新文件
            [weakSelf getFileWithUrlString:urlStr];
        }

        // 如果已下载的大小，大于服务器文件大小，肯定出错了，删除文件并从新下载
        if (localFileLength > serverFileLength) {
            // 删除文件 remove
            [[NSFileManager defaultManager]  removeItemAtPath:self.filePath error:NULL];
            
            // 下载新文件
            [self getFileWithUrlString:urlStr];
            
        } else if (localFileLength == serverFileLength) {
            NSLog(@"文件已经下载完毕");
        } else if (localFileLength && localFileLength < serverFileLength) {
            // 文件下载了一半，则使用断点续传
            self.localFileLength = localFileLength;
            
            [self getFileWithUrlString:urlStr WithStartSize:localFileLength endSize:serverFileLength-1];
        }
    }];
    
}

/// 重新开始下载文件(代理方法监听下载过程)
-(void)getFileWithUrlString:(NSString *)urlString
{
    NSURL *url = [NSURL URLWithString:urlString];
    // 默认就是 GET 请求
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // 开始请求，并设置代理为self
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    // 设置代理的执行线程，一般不在主线程
    [conn setDelegateQueue:[[NSOperationQueue alloc] init]];
    
    // NSUrlConnection 的代理方法是一个特殊的事件源!
    // 开启运行循环!
    CFRunLoopRun();
}

/* 断点续传(代理方法监听下载过程)
 * startSize:本次断点续传开始的位置
 * endSize:本地断点续传结束的位置
 */
-(void)getFileWithUrlString:(NSString *)urlString WithStartSize:(long long)startSize endSize:(long long)endSize
{
    // 1. 创建请求!
    NSURL *url = [NSURL URLWithString:urlString];
    // 默认就是 GET 请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    // 设置断点续传信息
    NSString *range = [NSString stringWithFormat:@"Bytes=%lld-%lld",startSize,endSize];
    [request setValue:range forHTTPHeaderField:@"Range"];
    
    // NSUrlConnection 下载过程!
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    // 设置代理的执行线程// 传一个非主队列!
    [conn setDelegateQueue:[[NSOperationQueue alloc] init]];
    
    // NSUrlConnection 的代理方法是一个特殊的事件源!
    // 开启运行循环!
    CFRunLoopRun();
}

#pragma mark - NSURLConnectionDataDelegate

/// 1. 接收到服务器响应
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // 服务器响应
    // response.expectedContentLength的大小是要下载文件的大小，而不是文件的总大小。比如请求头设置了Range[requestM setValue:rangeStr forHTTPHeaderField:@"Range"];则返回的大小为range范围内的大小
}
/// 2. 接收到数据
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // data当前接收到的网络数据;
    // 如果这个文件不存在,响应的文件句柄就不会创建!
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:self.filePath];
    // 在这个路径下已经有文件了!
    if (fileHandle) {
        // 将文件句柄移动到文件的末尾
        [fileHandle seekToEndOfFile];
        // 写入文件的意思(会将data写入到文件句柄所操纵的文件!)
        [fileHandle writeData:data];
        
        [fileHandle closeFile];
        
    } else {
        // 第一次调用这个方法的时候,在本地还没有文件路径(没有这个文件)!
        [data writeToFile:self.filePath atomically:YES];
    }
}
/// 3. 接收完成
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"下载完成");
}
/// 4. 网络错误
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"下载错误 %@", error);
}

@end
