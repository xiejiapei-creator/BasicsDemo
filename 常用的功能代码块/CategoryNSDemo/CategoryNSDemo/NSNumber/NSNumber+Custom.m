//
//  NSNumber+Custom.m
//  CategoryNSDemo
//
//  Created by 谢佳培 on 2020/11/25.
//

#import "NSNumber+Custom.h"

@implementation NSNumber (Custom)

// 金额浮点数高精度减法运算，默认两位小数处理
- (double)minusDecimalNumber:(NSNumber *)subtrahendNum
{
    NSDecimalNumber *minuend = [self decimalNumber:self];
    NSDecimalNumber *subtrahend = [self decimalNumber:subtrahendNum];
    NSDecimalNumberHandler *handler = [[NSDecimalNumberHandler alloc] initWithRoundingMode:(NSRoundPlain) scale:2 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:YES];
    NSDecimalNumber *res = [minuend decimalNumberBySubtracting:subtrahend withBehavior:handler];
    return res.doubleValue;
}

// 金额浮点数高精度比较，默认两位小数处理
- (NSComparisonResult)compareDecimalNumber:(NSNumber *)num
{
    NSDecimalNumber *first = [self decimalNumber:self];
    NSDecimalNumber *last = [self decimalNumber:num];
    return [first compare:last];
}

- (NSDecimalNumber *)decimalNumber:(NSNumber *)num
{
    NSDecimalNumber *decimalNumber = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%.2f",num.doubleValue]];
    return decimalNumber;
}

@end
