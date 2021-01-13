//
//  ManualKVOViewController.h
//  KVO_KVC_Demo
//
//  Created by 谢佳培 on 2020/9/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Target : NSObject
{
    int age;
}

// 手动 KVO - 监听age
- (int)age;
- (void)setAge:(int)theAge;

@end

@interface ManualKVOViewController : UIViewController

@end

NS_ASSUME_NONNULL_END
