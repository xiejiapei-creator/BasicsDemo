//
//  SidebarView.m
//  UseUIControlFramework
//
//  Created by 谢佳培 on 2020/11/12.
//

#import "SidebarView.h"


#define IPhoneXSafeAreaHeight 34

@interface SidebarView ()

// 遮罩特效
@property (nonatomic, strong) UIVisualEffectView *blurView;
// 设置
@property (nonatomic, strong) ImageButton *settingItem;
// 夜间模式
@property (nonatomic, strong) ImageButton *nightItem;

@end

@implementation SidebarView

- (instancetype)init
{
    if (self = [super init])
    {
        // 视图的区域比底层视图暗
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        _blurView = [[UIVisualEffectView alloc] initWithEffect:effect];
        [self addSubview:_blurView];
        
        // 设置和夜间模式按钮
        _settingItem = [self itemWithText:@"设置" imageNamed:@"sidebar_settings"];
        [self addSubview:_settingItem];
        _nightItem = [self itemWithText:@"夜间模式" imageNamed:@"sidebar_NightMode"];
        [self addSubview:_nightItem];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 重新布局
    // 不能放在初始化方法中，因为初始化完成后self.width才有值
    _blurView.frame = self.bounds;
    _settingItem.x =  50;
    _nightItem.right = self.width - 50;
}

// 创建底部设置和夜间模式按钮
- (ImageButton *)itemWithText:(NSString *)text imageNamed:(NSString *)imageNamed
{
    ImageButton *item = [ImageButton buttonWithType:UIButtonTypeCustom];
    item.userInteractionEnabled = YES;
    item.exclusiveTouch = YES;// 指示接收器是否以独占方式处理触摸事件
    item.titleLabel.font = [UIFont systemFontOfSize:13];
    [item setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    item.size = CGSizeMake(60, 90);
    item.bottom = ScreenHeight - 20 - IPhoneXSafeAreaHeight;
    item.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [item setImage:[UIImage imageNamed:imageNamed] forState:UIControlStateNormal];
    [item setTitle:text forState:UIControlStateNormal];
    // 上下布局
    [item imagePosition:ImageButtonPositionTop spacing:10 imageViewResize:CGSizeMake(30, 30)];
    return item;
}

// 创建中间的按钮组
- (void)setModels:(NSArray<NSString *> *)models
{
    _items = @[].mutableCopy;
    CGFloat _gap = 15;
    [models enumerateObjectsUsingBlock:^(NSString *text, NSUInteger idx, BOOL * _Nonnull stop) {
        
        ImageButton *item = [ImageButton buttonWithType:UIButtonTypeCustom];
        item.userInteractionEnabled = YES;
        item.exclusiveTouch = YES;
        item.titleLabel.font = [UIFont systemFontOfSize:15];
        item.imageView.contentMode = UIViewContentModeCenter;
        [item setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        item.imageView.contentMode = UIViewContentModeScaleAspectFit;
        NSString *imageNamed = [NSString stringWithFormat:@"sidebar_%@", text];
        [item setImage:[UIImage imageNamed:imageNamed] forState:UIControlStateNormal];
        [item setTitle:text forState:UIControlStateNormal];
        item.size = CGSizeMake(150, 50);
        item.y = (_gap + item.height) * idx + 150;
        item.centerX = self.width / 2;
        // 左右布局
        [item imagePosition:ImageButtonPositionLeft spacing:25 imageViewResize:CGSizeMake(25, 25)];
        [self addSubview:item];
        [_items addObject:item];
        item.tag = idx;
        [item addTarget:self action:@selector(itemClicked:) forControlEvents:UIControlEventTouchUpInside];
    }];
}

// 中间按钮的点击事件
- (void)itemClicked:(ImageButton *)sender
{
    if (self.didClickItems)
    {
        self.didClickItems(self, sender.tag);
    }
}

@end
