//
//  CurtainView.m
//  UseUIControlFramework
//
//  Created by 谢佳培 on 2020/11/11.
//

#import "CurtainView.h"

// 每行显示4个Item
#define ROW_COUNT 4

#define ScreenWidth [[UIScreen mainScreen] bounds].size.width

@implementation CurtainView

#pragma mark - Life Circle

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor whiteColor];
        [self createCloseButton];
    }
    return self;
}

// 创建关闭按钮
- (void)createCloseButton
{
    _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _closeButton.size = CGSizeMake(35, 35);
    _closeButton.right = ScreenWidth - 15;
    _closeButton.y = 45 + UIApplication.sharedApplication.keyWindow.safeAreaInsets.top;
    [_closeButton addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_closeButton];
}

#pragma mark - Setter

// 设置Item的尺寸
- (void)setItemSize:(CGSize)itemSize
{
    _itemSize = itemSize;
}

// 设置图片按钮的Model数组
- (void)setModels:(NSArray<ImageButtonModel *> *)models
{
    // 防空的默认值处理
    if (CGSizeEqualToSize(CGSizeZero, _itemSize))
    {
        _itemSize = CGSizeMake(50, 70);
    }
    
    // Item之间的间隙
    CGFloat _gap = UIApplication.sharedApplication.keyWindow.safeAreaInsets.top + 30;
    CGFloat _space = (self.width - ROW_COUNT * _itemSize.width) / (ROW_COUNT + 1);
    
    // 创建ImageButton数组
    _items = [NSMutableArray arrayWithCapacity:models.count];
    [models enumerateObjectsUsingBlock:^(ImageButtonModel * _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
        // Item所处的行数和列数
        NSInteger l = idx % ROW_COUNT;
        NSInteger v = idx / ROW_COUNT;
        
        // 使用Model数据配置item
        ImageButton *item = [ImageButton buttonWithType:UIButtonTypeCustom];
        item.userInteractionEnabled = YES;
        item.titleLabel.font = [UIFont fontWithName:@"pingFangSC-light" size:14];
        [item setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [item setTitle:model.text forState:UIControlStateNormal];
        [item setImage:model.icon forState:UIControlStateNormal];
        item.tag = idx;
        [item addTarget:self action:@selector(itemClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        // item的布局属性
        [item imagePosition:ImageButtonPositionTop spacing:15 imageViewResize:CGSizeMake(32, 32)];
        item.size = CGSizeMake(_itemSize.width, _itemSize.height + 20);
        item.x = _space + (_itemSize.width  + _space) * l;
        item.y = _gap + (_itemSize.height + 40) * v + 45;
        
        // 添加到视图
        [self addSubview:item];
        [_items addObject:item];
    }];
}

#pragma mark - Event

// 触发点击关闭按钮的回调
- (void)close:(UIButton *)sender
{
    if (self.closeClicked)
    {
        self.closeClicked(sender);
    }
}

// 点击Item按钮的回调
- (void)itemClicked:(ImageButton *)button
{
    if (self.didClickItems)
    {
        self.didClickItems(self, button.tag);
    }
}

@end
