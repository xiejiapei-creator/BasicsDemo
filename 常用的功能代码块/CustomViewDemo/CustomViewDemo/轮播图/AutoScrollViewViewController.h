//
//  AutoScrollViewViewController.h
//  FunctionCodeBlockDemo
//
//  Created by 谢佳培 on 2020/10/9.
//

#import <UIKit/UIKit.h>

@interface AutoScrollView : UIView

/** 滚动的图片 */
@property (nonatomic, strong, readwrite) NSMutableArray *scrollImage;
/** 滚动视图的尺寸 */
@property (nonatomic, assign, readwrite) CGSize scrollSize;
/** 滚动时长 */
@property (nonatomic, assign, readwrite) CGFloat duration;
/** 页面 */
@property (nonatomic, strong, readonly) UIPageControl *pageView;
/** 计时器 */
@property (nonatomic, strong) NSTimer *timer;

@end

@interface AutoScrollViewViewController : UIViewController

/** 滚动视图 */
@property (nonatomic, strong) AutoScrollView *autoScrollView;

@end
