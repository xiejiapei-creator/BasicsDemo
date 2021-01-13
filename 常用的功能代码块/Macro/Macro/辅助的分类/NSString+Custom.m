//
//  NSString+Custom.m
//  Macro
//
//  Created by 谢佳培 on 2020/11/25.
//

#import "NSString+Custom.h"

@implementation NSString (Custom)

#pragma mark - RemoveNil

//nil  转换  ""
+ (NSString *)removeNil:(NSString *)str
{
    return [NSString removeNilToValue:str value:@""];
}

//nil  转换  value
+ (NSString *)removeNilToValue:(NSString *)str value:(NSString *)value
{
    if (str == nil)
    {
        return value;
    }
    return str;
}

//nil  转换  "-"
+ (NSString *)removeNilToConnect:(NSString *)str
{
    return [NSString removeNilToValue:str value:@"-"];
}

//int 转 str
+ (NSString *)intToStr:(NSInteger)num
{
    return [NSString stringWithFormat:@"%ld", num];
}

@end
