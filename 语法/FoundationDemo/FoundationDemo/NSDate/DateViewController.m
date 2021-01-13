//
//  DateViewController.m
//  BasicGrammarDemo
//
//  Created by 谢佳培 on 2020/9/24.
//

#import "DateViewController.h"

@interface DateViewController ()

@end

@implementation DateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self calculateDate];
}

#pragma mark - Day

// 创建日期
- (void)date
{
    // 使用时间间隔创建日期
    NSTimeInterval secondsPerDay = 24 * 60 * 60;// 一天
    NSDate *tomorrow1 = [[NSDate alloc] initWithTimeIntervalSinceNow:secondsPerDay];// 明天
    NSDate *yesterday1 = [[NSDate alloc] initWithTimeIntervalSinceNow:-secondsPerDay];// 昨天
    NSLog(@"使用时间间隔创建日期，昨天：%@，明天：%@",yesterday1, tomorrow1);
    
    // 通过添加时间间隔创建日期
    NSDate *today = [NSDate date];
    NSDate *tomorrow2 = [today dateByAddingTimeInterval:secondsPerDay];// 明天
    NSDate *yesterday2 = [today dateByAddingTimeInterval:-secondsPerDay];// 昨天
    NSLog(@"通过添加时间间隔创建日期，昨天：%@，明天：%@",yesterday2, tomorrow2);

    // 从1970年1月1日开始，20年之后的日期
    NSDate *twentyYearsDate = [NSDate dateWithTimeIntervalSince1970:secondsPerDay*366*20];
    NSLog(@"从1970年1月1日开始，20年之后的日期：%@",twentyYearsDate);
}

// 比较日期
- (void)compareDate
{
    NSDate *today = [NSDate date];// 今天
    NSDate *tomorrow = [today dateByAddingTimeInterval:24 * 60 * 60];// 明天
    
    // 看看两个日期是否在一分钟（60秒）内
    // fabs:求一个实数的绝对值
    if (fabs([tomorrow timeIntervalSinceDate:today]) < 60)
    {
        NSLog(@"两个日期在一分钟（60秒）内");
    }
    else
    {
        NSLog(@"两个日期不在一分钟（60秒）内");
    }
    
    
    // 之前、相同、之后
    switch ([today compare:tomorrow])
    {
        case NSOrderedAscending:
            NSLog(@"之前");
            break;
        case NSOrderedSame:
            NSLog(@"相等");
            break;
        case NSOrderedDescending:
            NSLog(@"之后");
            break;
    }
    
    // 返回比较的两个日期中更早的那个
    today = [today earlierDate:tomorrow];
    NSLog(@"较早的日期：%@",today);
    
    // 返回比较的两个日期中更晚的那个
    today = [today laterDate:tomorrow];
    NSLog(@"较晚的日期：%@",today);
}

