//
//  ResidentThreadBySourceViewController.m
//  RunLoop实际运用
//
//  Created by 谢佳培 on 2020/8/20.
//  Copyright © 2020 xiejiapei. All rights reserved.
//

#import "ResidentThreadBySourceViewController.h"

@interface ResidentThreadBySourceViewController ()

@end

@implementation ResidentThreadBySourceViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self threadForDispatch];
}


// 两个静态全局变量
// 自定义的子线程
static NSThread *thread = nil;
// 标记是否要继续事件循环
static BOOL runAlways = YES;

// 创建thread
- (NSThread *)threadForDispatch {
    if (thread == nil) {
        // 线程安全的方式创建thread
        @synchronized(self) {
            if (thread == nil) {
                // 线程的创建
                thread = [[NSThread alloc] initWithTarget:self selector:@selector(runRequest) object:nil];
                // 设置线程名称
                [thread setName:@"com.xiejiapei.thread"];
                // 启动该线程
                [thread start];
            }
        }
    }
    return thread;
}

- (void)runRequest
{
    NSLog(@"开始循环，当前线程为：%@", [NSThread currentThread]);
    
    // 创建一个Source
    CFRunLoopSourceContext context = {0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL};// 上下文参数
    CFRunLoopSourceRef source = CFRunLoopSourceCreate(kCFAllocatorDefault, 0, &context);
    
    // 通过CFRunLoopGetCurrent创建RunLoop，子线程默认没有RunLoop
    // 同时向RunLoop的DefaultMode下面添加Source
    CFRunLoopAddSource(CFRunLoopGetCurrent(), source, kCFRunLoopDefaultMode);
    
    // 如果可以运行
    while (runAlways) {
        // 通过@autoreleasepool保证每次循环完后都释放内存
        @autoreleasepool {
            // 令当前RunLoop运行在DefaultMode下面
            // 需要注意添加资源的Mode和运行的Mode必须相同
            // 1.0e10 指循环运行到指定时间后退出，这里是指数表达式相当大，可以理解为遥远的未来
            // true表示资源被处理后立刻返回
            CFRunLoopRunInMode(kCFRunLoopDefaultMode, 1.0e10, true);
        }
    }
    
    NSLog(@"结束循环");
    
    // 某一时机 静态变量 runAlways = NO时 可以保证跳出RunLoop，线程退出
    // 移除并释放source，防止内存泄露
    CFRunLoopRemoveSource(CFRunLoopGetCurrent(), source, kCFRunLoopDefaultMode);
    CFRelease(source);
}

- (void)test
{
    NSLog(@"测试，当前线程为：%@", [NSThread currentThread]);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self performSelector:@selector(test) onThread:thread withObject:nil waitUntilDone:NO];
}

@end
