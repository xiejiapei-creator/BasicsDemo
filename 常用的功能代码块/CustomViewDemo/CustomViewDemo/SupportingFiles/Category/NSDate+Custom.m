//
//  NSDate+Custom.m
//  CategoryNSDemo
//
//  Created by 谢佳培 on 2020/11/3.
//

#import "NSDate+Custom.h"

@implementation NSDate (Custom)

- (NSCalendar *)calendar
{
    return [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
}

#pragma mark - 获取当前的时间

- (NSInteger)year
{
    return [[[self calendar] components:NSCalendarUnitYear fromDate:self] year];
}

- (NSInteger)month
{
    return [[[self calendar] components:NSCalendarUnitMonth fromDate:self] month];
}

- (NSInteger)day
{
    return [[[self calendar] components:NSCalendarUnitDay fromDate:self] day];
}

- (NSInteger)hour
{
    return [[[self calendar] components:NSCalendarUnitHour fromDate:self] hour];
}

- (NSInteger)minute
{
    return [[[self calendar] components:NSCalendarUnitMinute fromDate:self] minute];
}

- (NSInteger)second
{
    return [[[self calendar] components:NSCalendarUnitSecond fromDate:self] second];
}

- (NSInteger)weekday
{
    return [[[self calendar] components:NSCalendarUnitWeekday fromDate:self] weekday];
}

// 获取当前的"年月日时分"
+ (NSArray<NSString *> *)getCurrentTimeComponents
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd-HH-mm"];
    NSDate *date = [NSDate date];
    NSString *time = [formatter stringFromDate:date];
    return [time componentsSeparatedByString:@"-"];
}

#pragma mark - 获取某个月的天数

+ (NSInteger)getSumOfDaysMonth:(NSInteger)month inYear:(NSInteger)year
{
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM"];
    NSString *dateString = [NSString stringWithFormat:@"%lu-%lu", year, month];
    NSDate *date = [formatter dateFromString:dateString];
    
    NSRange range = [[NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return range.length;
}

#pragma mark - 获取星期几

- (NSString *)dayFromWeekday
{
    return [NSDate dayFromWeekday:self];
}

- (NSString *)dayFromWeekday2
{
    return [NSDate dayFromWeekday2:self];
}

- (NSString *)dayFromWeekday3
{
    return [NSDate dayFromWeekday3:self];
}

// 星期几的形式
+ (NSString *)dayFromWeekday:(NSDate *)date
{
    switch([date weekday])
    {
        case 1:
            return @"星期天";
            break;
        case 2:
            return @"星期一";
            break;
        case 3:
            return @"星期二";
            break;
        case 4:
            return @"星期三";
            break;
        case 5:
            return @"星期四";
            break;
        case 6:
            return @"星期五";
            break;
        case 7:
            return @"星期六";
            break;
        default:
            break;
    }
    return @"";
}

// 周几的形式
+ (NSString *)dayFromWeekday2:(NSDate *)date
{
    switch([date weekday])
    {
        case 1:
            return @"周日";
            break;
        case 2:
            return @"周一";
            break;
        case 3:
            return @"周二";
            break;
        case 4:
            return @"周三";
            break;
        case 5:
            return @"周四";
            break;
        case 6:
            return @"周五";
            break;
        case 7:
            return @"周六";
            break;
        default:
            break;
    }
    return @"";
}

// 英文的形式
+ (NSString *)dayFromWeekday3:(NSDate *)date
{
    switch([date weekday])
    {
        case 1:
            return @"Sunday";
            break;
        case 2:
            return @"Monday";
            break;
        case 3:
            return @"Tuesday";
            break;
        case 4:
            return @"Wednesday";
            break;
        case 5:
            return @"Thursday";
            break;
        case 6:
            return @"Friday";
            break;
        case 7:
            return @"Saturday";
            break;
        default:
            break;
    }
    return @"";
}

#pragma mark - 时间戳

// 获取当前时间戳字符串
+ (NSString *)currentTimeInterval
{
    NSDate *date = [NSDate date];
    NSTimeInterval timeInterval = [date timeIntervalSince1970];
    NSString *timeIntervalString = [NSString stringWithFormat:@"%d", (int)timeInterval];
    return timeIntervalString;
}

// (NSDate => Timestamp)
+ (NSInteger)timestampFromDate:(NSDate *)date
{
    return [[NSNumber numberWithDouble:[date timeIntervalSince1970]] integerValue];
}

// (Timestamp => NSDate)
+ (NSDate *)dateFromTimestamp:(NSInteger)timestamp
{
    return [NSDate dateWithTimeIntervalSince1970:timestamp];
}

// (TimeString => Timestamp)
+ (NSInteger)timestampFromTimeString:(NSString *)timeString formatter:(NSString *)format
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:format];
    
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    
    // 将字符串按formatter转成NSDate
    NSDate *date = [formatter dateFromString:timeString];
    return [self timestampFromDate:date];
}

