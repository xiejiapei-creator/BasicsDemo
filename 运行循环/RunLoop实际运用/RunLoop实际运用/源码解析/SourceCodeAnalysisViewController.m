//
//  SourceCodeAnalysisViewController.m
//  RunLoop实际运用
//
//  Created by 谢佳培 on 2021/2/23.
//  Copyright © 2021 xiejiapei. All rights reserved.
//

#import "SourceCodeAnalysisViewController.h"

@interface SourceCodeAnalysisViewController ()

@end

@implementation SourceCodeAnalysisViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //[self modeDemo];
    //[self CFTimerDemo];
    //[self CFObseverDemo];
    [self source0Demo];
}

#pragma mark - Mode

// Mode类型
- (void)modeDemo
{
    CFRunLoopRef runloop = CFRunLoopGetCurrent();
    CFRunLoopMode mode  = CFRunLoopCopyCurrentMode(runloop);
    NSLog(@"当前模式为：%@",mode);
    
    CFArrayRef modeArray = CFRunLoopCopyAllModes(runloop);
    NSLog(@"所有模式包括：%@",modeArray);
}

#pragma mark - 添加Timer

- (void)CFTimerDemo
{
    CFRunLoopTimerContext context =
    {
        0,
        ((__bridge void *)self),
        NULL,
        NULL,
        NULL
    };
    CFRunLoopRef runloop = CFRunLoopGetCurrent();
    CFRunLoopTimerRef timerRef = CFRunLoopTimerCreate(kCFAllocatorDefault, 0, 1, 0, 0, runLoopTimerCallBack, &context);
    CFRunLoopAddTimer(runloop, timerRef, kCFRunLoopDefaultMode);
}

void runLoopTimerCallBack(CFRunLoopTimerRef timer, void *info)
{
    NSLog(@"计时器：%@，携带的信息：%@",timer,info);
}

#pragma mark - 添加Observe

- (void)CFObseverDemo
{
    CFRunLoopObserverContext context =
    {
        0,
        ((__bridge void *)self),
        NULL,
        NULL,
        NULL
    };
    
    CFRunLoopRef runloop = CFRunLoopGetCurrent();
    CFRunLoopObserverRef observerRef = CFRunLoopObserverCreate(kCFAllocatorDefault, kCFRunLoopAllActivities, YES, 0, runLoopObserverCallBack, &context);
    CFRunLoopAddObserver(runloop, observerRef, kCFRunLoopDefaultMode);
}

void runLoopObserverCallBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info)
{
    NSLog(@"关注的事件：%lu，携带的信息：%@",activity,info);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hello boy" object:@"xiejiapei"];
}

#pragma mark - 添加 source0

- (void)source0Demo
{
    CFRunLoopSourceContext context =
    {
        0,
        NULL,
        NULL,
        NULL,
        NULL,
        NULL,
        NULL,
        schedule,
        cancel,
        perform,
    };
    
    CFRunLoopSourceRef source0 = CFRunLoopSourceCreate(CFAllocatorGetDefault(), 0, &context);
    CFRunLoopRef runloop = CFRunLoopGetCurrent();
    // 进入待绪状态
    CFRunLoopAddSource(runloop, source0, kCFRunLoopDefaultMode);
    // 一个执行信号
    CFRunLoopSourceSignal(source0);
    // 唤醒 runloop 防止进入沉睡状态
    CFRunLoopWakeUp(runloop);
    // 移除 source0。注释掉后会执行perform，否则执行cancel
    CFRunLoopRemoveSource(runloop, source0, kCFRunLoopDefaultMode);
    CFRelease(runloop);
}

void schedule(void *info, CFRunLoopRef rl, CFRunLoopMode mode)
{
    NSLog(@"准备");
}

void perform(void *info)
{
    NSLog(@"执行");
}

void cancel(void *info, CFRunLoopRef rl, CFRunLoopMode mode)
{
    NSLog(@"取消");
}

#pragma mark - <#note#>

@end
