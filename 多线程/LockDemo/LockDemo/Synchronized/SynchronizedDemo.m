//
//  SynchronizedDemo.m
//  多线程Demo
//
//  Created by 谢佳培 on 2020/7/16.
//  Copyright © 2020 xiejiapei. All rights reserved.
//

#import "SynchronizedDemo.h"

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

@end
