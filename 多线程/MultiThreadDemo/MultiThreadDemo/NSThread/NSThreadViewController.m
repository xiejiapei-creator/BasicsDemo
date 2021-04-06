//
//  NSThreadViewController.m
//  MultiThreadDemo
//
//  Created by 谢佳培 on 2020/8/18.
//  Copyright © 2020 xiejiapei. All rights reserved.
//

#import "NSThreadViewController.h"
#include <pthread.h>

@implementation NSThreadViewController

#pragma mark - NSThread创建线程

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"NSThread";

    /** 方法一，需要start */
    NSThread *threadOne = [[NSThread alloc] initWithTarget:self selector:@selector(doSomething:) object:@"需要start"];
    // 线程加入线程池等待CPU调度，时间很快，几乎是立刻执行
    [threadOne start];
    
    /** 方法二，创建好之后自动启动 */
    [NSThread detachNewThreadSelector:@selector(doSomething:) toTarget:self withObject:@"创建好之后自动启动"];
    
    /** 方法三，隐式创建，直接启动 */
    [self performSelectorInBackground:@selector(doSomething:) withObject:@"隐式创建，直接启动"];
}

- (void)doSomething:(NSObject *)object
{
    // 传递过来的参数
    NSLog(@"参数：%@， 线程：%@",object,[NSThread currentThread]);
}

#pragma mark - NSThread取消和结束线程

- (void)onCancelThread
{
    // 使用NSObject的方法隐式创建并自动启动
    [self performSelectorInBackground:@selector(testCancel) withObject:nil];
}

- (void)testCancel
{
    NSLog(@"当前线程%@", [NSThread currentThread]);
    
    for (int i = 0 ; i < 100; i++)
    {
        if (i == 20)
        {
            //取消线程
            [[NSThread currentThread] cancel];
            NSLog(@"取消线程%@", [NSThread currentThread]);
        }
        
        if ([[NSThread currentThread] isCancelled])
        {
            NSLog(@"结束线程%@", [NSThread currentThread]);
            //结束线程
            // [NSThread exit];
            NSLog(@"这行代码不会打印的");
        }
        
    }
}

#pragma mark - pthread_t的用法

- (void)onPthread_tThread {
    // 1. 创建线程: 定义一个pthread_t类型变量
    pthread_t thread;

    // 2. 开启线程: 执行任务
    //第一个参数：线程对象地址
    //第二个参数：线程属性
    //第三个参数：指向函数的执行
    //第四个参数：传递给该函数的参数
    NSString *name = @"xiejiapei";
    pthread_create(&thread, NULL, run, (__bridge void *)(name));
    
    // 3. 设置子线程的状态设置为detached，该线程运行结束后会自动释放所有资源
    pthread_detach(thread);
}

void * run(void *param) {
    NSLog(@"线程为：%@，参数为：%@", [NSThread currentThread], param);

    return NULL;
}


@end



