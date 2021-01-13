//
//  PushDemoViewController.m
//  PushServiceDemo
//
//  Created by 谢佳培 on 2020/10/23.
//

#import "PushDemoViewController.h"
#import <CoreLocation/CoreLocation.h>// 定点推送时用于创建regin

@interface PushDemoViewController ()

@end

@implementation PushDemoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self simpleLocalNotificationDescribe];
}

- (void)createNotification:(UIButton *)sender
{
    [self simpleLocalPushService];
}

#pragma mark - 通知的触发条件

// 定时推送
- (UNTimeIntervalNotificationTrigger *)getTimeTrigger
{
    // 触发推送的时机。timeInterval：单位为秒（s）  repeats：是否循环提醒
    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:5 repeats:NO];
    return trigger;
}

// 定期推送
- (UNCalendarNotificationTrigger *)getCalendarTrigger
{
    // components代表日期，这里指在每周一的14点3分提醒
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.weekday = 2;
    components.hour = 14;
    components.minute = 3;
    UNCalendarNotificationTrigger *calendarTrigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:components repeats:YES];
    return calendarTrigger;
}

// 定点推送
- (UNLocationNotificationTrigger *)getLocationTrigger
{
    // 使用CLRegion的子类CLCircularRegion创建位置信息
    CLLocationCoordinate2D center1 = CLLocationCoordinate2DMake(39.788857, 116.5559392);
    CLCircularRegion *region = [[CLCircularRegion alloc] initWithCenter:center1 radius:500 identifier:@"海峡国际社区"];
    
    // 进入地区、从地区出来或者两者都要的时候进行通知
    region.notifyOnEntry = YES;
    region.notifyOnExit = YES;
    
    // region 位置信息 repeats 是否重复
    UNLocationNotificationTrigger *locationTrigger = [UNLocationNotificationTrigger triggerWithRegion:region repeats:YES];
    return locationTrigger;
}

#pragma mark - 通知的内容

// 文字、图像、声音
- (UNMutableNotificationContent *)getSimpleContent
{
    // 推送的文本内容
    // UNNotificationContent的属性readOnly，而UNMutableNotificationContent的属性可以更改
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    
    // 限制在一行，多出部分省略号
    content.title = @"时间提醒";
    content.subtitle = [NSString stringWithFormat:@"《请回答1988》第二季放映的时间提醒"];
    
    // body中printf风格的转义字符，比如说要包含%，需要写成%% 才会显示，\同样
    content.body = @"口若悬河、妙语迭出的精彩表演，从作者津津乐道的口吻可以看出，王尔德无疑是在顾影自怜，因为他自己正是这样的作秀高手，而他在社交圈中越练越“酷”的口才，在他的社会喜剧中得到了淋漓尽致的发挥，令观众如醉如痴!";
    
    content.badge = @5;
    // UNNotificationSound *customSound = [UNNotificationSound soundNamed:@""];// 自定义声音
    content.sound = [UNNotificationSound defaultSound];
    content.userInfo = @{@"useName":@"XieJiapei",@"age":@"22"};
    
    // 辅助图像，下拉通知会放大图像
    NSString *imageFilePath = [[NSBundle mainBundle] pathForResource:@"luckcoffee" ofType:@"JPG"];
    if (imageFilePath)
    {
        NSError* error = nil;
        UNNotificationAttachment *imageAttachment = [UNNotificationAttachment attachmentWithIdentifier:@"imageAttachment" URL:[NSURL fileURLWithPath:imageFilePath] options:nil error:&error];
        if (imageAttachment)
        {
            // 这里设置的是Array，但是只会取lastObject
            content.attachments = @[imageAttachment];
        }
    }
    
    return content;
}

// 视频
- (UNMutableNotificationContent *)getVideoContent
{
    UNMutableNotificationContent* content = [[UNMutableNotificationContent alloc] init];
    content.title = @"WWDC";
    content.subtitle = @"苹果开发者技术大会";
    content.body = @"下拉通知可直接播放";
    
    // 导入视频的时候，默认不是添加到bundle中，必须手动勾选Add to targets或者之后放到Copy Bundle Resource里面
    NSString *videoFilePath = [[NSBundle mainBundle] pathForResource:@"girl" ofType:@"MP4"];
    if (videoFilePath)
    {
        UNNotificationAttachment* videoAttachment = [UNNotificationAttachment attachmentWithIdentifier:@"videoAttachment" URL:[NSURL fileURLWithPath:videoFilePath] options:nil error:nil];
        
        if (videoAttachment)
        {
            // 这里设置的是Array，但是只会取lastObject
            content.attachments = @[videoAttachment];
        }
    }
    
    return content;
}

