//
//  NotificationCenterViewController.h
//  PushServiceDemo
//
//  Created by 谢佳培 on 2020/10/23.
//

#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>

NS_ASSUME_NONNULL_BEGIN

@interface NotificationCenterViewController : UIViewController

/** 构建通知按钮的功能描述信息 */
- (void)buildNotificationDescribe:(NSString *)describeString;

/** 创建通知 */
- (void)createNotification:(UIButton *)sender;

@end

NS_ASSUME_NONNULL_END
