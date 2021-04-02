//
//  StrongRetainViewController.m
//  内存管理
//
//  Created by 谢佳培 on 2021/3/3.
//

#import "StrongRetainViewController.h"
#import "NSObject+Custom.h"
#import "TimerWapper.h"
#import "Proxy.h"

static int num = 0;

@interface StrongRetainViewController ()

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) id target;
@property (nonatomic, strong) TimerWapper *timerWapper;
@property (nonatomic, strong) Proxy *proxy;

@end

@implementation StrongRetainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self testProxy];
}

// 这里没有循环引用，但是就是释放不了，这是强引用的缘故
- (void)strongRetainNoRelease
{
    // timer加到了runloop中，所以runloop-持有-timer-持有-target(self)
    // 那么只要runloop不退出，那么target(self)就不会退出，这样就导致当前vc无法释放掉
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(fireHome) userInfo:nil repeats:YES];
}

// 使用Block的方式避免循环引用
// self-持有->timer-持有->block
// runloop-持有->timer
- (void)testTimerBlock
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer *timer) {
        NSLog(@"唱一首北京欢迎你");
    }];
}

#pragma mark - 系统方法

/*
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.timer invalidate];
    self.timer = nil;
    
    NSLog(@"页面即将消失");
}
*/

/*
- (void)didMoveToParentViewController:(UIViewController *)parent
{
    if (parent == nil)
    {
        [self.timer invalidate];
        self.timer = nil;
        
        NSLog(@"当父页面不存在的时候才移除定时器");
    }
}
*/

#pragma mark - 中间类

// 中间变量为NSObject
- (void)temporaryVariable
{
    // timer-持有-target（临时变量）-持有-vc（控制器)
    self.target = [[NSObject alloc] init];// 引入的第三者临时变量
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self.target selector:@selector(fireHome) userInfo:nil repeats:YES];
}

// Timer工具类
- (void)testTimerWapper
{
    // self-持有->timerWapper-持有->timer
    // runloop-持有->timer-持有-timerWapper
    // 所以timerWapper由于循环引用无法释放掉，但是self控制器可以被释放掉，相当于使用timerWapper作了self的替死鬼
    // 想要释放掉timerWapper，只需要将timer销毁掉即可
    // 在self控制器的dealloc方法中调用timerWapper的timerWapperInvalidate方法即可让timer被销毁
    self.timerWapper = [[TimerWapper alloc] timerWapperInitWithTimeInterval:1 target:self selector:@selector(fireHome) userInfo:nil repeats:YES];
}

#pragma mark - 代理

- (void)testProxy
{
    // 用proxy移交消息转发
    // self-持有->proxy-持有->self
    self.proxy = [Proxy proxyWithTransformObject:self];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self.proxy selector:@selector(fireHome) userInfo:nil repeats:YES];
}

#pragma mark - 辅助

- (void)fireHome
{
    num++;
    NSLog(@"你好，大叔：%d",num);
}

- (void)dealloc
{
    [self.timer invalidate];
    self.timer = nil;
    //[self.timerWapper timerWapperInvalidate];
    NSLog(@"销毁了控制器");
}

@end
