//
//  testNSDateViewController.m
//  CategoryNSDemo
//
//  Created by 谢佳培 on 2020/11/3.
//

#import "testNSDateViewController.h"
#import "NSDate+Custom.h"

@interface testNSDateViewController ()

@end

@implementation testNSDateViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self calculateDay];
}

// 获取当前的时间
- (void)getCurrentTime
{
    NSDate *date = [NSDate date];
    NSLog(@"%ld年，%ld月，%ld日，%ld时，%ld分，%ld秒，weekday为%ld",(long)date.year,date.month,date.day,date.hour,date.minute,date.second,date.weekday);
}

// 获取星期几
- (void)getWeekday
{
    NSDate *date = [NSDate date];
    NSLog(@"%@，%@，%@",[date dayFromWeekday],[date dayFromWeekday2],[date dayFromWeekday3]);
}

// 获取时间戳
- (void)getTimeInterval
{
    NSLog(@"获取当前时间戳字符串：%@",[NSDate currentTimeInterval]);
    NSLog(@"获取当前系统时间的时间戳 [北京时间]：%ld",(long)[NSDate getNowTimestampWithFormatter:@"yyyy-MM-dd HH:mm"]);
    NSLog(@"将date转换成时间戳 (NSDate => Timestamp)：%ld",(long)[NSDate timestampFromDate:[NSDate date]]);
    NSLog(@"将时间戳转换成date (Timestamp => NSDate)：%@",[NSDate dateFromTimestamp:1604396335]);
    NSLog(@"将时间字符串转换成时间戳 (TimeString => Timestamp) [北京时间]：%ld",(long)[NSDate timestampFromTimeString:@"2020-11-15 15:39" formatter:@"yyyy-MM-dd HH:mm"]);
    NSLog(@"将时间戳转换成时间字符串 (Timestamp => TimeString) [北京时间]：%@",[NSDate timeStringFromTimestamp:1604396335 formatter:@"yyyy-MM-dd HH:mm"]);
}

// 时间字符串
- (void)getTimeString
{
    NSLog(@"将date转换成时间字符串 (NSDate => TimeString)：%@",[NSDate stringWithDate:[NSDate date] format:@"yyyy/MM/dd"]);
    NSLog(@"将时间字符串转换成date (TimeString ==> NSDate)：%@",[NSDate dateWithString:@"2020-11-15" format:@"yyyy/MM/dd"]);
}

// 获取某个月的天数
- (void)getMonthDays
{
    NSLog(@"获取2020年11月的天数：%ld",(long)[NSDate getSumOfDaysMonth:11 inYear:2020]);
}

// 获取当前的"年月日时分"
- (void)getTimeComponents
{
    NSLog(@"获取当前的年月日时分：%@",[NSDate getCurrentTimeComponents]);
}

// 日期比较大小
- (void)compareDay
{
    NSComparisonResult result = [NSDate compareDateString1:@"2020-11-15" dateString2:@"2020-11-17" formatter:@"yyyy-MM-dd"];
    NSLog(@"比较的结果为：%ld",(long)result);
    
    NSDate *date = [NSDate dateWithString:@"2020-11-15" format:@"yyyy-MM-dd"];
    if ([date isInPast])
    {
        NSLog(@"2020-11-15日小于当前时间，属于过去");
    }
    
    if ([date isInFuture])
    {
        NSLog(@"2020-11-15日大于当前时间，属于未来");
    }
    
    if ([date isToday])
    {
        NSLog(@"2020-11-15日就在今天");
    }
}

// 计算日期
- (void)calculateDay
{
    NSLog(@"获取2天后的时间: %@",[NSDate backward:2 unitType:NSCalendarUnitDay]);
    NSLog(@"获取5天前的时间: %@",[NSDate forward:5 unitType:NSCalendarUnitDay]);
}

@end
