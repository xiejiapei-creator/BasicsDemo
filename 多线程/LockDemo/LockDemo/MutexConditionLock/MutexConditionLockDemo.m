//
//  MutexConditionLockDemo.m
//  多线程Demo
//
//  Created by 谢佳培 on 2020/7/16.
//  Copyright © 2020 xiejiapei. All rights reserved.
//

#import "MutexConditionLockDemo.h"
#import <pthread.h>

@interface MutexConditionLockDemo()

@property (assign, nonatomic) pthread_mutex_t mutex; // 锁
@property (assign, nonatomic) pthread_cond_t cond; //条件
@property (strong, nonatomic) NSMutableArray *data; //数据源

@end

@implementation MutexConditionLockDemo

- (instancetype)init
{
    self = [super init];
    if (self) {
        // 初始化属性
        pthread_mutexattr_t attr;
        pthread_mutexattr_init(&attr);
        pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE);
        // 初始化锁
        pthread_mutex_init(&_mutex, &attr);
        // 销毁属性
        pthread_mutexattr_destroy(&attr);
        
        // 初始化条件
        pthread_cond_init(&_cond, NULL);
        // 初始化数据源
        self.data = [NSMutableArray array];
    }
    return self;
}

- (void)dealloc
{
    // 销毁锁和条件
    pthread_mutex_destroy(&_mutex);
    pthread_cond_destroy(&_cond);
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
    pthread_mutex_lock(&_mutex);// 加锁
    
    if (self.data.count == 0) {
        // 数据为空就等待（进入休眠，放开mutex锁，被唤醒后，会再次对mutex加锁）
        NSLog(@"remove方法：数据为空就等待（进入休眠，放开mutex锁，被唤醒后，会再次对mutex加锁）");
        pthread_cond_wait(&_cond, &_mutex);
    }
    
    // 删除元素
    [self.data removeLastObject];
    NSLog(@"删除了元素");
    
    pthread_mutex_unlock(&_mutex);// 解锁
}

// 线程2：往数组中添加元素
- (void)add
{
    pthread_mutex_lock(&_mutex);// 加锁
    sleep(1);
    
    // 添加元素
    [self.data addObject:@"xiejiapei"];
    NSLog(@"添加了元素");
    
    // 激活一个等待该条件的线程
    pthread_cond_signal(&_cond);
    
    // 激活所有等待该条件的线程
    // pthread_cond_broadcast(&_cond);
    
    pthread_mutex_unlock(&_mutex);// 解锁
}

@end
