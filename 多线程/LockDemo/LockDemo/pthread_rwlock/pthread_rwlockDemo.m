//
//  pthread_rwlockDemo.m
//  多线程Demo
//
//  Created by 谢佳培 on 2020/7/16.
//  Copyright © 2020 xiejiapei. All rights reserved.
//

#import "pthread_rwlockDemo.h"
#import <pthread.h>

@interface pthread_rwlockDemo()

@property (assign, nonatomic) pthread_rwlock_t lock;

@end

@implementation pthread_rwlockDemo

- (instancetype)init
{
    self = [super init];
    if (self) {
        // 初始化锁
        pthread_rwlock_init(&_lock, NULL);
    }
    return self;
}

- (void)dealloc
{
    pthread_rwlock_destroy(&_lock);
}

// 多读
- (void)read {
    pthread_rwlock_rdlock(&_lock);
    
    sleep(1);
    NSLog(@"%s", __func__);
    
    pthread_rwlock_unlock(&_lock);
}

// 单写
- (void)write
{
    pthread_rwlock_wrlock(&_lock);
    
    sleep(1);
    NSLog(@"%s", __func__);
    
    pthread_rwlock_unlock(&_lock);
}

// 其他演示
- (void)otherTest{
    // 全局队列
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    
    // 并发执行写后读
    for (int i = 0; i < 3; i++) {
        dispatch_async(queue, ^{
            [self write];
            [self read];
        });
        
    }
    
    // 并发执行读
    for (int i = 0; i < 3; i++) {
        dispatch_async(queue, ^{
            [self write];
        });
    }
}

@end
