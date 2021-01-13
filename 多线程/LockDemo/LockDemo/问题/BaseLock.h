//
//  BaseLock.h
//  合并两个有序链表
//
//  Created by 谢佳培 on 2020/7/16.
//  Copyright © 2020 xiejiapei. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 子类重写方法
@interface BaseLock : NSObject

/// 存钱
- (void)saveMoney;

/// 取钱
- (void)drawMoney;

/// 存钱、取钱演示
- (void)moneyTest;

/// 其他演示
- (void)otherTest;

@end

NS_ASSUME_NONNULL_END
