//
//  AutoScrollViewViewController.m
//  FunctionCodeBlockDemo
//
//  Created by 谢佳培 on 2020/10/9.
//

#import "AutoScrollViewViewController.h"
#import <Masonry/Masonry.h>

@interface AutoScrollView ()<UIScrollViewDelegate>

@property (nonatomic, strong, readwrite) UIScrollView *autoScrollView;// 滚动视图
@property (nonatomic, strong, readwrite) UIView *scrollBox;// 滚动的方框视图
@property (nonatomic, assign, readwrite) NSInteger index;// 当前第几页
@property (nonatomic, strong, readwrite) UIPageControl *pageView;// 页面

@end

@implementation AutoScrollView

#pragma mark - Life Circle

// 添加子视图
- (void)createSubViews
{
    // 创建滚动的方框视图
    self.scrollBox = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.scrollSize.width, self.scrollSize.height)];
    [self addSubview:self.scrollBox];
    
    // 创建滚动视图
    self.autoScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.scrollSize.width, self.scrollSize.height)];
    self.autoScrollView.pagingEnabled = YES;// 能翻页
    self.autoScrollView.scrollEnabled = YES;// 能滚动
    self.autoScrollView.showsHorizontalScrollIndicator = NO;// 不显示水平滚动条
    self.autoScrollView.showsVerticalScrollIndicator = NO;// 不显示垂直滚动条
    self.autoScrollView.minimumZoomScale = 0.5;// 缩放
    self.autoScrollView.maximumZoomScale = 2.0;// 放大
    self.autoScrollView.delegate = self;// 委托
    self.autoScrollView.backgroundColor = UIColor.whiteColor;// 白色
    self.autoScrollView.userInteractionEnabled = YES;// 可交互翻页
    
    // 添加到方框视图中
    [self.scrollBox addSubview:self.autoScrollView];
    
    // 滚动视图内容范围为3倍方框视图的宽度
    CGSize viewSize = self.scrollBox.bounds.size;
    self.autoScrollView.contentSize = CGSizeMake(3 * viewSize.width, viewSize.height);
    
    // 添加图片子视图
    for (int i = 0; i < self.scrollImage.count;i++)
    {
        // 创建图片视图
        UIImageView *imageView = [self addViewToScrollView:i * viewSize.width];
        // 添加图片
        imageView.image = self.scrollImage[(i-1) % self.scrollImage.count];
        // 填充模式
        imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    // 初始化时候的偏移量
    [self.autoScrollView setContentOffset:CGPointMake(viewSize.width, 0)];
    
    // 翻页视图
    self.pageView = [[UIPageControl alloc]initWithFrame:CGRectZero];
    self.pageView.numberOfPages = self.scrollImage.count;// 页数
    self.pageView.currentPageIndicatorTintColor = [UIColor greenColor];// 页指示器颜色为绿色
    self.pageView.userInteractionEnabled = NO;// 不可点击交互
    [self addSubview:self.pageView];
    [self.pageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.autoScrollView.mas_safeAreaLayoutGuideBottom).offset(-20);
        make.height.equalTo(@44);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
    }];
}
 
// 添加图片子视图到滚动视图中
- (UIImageView *)addViewToScrollView : (CGFloat)offsetX
{
    CGSize viewSize = self.scrollBox.bounds.size;
    UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(offsetX, 0, viewSize.width, viewSize.height)];
    [self.autoScrollView addSubview:view];
    return view;
}

#pragma mark - UIScrollViewDelegate

// 开始拖动的时候停止定时器
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.timer setFireDate:[NSDate distantFuture]];
}

// 滚动了重新计算索引位置
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self reloadIndex];
}

// 结束拖动的时候调用
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.pageView.currentPage = self.index;// 设置当前页面
    [self.timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:self.duration]];// 重新启动定时器
    
}

#pragma mark - Private Methods

// 判断变量状态，初始化数据
- (void)preAction
{
    // 尺寸
    if (self.scrollSize.width == 0 || self.scrollSize.height == 0)
    {
        self.scrollSize = CGSizeMake(300, 200);
    }
    
    // 从0开始
    self.index = 0;
}

