//
//  NumberViewController.h
//  LittleMethodDemo
//
//  Created by 谢佳培 on 2020/11/3.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NumberViewController : UIViewController

/** 获取一个随机整数，范围在[from,to]，包括from，包括to */
- (int)getRandomNumber:(int)from to:(int)to;

@end

NS_ASSUME_NONNULL_END
