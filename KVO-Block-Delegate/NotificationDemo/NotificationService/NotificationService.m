//
//  NotificationService.m
//  NotificationService
//
//  Created by 谢佳培 on 2020/8/24.
//  Copyright © 2020 xiejiapei. All rights reserved.
//

#import "NotificationService.h"
#import <UIKit/UIKit.h>

@interface NotificationService ()

@property (nonatomic, strong) void (^contentHandler)(UNNotificationContent *contentToDeliver);
@property (nonatomic, strong) UNMutableNotificationContent *bestAttemptContent;

@end

@implementation NotificationService

#pragma mark - Service

//让你可以在后台处理接收到的推送，传递最终的内容给 contentHandler
//在这里把附件下载保存，然后才能展示渲染
- (void)didReceiveNotificationRequest:(UNNotificationRequest *)request withContentHandler:(void (^)(UNNotificationContent * _Nonnull))contentHandler {
    self.contentHandler = contentHandler;
    self.bestAttemptContent = [request.content mutableCopy];
    
    NSString * attchUrl = [request.content.userInfo objectForKey:@"image"];
    //下载图片,放到本地
    UIImage * imageFromUrl = [self getImageFromURL:attchUrl];
    
    //获取documents目录
    NSString * documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString * localPath = [self saveImage:imageFromUrl withFileName:@"MyImage" ofType:@"png" inDirectory:documentsDirectoryPath];
    
    if (localPath && ![localPath isEqualToString:@""])
    {
        UNNotificationAttachment * attachment = [UNNotificationAttachment attachmentWithIdentifier:@"photo" URL:[NSURL URLWithString:[@"file://" stringByAppendingString:localPath]] options:nil error:nil];
        if (attachment)
        {
            self.bestAttemptContent.attachments = @[attachment];
        }
    }
    
    // Modify the notification content here...
    self.bestAttemptContent.title = [NSString stringWithFormat:@"%@ [modified]", self.bestAttemptContent.title];
    
    // 资源路径
    NSURL *videoURL = [[NSBundle mainBundle] URLForResource:@"video" withExtension:@"mp4"];

    /**创建附件资源
     * identifier 资源标识符
     * URL 资源路径
     * options 资源可选操作 比如隐藏缩略图之类的
     * error 异常处理
     */
    UNNotificationAttachment *attachment = [UNNotificationAttachment attachmentWithIdentifier:@"video.attachment" URL:videoURL options:nil error:nil];
    
    // 将附件资源添加到 UNMutableNotificationContent 中
    if (attachment)
    {
        self.bestAttemptContent.attachments = @[attachment];
    }

    self.contentHandler(self.bestAttemptContent);
}

//在你获得的通知一小段运行代码的时间即将结束的时候，如果仍然没有成功的传入内容，就会走到这个方法
//可以在这里传肯定不会出错的内容，或者会默认传递原始的推送内容
- (void)serviceExtensionTimeWillExpire {
    // Called just before the extension will be terminated by the system.
    // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
    self.contentHandler(self.bestAttemptContent);
}

#pragma mark - Private Methods

- (UIImage *)getImageFromURL:(NSString *)fileURL
{
    NSLog(@"执行图片下载函数");
    UIImage *result;
    
    //dataWithContentsOfURL方法需要https连接
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
    result = [UIImage imageWithData:data];

    return result;
}

//将所下载的图片保存到本地
- (NSString *)saveImage:(UIImage *)image withFileName:(NSString *)imageName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath
{
    NSString *urlStr = @"";
    if ([[extension lowercaseString] isEqualToString:@"png"])
    {
        urlStr = [directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"png"]];
        [UIImagePNGRepresentation(image) writeToFile:urlStr options:NSAtomicWrite error:nil];

    }
    else if ([[extension lowercaseString] isEqualToString:@"jpg"] || [[extension lowercaseString] isEqualToString:@"jpeg"])
    {
        urlStr = [directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"jpg"]];
        [UIImageJPEGRepresentation(image, 1.0) writeToFile:urlStr options:NSAtomicWrite error:nil];

    }
    else
    {
        NSLog(@"extension error");
    }
    
    return urlStr;
}

@end

