//
//  NSString+Custom.h
//  Macro
//
//  Created by 谢佳培 on 2020/11/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Custom)

#pragma mark - RemoveNil

//nil  转换  ""
+ (NSString *)removeNil:(NSString *)str;

//nil  转换  value
+ (NSString *)removeNilToValue:(NSString *)str value:(NSString *)value;

//nil  转换  "-"
+ (NSString *)removeNilToConnect:(NSString *)str;

//int 转 str
+ (NSString *)intToStr:(NSInteger)num;

@end

NS_ASSUME_NONNULL_END
