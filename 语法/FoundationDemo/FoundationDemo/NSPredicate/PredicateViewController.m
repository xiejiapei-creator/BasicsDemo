//
//  PredicateViewController.m
//  BasicGrammarDemo
//
//  Created by 谢佳培 on 2020/9/24.
//

#import "PredicateViewController.h"
#import <CoreData/CoreData.h>

@interface PredicateViewController ()

@end

@implementation PredicateViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self characterMatch];
}

#pragma mark - 包含

// 是否在数组之中
- (void)inArrayDemo
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF IN %@",@[@"先生女士",@"妙不可言",@"哈哈哈哈哈"]];
    BOOL result = [predicate evaluateWithObject:@"哈哈哈哈哈"];
    if (result)
    {
        NSLog(@"哈哈哈哈哈在数组中");
    }
}

// 字符匹配
- (void)characterMatch
{
    NSString *prefix = @"prefix";
    NSString *suffix = @"suffix";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF like[c] %@",[[prefix stringByAppendingString:@"*"] stringByAppendingString:suffix]];
    NSLog(@"predicate = %@", [predicate predicateFormat]);
    BOOL result = [predicate evaluateWithObject:@"prefixxxxxxsuffix"];
    if (result)
    {
        NSLog(@"字符匹配成功");
    }
    else
    {
        NSLog(@"字符匹配失败");
    }
}

#pragma mark - 过滤

// 比较大小
- (void)greaterThanDemo
{
    NSArray* array = @[@101,@200,@50,@5,@25,@12];
    NSLog(@"原数组:%@",array);
    // 创建谓词，要求该对象自身的值大于50
    NSPredicate *predicateThan50 = [NSPredicate predicateWithFormat:@"SELF > 50"];
    // 使用谓词执行过滤，过滤后只剩下值大于50的集合元素
    NSArray *filteredArray = [array filteredArrayUsingPredicate:predicateThan50];
    NSLog(@"数组过滤后只剩下值大于50的集合元素:%@",filteredArray);
}

// 以特定字符开始
- (void)beginswithLetterDemo
{
    // 过滤掉不是以b开始的字符串
    NSMutableArray *letters = [@[@"Abc",@"Bbb",@"Ca"] mutableCopy];
    NSPredicate *predictForArray = [NSPredicate predicateWithFormat:@"SELF beginswith[c] 'b'"];
    NSArray *beginWithB = [letters filteredArrayUsingPredicate:predictForArray];
    NSLog(@"过滤掉不是以b开始的字符串：%@",beginWithB);
}

#pragma mark - 占位符

// 占位符参数
- (void)placeholderDemo
{
    NSString *name = @"name";
    NSString *value = @"齐天大圣";
    NSDictionary *ditc = @{@"name":@"我是齐天大圣孙悟空水帘洞花果山大王"};
    // 创建谓词，该谓词中包含了2个占位符，相当于创建了谓词表达式 "name CONTAINS '齐天大圣'" 字典中的键为name的值是否包含"齐天大圣"
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K contains %@",name, value];
    // 使用谓词执行判断
    BOOL isContain = [predicate evaluateWithObject:ditc];
    if (isContain)
    {
        NSLog(@"字典中的键为name的值包含齐天大圣");
    }
    else
    {
        NSLog(@"字典中的键为name的值不包含齐天大圣");
    }
}

// 设置变量值
- (void)SUBSTRdemo
{
    // $SUBSTR相当于一个变量，需要我们调用时为它设置值
    NSPredicate* predicateTemplate = [NSPredicate predicateWithFormat:@"%K CONTAINS $SUBSTR" , @"number"];
    // 使用NDDictionary指定SUBSTR的值为'50'，这就相当于创建了谓词表达式"pass CONTAINS '50'"
    NSPredicate* predicate = [predicateTemplate predicateWithSubstitutionVariables:[NSDictionary dictionaryWithObjectsAndKeys:@"50",@"SUBSTR", nil]];
    // 使用谓词执行判断
    NSDictionary *ditc = @{@"number":@"50000123432425432"};
    BOOL isContain = [predicate evaluateWithObject:ditc];
    if (isContain)
    {
        NSLog(@"字典中的键为number的值包含50");
    }
    else
    {
        NSLog(@"字典中的键为number的值不包含50");
    }
}

#pragma mark -  正则表达式

- (void)regularExpressionsDemo
{
    NSArray *array = @[@"TATACCATGGGCCATCATCATCATCATCATCATCATCATCATCACAG",
                       @"CGGGATCCCTATCAAGGCACCTCTTCG", @"CATGCCATGGATACCAACGAGTCCGAAC",
                       @"CAT", @"CATCATCATGTCT", @"DOG"];
    
    // 查找包含至少3个“CAT”序列重复的字符串，但后面没有“CA”
    NSPredicate *catPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES '.*(CAT){3,}(?!CA).*'"];
    NSArray *filteredArray = [array filteredArrayUsingPredicate:catPredicate];
    NSLog(@"查找包含至少3个CAT序列重复的字符串，但后面没有CA：%@",filteredArray);
}

#pragma mark - 空值

- (void)nullPredicateDemo
{
    NSString *firstName = @"Xie";
    NSArray *array = @[ @{ @"lastName" : @"JiaPei" }, @{ @"firstName" : @"Wang", @"lastName" : @"ErDe", @"birthday":[NSDate date]},@{ @"firstName" : @"Xie", @"lastName" : @"LingYun", @"birthday":[NSDate date]}];
    
    // 姓为Xie或者为空
    NSPredicate *predicateForNull = [NSPredicate predicateWithFormat:@"(firstName == %@) || (firstName = nil)", firstName];
    // 使用谓词执行判断
    NSArray *filteredArray = [array filteredArrayUsingPredicate:predicateForNull];
    NSLog(@"过滤后的数组为: %@", filteredArray);
    
    BOOL ok = [predicateForNull evaluateWithObject: [NSDictionary dictionaryWithObject:[NSNull null] forKey:@"firstName"]];
    if (ok)
    {
        NSLog(@"存在姓为Xie或者为空");
    }
    else
    {
        NSLog(@"不存在姓为Xie或者为空");
    }
}

#pragma mark - 复合谓词

- (void)compoundPredicateDemo
{
    NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"SELF > 10"];
    NSLog(@"predicate1 = %@", [predicate1 predicateFormat]);
    NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"SELF < 50"];
    NSLog(@"predicate2 = %@", [predicate2 predicateFormat]);
    
    // NSAndPredicateType 多个谓词表达式之间添加AND，NSOrPredicateType 多个谓词表达式之间添加OR
    NSCompoundPredicate *compound = [[NSCompoundPredicate alloc] initWithType:NSAndPredicateType subpredicates:@[predicate1, predicate2]];
    NSLog(@"compound = %@", [compound predicateFormat]);
    
    BOOL result = [compound evaluateWithObject:@20];
    if (result)
    {
        NSLog(@"20在区间(20,50)内");
    }
    else
    {
        NSLog(@"20不在区间(20,50)内");
    }
}

#pragma mark - Core Data

- (void)coreDataPredicate
{
    NSManagedObjectContext *managedObjectContext;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Employee" inManagedObjectContext:managedObjectContext];
    [request setEntity:entity];
    
    NSInteger salaryLimit = 100;
    // 查找收入超过指定金额的员工
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"salary > %@", salaryLimit];
    [request setPredicate:predicate];
    
    // 查询结果
    NSError *error;
    NSArray *resultArray = [managedObjectContext executeFetchRequest:request error:&error];
}



@end

