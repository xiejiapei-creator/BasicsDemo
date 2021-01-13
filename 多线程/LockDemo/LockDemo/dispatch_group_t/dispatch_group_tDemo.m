//
//  dispatch_group_tDemo.m
//  多线程Demo
//
//  Created by 谢佳培 on 2020/7/17.
//  Copyright © 2020 xiejiapei. All rights reserved.
//

#import "dispatch_group_tDemo.h"

@implementation dispatch_group_tDemo

// 下载任务1
- (void)downLoadImage1 {
    sleep(1);
    NSLog(@"下载任务1  %s--%@",__func__,[NSThread currentThread]);
}

// 下载任务2
- (void)downLoadImage2 {
     sleep(2);
    NSLog(@"下载任务2  %s--%@",__func__,[NSThread currentThread]);
}

// 刷新UI
- (void)reloadUI
{
    NSLog(@"刷新UI  %s--%@",__func__,[NSThread currentThread]);
}

// 其他演示
- (void)otherTest{
    
    //1.创建调度组
    dispatch_group_t group = dispatch_group_create();
    //2.队列
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    
    //3.调度组监听队列 标记开始本次执行
    dispatch_group_enter(group);
    dispatch_async(queue, ^{
       [self downLoadImage1];
       //标记本次请求完成
       dispatch_group_leave(group);
    });
    

    //3.调度组监听队列 标记开始本次执行
    dispatch_group_enter(group);
    dispatch_async(queue, ^{
        [self downLoadImage2];
        //标记本次请求完成
        dispatch_group_leave(group);
    });
    
    //4,调度组都完成了
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        //执行完test1和test2之后，在进行请求test3
         [self reloadUI];
    });
}

@end
