//
//  dispatch_barrier_asyncDemo.m
//  多线程Demo
//
//  Created by 谢佳培 on 2020/7/17.
//  Copyright © 2020 xiejiapei. All rights reserved.
//

#import "dispatch_barrier_asyncDemo.h"

@interface dispatch_barrier_asyncDemo ()

@property (strong, nonatomic) dispatch_queue_t queue;

@end

@implementation dispatch_barrier_asyncDemo

// 读
- (void)read {
    sleep(1);
    NSLog(@"read");
}

// 写
- (void)write
{
    sleep(1);
    NSLog(@"write");
}

// 其他测试
- (void)otherTest{
    
    // 初始化队列
    self.queue = dispatch_queue_create("rw_queue", DISPATCH_QUEUE_CONCURRENT);
    
    for (int i = 0; i < 3; i++) {
        // 读
        dispatch_async(self.queue, ^{
            [self read];
        });
        
        // 写
        dispatch_barrier_async(self.queue, ^{
            [self write];
        });
        
         // 读
        dispatch_async(self.queue, ^{
            [self read];
        });
        
         // 读
        dispatch_async(self.queue, ^{
            [self read];
        });
        
    }
}

@end
