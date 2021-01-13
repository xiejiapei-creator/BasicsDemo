//
//  NSConditionDemo.m
//  多线程Demo
//
//  Created by 谢佳培 on 2020/7/16.
//  Copyright © 2020 xiejiapei. All rights reserved.
//

#import "NSConditionDemo.h"

@interface NSConditionDemo()

@property (strong, nonatomic) NSCondition *condition; //条件
@property (strong, nonatomic) NSMutableArray *data; //数据源

@end

@implementation NSConditionDemo

- (instancetype)init
{
    self = [super init];
    if (self) {
        // 初始化条件
        self.condition = [[NSCondition alloc] init];
        // 初始化数据源
        self.data = [NSMutableArray array];
    }
    return self;
}

#pragma mark - 生产者-消费者模式

- (void)otherTest
{
    // 开启两个线程分别执行生产者-消费者方法
    [[[NSThread alloc] initWithTarget:self selector:@selector(remove) object:nil] start];
    [[[NSThread alloc] initWithTarget:self selector:@selector(add) object:nil] start];
}

// 线程1：删除数组中的元素
- (void)remove
{
    [self.condition lock];// 加锁
    
    if (self.data.count == 0) {
        // 数据为空就等待（进入休眠，放开mutex锁，被唤醒后，会再次对mutex加锁）
        NSLog(@"remove方法：数据为空就等待（进入休眠，放开mutex锁，被唤醒后，会再次对mutex加锁）");
        [self.condition wait];
    }
    
    // 删除元素
    [self.data removeLastObject];
    NSLog(@"删除了元素");
    
    [self.condition unlock];// 解锁
}

// 线程2：往数组中添加元素
- (void)add
{
    [self.condition lock];// 加锁
    sleep(1);
    
    // 添加元素
    [self.data addObject:@"xiejiapei"];
    NSLog(@"添加了元素");
    
    // 激活一个等待该条件的线程
    [self.condition signal];
    
    // 激活所有等待该条件的线程
    // [self.condition broadcast];
    
    [self.condition unlock];// 解锁
}

@end
