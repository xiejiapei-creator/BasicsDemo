//
//  ScrollViewController.m
//  UIKitGrammarDemo
//
//  Created by 谢佳培 on 2020/10/30.
//

#import "ScrollViewController.h"
#import <Masonry/Masonry.h>

@interface ScrollViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;// 滚动视图
@property (nonatomic, strong) UIPageControl *pageControl;// 翻页控件

@end

@implementation ScrollViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self createScrollView];
}

// 创建滚动视图
- (void)createScrollView
{
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    self.scrollView.delegate = self;
    
    self.scrollView.pagingEnabled = YES;// 是否支持翻页
    self.scrollView.showsHorizontalScrollIndicator = YES;// 展示水平滚动条
    self.scrollView.showsVerticalScrollIndicator = NO;// 展示垂直滚动条
    self.scrollView.minimumZoomScale = 0.5;// 最小化
    self.scrollView.maximumZoomScale = 2.0;// 最大化
    self.scrollView.scrollsToTop = YES;// 要不要返回顶部
    self.scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;// 滚动条颜色
    CGSize viewSize = self.view.bounds.size;
    self.scrollView.contentSize = CGSizeMake(viewSize.width*3, viewSize.height);// 内容为屏幕3倍用于横向滑动
    
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
    }];
    
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectZero];
    
    self.pageControl.numberOfPages = 3;// 3页
    self.pageControl.pageIndicatorTintColor = [UIColor colorWithWhite:1 alpha:0.5];// 小点的颜色
    self.pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];// 当前点的颜色
    
    [self.view addSubview:self.pageControl];
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-20);
        make.height.equalTo(@44);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
    }];
    
    // 创建红、蓝、绿三个页面
    UIView *redView = [self createScrollViewSubViewWithOffset:0];
    redView.backgroundColor = [UIColor redColor];
    
    UIView *blueView = [self createScrollViewSubViewWithOffset:viewSize.width];
    blueView.backgroundColor = [UIColor blueColor];
    
    UIView *greenView = [self createScrollViewSubViewWithOffset:viewSize.width*2];
    greenView.backgroundColor = [UIColor greenColor];
}

- (UIView *)createScrollViewSubViewWithOffset:(CGFloat)offsetX
{
    CGSize viewSize = self.view.bounds.size;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(offsetX, 0, viewSize.width, viewSize.height)];
    [self.scrollView addSubview:view];
    return view;
}

// UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView// 滚动了
{
    NSLog(@"偏移量：%@", @(scrollView.contentOffset.x));
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView// 结束滚动
{
    CGFloat offsetX = scrollView.contentOffset.x;
    NSLog(@"结束滚动时候在X轴的偏移量：%@", @(offsetX));
    
    // 计算当前页数
    NSInteger index = offsetX / scrollView.frame.size.width;
    self.pageControl.currentPage = index;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView// 需要缩放的视图
{
    CGFloat offsetX = scrollView.contentOffset.x;
    NSInteger index = offsetX / scrollView.frame.size.width;
    return scrollView.subviews[index];
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView// 缩放比例
{
    NSLog(@"缩放了 %@", @(scrollView.zoomScale));
}

@end
