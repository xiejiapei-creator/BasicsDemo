//
//  ResidentThreadByPortViewController.m
//  RunLoop实际运用
//
//  Created by 谢佳培 on 2020/8/20.
//  Copyright © 2020 xiejiapei. All rights reserved.
//

#import "ResidentThreadByPortViewController.h"

@interface ResidentThreadByPortViewController ()

@property(nonatomic ,strong) dispatch_source_t timer;

@property(nonatomic ,strong) NSThread *thread;

@end

@implementation ResidentThreadByPortViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.thread = [[NSThread alloc] initWithTarget:self selector:@selector(run) object:nil];
    [self.thread start];
}

- (void)run
{
    NSLog(@"开始循环，当前线程为：%@", [NSThread currentThread]);
    @autoreleasepool{
    // 如果不加这句，会发现runloop创建出来就挂了，因为runloop如果没有CFRunLoopSourceRef事件源输入或者定时器，就会立马消亡。
    // 下面的方法给runloop添加一个NSport，就是添加一个事件源，也可以添加一个定时器，或者observer，让runloop不会挂掉
    [[NSRunLoop currentRunLoop] addPort:[NSPort port] forMode:NSDefaultRunLoopMode];
    
    // 方法1 ,2，3实现的效果相同，让runloop无限期运行下去
    [[NSRunLoop currentRunLoop] run];
   }

    
    // 方法2
    // [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    
    // 方法3
    // [[NSRunLoop currentRunLoop] runUntilDate:[NSDate distantFuture]];
    
    NSLog(@"结束循环");
}

- (void)test
{
    NSLog(@"测试，当前线程为：%@", [NSThread currentThread]);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self performSelector:@selector(test) onThread:self.thread withObject:nil waitUntilDone:NO];
}
@end
