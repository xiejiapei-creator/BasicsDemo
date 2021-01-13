//
//  GCDViewController.m
//  MultiThreadDemo
//
//  Created by 谢佳培 on 2020/8/18.
//  Copyright © 2020 xiejiapei. All rights reserved.
//

#import "GCDViewController.h"

@interface GCDViewController ()

@property(nonatomic, strong) UIImageView *imageView;
@property(nonatomic ,strong) dispatch_source_t timer;

@end

@implementation GCDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self testGCDTimer];
}

// 串行同步
- (void)syncSerial
{
    
    NSLog(@"\n\n**************串行同步***************\n\n");
    
    // 串行队列
    dispatch_queue_t queue = dispatch_queue_create("syncSerial", DISPATCH_QUEUE_SERIAL);
    
    // 同步执行
    dispatch_sync(queue, ^{
        for (int i = 0; i < 3; i++)
        {
            NSLog(@"串行同步1   %@",[NSThread currentThread]);
        }
    });
    
    dispatch_sync(queue, ^{
        for (int i = 0; i < 3; i++)
        {
            NSLog(@"串行同步2   %@",[NSThread currentThread]);
        }
    });
    
    dispatch_sync(queue, ^{
        for (int i = 0; i < 3; i++)
        {
            NSLog(@"串行同步3   %@",[NSThread currentThread]);
        }
    });
}

// 串行异步
- (void)asyncSerial
{
    
    NSLog(@"\n\n**************串行异步***************\n\n");
    
    // 串行队列
    dispatch_queue_t queue = dispatch_queue_create("asyncSerial", DISPATCH_QUEUE_SERIAL);
    
    // 同步执行
    dispatch_async(queue, ^{
        for (int i = 0; i < 3; i++)
        {
            NSLog(@"串行异步1   %@",[NSThread currentThread]);
        }
    });
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 3; i++)
        {
            NSLog(@"串行异步2   %@",[NSThread currentThread]);
        }
    });
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 3; i++)
        {
            NSLog(@"串行异步3   %@",[NSThread currentThread]);
        }
    });
}

// 并发同步
- (void)syncConcurrent
{
    NSLog(@"\n\n**************并发同步***************\n\n");
    
    // 并发队列
    dispatch_queue_t queue = dispatch_queue_create("syncConcurrent", DISPATCH_QUEUE_CONCURRENT);
    
    // 同步执行
    dispatch_sync(queue, ^{
        for (int i = 0; i < 3; i++)
        {
            NSLog(@"并发同步1   %@",[NSThread currentThread]);
        }
    });
    
    dispatch_sync(queue, ^{
        for (int i = 0; i < 3; i++)
        {
            NSLog(@"并发同步2   %@",[NSThread currentThread]);
        }
    });
    
    dispatch_sync(queue, ^{
        for (int i = 0; i < 3; i++)
        {
            NSLog(@"并发同步3   %@",[NSThread currentThread]);
        }
    });
}

// 并发异步
- (void)asyncConcurrent
{
    NSLog(@"\n\n**************并发异步***************\n\n");
    
    // 并发队列
    dispatch_queue_t queue = dispatch_queue_create("asyncConcurrent", DISPATCH_QUEUE_CONCURRENT);
    
    // 同步执行
    dispatch_async(queue, ^{
        for (int i = 0; i < 3; i++)
        {
            NSLog(@"并发异步1   %@",[NSThread currentThread]);
        }
    });
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 3; i++)
        {
            NSLog(@"并发异步2   %@",[NSThread currentThread]);
        }
    });
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 3; i++)
        {
            NSLog(@"并发异步3   %@",[NSThread currentThread]);
        }
    });
}

// 主队列同步
- (void)syncMain
{
    // 主队列
    dispatch_queue_t queue = dispatch_get_main_queue();
    
    // 同步执行
    dispatch_sync(queue, ^{
        for (int i = 0; i < 3; i++)
        {
            NSLog(@"主队列同步1   %@",[NSThread currentThread]);
        }
    });
    
    dispatch_sync(queue, ^{
        for (int i = 0; i < 3; i++)
        {
            NSLog(@"主队列同步2   %@",[NSThread currentThread]);
        }
    });
    
    dispatch_sync(queue, ^{
        for (int i = 0; i < 3; i++)
        {
            NSLog(@"主队列同步3   %@",[NSThread currentThread]);
        }
    });
}

