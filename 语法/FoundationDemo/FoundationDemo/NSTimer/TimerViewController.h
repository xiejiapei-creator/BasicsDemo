//
//  TimerViewController.h
//  BasicGrammarDemo
//
//  Created by 谢佳培 on 2020/9/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TimerViewController : UIViewController

/** timer携带的信息 */
- (NSDictionary *)userInfo;

/** 重复的timer */
@property (nonatomic,weak) NSTimer *repeatingTimer;

/** 未注册的timer */
@property (strong, nullable) NSTimer *unregisteredTimer;

/** 调用次数 */
@property NSUInteger timerCount;

@end

NS_ASSUME_NONNULL_END
