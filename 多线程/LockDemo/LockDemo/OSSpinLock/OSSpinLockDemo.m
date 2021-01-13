//
//  OSSpinLockDemo.m
//  多线程Demo
//
//  Created by 谢佳培 on 2020/7/16.
//  Copyright © 2020 xiejiapei. All rights reserved.
//

#import "OSSpinLockDemo.h"
#import <libkern/OSAtomic.h>

@interface OSSpinLockDemo()

@property (assign, nonatomic) OSSpinLock moneyLock;// 自旋锁

@end

@implementation OSSpinLockDemo

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.moneyLock = OS_SPINLOCK_INIT;// 初始化
    }
    return self;
}

// 存钱
- (void)saveMoney
{
    OSSpinLockLock(&_moneyLock);//加锁
    [super saveMoney];
    OSSpinLockUnlock(&_moneyLock);//解锁
}

// 取钱
- (void)drawMoney
{
    OSSpinLockLock(&_moneyLock);//加锁
    [super drawMoney];
    OSSpinLockUnlock(&_moneyLock);//解锁
}

@end
