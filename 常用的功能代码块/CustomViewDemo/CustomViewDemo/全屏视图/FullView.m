//
//  FullView.m
//  UseUIControlFramework
//
//  Created by 谢佳培 on 2020/11/12.
//

#import "FullView.h"

@interface FullView () <UIScrollViewDelegate>
{
    CGFloat _gap, _space;
}
@property (nonatomic, strong) UILabel  *dateLabel;// 日期
@property (nonatomic, strong) UILabel  *weekLabel;// 周
@property (nonatomic, strong) UIButton *closeButton;// 关闭按钮
@property (nonatomic, strong) UIButton *closeIcon;// ❌按钮
@property (nonatomic, strong) UIScrollView *scrollContainer;// 滚动容器
@property (nonatomic, strong) NSMutableArray<UIImageView *> *pageViews;// 页数

@end

@implementation FullView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        // 点击了屏幕
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fullViewClicked:)]];
        
        [self createSubviews];
        [self createSubviewConstraints];
    }
    return self;
}

// 创建子视图
- (void)createSubviews
{
    // 日期
    _dateLabel = [UILabel new];
    _dateLabel.font = [UIFont fontWithName:@"Heiti SC" size:42];
    _dateLabel.textColor = [UIColor colorWithRed:21/255.0 green:21/255.0 blue:21/255.0 alpha:1.0];
    _dateLabel.textColor = [UIColor blackColor];
    _dateLabel.text = [NSString stringWithFormat:@"%.2ld", (long)[NSDate date].day];
    [self addSubview:_dateLabel];
    
    // 周
    _weekLabel = [UILabel new];
    _weekLabel.numberOfLines = 0;
    _weekLabel.font = [UIFont fontWithName:@"Heiti SC" size:12];
    _weekLabel.textColor = [UIColor colorWithRed:56/255.0 green:56/255.0 blue:56/255.0 alpha:1.0];
    NSString *weekText = [NSString stringWithFormat:@"%@\n%@", [NSDate date].dayFromWeekday, [NSDate stringWithDate:[NSDate date] format:@"MM/yyyy"]];
    NSMutableAttributedString *weekAttributedString = [[NSMutableAttributedString alloc] initWithString:weekText];
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    [weekAttributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, weekText.length)];
    [paragraphStyle setLineSpacing:5];
    _weekLabel.attributedText = weekAttributedString;
    [self addSubview:_weekLabel];
    
    // 关闭按钮
    _closeButton = [UIButton new];
    _closeButton.backgroundColor = [UIColor whiteColor];
    _closeButton.userInteractionEnabled = NO;
    [_closeButton addTarget:self action:@selector(slideToInitialPosition:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_closeButton];
    
    // ❌按钮
    _closeIcon = [UIButton new];
    _closeIcon.userInteractionEnabled = NO;
    _closeIcon.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [_closeIcon setImage:[UIImage imageNamed:@"sina_关闭"] forState:UIControlStateNormal];
    [_closeButton addSubview:_closeIcon];
    
    // 滚动容器
    _scrollContainer = [UIScrollView new];
    _scrollContainer.bounces = NO;
    _scrollContainer.pagingEnabled = YES;
    _scrollContainer.showsHorizontalScrollIndicator = NO;
    _scrollContainer.delaysContentTouches = YES;// 用于确定滚动视图是否延迟对触地手势的处理
    _scrollContainer.delegate = self;
    [self addSubview:_scrollContainer];
    
    // 页数
    _pageViews = @[].mutableCopy;
    for (NSInteger i = 0; i < PAGES; i++)
    {
        UIImageView *pageView = [UIImageView new];
        pageView.size = _scrollContainer.size;
        pageView.x = i * ScreenWidth;
        pageView.userInteractionEnabled = YES;
        [_scrollContainer addSubview:pageView];
        [_pageViews addObject:pageView];
    }
}

// 创建布局约束
- (void)createSubviewConstraints
{
    // 日期
    _dateLabel.size = [_dateLabel sizeThatFits:CGSizeMake(40, 40)];
    _dateLabel.origin = CGPointMake(15, 65);
    
    // 周
    _weekLabel.size = [_weekLabel sizeThatFits:CGSizeMake(100, 40)];
    _weekLabel.x = _dateLabel.right + 10;
    _weekLabel.centerY = _dateLabel.centerY;
    
    // 关闭按钮
    _closeButton.size = CGSizeMake(ScreenWidth, 44 + SafeAreaInsetsBottom);
    _closeButton.bottom = ScreenHeight;
    
    // ❌按钮
    _closeIcon.size = CGSizeMake(30, 30);
    _closeIcon.centerX = _closeButton.bounds.size.width / 2;
    _closeIcon.y = 8;

    // 滚动容器
    _itemSize = CGSizeMake(60, 95);
    _gap = 15;
    _space = (ScreenWidth - ROW_COUNT * _itemSize.width) / (ROW_COUNT + 1);
    _scrollContainer.size = CGSizeMake(ScreenWidth, _itemSize.height * ROWS + _gap  + 150);
    _scrollContainer.bottom = _closeButton.y;
    _scrollContainer.contentSize = CGSizeMake(PAGES * ScreenWidth, _scrollContainer.height);
}

