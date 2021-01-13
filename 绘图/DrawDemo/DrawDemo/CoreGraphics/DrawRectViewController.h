//
//  DrawRectViewController.h
//  AnimationDemo
//
//  Created by 谢佳培 on 2020/9/29.
//

#import <UIKit/UIKit.h>

#pragma mark - 画线

@interface DrawLineView : UIView

// 点线水平还是竖直
@property (nonatomic, assign) BOOL isHorizontal;

// 温度计上下颠倒
@property (nonatomic, assign) BOOL isTop;
@property (nonatomic, assign) BOOL isBottom;
- (void)isTop:(BOOL)isTop isBottom:(BOOL)isBottom;

@end

#pragma mark - 几何图形

@interface DrawGeometryView : UIView

@end

#pragma mark - 功能块

@interface DrawFunctionView : UIView

@property (nonatomic, assign) CGFloat progress;// 进度条
@property(nonatomic,strong) NSArray *nums;// 饼状图数量
@property(assign,nonatomic) NSInteger total;// 饼状图总数
@property(nonatomic,strong) NSArray *barNums;// 柱状图数量

@property (nonatomic, assign, readwrite) int starRadius;// 星星半径
@property (nonatomic, assign, readwrite) int defaultNumber;// 默认画五个星
@property (nonatomic, assign, readwrite) int starWithColorNumber;// 有几颗星星需要填充颜色
@property (nonatomic, strong, readwrite) UIColor *starColor;// 描边颜色

@end

#pragma mark - 文字和图片

@interface DrawImageAndText : UIView

@property(nonatomic,assign) CGFloat snowY;// 雪花Y轴坐标

// 压缩图片
- (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize;

@end

#pragma mark - 修改图形

@interface DrawEditView : UIView

@end

NS_ASSUME_NONNULL_BEGIN

@interface DrawRectViewController : UIViewController

@end

NS_ASSUME_NONNULL_END
