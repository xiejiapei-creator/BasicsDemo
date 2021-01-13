//
//  NotificationService.m
//  NotificationCenterService
//
//  Created by 谢佳培 on 2020/10/27.
//

#import "NotificationService.h"
#import <AVFoundation/AVFoundation.h>

@interface NotificationService ()

@property (nonatomic, strong) void (^contentHandler)(UNNotificationContent *contentToDeliver);
@property (nonatomic, strong) UNMutableNotificationContent *bestAttemptContent;

@end

@implementation NotificationService

// 让你可以在后台处理接收到的推送，传递最终的内容给 contentHandler
// 系统接到通知后，有最多30秒在这里重写通知内容（如下载附件并更新通知）
- (void)didReceiveNotificationRequest:(UNNotificationRequest *)request withContentHandler:(void (^)(UNNotificationContent * _Nonnull))contentHandler
{
    self.contentHandler = contentHandler;
    self.bestAttemptContent = [request.content mutableCopy];
    
    // 修改通知的内容
    self.bestAttemptContent.title = [NSString stringWithFormat:@"%@ [ServiceExtension modified]", self.bestAttemptContent.title];
    
    // 设置UNNotificationAction
    [self getAction];
    
    // category的唯一标识，Remote Notification保持一致
    self.bestAttemptContent.categoryIdentifier = @"categoryOperationAction";
    
    // 加载网络请求
    NSDictionary *userInfo =  self.bestAttemptContent.userInfo;
    NSString *mediaUrl = userInfo[@"media"][@"url"];
    NSString *mediaType = userInfo[@"media"][@"type"];
    
    if (!mediaUrl.length)// 不存在url则使用基本的内容
    {
        self.contentHandler(self.bestAttemptContent);
    }
    else// 否则使用网络请求到的内容
    {
        // 创建附件资源
        // UNNotificationAttachment的url接收的是本地文件的url
        // 附件资源必须存在本地，如果是远程推送的网络资源需要提前下载到本地
        [self loadAttachmentForUrlString:mediaUrl withType:mediaType completionHandle:^(UNNotificationAttachment *attach) {
            
            if (attach)
            {
                // 将附件资源添加到 UNMutableNotificationContent 中
                self.bestAttemptContent.attachments = [NSArray arrayWithObject:attach];
            }
            self.contentHandler(self.bestAttemptContent);
        }];
    }
}

// 网络请求
- (void)loadAttachmentForUrlString:(NSString *)urlStr withType:(NSString *)type completionHandle:(void(^)(UNNotificationAttachment *attach))completionHandler
{
    __block UNNotificationAttachment *attachment = nil;
    // 附件的URL
    NSURL *attachmentURL = [NSURL URLWithString:urlStr];
    // 获取媒体类型的后缀
    NSString *fileExt = [self getfileExtWithMediaType:type];
    
    // 从网络下载媒体资源
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[session downloadTaskWithURL:attachmentURL completionHandler:^(NSURL *temporaryFileLocation, NSURLResponse *response, NSError *error) {
        
        if (error)
        {
            NSLog(@"加载多媒体失败 %@", error.localizedDescription);
        }
        else
        {
            // 将下载好的媒体文件拷贝到目的路径
            NSFileManager *fileManager = [NSFileManager defaultManager];
            NSURL *localURL = [NSURL fileURLWithPath:[temporaryFileLocation.path stringByAppendingString:fileExt]];
            [fileManager moveItemAtURL:temporaryFileLocation toURL:localURL error:&error];
            
            // 自定义推送UI需要
            NSMutableDictionary *dict = [self.bestAttemptContent.userInfo mutableCopy];
            // 这里使用图片测试
            [dict setObject:[NSData dataWithContentsOfURL:localURL] forKey:@"image"];
            self.bestAttemptContent.userInfo = dict;
            
            NSError *attachmentError = nil;
            // category的唯一标识，Remote Notification保持一致
            // URL 资源路径
            // options 资源可选操作 比如隐藏缩略图之类的
            attachment = [UNNotificationAttachment attachmentWithIdentifier:@"categoryOperationAction" URL:localURL options:nil error:&attachmentError];
            if (attachmentError)
            {
                NSLog(@"%@", attachmentError.localizedDescription);
            }
        }
        
        // 将附件传递出去
        completionHandler(attachment);
    }] resume];
}

