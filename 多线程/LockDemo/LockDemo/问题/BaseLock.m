//
//  BaseLock.m
//  合并两个有序链表
//
//  Created by 谢佳培 on 2020/7/16.
//  Copyright © 2020 xiejiapei. All rights reserved.
//

#import "BaseLock.h"

@interface BaseLock()

@property (assign, nonatomic) int money;

@end

@implementation BaseLock

// 存钱
- (void)saveMoney
{
    // 每次存钱都存10元
    int oldMoney = self.money;
    sleep(.2);
    oldMoney += 10;
    self.money = oldMoney;
    
    NSLog(@"存10元，还剩%d元 - %@", oldMoney, [NSThread currentThread]);
}

// 取钱
- (void)drawMoney
{
    // 每次取钱都取20元
    int oldMoney = self.money;
    sleep(.2);
    oldMoney -= 20;
    self.money = oldMoney;
    
    NSLog(@"取20元，还剩%d元 - %@", oldMoney, [NSThread currentThread]);
}

// 存钱、取钱演示
- (void)moneyTest
{
    // 最初账号里面有100元
    self.money = 100;
    
    // 全局队列
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    
    // 异步执行全局队列中的任务：存钱，存5次
    dispatch_async(queue, ^{
        for (int i = 0; i < 5; i++)
        {
            [self saveMoney];
        }
    });
    
    // 异步执行全局队列中的任务：取钱，取5次
    dispatch_async(queue, ^{
        for (int i = 0; i < 5; i++)
        {
            [self drawMoney];
        }
    });
}

// 其他演示
- (void)otherTest {}

@end
