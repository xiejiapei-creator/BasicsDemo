//
//  NSURLSessionViewController.m
//  NetworkRequestDemo
//
//  Created by 谢佳培 on 2020/8/21.
//  Copyright © 2020 xiejiapei. All rights reserved.
//

#import "NSURLSessionViewController.h"

#define kResumeDataPath [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/resumeData.plist"]

@interface NSURLSessionViewController ()<NSURLSessionDelegate, NSURLSessionDownloadDelegate>

@property(nonatomic, strong) NSMutableData *data;
@property(nonatomic, strong) NSMutableArray *listData;
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) UIProgressView *progressView;
@property(nonatomic, strong) UILabel *progressLabel;
@property(nonatomic, strong) UIImageView *imageView;

@end

@implementation NSURLSessionViewController
{
    NSURLSession *_session;
    NSURLSessionDownloadTask *_downLoadTask;
}

#pragma mark - Get

// 实现 GET 请求
- (void)startGetRequest
{
    //1、指定请求的 URL
    //请求的参数全部暴露在 URL后面，这是 GET请求方法的典型特征
    //注册用户邮箱  type：数据交互类型（JSON 、 XML和 SOAP） action：add、 remove、 modify和query）
    NSString *strURL = [[NSString alloc] initWithFormat:@"http://www.51work6.com/service/mynotes/WebServic.php?email=%@&type%@&action=%@",@"<你的51work6.com用户邮箱>","JSON",@"query"];
    //URL字符串允许的字符集
    strURL = [strURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    //将字符串转换为 URL字符串
    NSURL *url = [NSURL URLWithString:strURL];

    //2、构造网络请求对象 NSURLRequest
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    //3、创建简单会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    //创建默认配置对象
    NSURLSessionConfiguration *defaultConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    //设置缓存策略
    defaultConfig.requestCachePolicy = NSURLRequestUseProtocolCachePolicy;
    //设置网络服务类型 决定了网络请求的形式
    defaultConfig.networkServiceType = NSURLNetworkServiceTypeDefault;
    //设置请求超时时间
    defaultConfig.timeoutIntervalForRequest = 15;
    //设置请求头
    //defaultConfig.HTTPAdditionalHeaders
    //网络属性  是否使用移动流量
    defaultConfig.allowsCellularAccess = YES;
    
    //3、创建默认会话对象
    //本例网络请求任务之后回调的是代码块，而非委托对象的方法，delegate参数被赋值为 nil
    //delegateQueue参数是设置会话任务执行所在的操作队列，NSOperationQueue是操作队列， 内部封装了线程
    //由于会话任务是在主线程中执行不需要再放到并发队列方法dispatch_async
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:defaultConfig delegate:nil delegateQueue:[NSOperationQueue mainQueue]];

    /* 4、数据任务 (NSURLSessionDataTask) 对象
     * 第一个参数是NSURLRequest请求对象
     * 第二个参数completionHandler是请求完成回调的代码块
     * data参数是从服务器返回的数据
     * response是从服务器返回的应答对象
     * error是错误对象，如果 error为 nil， 则说明请求过程没有错误发生
     */
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"请求完成...");
       
        //将响应对象转化为NSHTTPURLResponse对象
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        //获取网络连接的状态码，200成功  404网页未找到
        NSLog(@"状态码:%li", httpResponse.statusCode);
        if (httpResponse.statusCode == 200) {
            NSLog(@"请求成功");
        }
        //获取响应头
        NSLog(@"响应头:%@", httpResponse.allHeaderFields);
        
        //获取响应体
        if (!error) {
            NSDictionary *resDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            //调用 reloadView: 方法是在 GCD主队列中执行的
            //简单会话是在非主队列中执行的，当遇到表视图刷新这种更新 UI界面的操作时，要切换回主队列执行
            dispatch_async(dispatch_get_main_queue(), ^{
                //在请求完成时调用 reloadView:方法，该方法用千重新加载表视图中的数据
                [self reloadView:resDict];
            });
        } else {
            NSLog(@"error: %@", error.localizedDescription);
        }
    }];
    //5、在会话任务对象上调用 resume方法开始执行任务，新创建的任务默认情况下是暂停的
    [task resume];
}

