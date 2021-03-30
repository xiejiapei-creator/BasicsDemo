//
//  BallsLoadingView.h
//  AnimationDemo
//
//  Created by 谢佳培 on 2021/3/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT const CGFloat BallsLoadingLayerSize;

@interface BallsLoadingView : UIView

/** 开始动画 */
- (void)startAnimation;

/** 结束动画 */
- (void)stopAnimation;

@end

NS_ASSUME_NONNULL_END