// 创建图片按钮数组
- (void)setModels:(NSArray<ImageButtonModel *> *)models
{
    _items = @[].mutableCopy;
    [_pageViews enumerateObjectsUsingBlock:^(UIImageView * _Nonnull imageView, NSUInteger idx, BOOL * _Nonnull stop) {
        for (NSInteger i = 0; i < ROWS * ROW_COUNT; i++)
        {
            NSInteger l = i % ROW_COUNT;
            NSInteger v = i / ROW_COUNT;
            
            ImageButton *item = [ImageButton buttonWithType:UIButtonTypeCustom];
            [imageView addSubview:item];
            [_items addObject:item];
            
            item.tag = i + idx * (ROWS *ROW_COUNT);
            if (item.tag < models.count)
            {
                ImageButtonModel *model = [models objectAtIndex:item.tag];
                item.userInteractionEnabled = YES;
                item.titleLabel.font = [UIFont systemFontOfSize:14];
                [item setTitleColor:[UIColor colorWithRed:82/255.0 green:82/255.0 blue:82/255.0 alpha:1.0] forState:UIControlStateNormal];
                [item setTitle:model.text forState:UIControlStateNormal];
                [item setImage:model.icon forState:UIControlStateNormal];
                // 不知道为什么按钮点击无效
                [item addTarget:self action:@selector(itemClicked:) forControlEvents:UIControlEventTouchUpInside];
                
                [item imagePosition:ImageButtonPositionTop spacing:10 imageViewResize:CGSizeMake(45, 45)];
                item.size = _itemSize;
                item.x = _space + (_itemSize.width  + _space) * l;
                item.y = (_itemSize.height + _gap) * v + _gap + 100;
            }
        }
    }];
}

#pragma mark - Events

// 触发点击全屏视图的回调
- (void)fullViewClicked:(UITapGestureRecognizer *)recognizer
{
    __weak typeof(self) _self = self;
    [self endAnimationsWithCompletion:^(FullView *fullView) {
        if (self.didClickFullView)
        {
            _self.didClickFullView((FullView *)recognizer.view);
        }
    }];
}

// 触发点击图片按钮的回调
- (void)itemClicked:(UIButton *)sender
{
    if (ROWS * ROW_COUNT - 1 == sender.tag)// 更多按钮
    {
        // 滚动到下一页
        [_scrollContainer setContentOffset:CGPointMake(ScreenWidth, 0) animated:YES];
    }
    else
    {
        if (self.didClickItems)
        {
            self.didClickItems(self, sender.tag);
        }
    }
}

// 滑动到初始位置
- (void)slideToInitialPosition:(UIButton *)sender
{
    [_scrollContainer setContentOffset:CGPointMake(0, 0) animated:YES];
}

#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 首页是关闭，其余页是返回
    // index = 1时是返回按钮，此时有效，当index = 0时是关闭按钮，此时无效，点击不触发
    NSInteger index = scrollView.contentOffset.x /ScreenWidth + 0.5;
    _closeButton.userInteractionEnabled = index > 0;
    [_closeIcon setImage:[UIImage imageNamed:(index ? @"sina_返回" : @"sina_关闭")] forState:UIControlStateNormal];
}

#pragma mark - 滚动的动画

// 开始动画
- (void)startAnimationsWithCompletion:(void (^)(BOOL finished))completion
{
    // 关闭按钮的旋转动画
    [UIView animateWithDuration:0.5 animations:^{
        self.closeIcon.transform = CGAffineTransformMakeRotation(M_PI_4);
    } completion:NULL];
    
    [_items enumerateObjectsUsingBlock:^(ImageButton *item, NSUInteger idx, BOOL * _Nonnull stop) {
        
        // 首页的item数量
        NSUInteger firstPageCount = ROW_COUNT * ROWS;
        // 只需首页的item做动画即可
        if (idx < firstPageCount)
        {
            // 透明度动画
            item.alpha = 0;
            item.transform = CGAffineTransformMakeTranslation(0, ROWS * _itemSize.height);
            [UIView animateWithDuration:0.55
                                  delay:idx * 0.035 //依次延迟呈现
                 usingSpringWithDamping:0.6 //弹簧动画的阻尼系数
                  initialSpringVelocity:0 //速度
                                options:UIViewAnimationOptionCurveLinear //线性动画
                             animations:^{
                                 item.alpha = 1;
                                 item.transform = CGAffineTransformIdentity;
                             } completion:completion];
        }
    }];
}

// 结束动画
- (void)endAnimationsWithCompletion:(void (^)(FullView *))completion
{
    // 当前页数
    NSInteger flag = _scrollContainer.contentOffset.x /ScreenWidth + 0.5;
    
    // 关闭按钮的旋转动画
    if (!_closeButton.userInteractionEnabled)
    {
        [UIView animateWithDuration:0.35 animations:^{
            self.closeIcon.transform = CGAffineTransformIdentity;
        } completion:NULL];
    }
    
    [_items enumerateObjectsUsingBlock:^(ImageButton * _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
        NSInteger pageCount = ROW_COUNT * ROWS;// 每页最大的item数量
        NSInteger startIdx = (pageCount * flag);// 开始位置
        NSInteger endIdx = startIdx + pageCount;// 结束位置
        
        // 开始和结束位置之间的Item可以动画
        BOOL shouldAnimated = NO;
        if (idx >= startIdx && idx < endIdx)
        {
            shouldAnimated = YES;
        }
    
        if (shouldAnimated)
        {
            // 逆序依次消失
            [UIView animateWithDuration:0.25 delay:0.02f * (_items.count - idx) options:UIViewAnimationOptionCurveEaseInOut animations:^{
                // 横向不移动，纵向下移消失
                item.transform = CGAffineTransformMakeTranslation(0, ROWS * self.itemSize.height + 50);
            } completion:^(BOOL finished) {
                if (finished)
                {
                    if (idx == endIdx - 1)
                    {
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            completion(self);
                        });
                    }
                }
            }];
        }
    }];
}

@end