// 操作
- (UNMutableNotificationContent *)getActionContent
{
    UNMutableNotificationContent* content = [[UNMutableNotificationContent alloc] init];
    content.title = @"Apple";
    content.subtitle = @"Apple Developer";
    content.body = @"下拉放大图片";
    
    NSMutableArray *actionMutableArray = [[NSMutableArray alloc] initWithCapacity:3];
    
    // UNNotificationActionOptionAuthenticationRequired 需要解锁显示，点击不会进app
    UNNotificationAction *unUnlockAction = [UNNotificationAction actionWithIdentifier:@"IdentifierNeedUnUnlock" title:@"需要解锁" options: UNNotificationActionOptionAuthenticationRequired];
    
    // UNNotificationActionOptionDestructive 红色文字，点击不会进app
    UNNotificationAction *destructiveAction = [UNNotificationAction actionWithIdentifier:@"IdentifierRed" title:@"红色显示" options: UNNotificationActionOptionDestructive];
    
    // UNNotificationActionOptionForeground 黑色文字，点击会进app
    // UNTextInputNotificationAction是输入框Action，buttonTitle是输入框右边的按钮标题，placeholder是输入框占位符
    UNTextInputNotificationAction *inputTextAction = [UNTextInputNotificationAction actionWithIdentifier:@"IdentifierInputText" title:@"输入文本" options:UNNotificationActionOptionForeground textInputButtonTitle:@"发送" textInputPlaceholder:@"说说今天发生了啥......"];
    
    [actionMutableArray addObjectsFromArray:@[unUnlockAction, destructiveAction, inputTextAction]];
    
    if (actionMutableArray.count > 1)
    {
        /**categoryWithIdentifier方法
         * identifier：是这个category的唯一标识，用来区分多个category，这个id不管是Local Notification，还是remote Notification，一定要有并且要保持一致
         * actions：创建action的操作数组
         * intentIdentifiers：意图标识符 可在 <Intents/INIntentIdentifiers.h> 中查看，主要是针对电话、carplay 等开放的 API
         * options：通知选项 枚举类型 也是为了支持 carplay
         */
        UNNotificationCategory *categoryNotification = [UNNotificationCategory categoryWithIdentifier:@"categoryOperationAction" actions:actionMutableArray intentIdentifiers:@[] options:UNNotificationCategoryOptionCustomDismissAction];
        
        // 将创建的 category 添加到通知中心
        [[UNUserNotificationCenter currentNotificationCenter] setNotificationCategories:[NSSet setWithObject:categoryNotification]];
        
        // category的唯一标识，Local Notification保持一致
        content.categoryIdentifier = @"categoryOperationAction";
    }
    
    return content;
}

#pragma mark - 对推送进行查、改、删

- (void)removeNotificaiton
{
    NSString *requestIdentifier = @"XieJiaPei";
    UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
    
    // 删除设备已收到特定id的所有消息推送
    [center removeDeliveredNotificationsWithIdentifiers:@[requestIdentifier]];
    
    // 删除设备已收到的所有消息推送
    [center removeAllDeliveredNotifications];
    
    // 获取设备已收到的消息推送
    [center getDeliveredNotificationsWithCompletionHandler:^(NSArray<UNNotification *> * _Nonnull notifications) {
        NSLog(@"获取设备已收到的消息推送");
    }];
}

#pragma mark - 简单的本地通知

- (void)simpleLocalNotificationDescribe
{
    [self buildNotificationDescribe:@"最简单的本地通知（创建5秒后触发，建议回到桌面察看效果）"];
}

- (void)simpleLocalPushService
{
    // 定时推送
    UNTimeIntervalNotificationTrigger *trigger = [self getTimeTrigger];
    
    // 推送的内容
    UNMutableNotificationContent *content = [self getActionContent];
    
    // 创建通知请求 UNNotificationRequest 将触发条件和通知内容添加到请求中
    NSString *requestIdentifer = @"Simple Local Notification";
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:requestIdentifer content:content trigger:trigger];
    
    // 将通知请求 add 到 UNUserNotificationCenter
    [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        
        if (!error)
        {
            NSLog(@"简单的本地通知已添加成功!");
            
            // 此处省略一万行需求.......
        }
    }];
}

#pragma mark - Target

// 将内容发送给BTarget
- (UNMutableNotificationContent *)getBTargetContent
{
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = @"尤利西斯";
    content.subtitle = @"詹姆斯·乔伊斯";
    content.body = @"我读了一百多页了，现在一个人名都没记住，内容是啥也全都不知道，恍恍惚惚地状态中读着，读了又好像没读，每一页纸上全是注释，我看不懂的注释，没有耐心看下去了……这就是一本垃圾书。";
    
    content.categoryIdentifier = @"CustomUI";
    
    return content;
}

@end




