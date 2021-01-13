//
//  OverflyView.m
//  UseUIControlFramework
//
//  Created by 谢佳培 on 2020/11/11.
//

#import "OverflyView.h"
#import  <objc/runtime.h>

#define OverflyViewLineColor [UIColor colorWithHex:@"bfbfbf"]
static void *OverflyViewActionKey = &OverflyViewActionKey;

@interface OverflyButton ()

@property (nonatomic, strong) CALayer *horizontalLine;
@property (nonatomic, strong) CALayer *verticalLine;
@property (nonatomic, copy) void (^buttonClickedBlock)(OverflyButton *alertButton);

@end

@implementation OverflyButton

+ (instancetype)buttonWithTitle:(NSString *)title handler:(void (^)(OverflyButton *))handler
{
    return [[self alloc] initWithTitle:title handler:handler];
}

- (instancetype)initWithTitle:(NSString *)title handler:(void (^)(OverflyButton *))handler
{
    if (self = [super init])
    {
        self.buttonClickedBlock = handler;
        
        self.titleLabel.font = [UIFont systemFontOfSize:17];
        self.titleLabel.adjustsFontSizeToFitWidth = YES;
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
        [self setTitle:title forState:UIControlStateNormal];
        [self addTarget:self action:@selector(handlerClicked) forControlEvents:UIControlEventTouchUpInside];
        
        _horizontalLine = [CALayer layer];
        _horizontalLine.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.2].CGColor;
        [self.layer addSublayer:_horizontalLine];
        
        _verticalLine = [CALayer layer];
        _verticalLine.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.2].CGColor;
        _verticalLine.hidden = YES;
        [self.layer addSublayer:_verticalLine];
    }
    return self;
}

- (void)handlerClicked
{
    if (self && self.buttonClickedBlock) self.buttonClickedBlock(self);
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat lineWidth = self.lineWidth > 0 ? self.lineWidth : 1 / [UIScreen mainScreen].scale;
    _horizontalLine.frame = CGRectMake(0, 0, self.width, lineWidth);
    _verticalLine.frame = CGRectMake(0, 0, lineWidth, self.height);
}

- (void)setLineColor:(UIColor *)lineColor
{
    _verticalLine.backgroundColor = lineColor.CGColor;
    _horizontalLine.backgroundColor = lineColor.CGColor;
}

@end

@interface OverflyView ()

@property (nonatomic, strong) UIScrollView *scrollView;// 滚动视图
@property (nonatomic, strong) NSMutableSet *adjoinOverflyButtons;// 按钮集
@property (nonatomic, assign) CGSize overflyViewSize;// 容器尺寸

@end

@implementation OverflyView

- (instancetype)initWithFlyImage:(UIImage *)flyImage
                     highlyRatio:(CGFloat)highlyRatio
                 attributedTitle:(NSAttributedString *)attributedTitle
               attributedMessage:(NSAttributedString *)attributedMessage
                   constantWidth:(CGFloat)constantWidth
{
    if (self = [super init])
    {
        self.backgroundColor = [UIColor whiteColor];
        self.width = constantWidth;// 视图宽度
        self.highlyRatio = highlyRatio;// 顶部图片透明区域所占比
        // 消息文本边缘留白，默认UIEdgeInsetsMake(15, 15, 15, 15)
        self.messageEdgeInsets = UIEdgeInsetsMake(15, 15, 15, 15);
        // 子视图按钮(OverflyButton)的高度，默认49
        self.subOverflyButtonHeight = 49;
        // 可视滚动区域高，默认200(当message文本内容高度小于200时，则可视滚动区域等于文本内容高度)
        self.visualScrollableHight = 200;
        
        // 创建子视图
        [self createSubviews];
        
        _flyImageView.image = flyImage;
        _titleLabel.attributedText = attributedTitle;
        _messageLabel.attributedText = attributedMessage;
        
        // 创建子视图的约束
        [self createSubviewConstraints];
    }
    return self;
}

// 创建子视图
- (void)createSubviews
{
    _flyImageView = [UIImageView new];
    [self addSubview:_flyImageView];
    
    _titleLabel = [UILabel new];
    _titleLabel.numberOfLines = 0;
    [self addSubview:_titleLabel];
    
    _scrollView = [UIScrollView new];
    _scrollView.showsVerticalScrollIndicator = NO;
    [self addSubview:_scrollView];
    
    _messageLabel = [UILabel new];
    _messageLabel.numberOfLines = 0;
    _messageLabel.textAlignment = NSTextAlignmentCenter;
    [_scrollView addSubview:_messageLabel];
    
    _splitLine = [CALayer layer];
    _splitLine.backgroundColor = OverflyViewLineColor.CGColor;
    [self.layer addSublayer:_splitLine];
}