// 日期格式
- (void)dateFormat
{
    // 时间的本地化
    NSDate *today = [NSDate date];
    NSLocale *locale = [NSLocale currentLocale];// 系统当前的Locale
    [today descriptionWithLocale:locale];
    NSLog(@"时间的本地化：%@",today);
    
    
    
    // 创建两个NSLocale，分别代表中国、美国
    NSLocale *locales[] = {[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"], [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]};
        
    // 设置NSDateFormatter的日期、时间风格
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    
    // NSLocale
    [dateFormatter setLocale:locales[0]];
    // 设置自定义的格式模板
    [dateFormatter setDateFormat:@"公元yyyy年MM月DD日 HH时mm分"];
    // stringFromDate
    NSString* stringFromDate = [dateFormatter stringFromDate:today];
    NSLog(@"stringFromDate 时间的格式化：%@",stringFromDate);
    
    // dateFromString
    NSString *dateString = @"2020-01-18 06:50:24";
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *dateFromString = [formatter dateFromString:dateString];
    NSLog(@"dateFromString 时间的格式化：%@",dateFromString);
}

// 时间戳
- (void)dateInterval
{
    NSDate *today = [NSDate date];// 今天
    NSDate *tomorrow = [today dateByAddingTimeInterval:24 * 60 * 60];// 明天
    
    // 时间差
    double interval = [today timeIntervalSinceDate:tomorrow];
    NSLog(@"与明天的时间差：%f",interval);
    
    // 与现在的时间差
    interval = [today timeIntervalSinceNow];
    NSLog(@"与现在的时间差：%f",interval);
}

#pragma mark - Calendar

- (void)calendar
{
    // 创建日历对象
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    
    // local、usersCalendar和currentCalendar是相等的，尽管它们是不同的对象
    NSCalendar *usersCalendar = [[NSLocale currentLocale] objectForKey:NSLocaleCalendar];
    
    NSDate *date = [NSDate date];
    NSLog(@"现在日期为:%@",date);
    // 还可以通过为所需日历指定标识符来创建任意日历对象
    // 获取代表公历的Calendar对象
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];

    // 定义一个时间字段的旗标，指定将会获取指定年、月、日、时、分、秒的信息
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday;
    
    // 获取不同时间字段的信息
    NSDateComponents *components = [gregorian components:unitFlags fromDate:date];
    NSLog(@"年：%ld 月：%ld ",(long)components.year,(long)components.month);
    
    // 设置各时间字段的数值
    NSDateComponents *newComponents = [[NSDateComponents alloc] init];
    newComponents.year = 2020;
    newComponents.month = 10;
    newComponents.day = 1;
    
    // 恢复NSDate
    date = [gregorian dateFromComponents:newComponents];
    NSLog(@"设置的日期为:%@",date);
}

// 日期组件
- (void)dateComponents
{
    // 从日期获取组件
    NSDate *today = [NSDate date];
    // 获取代表公历的Calendar对象
    NSCalendar *decompose = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    // 指定将会获取指定周、日的信息
    NSDateComponents *weekdayComponents = [decompose components:(NSCalendarUnitDay | NSCalendarUnitWeekday) fromDate:today];
    
    NSInteger day = [weekdayComponents day];
    NSInteger newWeekday = [weekdayComponents weekday];
    NSLog(@"今天是:%@",today);
    NSLog(@"从日期获取组件 day:%ld, newWeekday:%ld",(long)day,(long)newWeekday);


    // 从组件创建日期
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:2];// 星期一
    [components setWeekdayOrdinal:1];// 这个月的第一个星期一
    [components setMonth:10];
    [components setYear:2020];
    NSDate *getDate = [decompose dateFromComponents:components];
    NSLog(@"从组件创建日期:%@",getDate);
}

// 计算日期
- (void)calculateDate
{
    NSDate *today = [[NSDate alloc] init];
    NSDate *tomorrow = [[NSDate alloc] initWithTimeIntervalSinceNow:24 * 60 * 60];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];

    // 增加一个半小时后
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setHour:1];
    [offsetComponents setMinute:30];
    NSDate *endOfWorldWar3 = [gregorian dateByAddingComponents:offsetComponents toDate:today options:0];
    NSLog(@"现在的时间是：%@",today);
    NSLog(@"一个半小时后就是第三次世界大战的结束时间：%@",endOfWorldWar3);
    
    // 通过减去日期来获取前一周的星期天 9月24日为周四，则上周日为9月20日，具有与原始日期相同的小时、分钟和秒
    NSDateComponents *weekdayComponents = [gregorian components:NSCalendarUnitWeekday fromDate:today];
    NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];
    // 从当前日期减去的天数，公历中星期日的值是1，所以减去1，如果今天是星期日，则减去0天
    [componentsToSubtract setDay:(0 - ([weekdayComponents weekday] - 1))];
    NSDate *beginningOfWeek = [gregorian dateByAddingComponents:componentsToSubtract toDate:today options:0];
    NSLog(@"通过减去日期来获取前一周的星期天：%@",beginningOfWeek);
    
    // 获取两个日期之间的差异
    NSUInteger unitFlags = NSCalendarUnitDay | NSCalendarUnitMonth;
    NSDateComponents *components = [gregorian components:unitFlags fromDate:today  toDate:tomorrow options:0];
    NSInteger months = [components month];
    // 输出两个日期day差数为0，因为8.5小时不到1天
    NSInteger days = [components day];
    NSLog(@"获取两个日期之间的差异，days：%ld，months：%ld",(long)days,(long)months);
}
 

@end



