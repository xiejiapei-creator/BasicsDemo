//
//  MultithreadingViewController.m
//  PossibleInterviewQuestions
//
//  Created by 谢佳培 on 2021/2/22.
//

#import "MultithreadingViewController.h"

@interface MultithreadingViewController ()

@property (nonatomic, assign) NSInteger tickets;
@property (nonatomic, strong) dispatch_queue_t queue;

@end

@implementation MultithreadingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initTickes];
    //[self asyncAndAsyncExecutionSequence];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self startTwoThreadsSaleTickes];
}

// 异步开启多条子线程同时增加数值，未加锁会返回错误结果
- (void)addStudentNumber
{
    NSLock *lock = [NSLock new];
    
    __block int studentNumber = 0;
    while (studentNumber < 10)
    {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            studentNumber++;
            NSLog(@"学生数量：%d，当前线程为：%@",studentNumber,[NSThread currentThread]);
            
            [lock unlock];
        });
        
        [lock lock];
    }
    
    NSLog(@"主线程中学生最终的人数为：%d",studentNumber);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"子线程中学生最终的人数为：%d",studentNumber);
    });
}

// 执行顺序
- (void)asyncAndSyncExecutionSequence
{
    dispatch_queue_t queue = dispatch_queue_create("xie", DISPATCH_QUEUE_CONCURRENT);
    NSLog(@"1");
    
    // 异步
    dispatch_async(queue, ^{
        NSLog(@"2");
        
        // 同步
        dispatch_sync(queue, ^{
            NSLog(@"10");
        });

        NSLog(@"7");
        
    });
    NSLog(@"5");
}

- (void)asyncAndAsyncExecutionSequence
{
    dispatch_queue_t queue = dispatch_queue_create("cooci", DISPATCH_QUEUE_CONCURRENT);
    
    NSLog(@"1");
    
    // async会耗时
    dispatch_async(queue, ^{
        NSLog(@"2");
        
        dispatch_async(queue, ^{
            NSLog(@"3");
        });
        
        NSLog(@"4");
    });
    
    NSLog(@"5");
}

// 开启两个线程使用串行队列同步任务进行售票
- (void)initTickes
{
    // 准备票数
    _tickets = 20;
    // 创建串行队列
    _queue = dispatch_queue_create("xie", DISPATCH_QUEUE_SERIAL);
}

- (void)startTwoThreadsSaleTickes
{
    // 第一个线程卖票
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self saleTickes];
    });

    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 第二个线程卖票
        [self saleTickes];
    });
}

- (void)saleTickes
{
    while (self.tickets > 0)
    {
        // 模拟延时
        [NSThread sleepForTimeInterval:1.0];
        
        // 苹果不推荐使用互斥锁 @synchronized，这里使用串行队列同步任务可以达到同样的效果！
        // 使用串行队列，同步任务卖票
        dispatch_sync(_queue, ^{
            // 检查票数
            if (self.tickets > 0)
            {
                self.tickets--;
                NSLog(@"剩余票数：%zd，当前线程为：%@", self.tickets, [NSThread currentThread]);
            }
            else
            {
                NSLog(@"票已售罄");
            }
        });
    }
}

@end