// 定时滚动函数
- (void)changeNext
{
    // 设置2倍偏移量进行翻页
    [self.autoScrollView setContentOffset:CGPointMake(2 * CGRectGetWidth(self.autoScrollView.bounds), 0) animated:YES];
}

// 重新给图片视图赋值
- (void)recreate
{
    if (self.scrollImage && self.scrollImage.count > 0)
    {
        NSInteger totalCount = self.scrollImage.count;// 图片数量
        NSInteger leftIndex = (self.index + totalCount - 1) % totalCount;
        NSInteger rightIndex = (self.index +  1) % totalCount;
        
        NSArray <UIImageView *> *subviews = self.autoScrollView.subviews;
        subviews[0].image = self.scrollImage[leftIndex];// 上一张图
        subviews[1].image = self.scrollImage[self.index];// 当前图
        subviews[2].image = self.scrollImage[rightIndex];// 下一张图
    }

    // 每次滑动完，再滑动回中心
    [self scrollCenter];
}

// 每次滑动完，再滑动回中心
- (void)scrollCenter
{
    // 设置偏移量
    [self.autoScrollView setContentOffset:CGPointMake(self.scrollBox.bounds.size.width, 0)];
    // 当前页
    self.pageView.currentPage = self.index;
}

// 计算页数
- (void)reloadIndex
{
    if (self.scrollImage && self.scrollImage.count > 0)
    {
        CGFloat pointX = self.autoScrollView.contentOffset.x;
        
        // 此处的value用于边缘判断，当imageview距离两边间距小于1时，触发偏移
        CGFloat value = 0.2f;
        
        if (pointX > CGRectGetWidth(self.autoScrollView.bounds) * 2 - value)
        {
            self.index = (self.index + 1) % self.scrollImage.count;
        }
        else if (pointX < value)
        {
            self.index = (self.index + self.scrollImage.count - 1) % self.scrollImage.count;
        }
    }
}

#pragma mark - Setter/Getter

// 设置滚动视图大小
- (void)setScrollSize:(CGSize)scrollSize
{
    _scrollSize = scrollSize;
    
    // 判断变量状态，初始化数据
    [self preAction];
    // 创建视图
    [self createSubViews];
}

// 设置定时器
- (void)setDuration:(CGFloat)duration
{
    _duration = duration;
    
    if (duration > 0.0)
    {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:duration target:self selector:@selector(changeNext) userInfo:nil repeats:YES];
        [self.timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:duration]];
    }
}

// 设置位置
- (void)setIndex:(NSInteger)index
{
    _index = index;
    
    // 重新给图片视图赋值
    [self recreate];
}

@end

@implementation AutoScrollViewViewController

- (void)viewDidLoad
{
    [self createAutoScrollView];
}

// 创建轮播图
- (void)createAutoScrollView
{
    self.autoScrollView = [[AutoScrollView alloc] initWithFrame:CGRectZero];
    
    NSMutableArray *scrollImages = [[NSMutableArray alloc] init];
    UIImage *boy = [UIImage imageNamed:@"稚气.PNG"];
    UIImage *coffee = [UIImage imageNamed:@"咖啡.JPG"];
    UIImage *luckcoffee = [UIImage imageNamed:@"luckcoffee.JPG"];
    [scrollImages addObject:boy];
    [scrollImages addObject:coffee];
    [scrollImages addObject:luckcoffee];
    self.autoScrollView.scrollImage = [NSMutableArray arrayWithArray:[scrollImages copy]];
    
    self.autoScrollView.duration = 3;
    self.autoScrollView.backgroundColor = [UIColor redColor];
    self.autoScrollView.scrollSize = CGSizeMake(self.view.frame.size.width, 200);
    
    [self.view addSubview:self.autoScrollView];
    [self.autoScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.centerY.equalTo(self.view);
        make.height.equalTo(@200);
    }];
}

@end
