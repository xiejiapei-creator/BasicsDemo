//
//  ThreadCommunicationByPortViewController.m
//  RunLoop实际运用
//
//  Created by 谢佳培 on 2020/8/20.
//  Copyright © 2020 xiejiapei. All rights reserved.
//

#import "ThreadCommunicationByPortViewController.h"

@interface ThreadCommunicationByPortViewController ()<NSMachPortDelegate>

@end

@implementation ThreadCommunicationByPortViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self source1];
}

- (void)source1
{
    //声明两个端口
    NSPort *mainPort = [NSMachPort port];
    NSPort *threadPort = [NSMachPort port];
    //设置线程的端口的代理回调为自己
    threadPort.delegate = self;
    
    //给主线程runloop加一个端口
    [[NSRunLoop currentRunLoop] addPort:mainPort forMode:NSDefaultRunLoopMode];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        //给子线程添加一个Port，并让子线程中的runloop跑起来
        [[NSRunLoop currentRunLoop] addPort:threadPort forMode:NSDefaultRunLoopMode];
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        
    });
    
    //2秒后，从主线程向子线程发送一条消息
    NSString *str = @"hello friend";
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        NSMutableArray *array = [NSMutableArray arrayWithArray:@[mainPort,data]];
        
        //过2秒向threadPort发送一条消息，
        //第一个参数：发送时间。msgid 消息标识。components，发送消息附带参数。reserved：为头部预留的字节数
        [threadPort sendBeforeDate:[NSDate date] msgid:1000 components:array from:mainPort reserved:0];
        
    });
}

//这个NSMachPort收到消息的回调，注意这个参数，如果用文档里的NSPortMessage会发现无法取值，可以先给一个id
- (void)handlePortMessage:(id)message
{
    NSLog(@"收到消息了，线程为：%@",[NSThread currentThread]);
    NSArray *array = [message valueForKeyPath:@"components"];
    NSData *data =  array[1];
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"收到的消息是：%@",str);
}

@end
