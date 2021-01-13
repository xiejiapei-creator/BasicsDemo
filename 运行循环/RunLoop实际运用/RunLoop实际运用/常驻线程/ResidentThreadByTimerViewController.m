//
//  ResidentThreadByTimerViewController.m
//  RunLoop实际运用
//
//  Created by 谢佳培 on 2020/8/20.
//  Copyright © 2020 xiejiapei. All rights reserved.
//

#import "ResidentThreadByTimerViewController.h"

@interface ResidentThreadByTimerViewController ()

@end

@implementation ResidentThreadByTimerViewController
{
    int count;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    count = 0;
    [self run];
}

- (void)run
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSLog(@"开启线程…….");
        
        NSTimer *timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(doTimerTask:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
        
        //若runloop一直存在，后面的代码就不执行了
        //最后一个参数，是否处理完事件返回，结束runLoop
        SInt32 result = CFRunLoopRunInMode(kCFRunLoopDefaultMode, 100, YES);
        
        /*
         kCFRunLoopRunFinished = 1, //Run Loop结束，没有Timer或者其他Input Source
         kCFRunLoopRunStopped = 2, //Run Loop被停止，使用CFRunLoopStop停止Run Loop
         kCFRunLoopRunTimedOut = 3, //Run Loop超时
         kCFRunLoopRunHandledSource = 4 //Run Loop处理完事件，注意Timer事件的触发是不会让Run Loop退出返回的，即使CFRunLoopRunInMode的第三个参数是YES也不行
         */
        switch (result)
        {
            case kCFRunLoopRunFinished:
                NSLog(@"kCFRunLoopRunFinished");
                
                break;
            case kCFRunLoopRunStopped:
                NSLog(@"kCFRunLoopRunStopped");
                
            case kCFRunLoopRunTimedOut:
                NSLog(@"kCFRunLoopRunTimedOut");
                
            case kCFRunLoopRunHandledSource:
                NSLog(@"kCFRunLoopRunHandledSource");
            default:
                break;
        }
        
        NSLog(@"结束线程……");
    });
    
}

- (void)doTimerTask:(NSTimer *)timer
{
    count++;
    if (count == 2)
    {
        //停止timer，runloop没有source，没有timer，没有observer，退出runloop，线程随之往下执行，完成后也退出
        [timer invalidate];
    }
    NSLog(@"do timer task count:%d",count);
}

@end
