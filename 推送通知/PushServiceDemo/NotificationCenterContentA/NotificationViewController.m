//
//  NotificationViewController.m
//  NotificationCenterContentA
//
//  Created by 谢佳培 on 2020/10/27.
//

#import "NotificationViewController.h"
#import <UserNotifications/UserNotifications.h>
#import <UserNotificationsUI/UserNotificationsUI.h>

#define Margin      15

@interface NotificationViewController () <UNNotificationContentExtension>

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UILabel *subLabel;
@property (nonatomic, strong) UILabel *hintLabel;
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation NotificationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGPoint origin = self.view.frame.origin;
    CGSize size = self.view.frame.size;
    
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(Margin, Margin, size.width-Margin*2, 30)];
    self.label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:self.label];
    
    self.subLabel = [[UILabel alloc] initWithFrame:CGRectMake(Margin, CGRectGetMaxY(self.label.frame)+10, size.width-Margin*2, 30)];
    self.subLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:self.subLabel];
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(Margin, CGRectGetMaxY(self.subLabel.frame)+10, 100, 100)];
    [self.view addSubview:self.imageView];
    
    self.hintLabel = [[UILabel alloc] initWithFrame:CGRectMake(Margin, CGRectGetMaxY(self.imageView.frame)+10, size.width-Margin*2, 20)];
    [self.hintLabel setText:@"我是hintLabel"];
    [self.hintLabel setFont:[UIFont systemFontOfSize:14]];
    [self.hintLabel setTextAlignment:NSTextAlignmentLeft];
    [self.view addSubview:self.hintLabel];
    self.view.frame = CGRectMake(origin.x, origin.y, size.width, CGRectGetMaxY(self.imageView.frame)+Margin);

    // 设置控件边框颜色
    [self.label.layer setBorderColor:[UIColor redColor].CGColor];
    [self.label.layer setBorderWidth:1.0];
    [self.subLabel.layer setBorderColor:[UIColor greenColor].CGColor];
    [self.subLabel.layer setBorderWidth:1.0];
    [self.imageView.layer setBorderWidth:2.0];
    [self.imageView.layer setBorderColor:[UIColor blueColor].CGColor];
    [self.view.layer setBorderWidth:2.0];
    [self.view.layer setBorderColor:[UIColor cyanColor].CGColor];
}

// 生成时默认实现了UNNotificationContentExtension协议的方法
- (void)didReceiveNotification:(UNNotification *)notification
{
    self.label.text = notification.request.content.title;
    self.subLabel.text = [NSString stringWithFormat:@"%@ [ContentExtension modified]", notification.request.content.subtitle];
    
    // 提取附件
    UNNotificationAttachment *attachment = notification.request.content.attachments.firstObject;
    if ([attachment.URL startAccessingSecurityScopedResource])
    {
        NSData *imageData = [NSData dataWithContentsOfURL:attachment.URL];
        [self.imageView setImage:[UIImage imageWithData:imageData]];
        [attachment.URL stopAccessingSecurityScopedResource];
    }
}

// 点击通知进入app时触发（杀死/切到后台唤起）
- (void)didReceiveNotificationResponse:(UNNotificationResponse *)response completionHandler:(void (^)(UNNotificationContentExtensionResponseOption))completion
{
    
    [self.hintLabel setText:[NSString stringWithFormat:@"触发了%@", response.actionIdentifier]];
    
    if ([response.actionIdentifier isEqualToString:@"IdentifierNeedUnUnlock"])
    {
        NSLog(@"点击了解锁");
    }
    else if([response.actionIdentifier isEqualToString:@"IdentifierRed"])
    {
        NSLog(@"点击了红色");
    }
    else if([response.actionIdentifier isEqualToString:@"IdentifierInputText"])
    {
        UNTextInputNotificationResponse *textInputResponse = (UNTextInputNotificationResponse *)response;
        [self.hintLabel setText:[NSString stringWithFormat:@"用户输入的文字是：%@", textInputResponse.userText]];
    }
    else
    {
        NSLog(@"啥？");
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        // 必须设置completion，否则通知不会消失
        // UNNotificationContentExtensionResponseOptionDismiss 直接让该通知消失
        // UNNotificationContentExtensionResponseOptionDismissAndForwardAction 消失并传递按钮信息给AppDelegate，是否进入App看Att的设置
        completion(UNNotificationContentExtensionResponseOptionDismiss);
    });
}

#pragma mark - 控制媒体文件的播放

// 返回默认样式的button
- (UNNotificationContentExtensionMediaPlayPauseButtonType)mediaPlayPauseButtonType
{
    return UNNotificationContentExtensionMediaPlayPauseButtonTypeDefault;
}

// 返回button的frame
- (CGRect)mediaPlayPauseButtonFrame
{
    return CGRectMake(100, 100, 100, 100);
}

// 返回button的颜色
- (UIColor *)mediaPlayPauseButtonTintColor
{
    return [UIColor blueColor];
}

// 开始播放
- (void)mediaPlay
{
    NSLog(@"mediaPlay，开始播放");
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.extensionContext mediaPlayingPaused];
    });
}

// 暂停播放
- (void)mediaPause
{
    NSLog(@"mediaPause，暂停播放");
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.extensionContext mediaPlayingStarted];
    });
}

@end
