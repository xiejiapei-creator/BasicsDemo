//
//  CustomAlertView.m
//  UseUIControlFramework
//
//  Created by 谢佳培 on 2020/11/9.
//

#import "CustomAlertView.h"
#import  <objc/runtime.h>

static void *AlertViewActionKey = &AlertViewActionKey;

@interface CustomAlertButton ()

@property (nonatomic, strong) CALayer *horizontalLine;// 水平线条
@property (nonatomic, strong) CALayer *verticalLine;// 垂直线条
@property (nonatomic, copy) void (^buttonClickedBlock)(CustomAlertButton *alertButton);// 按钮点击事件

@end

@implementation CustomAlertButton

+ (instancetype)buttonWithTitle:(NSString *)title handler:(void (^)(CustomAlertButton *))handler
{
    return [[self alloc] initWithTitle:title handler:handler];
}

- (instancetype)initWithTitle:(NSString *)title handler:(void (^)(CustomAlertButton *))handler
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
        _horizontalLine.backgroundColor = [UIColor colorWithHex:@"bfbfbf"].CGColor;
        [self.layer addSublayer:_horizontalLine];
        
        _verticalLine = [CALayer layer];
        _verticalLine.backgroundColor = [UIColor colorWithHex:@"bfbfbf"].CGColor;
        [self.layer addSublayer:_verticalLine];
    }
    return self;
}

- (void)handlerClicked
{
    if (self && self.buttonClickedBlock)
    {
        self.buttonClickedBlock(self);
    }
}

// 线条宽度可配置
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat lineWidth = self.lineWidth > 0 ? self.lineWidth : 1 / [UIScreen mainScreen].scale;
    _horizontalLine.frame = CGRectMake(0, 0, self.width, lineWidth);
    _verticalLine.frame = CGRectMake(0, 0, lineWidth, self.height);
}

// 线条颜色可配置
- (void)setLineColor:(UIColor *)lineColor
{
    _lineColor = lineColor;
    _verticalLine.backgroundColor = lineColor.CGColor;
    _horizontalLine.backgroundColor = lineColor.CGColor;
}

@end

@interface CustomAlertView ()
{
    CGSize  _contentSize;// 内容大小
    CGFloat _paddingTop, _paddingBottom, _paddingLeft; // 空白间隔
    CGFloat _spacing;// 空白
}
@property (nonatomic, strong) NSMutableSet *subAlertButtons;
@property (nonatomic, strong) NSMutableSet *adjoinAlertButtons;

@end

@implementation CustomAlertView

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message constantWidth:(CGFloat)constantWidth
{
    if (self = [super init])
    {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 5;// 圆角
        self.clipsToBounds = NO;
        
        // 子视图按钮的高度，默认49
        self.subOverflyButtonHeight = 49;
        
        // 默认宽度200
        _contentSize.width = 200;
        if (constantWidth > 0) _contentSize.width = constantWidth;
        
        
        _paddingTop = 15; _paddingBottom = 15; _paddingLeft = 20; _spacing = 15;
        
        if (title.length)
        {
            _titleLabel = [[UILabel alloc] init];
            _titleLabel.text = title;
            _titleLabel.numberOfLines = 0;
            _titleLabel.textAlignment = NSTextAlignmentCenter;
            _titleLabel.font = [UIFont systemFontOfSize:22];
            [self addSubview:_titleLabel];

            _titleLabel.size = [_titleLabel sizeThatFits:CGSizeMake(_contentSize.width - 2 * _paddingLeft, MAXFLOAT)];
            _titleLabel.y = _paddingTop;
            _titleLabel.centerX = _contentSize.width / 2;
            _contentSize.height = _titleLabel.bottom;
        }

        if (message.length)
        {
            _messageLabel = [[UILabel alloc] init];
            _messageLabel.numberOfLines = 0;
            _messageLabel.font = [UIFont systemFontOfSize:16];
            _messageLabel.textColor = [UIColor grayColor];
            [self addSubview:_messageLabel];
            
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:message];
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            paragraphStyle.lineSpacing = 5;
            [string addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, message.length)];
            _messageLabel.attributedText = string;

            _messageLabel.size = [_messageLabel sizeThatFits:CGSizeMake(_contentSize.width - 2 * _paddingLeft, MAXFLOAT)];
            _messageLabel.y = _titleLabel.bottom + _spacing;
            _messageLabel.centerX = _contentSize.width / 2;
            _contentSize.height = _messageLabel.bottom;
        }
     
        self.size = CGSizeMake(_contentSize.width, _contentSize.height + _paddingBottom);
        if (!title.length && !message.length)
        {
            self.size = CGSizeZero;
        }
    }
    return self;
}

// 纵向依次向下添加提示按钮
- (void)addAlertButton:(CustomAlertButton *)alertButton
{
    // 清空提示按钮
    [self clearAlertButtons:self.adjoinAlertButtons.allObjects];
    [self.adjoinAlertButtons removeAllObjects];
    
    void (^layout)(CGFloat) = ^(CGFloat top){
        CGFloat width = self->_contentSize.width - alertButton.edgeInsets.left - alertButton.edgeInsets.right;
        alertButton.size = CGSizeMake(width, self.subOverflyButtonHeight);
        alertButton.y = top;
        alertButton.centerX = self->_contentSize.width / 2;
    };
    
    CustomAlertButton *lastAlertButton = objc_getAssociatedObject(self, AlertViewActionKey);
    if (lastAlertButton)// current
    {
        if (![alertButton isEqual:lastAlertButton])
        {
            layout(lastAlertButton.bottom + alertButton.edgeInsets.top);
        }
    }
    else// first
    {
        // 增加10间距
        layout(_contentSize.height + alertButton.edgeInsets.top + 10);
    }
    
    alertButton.verticalLine.hidden = YES;
    [self insertSubview:alertButton atIndex:0];
    self.size = CGSizeMake(_contentSize.width, alertButton.bottom + alertButton.edgeInsets.bottom);
    objc_setAssociatedObject(self, AlertViewActionKey, alertButton, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

// 清空提示按钮
- (void)clearAlertButtons:(NSArray *)subviews
{
    for (UIView *subview in subviews)
    {
        if ([subview isKindOfClass:[CustomAlertButton class]])
        {
            [subview removeFromSuperview];
        }
    }
}

// 水平方向两个提示按钮
- (void)adjoinWithLeftAction:(CustomAlertButton *)leftAction rightAction:(CustomAlertButton *)rightAction
{
    // 清空提示按钮
    [self clearAlertButtons:self.subviews];
    objc_setAssociatedObject(self, AlertViewActionKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    leftAction.size = CGSizeMake(_contentSize.width / 2, self.subOverflyButtonHeight);
    leftAction.y = _contentSize.height + leftAction.edgeInsets.top; 
    
    rightAction.frame = leftAction.frame;
    rightAction.x = leftAction.right;
    rightAction.verticalLine.hidden = NO;
    [self addSubview:leftAction];
    [self addSubview:rightAction];
    
    
    self.adjoinAlertButtons = [NSMutableSet setWithObjects:leftAction, rightAction, nil];
    self.size = CGSizeMake(_contentSize.width, leftAction.bottom);
}

@end
