//
//  JpushManager.h
//  PushServiceDemo
//
//  Created by 谢佳培 on 2020/10/28.
//

#import <Foundation/Foundation.h>

// 收到推送的消息后的回调
typedef void(^AfterReceiveNoticationHandle)(NSDictionary *userInfo);

@interface JpushManager : NSObject

/** 接收到消息后的处理 */
@property(copy,nonatomic) AfterReceiveNoticationHandle afterReceiveNoticationHandle;

/** 单例 */
+ (instancetype)shareManager;

/** 初始化推送 */
- (void)setupJPushWithLaunchingOption:(NSDictionary *)launchingOption
                               appKey:(NSString *)appKey
                              channel:(NSString *)channel
                     apsForProduction:(BOOL)isProduction
                advertisingIdentifier:(NSString *)advertisingId;

/** 在appdelegate注册设备处调用 */
- (void)registerDeviceToken:(NSData *)deviceToken;

/** 设置别名 */
- (void)setAlias:(NSString *)aliasName;

/** 删除别名 */
- (void)deleteAlias;

/** 设置角标 */
- (void)setBadge:(int)badge;

@end
 
