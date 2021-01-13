//
//  NSDate+Custom.h
//  CategoryNSDemo
//
//  Created by 谢佳培 on 2020/11/3.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (Custom)

#pragma mark - 获取当前的时间

@property (nonatomic, assign, readonly) NSInteger year;
@property (nonatomic, assign, readonly) NSInteger month;
@property (nonatomic, assign, readonly) NSInteger day;
@property (nonatomic, assign, readonly) NSInteger hour;
@property (nonatomic, assign, readonly) NSInteger minute;
@property (nonatomic, assign, readonly) NSInteger second;
@property (nonatomic, assign, readonly) NSInteger weekday;

/// 获取当前的"年月日时分"
+ (NSArray<NSString *> *)getCurrentTimeComponents;


#pragma mark - 获取星期几

/*
 [1 - Sunday]
 [2 - Monday]
 [3 - Tuerday]
 [4 - Wednesday]
 [5 - Thursday]
 [6 - Friday]
 [7 - Saturday]
 */
- (NSString *)dayFromWeekday; // 星期几的形式
- (NSString *)dayFromWeekday2; // 周几的形式
- (NSString *)dayFromWeekday3; // 英文的形式

#pragma mark - 获取天数

/// 获取某个月的天数
+ (NSInteger)getSumOfDaysMonth:(NSInteger)month inYear:(NSInteger)year;

#pragma mark - 时间戳

/// 获取当前时间戳字符串
+ (NSString *)currentTimeInterval;

/// 获取当前系统时间的时间戳 [北京时间]
+ (NSInteger)getNowTimestampWithFormatter:(NSString *)format;

/// 将date转换成时间戳 (NSDate => Timestamp)
+ (NSInteger)timestampFromDate:(NSDate *)date;

/// 将时间戳转换成date (Timestamp => NSDate)
+ (NSDate *)dateFromTimestamp:(NSInteger)timestamp;

/// 将时间字符串转换成时间戳 (TimeString => Timestamp) [北京时间]
+ (NSInteger)timestampFromTimeString:(NSString *)timeString formatter:(NSString *)format;

/// 将时间戳转换成时间字符串 (Timestamp => TimeString) [北京时间]
+ (NSString *)timeStringFromTimestamp:(NSInteger)timestamp formatter:(NSString *)format;

#pragma mark - 时间字符串

/// 将date转换成时间字符串 (NSDate => TimeString)
+ (NSString *)stringWithDate:(NSDate *)date format:(NSString *)format;

/// 将时间字符串转换成date (TimeString ==> NSDate)
+ (NSDate *)dateWithString:(NSString *)dateString format:(NSString *)format;

#pragma mark - 日期比较大小

/**比较两个date的大小关系  
 * NSOrderedAscending     => (dateString1 < dateString2)
 * NSOrderedDescending    => (dateString1 > dateString2)
 * NSOrderedSame          => (dateString1 = dateString2)
 */
+ (NSComparisonResult)compareDateString1:(NSString *)dateString1
                             dateString2:(NSString *)dateString2
                               formatter:(NSString *)format;

/// 是否小于当前时间(过去时间)
- (BOOL)isInPast;
/// 是否大于当前时间(未来时间)
- (BOOL)isInFuture;
/// 是否是今天
- (BOOL)isToday;
/// 是否是同一天
- (BOOL)isSameDay:(NSDate *)anotherDate;

#pragma mark - 日期的计算

/// 获取未来的日期时间
+ (NSDate *)backward:(NSInteger)backwardN unitType:(NSCalendarUnit)unit;
 
/// 获取过去的日期时间
+ (NSDate *)forward:(NSInteger)forwardN unitType:(NSCalendarUnit)unit;


@end

NS_ASSUME_NONNULL_END
