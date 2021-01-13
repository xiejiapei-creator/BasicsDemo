//
//  AppDelegate.m
//  PushServiceDemo
//
//  Created by 谢佳培 on 2020/10/23.
//

#import "AppDelegate.h"
#import "PushDemoViewController.h"
#import "JpushManager.h"
#import <MBProgressHUD.h>

static NSString * const JPushAppKey = @"e98bc4beea9b2988976bae04";// 极光appKey
static NSString * const JPushChannel = @"Publish channel";// 固定的
// NO为开发环境，YES为生产环境。虚拟机和真机调试属于开发环境。测试包、企业包和App Store属于生产环境
BOOL isProduction = !DEBUG;
BOOL kFUserJPush = NO;

@interface AppDelegate ()<UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    PushDemoViewController *rootVC = [[PushDemoViewController alloc] init];
    UINavigationController *mainNC = [[UINavigationController alloc] initWithRootViewController:rootVC];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = mainNC;
    [self.window makeKeyAndVisible];
    
    // 使用推送通知服务需要得到用户的许可
    [self registerPushService];
    
    // 极光推送
    [self configureJpushWithLaunchingOption:launchOptions];

    return YES;
}

#pragma mark - UNUserNotificationCenterDelegate

// 即将展示推送的通知 (app在前台获取到通知)
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler
{
    // 收到推送的请求
    UNNotificationRequest *request = notification.request;
    
    // 收到的内容
    UNNotificationContent *content = request.content;
    
    // 收到用户的基本信息
    NSDictionary *userInfo = content.userInfo;
    
    // 收到消息的角标
    NSNumber *badge = content.badge;
    
    // 收到消息的body
    NSString *body = content.body;
    
    // 收到消息的声音
    UNNotificationSound *sound = content.sound;
    
    // 推送消息的副标题
    NSString *subtitle = content.subtitle;
    
    // 推送消息的标题
    NSString *title = content.title;
    
    if ([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]])// 远程推送的通知
    {
        NSLog(@"远程推送的通知，收到用户的基本信息为： %@\n",userInfo);
    }
    else // 本地通知
    {
        NSLog(@"本地推送的通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@}",body,title,subtitle,badge,sound,userInfo);
    }
    
    // 不管前台后台状态下。推送消息的横幅都可以展示出来
    // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Banner三种类型可以设置
    completionHandler(UNNotificationPresentationOptionBadge|
                      UNNotificationPresentationOptionSound|
                      UNNotificationPresentationOptionBanner);
}

// 用户点击推送消息时触发 (点击通知进入app时触发)
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler
{
    //  UNNotificationResponse 是普通按钮的Response
    NSString *actionIdentifierString = response.actionIdentifier;
    if (actionIdentifierString)
    {
        // 点击后展示文本2秒后隐藏
        UIView *windowView = [[[UIApplication sharedApplication] keyWindow] rootViewController].view;
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:windowView animated:YES];
        hud.label.text = [NSString stringWithFormat:@"用户点击了消息，id为：%@",actionIdentifierString];
        hud.mode = MBProgressHUDModeText;
        [hud hideAnimated:YES afterDelay:2];
        
        if ([actionIdentifierString isEqualToString:@"IdentifierNeedUnUnlock"])
        {
            NSLog(@"需要解锁");
        }
        else if ([actionIdentifierString isEqualToString:@"IdentifierRed"])
        {
            NSLog(@"红色显示，并且设置APP的Badge通知数字为0");
            
            // 设置APP的Badge通知数字
            [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
        }
    }
    
    //  UNTextInputNotificationResponse 是带文本输入框按钮的Response
    if ([response isKindOfClass:[UNTextInputNotificationResponse class]])
    {
        NSString *userSayString = [(UNTextInputNotificationResponse *)response userText];
        if (userSayString)
        {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                UIView *windowView = [[[UIApplication sharedApplication] keyWindow] rootViewController].view;
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:windowView animated:YES];
                hud.label.text = userSayString;
                hud.mode = MBProgressHUDModeText;
                [hud hideAnimated:YES afterDelay:2];
            });
        }
    }

    // 系统要求执行这个方法
    completionHandler();
}

#pragma mark - 注册远程通知

// 使用推送通知服务需要得到用户的许可
- (void)registerPushService
{
    // 远程通知授权
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert | UNAuthorizationOptionBadge | UNAuthorizationOptionSound) completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted)
        {
            NSLog(@"远程通知中心成功打开");
            
            // 必须在主线程注册通知
            dispatch_async(dispatch_get_main_queue(), ^{
                // 注册远程通知
                [[UIApplication sharedApplication] registerForRemoteNotifications];
                
                // 注册delegate
                [[UNUserNotificationCenter currentNotificationCenter] setDelegate:self];
            });
        }
        else
        {
            NSLog(@"远程通知中心打开失败");
        }
    }];
    
    // 获取注册之后的权限设置
    // 注意UNNotificationSettings是只读对象，不能直接修改
    [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
        NSLog(@"通知的配置信息:\n%@",settings);
    }];
}

#pragma  mark - 获取device Token

// 远端推送需要获取设备的Device Token
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    // 解析NSData获取字符串
    NSString *deviceString = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];// 移除<>
    deviceString = [deviceString stringByReplacingOccurrencesOfString:@" " withString:@""];// 移除空格
    
    NSLog(@"设备的Device Token为：%@",deviceString);
    
    // 极光推送注册 DeviceToken
    [[JpushManager shareManager] registerDeviceToken:deviceToken];
}

// 获取设备的DeviceToken失败
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"获取设备的DeviceToken失败：%@\n",error.description);
}

#pragma mark - 极光推送

// didFinishLaunching中极光推送的配置
- (void)configureJpushWithLaunchingOption:(NSDictionary *)launchingOption
{
    // 初始化推送
    [[JpushManager shareManager] setupJPushWithLaunchingOption:launchingOption appKey:JPushAppKey channel:JPushChannel apsForProduction:isProduction advertisingIdentifier:nil];
    
    // 设置角标为0
    [[JpushManager shareManager] setBadge:0];
    
    __weak __typeof(self)weakSelf = self;
    [JpushManager shareManager].afterReceiveNoticationHandle = ^(NSDictionary *userInfo){
        NSLog(@"接收到消息后处理消息");
        
        [weakSelf getMessageToHandle];
    };
}

// 将要从后台进入前台
- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // 设置角标为0
    [[JpushManager shareManager] setBadge:0];
}

// 接收到消息后处理消息
- (void)getMessageToHandle
{
    NSLog(@"这条消息价值百万英镑！！！");
}

@end

