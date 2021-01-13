//
//  TimerViewController.m
//  BasicGrammarDemo
//
//  Created by 谢佳培 on 2020/9/24.
//

#import "TimerViewController.h"
#import "DateViewController.h"

@interface TimerViewController ()

@end

@implementation TimerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createSubviews];
}

- (void)createSubviews
{
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(120, 100, 200, 100)];
    button.backgroundColor = [UIColor blackColor];
    [button setTitle:@"创建计时器" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(startFireDateTimer) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UIButton *nextPageButton = [[UIButton alloc] initWithFrame:CGRectMake(120, 300, 200, 100)];
    nextPageButton.backgroundColor = [UIColor blackColor];
    [nextPageButton setTitle:@"进入第二个页面" forState:UIControlStateNormal];
    [nextPageButton addTarget:self action:@selector(stepNextPage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextPageButton];
}

- (void)stepNextPage
{
    DateViewController *dateVC = [[DateViewController alloc] init];
    [self.navigationController pushViewController:dateVC animated:YES];
}

#pragma mark - 不重复的timer

// 在默认模式（NSDefaultRunLoopMode）下，用当前NSRunLoop对象自动注册新计时器
- (void)startTimer
{
    // 计时器在2秒后由运行循环自动触发，然后从运行循环中删除
    [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(targetMethod:) userInfo:self.userInfo repeats:NO];
}

- (void)targetMethod:(NSTimer *)theTimer
{
    NSDate *startDate = [[theTimer userInfo] objectForKey:@"StartDate"];
    NSLog(@"开始日期：%@",startDate);
}

- (NSDictionary *)userInfo
{
    return @{@"StartDate": [NSDate date]};
}

#pragma mark - 重复timer

- (void)startRepeatingTimer
{
    // 取消之前存在的timer
    [_repeatingTimer invalidate];
    
    // 创建新的timer
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(targetMethod:) userInfo:self.userInfo repeats:YES];
    _repeatingTimer = timer;
}

- (void)viewDidDisappear:(BOOL)animated
{
    //NSLog(@"退出了当前页面，销毁了定时器");
    //[self stopRepeatingTimer];
}

- (void)stopRepeatingTimer
{
    // 将计数器timer停止，否则可能会导致内存泄露
    [self.repeatingTimer invalidate];
    
    // 停止后，一定要将timer赋空，否则还是没有释放，会造成不必要的内存开销
    self.repeatingTimer = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"进入定时器页面，重新开启定时器");
    
    // 开启定时器
    [self.repeatingTimer setFireDate:[NSDate distantPast]];//很远的过去
}

// 在页面消失的时候关闭定时器，然后等页面再次打开的时候，又开启定时器
- (void)viewWillDisappear:(BOOL)animated
{
    // 关闭定时器
    [self.repeatingTimer setFireDate:[NSDate distantFuture]]; //很远的将来
    NSLog(@"退出了当前页面，只是关闭定时器未销毁，再次进入可重新启动");
}

#pragma mark - Invocation + RunLoop

// 使用invocation创建计时器
- (void)createUnregisteredTimer
{
    // 1、根据方法来初始化NSMethodSignature
    // 方法签名中保存了方法的名称/参数/返回值，协同NSInvocation来进行消息的转发
    NSMethodSignature *methodSignature = [self methodSignatureForSelector:@selector(invocationMethod:)];
    
    // 2、其实NSInvocation就是将一个方法变成一个对象
    // NSInvocation中保存了方法所属的对象/方法名称/参数/返回值
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
    
    // 设置方法调用者
    [invocation setTarget:self];
    
    // 设置方法名称，这里的方法名一定要与方法签名类中的方法一致
    [invocation setSelector:@selector(invocationMethod:)];
    
    NSDate *startDate = [NSDate date];
    // 设置方法参数，这里的Index要从2开始，因为0跟1已经被占据了，分别是self（target）,selector
    [invocation setArgument:&startDate atIndex:2];
    
    // 3、调用invoke方法
    [invocation invoke];
    
    // 使用invocation创建计时器
    NSTimer *timer = [NSTimer timerWithTimeInterval:0.5 invocation:invocation repeats:YES];
    self.unregisteredTimer = timer;
    [self addTimerToRunLoop];
}

- (void)invocationMethod:(NSDate *)date
{
    NSLog(@"调用日期为：%@", date);
}

// 将timer添加到run loop中
- (void)addTimerToRunLoop
{
    if (self.unregisteredTimer != nil)
    {
        NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
        [runLoop addTimer:self.unregisteredTimer forMode:NSDefaultRunLoopMode];
    }
}


#pragma mark - Fire Date + RunLoop

- (void)startFireDateTimer
{
    // 用日期初始化计时器
    NSDate *fireDate = [NSDate dateWithTimeIntervalSinceNow:1.0];
    
    // 尽管计时器被配置为重复，但在countedTimerFireMethod触发三次之后，它将停止
    NSTimer *timer = [[NSTimer alloc] initWithFireDate:fireDate interval:0.5 target:self selector:@selector(countedTimerFireMethod:) userInfo:self.userInfo repeats:YES];
   
    self.timerCount = 1;
    
    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
    [runLoop addTimer:timer forMode:NSDefaultRunLoopMode];
}

// 给计时器计算调用次数
- (void)countedTimerFireMethod:(NSTimer *)theTimer
{
    NSDate *startDate = [[theTimer userInfo] objectForKey:@"StartDate"];
    NSLog(@"开始日期： %@，调用次数： %lu", startDate, (unsigned long)self.timerCount);
    
    // 这将使计时器在触发三次后失效
    self.timerCount++;
    if (self.timerCount > 3)
    {
        [theTimer invalidate];
    }
}
 
@end
