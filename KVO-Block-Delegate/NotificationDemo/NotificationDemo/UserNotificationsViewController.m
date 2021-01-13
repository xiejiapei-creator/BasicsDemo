//
//  UserNotificationsViewController.m
//  NotificationDemo
//
//  Created by 谢佳培 on 2020/8/24.
//  Copyright © 2020 xiejiapei. All rights reserved.
//

#import "UserNotificationsViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <UserNotifications/UserNotifications.h>

@interface UserNotificationsViewController ()

@end

@implementation UserNotificationsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - 生成本地推送

- (void)generateLocalPush
{
//设置触发条件
    //timeInterval：单位为秒（s）  repeats：是否循环提醒
    //50s后提醒
    UNTimeIntervalNotificationTrigger *timeTrigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:10 repeats:NO];
    
    //在每周一的14点3分提醒
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.weekday = 2;
    components.hour = 16;
    components.minute = 3;
    //components日期
    UNCalendarNotificationTrigger *calendarTrigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:components repeats:YES];
    
    //创建位置信息
    CLLocationCoordinate2D locationCenter = CLLocationCoordinate2DMake(39.788857, 116.5559392);
    CLCircularRegion *region = [[CLCircularRegion alloc] initWithCenter:locationCenter radius:500 identifier:@"经海五路"];
    region.notifyOnEntry = YES;
    region.notifyOnExit = YES;
    //region 位置信息 repeats 是否重复 （CLRegion 可以是地理位置信息）
    UNLocationNotificationTrigger *locationTrigger = [UNLocationNotificationTrigger triggerWithRegion:region repeats:YES];
    
//创建通知内容
    //创建通知内容 UNMutableNotificationContent, 注意不是 UNNotificationContent ,此对象为不可变对象
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    //限制在一行，多出部分省略号
    content.title = @"《呼啸山庄》 - title";
    content.subtitle = [NSString stringWithFormat:@"艾米莉·勃朗特 - subtitle"];
    //通知栏出现时，限制在两行，多出部分省略号，但是预览时会全部展示
    //body中printf风格的转义字符，比如说要包含%，需要写成%% 才会显示，\同样
    content.body = @"一段惊世骇俗的恋情 - body";
    content.badge = @5;
    content.sound = [UNNotificationSound defaultSound];
    content.userInfo = @{@"author":@"Emily Jane Bronte",@"birthday":@"1818年7月30日"};
    
    //添加Notification Actions
    content.categoryIdentifier = @"locationCategory";
    [self addNotificationActions];
    
//创建推送请求
    NSString *requestIdentifier = @"xiejiapei";
    //创建通知请求 UNNotificationRequest 将触发条件和通知内容添加到请求中
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:requestIdentifier content:content trigger:timeTrigger];
    //将通知请求 add 到 UNUserNotificationCenter
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        if (!error)
        {
            NSLog(@"推送已添加成功 %@", requestIdentifier);
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"本地通知" message:@"成功添加推送" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:cancelAction];
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
            //此处省略一万行需求。。。。
        }
    }];
}

#pragma mark - Notification Management

+  (void)notificationAction
{
    NSString *requestIdentifier = @"xiejiapei";
    UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];

    //删除设备已收到的所有消息推送
    [center removeAllDeliveredNotifications];

    //删除设备已收到特定id的所有消息推送
    [center removeDeliveredNotificationsWithIdentifiers:@[requestIdentifier]];

    //获取设备已收到的消息推送
    [center getDeliveredNotificationsWithCompletionHandler:^(NSArray<UNNotification *> * _Nonnull notifications) {
    }];
}

#pragma mark - Notification Actions

- (void)addNotificationActions
{
    //按钮action
    UNNotificationAction *lookAction = [UNNotificationAction actionWithIdentifier:@"action.join" title:@"接收邀请" options:UNNotificationActionOptionAuthenticationRequired];

    UNNotificationAction *joinAction = [UNNotificationAction actionWithIdentifier:@"action.look" title:@"查看邀请" options:UNNotificationActionOptionForeground];

    UNNotificationAction *cancelAction = [UNNotificationAction actionWithIdentifier:@"action.cancel" title:@"取消" options:UNNotificationActionOptionDestructive];

    //输入框Action
    //buttonTitle 输入框右边的按钮标题
    //placeholder 输入框占位符
    UNTextInputNotificationAction *inputAction = [UNTextInputNotificationAction actionWithIdentifier:@"action.input" title:@"输入" options:UNNotificationActionOptionForeground textInputButtonTitle:@"发送" textInputPlaceholder:@"大声疾呼"];
    

    /**创建category
     * identifier：标识符是这个category的唯一标识，用来区分多个category，这个id不管是Local Notification，还是remote Notification，一定要有并且要保持一致
     * actions：创建action的操作数组
     * intentIdentifiers：意图标识符，可在 <Intents/INIntentIdentifiers.h> 中查看，主要是针对电话、carplay 等开放的API
     * options：通知选项，是个枚举类型，也是为了支持carplay
     */
    UNNotificationCategory *notificationCategory = [UNNotificationCategory categoryWithIdentifier:@"locationCategory" actions:@[lookAction, joinAction, cancelAction, inputAction] intentIdentifiers:@[] options:UNNotificationCategoryOptionCustomDismissAction];
    
    //将 category 添加到通知中心
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center setNotificationCategories:[NSSet setWithObject:notificationCategory]];
}

@end



