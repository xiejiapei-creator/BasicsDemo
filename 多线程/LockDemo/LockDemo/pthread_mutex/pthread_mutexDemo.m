//
//  pthread_mutexDemo.m
//  多线程Demo
//
//  Created by 谢佳培 on 2020/7/16.
//  Copyright © 2020 xiejiapei. All rights reserved.
//

#import "pthread_mutexDemo.h"
#import <pthread.h>

@interface pthread_mutexDemo()

@property (assign, nonatomic) pthread_mutex_t moneyMutexLock;

@end

@implementation pthread_mutexDemo

#pragma mark - 解答本题

// 初始化锁
- (void)initMutexLock:(pthread_mutex_t *)mutex
{
    // 初始化属性
    pthread_mutexattr_t attr;
    pthread_mutexattr_init(&attr);
    pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_DEFAULT);
    // 初始化锁
    pthread_mutex_init(mutex, &attr);
    // 销毁属性
    pthread_mutexattr_destroy(&attr);
    
    // 上面五行相当于下面一行
    // 传空，相当于PTHREAD_MUTEX_DEFAULT
    // pthread_mutex_init(mutex, NULL);
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initMutexLock:&_moneyMutexLock];
    }
    return self;
}

- (void)dealloc
{
    // delloc时候，需要销毁锁
    pthread_mutex_destroy(&_moneyMutexLock);
}

// 存钱
- (void)saveMoney
{
    pthread_mutex_lock(&_moneyMutexLock);//加锁
    [super saveMoney];
    pthread_mutex_unlock(&_moneyMutexLock);//解锁
}

// 取钱
- (void)drawMoney
{
    pthread_mutex_lock(&_moneyMutexLock);//加锁
    [super drawMoney];
    pthread_mutex_unlock(&_moneyMutexLock);//解锁
}

#pragma mark - 买火车票问题

pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;
NSMutableArray *tickets;

- (void)onThread
{
    tickets = [NSMutableArray array];
    
    //生成100张票
    for (int i = 0; i < 100; i++)
    {
        [tickets addObject:[NSNumber numberWithInt:i]];
    }
    
    // 线程1 北京卖票窗口
    // 1. 创建线程1: 定义一个pthread_t类型变量
    pthread_t thread1;
    // 2. 开启线程1: 执行任务
    pthread_create(&thread1, NULL, run, NULL);
    // 3. 设置子线程1的状态设置为detached，该线程运行结束后会自动释放所有资源
    pthread_detach(thread1);
    
    // 线程2 上海卖票窗口
    // 1. 创建线程2: 定义一个pthread_t类型变量
    pthread_t thread2;
    // 2. 开启线程2: 执行任务
    pthread_create(&thread2, NULL, run, NULL);
    // 3. 设置子线程2的状态设置为detached，该线程运行结束后会自动释放所有资源
    pthread_detach(thread2);

}

void * run(void *param) {
    while (true) {
        //锁门，执行任务
        pthread_mutex_lock(&mutex);
        
        if (tickets.count > 0)
        {
            NSLog(@"剩余票数%ld, 卖票窗口%@", tickets.count, [NSThread currentThread]);
            [tickets removeLastObject];
            [NSThread sleepForTimeInterval:0.2];
        }
        else
        {
            NSLog(@"票已经卖完了");

            //开门，让其他任务可以执行
            pthread_mutex_unlock(&mutex);

            break;
        }
        
        //开门，让其他任务可以执行
        pthread_mutex_unlock(&mutex);
    }  
    return NULL;
}


@end