// 主队列异步
- (void)asyncMain {
    
    NSLog(@"\n\n**************主队列异步***************\n\n");
    
    // 主队列
    dispatch_queue_t queue = dispatch_get_main_queue();
    
    // 异步执行
    dispatch_async(queue, ^{
        for (int i = 0; i < 3; i++)
        {
            NSLog(@"主队列异步1   %@",[NSThread currentThread]);
        }
    });

    dispatch_async(queue, ^{
        for (int i = 0; i < 3; i++)
        {
            NSLog(@"主队列异步2   %@",[NSThread currentThread]);
        }
    });
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 3; i++)
        {
            NSLog(@"主队列异步3   %@",[NSThread currentThread]);
        }
    });
}

// 线程间通讯
- (void)communicationOfThread
{
    // 获取全局并发队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    // 获取主队列
    dispatch_queue_t mainQueue = dispatch_get_main_queue();

    dispatch_async(queue, ^{
        // 异步追加任务
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作

            // 打印当前线程
            NSLog(@"queue-currentThread---%@",[NSThread currentThread]);
        }

        NSString *picURLStr = @"http://www.bangmangxuan.net/uploads/allimg/160320/74-160320130500.jpg";
        NSURL *picURL = [NSURL URLWithString:picURLStr];
        NSData *picData = [NSData dataWithContentsOfURL:picURL];
        UIImage *image = [UIImage imageWithData:picData];

        // 回到主线程
        dispatch_async(mainQueue, ^{
            // 追加在主线程中执行的任务
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作

            // 打印当前线程
            NSLog(@"mainQueue-currentThread---%@",[NSThread currentThread]);

            // 在主线程上添加图片
            self.imageView.image = image;
        });
    });
}

// GCD栅栏
- (void)GCDBarrier
{
    // 并发队列
    dispatch_queue_t queue = dispatch_queue_create("barrier", DISPATCH_QUEUE_CONCURRENT);
    
    // 异步执行
    dispatch_async(queue, ^{
        for (int i = 0; i < 3; i++)
        {
            NSLog(@"栅栏：并发异步1   %@",[NSThread currentThread]);
        }
    });
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 3; i++)
        {
            NSLog(@"栅栏：并发异步2   %@",[NSThread currentThread]);
        }
    });
    
    dispatch_barrier_async(queue, ^{
        NSLog(@"------------barrier------------%@", [NSThread currentThread]);
        NSLog(@"******* 并发异步执行，但是34一定在12后面 *********");
    });
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 3; i++)
        {
            NSLog(@"栅栏：并发异步3   %@",[NSThread currentThread]);
        }
    });
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 3; i++)
        {
            NSLog(@"栅栏：并发异步4   %@",[NSThread currentThread]);
        }
    });
}

// 快速迭代方法
- (void)applyGCD
{
    NSLog(@"\n\n************** GCD快速迭代 ***************\n\n");
    
    // 并发队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    // 同时遍历多个数字
    // 指定重复次数，追加对象的Dispatch Queue，Block中index参数的作用是为了按执行的顺序区分各个Block
    dispatch_apply(6, queue, ^(size_t index) {
        // 迭代任务
        NSLog(@"GCD快速迭代 index %zd，currentThread：%@",index, [NSThread currentThread]);
    });
    
    NSLog(@"等到全部的处理执行结束");
}

// 队列组
- (void)groupNotify
{
    NSLog(@"group---begin");
    
    dispatch_group_t group =  dispatch_group_create();
    
    // 纳入队列组的监听范围
    dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
        NSLog(@"队列组：有一个耗时操作任务1完成！%@ ",[NSThread currentThread]);
    });
    
    dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
        NSLog(@"队列组：有一个耗时操作任务2完成！%@ ",[NSThread currentThread]);
    });
    
    dispatch_group_enter(group);

    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    dispatch_async(queue, ^{
        NSLog(@"队列组：有一个耗时操作任务3完成！%@ ",[NSThread currentThread]);
        
        dispatch_group_leave(group);
    });
    
    dispatch_group_enter(group);
    dispatch_async(queue, ^{
        NSLog(@"队列组：有一个耗时操作任务4完成！%@ ",[NSThread currentThread]);
        
        dispatch_group_leave(group);
    });
    
    dispatch_async(queue, ^{
        NSLog(@"队列组：有一个耗时操作任务5完成！%@ ",[NSThread currentThread]);
    });
    
    dispatch_async(queue, ^{
        NSLog(@"队列组：有一个耗时操作任务6完成！%@ ",[NSThread currentThread]);
    });
    
    // 所有的任务会并发的执行(不按序)
    for (int i = 0; i < 10 ; i++) {
        dispatch_group_async(group, queue, ^{
            NSLog(@"执行一次任务 %@ ",[NSThread currentThread]);
        });
    }
    
    // 等待上面的任务全部完成后，会往下继续执行（会阻塞当前线程）
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    NSLog(@"group---end");
    
    // 监听上面的任务是否完成，如果完成, 就会调用这个方法
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"队列组：前面的耗时操作都完成了，回到主线程更新UI");
    });
    
}

