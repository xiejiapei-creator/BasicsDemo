//
//  NSConditionLockDemo.m
//  多线程Demo
//
//  Created by 谢佳培 on 2020/7/16.
//  Copyright © 2020 xiejiapei. All rights reserved.
//

#import "NSConditionLockDemo.h"

@implementation NSConditionLockDemo

- (void)otherTest
{
    //主线程中：初始化lock
    NSConditionLock *lock = [[NSConditionLock alloc] initWithCondition:0];
    
    //线程1
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [lock lockWhenCondition:2];//当条件为2的时候，加锁
        NSLog(@"线程1加锁");
        
        sleep(2);
        
        NSLog(@"线程1解锁成功");
        [lock unlockWithCondition:3];//当条件为3的时候，解锁
    });
    
    //线程2
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [lock lockWhenCondition:0];
        NSLog(@"线程2加锁");
        
        sleep(3);
        
        NSLog(@"线程2解锁成功");
        [lock unlockWithCondition:1];
    });
    
    //线程3
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [lock lockWhenCondition:3];
        NSLog(@"线程3加锁");
        
        sleep(3);
        
        NSLog(@"线程3解锁成功");
        [lock unlockWithCondition:4];
    });
    
    //线程4
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [lock lockWhenCondition:1];
        NSLog(@"线程4加锁");
        
        sleep(2);
        
        NSLog(@"线程4解锁成功");
        [lock unlockWithCondition:2];
    });
    
}

@end