// 创建子视图的约束
- (void)createSubviewConstraints
{
    CGFloat constantWidth = self.frame.size.width;
    
    // 处理顶部图片
    UIImage *flyImage = self.flyImageView.image;
    if (flyImage)
    {
        // 高宽比因数
        double factor = flyImage.size.height / flyImage.size.width;
        CGFloat imageWidth = constantWidth;
        CGFloat imageHeight = imageWidth * factor;
        // 对图片重新制定尺寸
        _flyImageView.size = CGSizeMake(constantWidth, constantWidth * factor);
        // 顶部图片透明区域所占比
        _flyImageView.y = -(imageHeight * self.highlyRatio);
    }
    
    // 处理标题
    _titleLabel.bottom = _flyImageView.bottom;
    if (_titleLabel.attributedText.length)
    {
        _titleLabel.size = [_titleLabel sizeThatFits:CGSizeMake(constantWidth, MAXFLOAT)];
        _titleLabel.width = constantWidth;
        _titleLabel.y = _flyImageView.bottom + 2;
        _titleLabel.textAlignment = self.titleLabel.textAlignment;
    }
    
    // 处理滚动视图
    _scrollView.bottom = _titleLabel.bottom;
    if (_messageLabel.attributedText.length)
    {
        _messageLabel.size = [_messageLabel sizeThatFits:CGSizeMake(constantWidth, MAXFLOAT)];
        _messageLabel.width = constantWidth;
        _messageLabel.textAlignment = self.messageLabel.textAlignment;
        
        // 消息文本边缘留白
        UIEdgeInsets insets = self.messageEdgeInsets;
        CGFloat paddingh = insets.left + insets.right;
        CGFloat paddingv = insets.top + insets.bottom;
        _messageLabel.width -= paddingh;
        _messageLabel.height += paddingh;
        _messageLabel.x = insets.left;
        _messageLabel.height += paddingv;
        _messageLabel.y = 0;
        
        // 滚动范围
        _scrollView.y = _titleLabel.bottom + 7;
        _scrollView.contentSize = CGSizeMake(constantWidth, _messageLabel.size.height + 10);
        
        // 可视滚动区域高，默认200 (当message文本内容高度小于200时，则可视滚动区域等于文本内容高度)
        if ((self.visualScrollableHight > 0) && (_messageLabel.height > self.visualScrollableHight))
        {
            _scrollView.size = CGSizeMake(constantWidth, self.visualScrollableHight);
        }
        else
        {
            _scrollView.size = CGSizeMake(constantWidth, _messageLabel.height);
        }
        
        // 分割线
        self.splitLine.frame = CGRectMake(0, _scrollView.y, constantWidth, 1 / [UIScreen mainScreen].scale);
    }
    
    // 处理容器尺寸
    self.size = CGSizeMake(constantWidth, _scrollView.bottom);
    self.overflyViewSize = self.size;
}

// 清除按钮
- (void)clearOverflyButtons:(NSArray<UIView *> *)subviews
{
    for (UIView *subview in subviews)
    {
        if ([subview isKindOfClass:[OverflyButton class]])
        {
            [subview removeFromSuperview];
        }
    }
}

// 竖直方向添加一个按钮，可增加多个按钮依次向下排列
- (void)addOverflyButton:(OverflyButton *)button
{
    // 清除按钮
    [self clearOverflyButtons:self.adjoinOverflyButtons.allObjects];
    [self.adjoinOverflyButtons removeAllObjects];

    void (^layout)(CGFloat) = ^(CGFloat top){
        // 子视图按钮(OverflyButton)的宽度
        CGFloat width = self.overflyViewSize.width - button.flyEdgeInsets.left - button.flyEdgeInsets.right;
        // 子视图按钮(OverflyButton)的高度，默认49
        button.size = CGSizeMake(width, self.subOverflyButtonHeight);
        button.y = top;
        // 中心位置
        button.centerX = self.overflyViewSize.width / 2;
    };
    
    OverflyButton *lastButton = objc_getAssociatedObject(self, OverflyViewActionKey);
    if (lastButton)// current
    {
        if (![button isEqual:lastButton])
        {
            // 添加新的Button到上一个Button的底部
            layout(lastButton.bottom + button.flyEdgeInsets.top);
        }
    }
    else// first
    {
        layout(self.overflyViewSize.height + button.flyEdgeInsets.top);
    }
    
    button.verticalLine.hidden = YES;// 隐藏中间垂线
    [self insertSubview:button atIndex:0];// 插入按钮到顶层
    
    // 重新计算容器尺寸
    self.size = CGSizeMake(self.overflyViewSize.width, button.bottom + button.flyEdgeInsets.bottom);
    
    // 保存作为上一个按钮
    objc_setAssociatedObject(self, OverflyViewActionKey, button, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
 
// 水平方向两个并列按钮
- (void)adjoinWithLeftOverflyButton:(OverflyButton *)leftButton rightOverflyButton:(OverflyButton *)rightButton
{
    // 清除按钮
    [self clearOverflyButtons:self.adjoinOverflyButtons.allObjects];
    objc_setAssociatedObject(self, OverflyViewActionKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

    // 左边按钮的尺寸
    leftButton.size = CGSizeMake(self.overflyViewSize.width / 2, self.subOverflyButtonHeight);
    leftButton.y = self.overflyViewSize.height;// 容器尺寸
    
    // 右边按钮的尺寸
    rightButton.frame = leftButton.frame;
    rightButton.x = leftButton.right;
    
    // 显示中间垂线
    rightButton.verticalLine.hidden = NO;
    
    // 添加按钮
    [self addSubview:leftButton];
    [self addSubview:rightButton];
    self.adjoinOverflyButtons = [NSMutableSet setWithObjects:leftButton, rightButton, nil];
    
    // 重新计算容器尺寸
    self.size = CGSizeMake(self.overflyViewSize.width, leftButton.bottom);
}



@end

