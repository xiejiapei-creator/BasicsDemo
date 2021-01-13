//
//  strViewController.m
//  FoundationDemo
//
//  Created by 谢佳培 on 2020/10/30.
//

#import "strViewController.h"

@interface strViewController ()

@end

@implementation strViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self pathArray];
}

// 范围
- (void)substring
{
    NSLog(@"============NSMakeRange==============");
    NSRange range = NSMakeRange(2, 4);
    NSString *fullString = @"abcdefghijk";
    NSString *subString = [fullString substringWithRange:range];
    NSLog(@"原字符串为abcdefghijk，其(2,4)范围内的子字符串为：%@", subString);
    
    NSLog(@"============substringToIndex==============");
    NSString *intString = @"456789";
    NSString *charString = @"abcdef";
    NSString *chineseString = @"中文哈哈哈哈";
    
    NSString *subIntString = [intString substringToIndex:2];
    NSString *subCharString = [charString substringToIndex:2];
    NSString *subChineseString = [chineseString substringToIndex:2];
    NSLog(@"substringToIndex:2，456789的子串为：%@，abcdef的子串为：%@，中文哈哈哈哈的子串为：%@", subIntString,subCharString,subChineseString);
    
    NSLog(@"============substringFromIndex==============");
    NSString *subFromString = [chineseString substringFromIndex:2];
    NSLog(@"原字符串为中文哈哈哈哈，FromIndex:2范围内的子字符串为：%@", subFromString);
}

// 格式
- (void)stringFormat
{
    NSLog(@"============stringWithFormat==============");
    NSString *stringWithFormat = [NSString stringWithFormat:@"字符串为: %@, 两位小数的浮点数为: %1.2f",@"XieJiaPei", 31415.9265];
    NSLog(@"带格式的字符串 = %@", stringWithFormat);
    
    NSLog(@"============stringByAppendingFormat==============");
    NSNumber *number = @12345;
    NSDictionary *dictionary = @{@"date": [NSDate date]};
    NSString *baseString = @"Test: ";
    NSString *stringByAppendingFormat = [baseString stringByAppendingFormat:@"数字: %@, 字典: %@", number, dictionary];
    NSLog(@"追加格式字符串 = %@", stringByAppendingFormat);
}

// 拷贝
- (void)copyString
{
    NSString *intString = @"456789";
    NSString *charString = @"abcdef";
    NSString *chineseString = @"中文哈哈哈哈";
    
    NSLog(@"============copy==============");
    NSString *copyIntString = [intString copy];
    NSString *copyCharString = [charString copy];
    NSString *copyChineseString = [chineseString copy];
    
    NSLog(@"复制后的字符串，%@，%@，%@", copyIntString,copyCharString,copyChineseString);
}

// 替换
- (void)replaceString
{
    NSString *chineseString = @"中文哈哈哈哈";
    
    NSLog(@"============stringByReplacingOccurrencesOfString==============");
    NSString *replaceChineseString = [chineseString stringByReplacingOccurrencesOfString:@"哈" withString:@"好"];
    NSLog(@"原字符串为中文哈哈哈哈，替换后为：%@", replaceChineseString);
    
    NSString *pureChineseString = [chineseString stringByReplacingOccurrencesOfString:@"哈" withString:@""];
    NSLog(@"原字符串为中文哈哈哈哈，用替换的方式进行删除后为：%@", pureChineseString);
}

// 比较
- (void)compareString
{
    NSLog(@"============compare==============");
    NSString *abc = @"abc";
    NSString *aBc = @"aBc";
    NSString *aB = @"aB";
    NSComparisonResult abcOrder = [abc compare:aBc];
    NSComparisonResult aBOrder = [aB compare:aBc];
    NSLog(@"abc compare:aBc的结果为：%ld，即abc > aBc",(long)abcOrder);
    NSLog(@"aB compare:aBc的结果为：%ld，即aB < aBc",(long)aBOrder);
    
    NSLog(@"============caseInsensitiveCompare==============");
    // 不区分大小写进行比较
    NSLog(@"abc和aBc不区分大小写进行比较：%ld",(long)[abc caseInsensitiveCompare:aBc]);
}

// 前缀和后缀
- (void)PrefixAndSuffix
{
    NSString *aBc = @"aBc";
    
    NSLog(@"============hasSuffix==============");
    if ([aBc hasSuffix:@"Bc"])
    {
        NSLog(@"aBc的后缀为Bc");
    }
    
    NSLog(@"============hasPrefix==============");
    if ([aBc hasPrefix:@"aB"])
    {
        NSLog(@"aBc的前缀为aB");
    }
}

