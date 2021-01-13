//
//  CustomAlertView.h
//  UseUIControlFramework
//
//  Created by 谢佳培 on 2020/11/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CustomAlertButton : UIButton

/// 工厂方法初始化Button
+ (instancetype)buttonWithTitle:(NSString *)title handler:(void (^)(CustomAlertButton *button))handler;

/// 线条颜色
@property (nonatomic, assign) UIColor *lineColor;
/// 线条宽度
@property (nonatomic, assign) CGFloat lineWidth;
/// 边缘留白 top -> 间距 / bottom -> 最底部留白(根据不同情况调整不同间距)
@property (nonatomic, assign) UIEdgeInsets edgeInsets;

@end

@interface CustomAlertView : UIView

/// 标题
@property (nonatomic, strong, readonly) UILabel *titleLabel;

/// 内容
@property (nonatomic, strong, readonly) UILabel *messageLabel;

/// 初始化
- (instancetype)initWithTitle:(nullable NSString *)title
                      message:(nullable NSString *)message
                constantWidth:(CGFloat)constantWidth;

/// 子视图按钮的高度，默认49
@property (nonatomic, assign) CGFloat subOverflyButtonHeight;

/// 纵向依次向下添加提示按钮
- (void)addAlertButton:(CustomAlertButton *)alertButton;

/// 水平方向两个提示按钮
- (void)adjoinWithLeftAction:(CustomAlertButton *)leftAction rightAction:(CustomAlertButton *)rightAction;

@end
 
NS_ASSUME_NONNULL_END
