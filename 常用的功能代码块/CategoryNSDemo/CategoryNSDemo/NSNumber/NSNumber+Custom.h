//
//  NSNumber+Custom.h
//  CategoryNSDemo
//
//  Created by 谢佳培 on 2020/11/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSNumber (Custom)

/// 金额浮点数高精度减法运算，默认两位小数处理
- (double)minusDecimalNumber:(NSNumber *)subtrahend;

/// 金额浮点数高精度比较，默认两位小数处理
- (NSComparisonResult)compareDecimalNumber:(NSNumber *)num;

@end

NS_ASSUME_NONNULL_END
