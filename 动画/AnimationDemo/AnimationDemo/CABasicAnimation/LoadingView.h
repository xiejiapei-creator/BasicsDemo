//
//  LoadingView.h
//  AnimationDemo
//
//  Created by 谢佳培 on 2021/3/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

// view宽度必须使用此值
FOUNDATION_EXPORT const CGFloat LoadingViewSize;

// 全局loading
@interface LoadingView : UIView

/** 开始动画 */
- (void)startAnimating;

/** 结束动画 */
- (BOOL)isAnimating;

@end

NS_ASSUME_NONNULL_END