// 控制线程数量
- (void)runMaxThreadCountWithGCD
{
    dispatch_queue_t concurrentQueue = dispatch_queue_create("concurrentRunMaxThreadCountWithGCD", DISPATCH_QUEUE_CONCURRENT);
    dispatch_queue_t serialQueue = dispatch_queue_create("serialRunMaxThreadCountWithGCD", DISPATCH_QUEUE_SERIAL);
    
    // 创建一个semaphore,并设置最大信号量，最大信号量表示最大线程数量
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(2);
    
    // 使用循环 往串行队列 serialQueue 增加 10 个任务
    for (int i = 0; i < 10 ; i++)
    {
        dispatch_async(serialQueue, ^{
            // 只有当信号量大于 0 的时候，线程将信号量减 1，程序继续执行
            // 否则线程会阻塞并且一直等待，直到信号量大于 0
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
            
            dispatch_async(concurrentQueue, ^{
                NSLog(@"%@ 并发队列执行任务一次  i = %d",[NSThread currentThread],i);
                // 当线程任务执行完成之后，发送一个信号，增加信号量
                dispatch_semaphore_signal(semaphore);
            });
        });
    }

    NSLog(@"%@ 执行任务结束",[NSThread currentThread]);
}

// 任务分组 + 线程数量控制
- (void)runMaxCountInGroupWithGCD
{
    dispatch_queue_t concurrentQueue = dispatch_queue_create("runGroupWithGCD", DISPATCH_QUEUE_CONCURRENT);
    dispatch_group_t group =  dispatch_group_create();
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(2);
    
    for (int i = 0; i < 10 ; i++)
    {
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        
        dispatch_group_async(group, concurrentQueue, ^{
            NSLog(@"%@ 执行任务一次",[NSThread currentThread]);
            dispatch_semaphore_signal(semaphore);
        });
    }
     
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"%@ 执行任务结束",[NSThread currentThread]);
    });
}

- (void)testGCDTimer
{
    //0.创建一个队列
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);

    //1.创建一个GCD的定时器
    /*
     第一个参数：说明这是一个定时器
     第四个参数：GCD的回调任务添加到那个队列中执行，如果是主队列则在主线程执行
     */
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);

    //2.设置定时器的开始时间，间隔时间以及精准度

    //设置开始时间，三秒钟之后调用。DISPATCH_TIME_NOW表示从当前开始
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW,3.0 *NSEC_PER_SEC);
    //设置定时器工作的间隔时间
    uint64_t intevel = 1.0 * NSEC_PER_SEC;

    /*
     第一个参数：要给哪个定时器设置
     第二个参数：定时器的开始时间
     第三个参数：定时器调用方法的间隔时间
     第四个参数：定时器的精准度，如果传0则表示采用最精准的方式计算，如果传大于0的数值，则表示该定时切换i可以接收该值范围内的误差，通常传0
     该参数的意义：可以适当的提高程序的性能
     注意点：GCD定时器中的时间以纳秒为单位（面试）
     */
    dispatch_source_set_timer(timer, start, intevel, 0 * NSEC_PER_SEC);

    //3.设置定时器开启后回调的方法
    /*
     第一个参数：要给哪个定时器设置
     第二个参数：回调block
     */
    dispatch_source_set_event_handler(timer, ^{
        NSLog(@"定时器开启后每次回调的方法：打印当前线程------%@",[NSThread currentThread]);
    });

    //4.执行定时器
    dispatch_resume(timer);

    //注意：dispatch_source_t本质上是OC类，在这里是个局部变量，需要强引用
    self.timer = timer;
}

@end
