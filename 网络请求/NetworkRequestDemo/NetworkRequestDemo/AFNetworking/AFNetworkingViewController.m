//
//  AFNetworkingViewController.m
//  NetworkRequestDemo
//
//  Created by 谢佳培 on 2020/8/21.
//  Copyright © 2020 xiejiapei. All rights reserved.
//

#import "AFNetworkingViewController.h"
#import <AFNetworking/AFNetworking.h>

@interface AFNetworkingViewController ()

@property(nonatomic, strong) NSMutableData *data;
@property(nonatomic, strong) NSMutableArray *listData;
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) UIProgressView *progressView;
@property(nonatomic, strong) UILabel *progressLabel;
@property(nonatomic, strong) UIImageView *imageView;
@property(nonatomic, strong) UITextField *textField;

@end

@implementation AFNetworkingViewController

#pragma mark - 实现GET请求

- (void)startGetRequest
{
    NSString *urlString = @"http://piao.163.com/m/cinema/list.html?app_id=1&mobileType=iPhone&ver=2.6&channel=appstore&deviceId=9E89CB6D-A62F-438C-8010-19278D46A8A6&apiVer=6&city=110000";
    
    //1、创建manager
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];

    //2、设置发送和接收的数据类型
    //发送数据格式
    //AFHTTPRequestSerializer 使用 key1=value1&key2=value2的形式来上传数据 默认
    //AFJSONRequestSerializer 使用Json格式上传数据 [AFJSONRequestSerializer serializerWithWritingOptions:NSJSONWritingPrettyPrinted];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    //接受数据格式
    //AFHTTPResponseSerializer 不做解析操作
    //AFJSONResponseSerializer 自动进行Json解析  默认
    //AFXMLParserResponseSerializer 接受XML数据
    manger.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingMutableLeaves];
    
    [manger GET:urlString parameters:nil headers:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
        NSLog(@"%lli/%lli", downloadProgress.completedUnitCount, downloadProgress.totalUnitCount);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        NSLog(@"请求成功");
        
        //responseObject是从服务器返回的JSON对象，可以是字典或数组类型
        NSLog(@"responseObject%@", responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"请求失败");
        NSLog(@"error : %@", error.localizedDescription);
    }];
            
}

#pragma mark - Post

- (void)startPostRequest
{
    //1、创建manager
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];

    //2、请求参数
    NSString *urlString = @"http://piao.163.com/m/cinema/schedule.html?app_id=1&mobileType=iPhone&ver=2.6&channel=appstore&deviceId=9E89CB6D-A62F-438C-8010-19278D46A8A6&apiVer=6&city=110000";
    NSDictionary *parameters = @{@"cinema_id" : @"1533"};


    //3、发起POST请求
    [manager POST:urlString parameters:parameters headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"请求成功:%@", responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"请求失败");
    }];
}

#pragma mark - 下载数据

- (void)startDownloadRequest
{
    //下载地址
    NSString *urlString = @"http://218.76.27.57:8080/chinaschool_rs02/135275/153903/160861/160867/1370744550357.mp3";
    
    //创建manager
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //创建请求对象
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    
    
    //创建下载任务
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        
        NSLog(@"%lli/%lli", downloadProgress.completedUnitCount, downloadProgress.totalUnitCount);
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        //接受到响应头，需要制定保存路径
        NSLog(@"状态码:%li", ((NSHTTPURLResponse *)response).statusCode);
        
        //targetPath 零时文件保存路径
        //返回值 指定的保存路径
        NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/歌曲.mp3"];
        NSLog(@"%@", filePath);
        
        //创建一个沙盒路径下的子路径，设定保存的文件夹位置
        return [NSURL fileURLWithPath:filePath];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        NSLog(@"下载完成");
    }];
    
    [downloadTask resume];
}

#pragma mark - 上传数据

- (void)startUploadRequest
{
    //设置请求网址
    NSString *urlString = @"https://api.weibo.com/2/statuses/upload.json";
    NSString *token = @"2.00hd363CtKpsnBedca9b3f35tBYiP";
    
    //获取输入的文字和图片
    UIImage *image = _imageView.image;
    NSString *text = _textField.text;
    if (image == nil || text.length == 0)
    {
        return;
    }
    
    //构造参数字典
    NSDictionary *dic = @{@"access_token" : token, @"status" : text};
    
    //创建HTTP请求序列化对象，封装了HTTP请求参数(放在 URL 问号之后的部分)和表单数据
    AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
    
    //创建请求对象
    /* 该方法可以发送 multipart/form-data格式的表单数据
     * method参数的请求方法一般是 POST
     * URLString 参数是上传时的服务器地址
     * parameters是请求参数，它是字典结构;
     * constructingBodyWithBlock是请求体代码块
     * error参数是错误对象
     */
    NSMutableURLRequest *request = [serializer multipartFormRequestWithMethod:@"POST" URLString:urlString parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        //图片数据的拼接
        NSData *imageData = UIImageJPEGRepresentation(image, 1);
        
        /* 添加 multipart/form-data格式 的表单数据，这种格式的数据被分割成小段进行上传
         * 该方法的第一个参数是要上传的文件路径
         * 第二个参数name是与数据相关的名称，一般是 file，相当于 HTML中表单内的选择文件控件 <input type="file" >类型
         * 第三个参数 fileName是文件名，是放在请求头中的文件名，不能为空
         * 第四个参数 mimeType是数据相关的MIME类型
        */
        [formData appendPartWithFileData:imageData name:@"pic" fileName:@"image.png" mimeType:@"image/png"];
        
    } error:nil];
    
    //创建manager
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    /* 用于创建NSURLSessionUploadTask上传会话任务
     * request参数是请求对象
     * progress参数代码块用来获得当前运行的进度，代码块的参数upload Progress也是 NSProgress类型
     * completionHandler参数也是代码库，是从服务器返回应答数据时回调
     */
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithStreamedRequest:request progress:^(NSProgress * _Nonnull uploadProgress) {
        
        //回到主线程中 刷新界面
        [_progressView performSelectorOnMainThread:@selector(setProgress:) withObject:@(uploadProgress.fractionCompleted) waitUntilDone:YES];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //上传进度
            [_progressView setProgress:uploadProgress.fractionCompleted];
        });
        
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        NSLog(@"上传结束,状态码:%li", ((NSHTTPURLResponse *)response).statusCode);
    }];
    
    [uploadTask resume];
}


@end


