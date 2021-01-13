//
//  JpushManager.m
//  PushServiceDemo
//
//  Created by 谢佳培 on 2020/10/28.
//

#import "JpushManager.h"
#import "AppDelegate.h"
#import "JPUSHService.h"// 引入JPush功能所需头文件
#import <UserNotifications/UserNotifications.h>// 注册APNs所需头文件

@interface JpushManager ()<JPUSHRegisterDelegate,UNUserNotificationCenterDelegate>

@end

@implementation JpushManager

// 单例
+ (instancetype)shareManager
{
    static JpushManager *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_instance == nil)
        {
            _instance = [[JpushManager alloc]init];
        }
    });
    return _instance;
}

// 初始化推送
- (void)setupJPushWithLaunchingOption:(NSDictionary *)launchingOption appKey:(NSString *)appKey channel:(NSString *)channel apsForProduction:(BOOL)isProduction advertisingIdentifier:(NSString *)advertisingId;
{
    // 添加APNs代码 注册极光
    JPUSHRegisterEntity *entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    // 可以添加自定义categories
    NSSet<UNNotificationCategory *> *categories;
    entity.categories = categories;
    
    // IDFA为设备广告标示符，用于广告投放。通常不会改变，不同App获取到都是一样的。但如果用户完全重置系统（(设置程序 -> 通用 -> 还原 -> 还原位置与隐私) ，这个广告标示符会重新生成。
    // IDFA用于同一设备下的不同app信息共享，如不需要使用，advertisingIdentifier 可为nil
    // NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    [JPUSHService setupWithOption:launchingOption appKey:appKey channel:channel apsForProduction:isProduction advertisingIdentifier:advertisingId];
    
    // 获取极光推送注册ID（RegistrationID）
    // 原生是采用deviceToken来标识设备唯一性。在极光中采用RegistrationID
    // 其生成原则优先采用IDFA（如果设备未还原IDFA，卸载App后重新下载，还是能被识别出老用户），次采用deviceToken
    // 集成了 JPush SDK 的应用程序在第一次 App 启动后，成功注册到 JPush 服务器时，JPush 服务器会给客户端返回唯一的该设备的标识 -—— RegistrationID
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if(resCode == 0)
        {
            NSLog(@"registrationID 获取成功为：%@",registrationID);
            
            // 设置别名
            // 一个设备只能有一个别名(Alias)，但能有多个标签。所以别名可以用userId，针对一个用户
            // 标签(Tag)可以用用户所处分组，方便针对目标用户推送，针对一批用户
            [JPUSHService setAlias:[[NSUserDefaults standardUserDefaults] valueForKey:@"userId"]  completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
                
                NSLog(@"设置别名");
                
            } seq:0];
        }
        else
        {
            NSLog(@"registrationID 获取失败，code为：%d",resCode);
        }
    }];
}

// 在appdelegate注册设备处调用
- (void)registerDeviceToken:(NSData *)deviceToken
{
    [JPUSHService registerDeviceToken:deviceToken];
}

#pragma mark - JPUSHRegisterDelegate

// 收到通知消息后展示
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler
{
    NSDictionary *userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]])
    {
       [JPUSHService handleRemoteNotification:userInfo];
        
        if (self.afterReceiveNoticationHandle)
        {
            self.afterReceiveNoticationHandle(userInfo);
        }
    }
    
    // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Banner三种类型可以设置
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBanner);
}

// 点击通知进入App
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler
{
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    UNNotificationRequest *request = response.notification.request;// 收到推送的请求
    UNNotificationContent *content = request.content;// 收到推送的消息内容
    NSNumber *badge = content.badge;// 推送消息的角标
    NSString *body = content.body;// 推送消息体
    UNNotificationSound *sound = content.sound;// 推送消息的声音
    NSString *subtitle = content.subtitle;// 推送消息的副标题
    NSString *title = content.title;// 推送消息的标题
    
    NSLog(@"点击通知栏，收到远程通知的用户信息为:%@", userInfo);
    NSLog(@"解析后信息为:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    
    // 清空Jpush中存储的badge值
    [self setBadge:0];
    
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]])// 远程通知
    {
        NSLog(@"远程通知");
    }
    else// 本地通知
    {
        NSLog(@"本地通知");
    }
    
    [JPUSHService handleRemoteNotification:userInfo];

    // 点击消息进行跳转到消息的详情界面中
    // [self goToMssageViewControllerWith:userInfo];
    
    // 系统要求执行这个方法
    completionHandler();
}

// 点击通知打开设置APP
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center openSettingsForNotification:(UNNotification *)notification
{
    if (notification && [notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]])
    {
        NSLog(@"通知界面进入应用");
    }
    else
    {
        NSLog(@"设置界面进入应用");
    }
}


#pragma mark - 便利方法

// 设置角标
- (void)setBadge:(int)badge
{
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:badge];
    [JPUSHService setBadge:badge];
}

// 设置别名
- (void)setAlias:(NSString *)aliasName
{
    [JPUSHService getAlias:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
        NSLog(@"旧的别名为：iResCode == %ld，iAlias == %@",(long)iResCode,iAlias);
        
        if (![iAlias isEqualToString:aliasName])
        {
            [JPUSHService setAlias:aliasName completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
                
                NSLog(@"设置新的别名：callBackTextView %@",[NSString stringWithFormat:@"iResCode:%ld, \niAlias: %@, \nseq: %ld\n", (long)iResCode, iAlias, (long)seq]);
                
            } seq:0];
            
        }
        
    } seq:0];
}

// 删除别名
- (void)deleteAlias
{
    [JPUSHService deleteAlias:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
        NSLog(@"删除别名");
    } seq:0];
}
 

@end



