//
//  SemaphoreDemo.m
//  多线程Demo
//
//  Created by 谢佳培 on 2020/7/16.
//  Copyright © 2020 xiejiapei. All rights reserved.
//

#import "SemaphoreDemo.h"

@interface SemaphoreDemo()

@property (strong, nonatomic) dispatch_semaphore_t semaphore;
@property (strong, nonatomic) dispatch_semaphore_t moneySemaphore;

@end

@implementation SemaphoreDemo

- (instancetype)init
{
    self = [super init];
    if (self) {
        // 创建信号量，设置每次最多三条线程执行
        self.semaphore = dispatch_semaphore_create(3);
        // 创建信号量
        self.moneySemaphore = dispatch_semaphore_create(1);
    }
    return self;
}

// 存钱
- (void)saveMoney
{
    dispatch_semaphore_wait(self.moneySemaphore, DISPATCH_TIME_FOREVER);// 等待信号量
    
    [super saveMoney];
    
    dispatch_semaphore_signal(self.moneySemaphore);// 发送信号量
}

// 取钱
- (void)drawMoney
{
    dispatch_semaphore_wait(self.moneySemaphore, DISPATCH_TIME_FOREVER);// 等待信号量
    
    [super drawMoney];
    
    dispatch_semaphore_signal(self.moneySemaphore);// 发送信号量
}

// 其他演示
- (void)otherTest
{
    for (int i = 0; i < 10; i++)
    {
        [[[NSThread alloc] initWithTarget:self selector:@selector(test) object:nil] start];
    }
}

// 线程10、7、6、9、8
- (void)test
{
    // 如果信号量的值 > 0，就让信号量的值减1，然后继续往下执行代码
    // 如果信号量的值 <= 0，就会休眠等待，直到信号量的值变成>0，就让信号量的值减1，然后继续往下执行代码
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    
    sleep(2);
    NSLog(@"test方法 - %@", [NSThread currentThread]);
    
    // 让信号量的值+1
    dispatch_semaphore_signal(self.semaphore);
}

@end



