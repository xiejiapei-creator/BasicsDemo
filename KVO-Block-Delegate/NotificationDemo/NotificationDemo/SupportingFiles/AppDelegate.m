//
//  AppDelegate.m
//  NotificationDemo
//
//  Created by 谢佳培 on 2020/8/24.
//  Copyright © 2020 xiejiapei. All rights reserved.
//

#import "AppDelegate.h"
#import "UserNotificationsViewController.h"
#import <UserNotifications/UserNotifications.h>

@interface AppDelegate ()<UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    UserNotificationsViewController *rootVC = [[UserNotificationsViewController alloc] init];
    UINavigationController *mainNC = [[UINavigationController alloc] initWithRootViewController:rootVC];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = mainNC;
    [self.window makeKeyAndVisible];
    
    
    [self replyPushNotificationAuthorization:application];
    
    return YES;
}

#pragma mark - 申请通知权限

// 申请通知权限
- (void)replyPushNotificationAuthorization:(UIApplication *)application
{
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    //必须写代理，不然无法监听通知的接收与点击事件
    center.delegate = self;
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (!error && granted)
        {
            //用户点击允许
            NSLog(@"注册成功");
        }
        else
        {
            //用户点击不允许
            NSLog(@"注册失败");
        }
    }];

    //获取权限设置信息，注意UNNotificationSettings是只读对象哦，不能直接修改！
    [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
        NSLog(@"获取权限设置信息：%@",settings);
    }];

    //注册远端消息通知获取device token
    [application registerForRemoteNotifications];
}

#pragma  mark - 远端推送需要获取设备的Device Token

//获取DeviceToken成功
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{

    //解析NSData获取字符串
    //错误写法：直接使用下面方法转换为string会得到一个nil（别怪我不告诉你哦）
    //NSString *deviceString = [[NSString alloc] initWithData:deviceToken encoding:NSUTF8StringEncoding];

    //正确写法
    NSString *deviceString = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    deviceString = [deviceString stringByReplacingOccurrencesOfString:@" " withString:@""];

    NSLog(@"获取DeviceToken成功：%@",deviceString);
}

//获取DeviceToken失败
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"获取DeviceToken失败：%@\n",error.description);
}


#pragma mark - 收到通知（苹果把本地通知跟远程通知合二为一）

//App处于前台接收通知时调用，后台模式下是不会走这里的
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{

    //收到推送的请求
    UNNotificationRequest *request = notification.request;

    //收到推送的内容
    UNNotificationContent *content = request.content;

    //收到用户的基本信息
    NSDictionary *userInfo = content.userInfo;

    //收到推送消息的角标
    NSNumber *badge = content.badge;

    //收到推送消息body
    NSString *body = content.body;

    //推送消息的声音
    UNNotificationSound *sound = content.sound;

    // 推送消息的副标题
    NSString *subtitle = content.subtitle;

    // 推送消息的标题
    NSString *title = content.title;

    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]])
    {
        //此处省略一万行需求代码。。。。。。
        NSLog(@"收到远程通知:%@",userInfo);
    }
    else
    {
        //判断为本地通知
        //此处省略一万行需求代码。。。。。。
        NSLog(@"iOS10 收到本地通知:{\\\\nbody:%@，\\\\ntitle:%@,\\\\nsubtitle:%@,\\\\nbadge：%@，\\\\nsound：%@，\\\\nuserInfo：%@\\\\n}",body,title,subtitle,badge,sound,userInfo);
    }

    //不管前台后台状态下。推送消息的横幅都可以展示出来！后台状态不用说，前台时需要在前台代理方法中进行如下设置
    //需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
    completionHandler(UNNotificationPresentationOptionBadge|
                      UNNotificationPresentationOptionSound|
                      UNNotificationPresentationOptionAlert);

}


//App通知的点击事件。用户点击消息才会触发，如果使用户长按（3DTouch）、弹出Action页面等并不会触发，但是点击Action的时候会触发！
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler
{
    //收到推送的请求
    UNNotificationRequest *request = response.notification.request;

    //收到推送的内容
    UNNotificationContent *content = request.content;

    //收到用户的基本信息
    NSDictionary *userInfo = content.userInfo;

    //收到推送消息的角标
    NSNumber *badge = content.badge;

    //收到推送消息body
    NSString *body = content.body;

    //推送消息的声音
    UNNotificationSound *sound = content.sound;

    // 推送消息的副标题
    NSString *subtitle = content.subtitle;

    // 推送消息的标题
    NSString *title = content.title;

    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]])
    {
        NSLog(@"收到远程通知:%@",userInfo);
        //此处省略一万行需求代码。。。。。。

    }
    else
    {
        //判断为本地通知
        //此处省略一万行需求代码。。。。。。
        NSLog(@"iOS10 收到本地通知:{\\\\nbody:%@，\\\\ntitle:%@,\\\\nsubtitle:%@,\\\\nbadge：%@，\\\\nsound：%@，\\\\nuserInfo：%@\\\\n}",body,title,subtitle,badge,sound,userInfo);
    }
    
    //Notification Actions
    NSString* actionIdentifierStr = response.actionIdentifier;
 
    //输入action
    if ([response isKindOfClass:[UNTextInputNotificationResponse class]])
    {
        NSString* userSayStr = [(UNTextInputNotificationResponse *)response userText];
        NSLog(@"actionid = %@\n  userSayStr = %@",actionIdentifierStr, userSayStr);
        //此处省略一万行需求代码。。。。
    }

    //点击action
    if ([actionIdentifierStr isEqualToString:@"action.join"])
    {
        //此处省略一万行需求代码
         NSLog(@"actionid = %@\n",actionIdentifierStr);
    }
    
    if ([actionIdentifierStr isEqualToString:@"action.look"])
    {

        //此处省略一万行需求代码
        NSLog(@"actionid = %@\n",actionIdentifierStr);
    }
    
    //系统要求执行这个方法，不然会报completion handler was never called.错误
    completionHandler();
}

@end
