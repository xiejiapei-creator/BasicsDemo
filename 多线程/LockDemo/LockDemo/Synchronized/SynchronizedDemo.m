//
//  SynchronizedDemo.m
//  多线程Demo
//
//  Created by 谢佳培 on 2020/7/16.
//  Copyright © 2020 xiejiapei. All rights reserved.
//

#import "SynchronizedDemo.h"
#import <UIKit/UIKit.h>

@implementation SynchronizedDemo

// 存钱
- (void)saveMoney
{
    @synchronized (self) {
        [super saveMoney];
    }
}

// 取钱
- (void)drawMoney
{
    @synchronized (self) {
        [super drawMoney];
    }
}

// 多线程下可变数组添加新元素导致线程不安全的解决办法
- (void)synchronizedImage
{
    dispatch_queue_t concurrentQueue = dispatch_queue_create("jiapei", DISPATCH_QUEUE_CONCURRENT);

    for (int i = 0; i<5000; i++)
    {
        dispatch_async(concurrentQueue, ^{
            NSString *imageName = [NSString stringWithFormat:@"%d.jpg", (i % 10)];
            NSURL *url = [[NSBundle mainBundle] URLForResource:imageName withExtension:nil];
            NSData *data = [NSData dataWithContentsOfURL:url];
            UIImage *image = [UIImage imageWithData:data];
            
            @synchronized (self)
            {
                [self.mutableArray addObject:image];
            }
        });
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"数组的个数:%zd",self.mutableArray.count);
}

- (NSMutableArray *)mutableArray
{
    if (!_mutableArray)
    {
        _mutableArray = [NSMutableArray arrayWithCapacity:10];
    }
    return _mutableArray;
}

@end