// 用于将媒体类型的后缀添加到文件路径上
// 服务端在处理推送内容时，最好加上媒体类型字段
- (NSString *)getfileExtWithMediaType:(NSString *)mediaType
{
    NSString *fileExt = mediaType;
    if ([mediaType isEqualToString:@"image"])
    {
        fileExt = @"jpg";
    }
    
    if ([mediaType isEqualToString:@"video"])
    {
        fileExt = @"mp4";
    }
    
    if ([mediaType isEqualToString:@"audio"])
    {
        fileExt = @"mp3";
    }
    
    return [@"." stringByAppendingString:fileExt];
}

// 操作
- (void)getAction
{
    NSMutableArray *actionMutableArray = [[NSMutableArray alloc] initWithCapacity:3];
    
    // UNNotificationActionOptionAuthenticationRequired 需要解锁显示，点击不会进app
    UNNotificationAction *unUnlockAction = [UNNotificationAction actionWithIdentifier:@"IdentifierNeedUnUnlock" title:@"需要解锁" options: UNNotificationActionOptionAuthenticationRequired];
    
    // UNNotificationActionOptionDestructive 红色文字，点击不会进app
    UNNotificationAction *destructiveAction = [UNNotificationAction actionWithIdentifier:@"IdentifierRed" title:@"红色显示" options: UNNotificationActionOptionDestructive];
    
    // UNNotificationActionOptionForeground 黑色文字，点击会进app
    // UNTextInputNotificationAction是输入框Action，buttonTitle是输入框右边的按钮标题，placeholder是输入框占位符
    UNTextInputNotificationAction *inputTextAction = [UNTextInputNotificationAction actionWithIdentifier:@"IdentifierInputText" title:@"输入文本" options:UNNotificationActionOptionForeground textInputButtonTitle:@"发送" textInputPlaceholder:@"说说今天发生了啥......"];
    
    NSArray *identifierArray = [[NSArray alloc] initWithObjects:@"IdentifierNeedUnUnlock", @"IdentifierRed", @"IdentifierInputText", nil];
    [actionMutableArray addObjectsFromArray:@[unUnlockAction, destructiveAction, inputTextAction]];
    
    if (actionMutableArray.count > 1)
    {
        /**categoryWithIdentifier方法
         * identifier：是这个category的唯一标识，用来区分多个category，这个id不管是Local Notification，还是remote Notification，一定要有并且要保持一致
         * actions：创建action的操作数组
         * intentIdentifiers：意图标识符 可在 <Intents/INIntentIdentifiers.h> 中查看，主要是针对电话、carplay 等开放的 API
         * options：通知选项 枚举类型 也是为了支持 carplay
         */
        UNNotificationCategory *categoryNotification = [UNNotificationCategory categoryWithIdentifier:@"categoryOperationAction" actions:actionMutableArray intentIdentifiers:identifierArray options:UNNotificationCategoryOptionCustomDismissAction];
        
        // 将创建的 category 添加到通知中心
        [[UNUserNotificationCenter currentNotificationCenter] setNotificationCategories:[NSSet setWithObject:categoryNotification]];
    }
}

// 在你获得的一小段运行通知代码的时间即将结束的时候
// 如果仍然没有成功的传入内容，会走到这个方法，可以在这里传肯定不会出错的内容，或者默认传递原始的推送内容
// 处理过程超时，则收到的通知直接展示出来
- (void)serviceExtensionTimeWillExpire
{
    // 将获取到的内容传递给content扩展
    self.contentHandler(self.bestAttemptContent);
}

@end