- (void)reloadView:(NSDictionary *)res
{
    //从服务器返回的JSON格式数据有两种情况，成功返回或者失败，ResultCode数据项用于说明该结果
    NSNumber *resultCode = res[@"ResultCode"];
    //当ResultCode大于等于0时，说明服务器端操作成功
    if ([resultCode integerValue] >= 0)
    {
        //取得从服务端返回的数据
        self.listData = res[@"Record"];
        [self.tableView reloadData];
    }
    else
    {
        //为了减少网络传输，只传递消息代码，不传递消息内容
        //根据结果编码获得结果消息
        NSString *errorStr = [NSString stringWithFormat:@"错误编码为：%ld",(long)[resultCode integerValue]];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"错误信息" message:errorStr preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:okAction];
        //显示错误消息
        [self presentViewController:alertController animated:true completion:nil];
    }
}

#pragma mark - NSURLSessionDelegate

//已经接受到响应头
- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler
{
    //通过状态码来判断石是否成功
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    if (httpResponse.statusCode == 200)
    {
        NSLog(@"请求成功");
        NSLog(@"%@", httpResponse.allHeaderFields);

        //初始化接受数据的NSData变量
        _data = [[NSMutableData alloc] init];

        //执行completionHandler Block回调来继续接收响应体数据
        /*
         NSURLSessionResponseCancel 取消接受
         NSURLSessionResponseAllow  继续接受
         NSURLSessionResponseBecomeDownload 将当前任务 转化为一个下载任务
         NSURLSessionResponseBecomeStream   将当前任务 转化为流任务
         */
        completionHandler(NSURLSessionResponseAllow);
    }
    else
    {
        NSLog(@"请求失败");
    }
}

//接受到数据包时调用的代理方法
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    NSLog(@"收到了一个数据包");

    //拼接完整数据
    [_data appendData:data];
    NSLog(@"接受到了%li字节的数据", data.length);
}

//数据接收完毕时调用的代理方法
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    NSLog(@"数据接收完成");

    if (error)
    {
        NSLog(@"数据接收出错!");
        //清空出错的数据
        _data = nil;
    }
    else
    {
        //数据传输成功无误，JSON解析数据
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:_data options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"%@", dic);
    }
}

#pragma mark - Post

// 实现 Post 请求
- (void)startPostRequest
{
    //在这个URL字符串后面没有参数(即没有?号后面的内容)
    NSString *strURL = @"http://www.51work6.com/service/mynotes/WebService.php";
    NSURL *url = [NSURL URLWithString:strURL];
    
    //参数字符串：请求参数放到请求体中
    NSString *post = [NSString stringWithFormat:@"email=%@&type=%@&action=%@", @"<用户邮箱>", @"JSON", @"query"];
    //postData就是请求参数：将参数字符串转换成NSData类型，编码一定要采用UTF-8
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding];

    //创建可变的请求对象NSMutableURLRequest,所以可以通过属性设置其内容
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    //HTTPMethod属性用于设置HTTP请求方法为POST
    [request setHTTPMethod:@"POST"];
    //HTTPBody属性用于设置请求数据
    [request setHTTPBody:postData];

    //创建会话
    NSURLSessionConfiguration *defaultConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration: defaultConfig delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    
    //创建任务
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        //JSON解析
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"%@", dic);
    }];
    
    [dataTask resume];
}

#pragma mark - 下载数据

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //创建会话，delegate为self
    NSURLSessionConfiguration *defaultConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    _session = [NSURLSession sessionWithConfiguration:defaultConfig delegate:self delegateQueue:[NSOperationQueue mainQueue]];
}

//开始下载
- (void)startDownLoad
{
    //设置文件下载地址
    NSString *strURL = [[NSString alloc] initWithFormat:@"http://218.76.27.57:8080/海贼王.jpg"];
    NSURL *url = [NSURL URLWithString:strURL];
    
    //创建下载任务
    _downLoadTask = [_session downloadTaskWithURL:url];
    //开始执行任务
    [_downLoadTask resume];
}

