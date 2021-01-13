//
//  PlistViewController.m
//  LocalCacheDemo
//
//  Created by 谢佳培 on 2020/10/19.
//

#import "PlistViewController.h"

@interface PlistViewController ()

@end

@implementation PlistViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self useDocumentPlist];
}

// Bundle中的plist文件
- (void)useBundlePlist
{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"LuckCoffee" ofType:@"plist"];
    NSArray *dataArray = [[NSArray alloc] initWithContentsOfFile:plistPath];
    
    // 直接打印数据
    NSLog(@"文件内容为：%@",dataArray);
}

// 沙盒中的plist文件（程序会自动新建的那一个）
- (void)useDocumentPlist
{
    // 写入数组
    [self arrayPlist];
     
    // 写入字典
    [self dictionaryPlist];
}

// 写入数组
- (void)arrayPlist
{
    NSArray *dataArray = @[@"East China Normal University",@"LuckCoffee",@"Thirst for knowledge, be modest and foolish"];
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *plistFilePath = [documentPath stringByAppendingPathComponent:@"Xiejiapei.plist"];
    [dataArray writeToFile:plistFilePath atomically:YES];
    
    // 直接打印数据
    NSLog(@"文件内容为：%@",[[NSArray alloc] initWithContentsOfFile:plistFilePath]);
}

// 写入字典
- (void)dictionaryPlist
{
    // 我发现要写入plist文件，key必须为string类型
    NSDictionary *dict = @{@"name": @"XieJiaPei", @"age": @22, @"4": @5};
    
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [documentPath stringByAppendingPathComponent:@"jia.plist"];
    
    // 将路径转换为本地url形式
    NSURL *fileUrl = [NSURL fileURLWithPath:filePath];

    // writeToURL 的好处是，既可以写入本地url也可以写入远程url，苹果推荐使用此方法写入plist文件
    if ( [dict writeToURL:fileUrl atomically:YES] )
    {
        NSLog(@"成功写入文件，路径为：%@",filePath);
    }
    
    NSDictionary *dictionaryFromFile = [NSDictionary dictionaryWithContentsOfFile:filePath];
    NSLog(@"从文件中读取到的字典为：%@",dictionaryFromFile);
}

@end
