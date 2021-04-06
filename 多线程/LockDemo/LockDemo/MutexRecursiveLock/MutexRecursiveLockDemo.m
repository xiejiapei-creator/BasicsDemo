//
//  MutexRecursiveLockDemo.m
//  多线程Demo
//
//  Created by 谢佳培 on 2020/7/16.
//  Copyright © 2020 xiejiapei. All rights reserved.
//

#import "MutexRecursiveLockDemo.h"
#import <pthread.h>

@interface MutexRecursiveLockDemo()

@property (assign, nonatomic) pthread_mutex_t MutexLock;

@end

@implementation MutexRecursiveLockDemo

// 初始化锁
- (void)initMutexLock:(pthread_mutex_t *)mutex
{
    // 初始化属性
    pthread_mutexattr_t attr;
    pthread_mutexattr_init(&attr);
    pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE);
    // 初始化锁
    pthread_mutex_init(mutex, &attr);
    // 销毁属性
    pthread_mutexattr_destroy(&attr);
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initMutexLock:&_MutexLock];
    }
    return self;
}

- (void)dealloc
{
    // delloc时候，需要销毁锁
    pthread_mutex_destroy(&_MutexLock);
}

// 其他演示
- (void)otherTest
{
    // 第一次进来直接加锁，第二次进来已经加锁了，还能递归继续加锁
    pthread_mutex_lock(&_MutexLock);
    NSLog(@"加锁 %s",__func__);
    
    static int count = 0;
    if (count < 5)
    {
        count++;
        NSLog(@"count:%d", count);
        [self otherTest];
    }
    
    NSLog(@"解锁 %s",__func__);
    pthread_mutex_unlock(&_MutexLock);
}

@end