//暂停下载
- (void)pauseDownLoad
{
    //判断当前的下载状态
    if (_downLoadTask && _downLoadTask.state == NSURLSessionTaskStateRunning)
    {
        //取消当前任务，将任务的信息保存的文件中
        [_downLoadTask cancelByProducingResumeData:^(NSData * _Nullable resumeData) {

            //将数据写入到文件，方便下次读取
            //下载链接，已下载的数据大小，已下载的临时文件文件名
            [resumeData writeToFile:kResumeDataPath atomically:YES];
            NSLog(@"将数据写入到文件:%@", kResumeDataPath);
        }];

        _downLoadTask = nil;
    }
}

//继续下载
- (void)resumeDownLoad
{
    //获取已经保存的数据
    NSData *data = [NSData dataWithContentsOfFile:kResumeDataPath];
    if (data)
    {
        //重建下载任务
        _downLoadTask = [_session downloadTaskWithResumeData:data];
        //继续任务
        [_downLoadTask resume];
        //移除文件
        [[NSFileManager defaultManager] removeItemAtPath:kResumeDataPath error:nil];
    }
}

#pragma mark - NSURLSessionDownloadDelegate

 /** 文件下载完成
  *  @param session      网络会话
  *  @param downloadTask 下载任务
  *  @param location     下载完成的文件，在本地磁盘中的位置，是个保存数据的本地临时文件
  */
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
    NSLog(@"下载完成");
    NSLog(@"临时文件: %@\n", location);
    
    //拼接文件的目标路径
    NSString *downloadsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, TRUE) objectAtIndex:0];
    NSString *downloadStrPath = [downloadsDir stringByAppendingPathComponent:@"歌曲.mp3"];
    NSURL *downloadURLPath = [NSURL fileURLWithPath:downloadStrPath];
    
    //将临时文件，移动到沙盒路径中
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    //用于判断在沙箱 Documents 目录下是否存在 海贼王.jpg文件
    NSError *error = nil;
    if ([fileManager fileExistsAtPath:downloadStrPath])
    {
        //如果存在，删除 海贼王.jpg文件，这可以防止最新下载的文件不能覆盖之前遗留的 海贼王.jpg文件
        [fileManager removeItemAtPath:downloadStrPath error:&error];
        if (error)
        {
            NSLog(@"删除文件失败: %@", error.localizedDescription);
        }
    }
    
    error = nil;
    if ([fileManager moveItemAtURL:location toURL:downloadURLPath error:&error])
    {
        NSLog(@"文件保存地址: %@", downloadStrPath);
        
        //将下载时保存数据的本地临时文件移动到沙箱 Documents 目录下，并命名为 海贼王.jpg文件
        //沙箱Documents目录下不能有 海贼王.jpg名字的文件，否则无法完成移动操作
        UIImage *image = [UIImage imageWithContentsOfFile:downloadStrPath];
        
        //文件下载并移动成功后，构建UIImage对象，然后再把UIImage对象赋值给图片视图
        //在界面中我 们就可以看到下载的图片了
        self.imageView.image = image;
    }
    else
    {
        NSLog(@"保存文件失败: %@", error.localizedDescription);
    }
}

/** 接受到一部分数据后 调用的方法
 *  @param session                   网络会话对象
 *  @param downloadTask              下载任务对象
 *  @param bytesWritten              当前数据包写入的数据字节数
 *  @param totalBytesWritten         当前总共写入的数据字节数
 *  @param totalBytesExpectedToWrite 完整的文章总大小字节数
 */
- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{

    NSLog(@"获取到一个数据包:%lli", bytesWritten);
    NSLog(@"已经写入的数据包大小:%lli", totalBytesWritten);
    NSLog(@"总文件大小:%lli", totalBytesExpectedToWrite);

    //计算当前下载任务进度
    CGFloat progress = (CGFloat)totalBytesWritten / totalBytesExpectedToWrite;

    //更新进度条的进度，属于更新UI操作，需要在主队列(主线程所在队列)中执行
    //由于配置会话时设置的是主队列(主线程所在队列)，所以更新UI的操作不必放在 dispatch_async中执行
    _progressView.progress = progress;
    _progressLabel.text = [NSString stringWithFormat:@"%.2f%%", progress * 100];
}

#pragma mark - 上传数据

