//
//  NotificationViewController.m
//  NotificationContent
//
//  Created by 谢佳培 on 2020/8/24.
//  Copyright © 2020 xiejiapei. All rights reserved.
//

#import "NotificationViewController.h"
#import <UserNotifications/UserNotifications.h>
#import <UserNotificationsUI/UserNotificationsUI.h>

@interface NotificationViewController () <UNNotificationContentExtension>

@property IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation NotificationViewController

// 渲染UI
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    [self.view addSubview:view];
    view.backgroundColor = [UIColor redColor];
}

// 获取通知信息，更新UI控件中的数据
- (void)didReceiveNotification:(UNNotification *)notification
{
    self.label.text = notification.request.content.body;
    UNNotificationContent * content = notification.request.content;
    UNNotificationAttachment * attachment = content.attachments.firstObject;
    
    if (attachment.URL.startAccessingSecurityScopedResource)
    {
        self.imageView.image = [UIImage imageWithContentsOfFile:attachment.URL.path];
    }
}

@end
