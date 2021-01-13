//
//  ThreadCommunicationBySourceViewController.m
//  RunLoop实际运用
//
//  Created by 谢佳培 on 2020/8/20.
//  Copyright © 2020 xiejiapei. All rights reserved.
//

#import "ThreadCommunicationBySourceViewController.h"

@interface ThreadCommunicationBySourceViewController ()

@end

@implementation ThreadCommunicationBySourceViewController
{
    CFRunLoopRef runLoopRef;
    CFRunLoopSourceRef source;
    CFRunLoopSourceContext source_context;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self source0];
}

- (void)source0
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{

        NSLog(@"开始 thread.......");
        
        runLoopRef = CFRunLoopGetCurrent();
        
        //初始化_source_context。
        bzero(&source_context, sizeof(source_context));
        
        //这里创建了一个基于事件的源，绑定了一个函数
        source_context.perform = fire;
        
        //参数
        source_context.info = "hello friend";
        
        //创建一个source
        source = CFRunLoopSourceCreate(NULL, 0, &source_context);
        
        //将source添加到当前RunLoop中去
        CFRunLoopAddSource(runLoopRef, source, kCFRunLoopDefaultMode);
        
        //开启runloop 第三个参数设置为YES，执行完一次事件后返回
        CFRunLoopRunInMode(kCFRunLoopDefaultMode, 9999999, YES);
        
        NSLog(@"结束 thread.......");
    });
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if (CFRunLoopIsWaiting(runLoopRef))
        {
            NSLog(@"RunLoop 正在等待事件输入");
            
            //添加输入事件
            CFRunLoopSourceSignal(source);
            
            //唤醒线程，线程唤醒后发现由事件需要处理，于是立即处理事件
            CFRunLoopWakeUp(runLoopRef);
        }
        else
        {
            NSLog(@"RunLoop 正在处理事件");
            
            //添加输入事件，当前正在处理一个事件，当前事件处理完成后，立即处理当前新输入的事件
            CFRunLoopSourceSignal(source);
        }
    });
    
}

static void fire(void* info)
{
    
    NSLog(@"我现在正在处理后台任务");
    
    NSLog(@"信息是：%s",info);
}

@end