#define kBoundary @"ABC"

/*
 multipart/form-data 上传数据时 所需要的数据格式
 HTTP请求头：
 ....
 multipart/form-data; charset=utf-8;boundary=AaB03x
 ....

 HTTP请求体：
 --AaB03x
 Content-Disposition: form-data; name="key1"

 value1
 --AaB03x
 Content-Disposition: form-data; name="key2"

 value2
 --AaB03x
 Content-Disposition: form-data; name="key3"; filename="file"
 Content-Type: application/octet-stream

 图片数据...
 --AaB03x--
 */


/**
*  包装请求体
*
*  @param token 用户密钥
*  @param text  微博正文
*  @param image 上传的图片
*
*  @return multipart/form-data
*/
- (NSData *)bodyDataWithToken:(NSString *)token
                    text:(NSString *)text
                   image:(UIImage *)image
{

    //key1 = @"access_token"    vlaue1 = 2.00hd363CtKpsnBedca9b3f35tBYiPD
    //key2 = @"status"          value2 = text
    //key3 = @"pic"             value3 = image;

    //包装数据到请求体中
    NSMutableString *mString = [[NSMutableString alloc] init];

    //token
    [mString appendFormat:@"--%@\r\n", kBoundary];
    //拼接带有双引号的字符串 需要添加\在双引号之前
    [mString appendFormat:@"Content-Disposition: form-data; name=\"access_token\"\r\n\r\n"];
    //拼接value1
    [mString appendFormat:@"%@\r\n", token];
    [mString appendFormat:@"--%@\r\n", kBoundary];

    //微博正文
    //key2
    [mString appendFormat:@"Content-Disposition: form-data; name=\"status\"\r\n\r\n"];
    //拼接value2
    [mString appendFormat:@"%@\r\n", text];
    [mString appendFormat:@"--%@\r\n", kBoundary];

    //图片
    [mString appendFormat:@"Content-Disposition: form-data; name=\"pic\"; filename=\"file\"\r\n"];
    [mString appendFormat:@"Content-Type: application/octet-stream\r\n\r\n"];

    NSLog(@"%@", mString);
    //将字符串  转化为NSData
    NSMutableData *bodyData = [[mString dataUsingEncoding:NSUTF8StringEncoding] mutableCopy];

    //拼接图片数据
    //将图片转化为数据
    NSData *imageData = UIImageJPEGRepresentation(image, 1);
    [bodyData appendData:imageData];

    //结尾字符串  结束符
    NSString *endString = [NSString stringWithFormat:@"\r\n--%@--\r\n", kBoundary];
    NSData *endData = [endString dataUsingEncoding:NSUTF8StringEncoding];

    [bodyData appendData:endData];

    return [bodyData copy];
}


- (void)uploadImage
{
    //构建URL
    NSURL *url = [NSURL URLWithString:@"https://upload.api.weibo.com/2/statuses/upload.json"];
    //构建请求对象
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];

    //设置请求对象
    request.URL = url;
    request.HTTPMethod = @"POST";
    //请求头
    //格式： multipart/form-data; charset=utf-8;boundary=AaB03x
    //拼接请求头字符串
    NSString *string = [NSString stringWithFormat:@"multipart/form-data; charset=utf-8; boundary=%@", kBoundary];
    //设置请求头
    [request setValue:string forHTTPHeaderField:@"Content-Type"];

    //图片和文本
    UIImage *ali = [UIImage imageNamed:@"ali.jpg"];
    NSString *text = @"发送微博";
    NSString *token = @"2.00hd363CtKpsnBedca9b3f35tBYiP";
    //创建bodyData
    NSData *bodyData = [self bodyDataWithToken:token text:text image:ali];


    //创建会话
    NSURLSession *session = [NSURLSession sharedSession];
    //创建上传任务
    NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:request fromData:bodyData completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {

        NSHTTPURLResponse *httpRes = (NSHTTPURLResponse *)response;
        NSLog(@"状态码:%li", httpRes.statusCode);
        if (error) {
            NSLog(@"上传出错");
        } else {
            NSLog(@"上传成功");
        }
    }];

    //开始任务
    [uploadTask resume];
}

@end

