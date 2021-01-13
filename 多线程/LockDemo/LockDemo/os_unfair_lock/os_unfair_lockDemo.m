//
//  os_unfair_lockDemo.m
//  多线程Demo
//
//  Created by 谢佳培 on 2020/7/16.
//  Copyright © 2020 xiejiapei. All rights reserved.
//

#import "os_unfair_lockDemo.h"
#import <os/lock.h>

@interface os_unfair_lockDemo()

@property (nonatomic ,assign) os_unfair_lock moneyLock;

@end

@implementation os_unfair_lockDemo

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.moneyLock = OS_UNFAIR_LOCK_INIT;
    }
    return self;
}

// 存钱
- (void)saveMoney
{
    os_unfair_lock_lock(&_moneyLock);//加锁
    [super saveMoney];
    os_unfair_lock_unlock(&_moneyLock);//解锁
}

// 取钱
- (void)drawMoney
{
    os_unfair_lock_lock(&_moneyLock);//加锁
    [super drawMoney];
    os_unfair_lock_unlock(&_moneyLock);//解锁
}

@end
