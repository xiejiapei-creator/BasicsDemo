//
//  OverflyView.h
//  UseUIControlFramework
//
//  Created by 谢佳培 on 2020/11/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OverflyButton : UIButton

+ (instancetype)buttonWithTitle:(NSString *)title handler:(void (^)(OverflyButton *button))handler;

/// 线条颜色
@property (nonatomic, assign) UIColor *lineColor;
/// 线宽
@property (nonatomic, assign) CGFloat lineWidth;
/// 边缘留白 top -> 间距 / bottom -> 最底部留白(根据不同情况调整不同间距)
@property (nonatomic, assign) UIEdgeInsets flyEdgeInsets;

@end

@interface OverflyView : UIView

/// 顶部image
@property (nonatomic, strong) UIImageView *flyImageView;
/// 标题
@property (nonatomic, strong, readonly) UILabel *titleLabel;
/// 消息文本
@property (nonatomic, strong, readonly) UILabel *messageLabel;
/// 分割线
@property (nonatomic, strong, readonly) CALayer *splitLine;

/// 顶部图片透明区域所占比
@property (nonatomic, assign) CGFloat highlyRatio;
/// 可视滚动区域高，默认200 (当message文本内容高度小于200时，则可视滚动区域等于文本内容高度)
@property (nonatomic, assign) CGFloat visualScrollableHight;
/// 消息文本边缘留白，默认UIEdgeInsetsMake(15, 15, 15, 15)
@property (nonatomic, assign) UIEdgeInsets messageEdgeInsets;
/// 子视图按钮(OverflyButton)的高度，默认49
@property (nonatomic, assign) CGFloat subOverflyButtonHeight;

/**
 * @param flyImage 顶部image
 * @param highlyRatio 为使对称透明区域视觉上更加美观，需要设置顶部图片透明区域所占比，无透明区域设置为0即可 ( highlyRatio = 图片透明区域高度 / 图片高度 )
 * @param attributedTitle 富文本标题
 * @param attributedMessage 消息文本
 * @param constantWidth 自动计算内部各组件高度，最终zhOverflyView视图高等于总高度
 */
- (instancetype)initWithFlyImage:(UIImage *)flyImage
                     highlyRatio:(CGFloat)highlyRatio
                 attributedTitle:(NSAttributedString *)attributedTitle
               attributedMessage:(NSAttributedString *)attributedMessage
                   constantWidth:(CGFloat)constantWidth;

/// 竖直方向添加一个按钮，可增加多个按钮依次向下排列
- (void)addOverflyButton:(OverflyButton *)button;

/// 水平方向两个并列按钮
- (void)adjoinWithLeftOverflyButton:(OverflyButton *)leftButton rightOverflyButton:(OverflyButton *)rightButton;

@end

NS_ASSUME_NONNULL_END