// 路径
- (void)pathComponent
{
    NSLog(@"============stringByAppendingPathComponent==============");
    NSString *homePath = NSHomeDirectory();// 能够访回当前用户的主目录
    NSString *workPath = [homePath stringByAppendingPathComponent:@"LuckCoffee"];
    NSLog(@"瑞幸咖啡的存储路径为：%@", workPath);
    
    NSLog(@"============lastPathComponent/pathExtension==============");
    NSString *filePath = @"/tmp/image/cat.tiff";
    NSLog(@"路径为：/tmp/image/cat.tiff，最后一个部分为：%@，文件的扩展名为：%@",[filePath lastPathComponent],[filePath pathExtension]);
}

// 字符串和数组之间的转变
- (void)pathArray
{
    NSString *homePath = NSHomeDirectory();// 能够访回当前用户的主目录
    
    NSLog(@"============componentsSeparatedByString==============");
    // 分割
    NSArray *pathArray = [homePath componentsSeparatedByString:@"/"];
    NSLog(@"NSHomeDirectory的路径为：%@", homePath);
    NSLog(@"路径转变为数组后为：%@", pathArray);
    
    NSLog(@"============componentsJoinedByString==============");
    // 拼接
    NSString *joinPath = [pathArray componentsJoinedByString:@"/"];
    NSLog(@"将数组拼接成为路径：%@",joinPath);
    
    NSLog(@"============把NSArray集合转换为格式字符串==============");
    NSArray *array = @[@"xie",@"jia",@"pei",@"fan",@"yi",@"cheng",@"lin",@"feng",@"mian"];
    NSMutableString *result = [NSMutableString stringWithString:@"["];
    for (id object in array)
    {
        [result appendString:[object description]];
        [result appendString:@","];
    }
    // 去掉字符串最后的两个字符
    [result deleteCharactersInRange:NSMakeRange(result.length - 2, 2)];
    [result appendString:@"]"];
    NSLog(@"把NSArray集合转换为字符串:%@",result);
}
 
// 字符串和Data之间的转变
- (void)initWithData
{
    NSString *name = @"XieJiaPei";
    
    // 将NSString转化为NSData
    NSData *data = [name dataUsingEncoding:NSUTF8StringEncoding];

    // 用存储在data中的二进制数据来初始化NSString对象
    NSString *dataName = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"用存储在data中的二进制数据来初始化NSString对象，结果为：%@",dataName);
}

// 字符串属性
- (void)stringProperties
{
    NSString *name = @"XieJiaPei";
    
    // 字符串对象内部使用Unicode 编码，返回C语言字符串的指针
    NSLog(@"Unicode 编码：%s",[name UTF8String]);
    
    // 小写与大写
    NSLog(@"原字符串为：XieJiaPei，小写结果为：%@",[name lowercaseString]);
    NSLog(@"原字符串为：XieJiaPei，大写结果为：：%@",[name uppercaseString]);
    NSLog(@"原字符串为：XieJiaPei，首字母变为大写结果为：：%@",[name capitalizedString]);
    
    // 分别被用来把NSString类型的字符串转为float、int、NSinteger和BOOL类型的数值
    NSLog(@"原字符串为：414.5678，floatValue值为：%f",[@"414.5678" floatValue]);
    NSLog(@"原字符串为：512，intValue值为：%d",[@"512" intValue]);
    NSLog(@"原字符串为：1024，integerValue值为：%ld",(long)[@"1024" integerValue]);
    NSLog(@"原字符串为：OK，boolValue值为：%ld",(long)[@"2" boolValue]);
}

// 可变字符串
- (void)mutableString
{
    // 随着字符串的变化而自动扩展内存，所以capacity不需要非常精密
    NSMutableString* mutableString = [[NSMutableString alloc] initWithCapacity:20];
    
    // 在原来的字符串尾部添加，返回void，不产生新字符串
    [mutableString appendString:@"所谓平庸"];
    
    // 在原来的字符串尾部添加格式化字符串
    [mutableString appendFormat:@"是在于认清%i个人的限度，而安于这个限度。",1];
    
    // 插入字符串
    [mutableString insertString:@"，" atIndex:4];
    
    // 替换
    [mutableString replaceCharactersInRange:NSMakeRange(2, 2) withString:@"幸福"];
    
    NSLog(@"可变字符串为：%@",mutableString);
}

// 富文本
- (void)attributedString
{
    NSString *singleLineText = @"Single Line";
    
    // 下划线
    NSAttributedString *singleLineTextAttr = [[NSAttributedString alloc] initWithString:singleLineText attributes:@{NSUnderlineStyleAttributeName: @(1)}];
    
    UILabel *singleLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(150, 100, 100, 50)];
    singleLineLabel.attributedText = singleLineTextAttr;
    [self.view addSubview:singleLineLabel];
}

@end
