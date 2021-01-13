//
//  KVOUseViewController.m
//  KVO_KVC_Demo
//
//  Created by 谢佳培 on 2020/9/24.
//

#import "KVOUseViewController.h"

@implementation ScrollViewRecorder

// 添加观察者
- (void)beginRecordScrollViewOffset
{
    [self.scrollView addObserver:self forKeyPath:@"contentOffset" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];
}

// 移除观察者
- (void)dealloc
{
    [self.scrollView removeObserver:self forKeyPath:@"contentOffset"];
}

// 观察到的数据
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentOffset"])
    {
        NSNumber *changeKind = change[NSKeyValueChangeKindKey];
        NSValue *oldValue = change[NSKeyValueChangeOldKey];
        NSValue *newValue = change[NSKeyValueChangeNewKey];
        CGPoint oldOffset = oldValue.CGPointValue;
        CGPoint newOffset = newValue.CGPointValue;
        NSLog(@"ChangeKind：%@，旧的Y坐标值：%f，新的Y坐标值：%f", changeKind,oldOffset.y,newOffset.y);
    }
}

@end

@interface KVOUseViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) ScrollViewRecorder *scrollViewRecorder;

@end

@implementation KVOUseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createSubViews];
}

- (void)createSubViews
{
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 100, 400, 400)];
    self.scrollView.backgroundColor = [UIColor redColor];
    self.scrollView.delegate = self;
    self.scrollView.contentSize = CGSizeMake(400, 800);
    [self.view addSubview:self.scrollView];
    
    self.scrollViewRecorder = [[ScrollViewRecorder alloc] init];
    self.scrollViewRecorder.scrollView = self.scrollView;
    // 开始观察记录
    [self.scrollViewRecorder beginRecordScrollViewOffset];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"y轴坐标值：%f", scrollView.contentOffset.y);
}

@end
