//
//  RefreshView.h
//  AnimationDemo
//
//  Created by 谢佳培 on 2021/3/30.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreGraphics/CoreGraphics.h>

FOUNDATION_EXPORT const CGFloat PullLoadingViewSize;

@interface RefreshView : UIView

/** 关联滑动视图 */
@property (weak, nonatomic) UIScrollView *scrollView;

/** 拉多少距离转一周 */
@property (nonatomic, assign) CGFloat distanceForTurnOneCycle;

/** 下拉加载 */
- (void)loading;

/** 当取消或者加载完成的时机会调用这个方法 */
- (void)loadingFinished;

@end