// (Timestamp => TimeString)
+ (NSString *)timeStringFromTimestamp:(NSInteger)timestamp formatter:(NSString *)format
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:format];
    
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    
    NSDate *timeDate = [self dateFromTimestamp:timestamp];
    return [formatter stringFromDate:timeDate];
}

// 获取当前系统时间的时间戳 [北京时间]
+ (NSInteger)getNowTimestampWithFormatter:(NSString *)format
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:format];
    
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    
    return [self timestampFromDate:[NSDate date]];
}

#pragma mark - 时间字符串

// 将date转换成时间字符串 (NSDate => TimeString)
+ (NSString *)stringWithDate:(NSDate *)date format:(NSString *)format
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    [formatter setLocale:[NSLocale currentLocale]];
    NSString *dateString = [formatter stringFromDate:date];
    return dateString;
}

// 将时间字符串转换成date (TimeString ==> NSDate)
+ (NSDate *)dateWithString:(NSString *)dateString format:(NSString *)format
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    return [formatter dateFromString:dateString];
}

#pragma mark - 日期比较大小

// 比较两个date的大小关系  
+ (NSComparisonResult)compareDateString1:(NSString *)dateString1
                             dateString2:(NSString *)dateString2
                               formatter:(NSString *)format
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:format];
    
    NSDate *date1 = [[NSDate alloc] init];
    NSDate *date2 = [[NSDate alloc] init];
    
    date1 = [formatter dateFromString:dateString1];
    date2 = [formatter dateFromString:dateString2];
    
    return [date1 compare:date2];
}

// 是否小于当前时间(过去时间)
- (BOOL)isInPast
{
    return ([self compare:[NSDate date]] == NSOrderedAscending);
}

// 是否大于当前时间(未来时间)
- (BOOL)isInFuture
{
    return ([self compare:[NSDate date]] == NSOrderedDescending);
}

// 是否是今天
- (BOOL)isToday
{
    return [self isSameDay:[NSDate date]];
}

// 是否是同一天
- (BOOL)isSameDay:(NSDate *)anotherDate
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components1 = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self];
    NSDateComponents *components2 = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:anotherDate];
    
    return ([components1 year] == [components2 year] && [components1 month] == [components2 month] && [components1 day] == [components2 day]);
}

#pragma mark - 日期计算

// 获取之前的日期时间
+ (NSDate *)backward:(NSInteger)backward unitType:(NSCalendarUnit)unit
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setValue:backward forComponent:unit];
    
    NSCalendar *calendar = [[self alloc] calendar];
    NSDate *dateFromDateComponents =  [calendar dateByAddingComponents:dateComponents toDate:[NSDate date] options:0];
    return dateFromDateComponents;
}

// 获取未来的日期时间
+ (NSDate *)forward:(NSInteger)forward unitType:(NSCalendarUnit)unit
{
    return [self backward:-forward unitType:unit];
}

@end
