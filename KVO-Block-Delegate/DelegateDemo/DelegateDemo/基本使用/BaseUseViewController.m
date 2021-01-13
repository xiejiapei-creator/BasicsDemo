//
//  BaseUseViewController.m
//  DelegateDemo
//
//  Created by 谢佳培 on 2020/10/20.
//

#import "BaseUseViewController.h"

#pragma mark - 计数工具

@implementation CountTool

// 计数方法
- (void)count
{
    // 调用即将计数的委托方法
    if (self.delegate && [self.delegate conformsToProtocol:@protocol(CountToolDelegate)])
    {
        [self.delegate willCountAllPerson];
    }
    
    // 调用数据源进行计数
    NSArray *persons = [self.dataSource personArray];
    NSLog(@"人数：%@", @(persons.count));
    
    // 调用完成计数的委托方法
    if (self.delegate && [self.delegate respondsToSelector:@selector(didCountedAllPerson)])
    {
        [self.delegate didCountedAllPerson];
    }
}

@end

#pragma mark - 管理者

@interface Administrator() <CountToolDelegate, CountToolDataSource>

@property (nonatomic, strong) CountTool *countTool;

@end

@implementation Administrator

// 初始化人物和计算人数工具类
- (instancetype)init
{
    self = [super init];
    if (self)
    {
        Person *aPerson = [Person new];
        aPerson.firstName = @"xie";
        aPerson.lastName = @"jiapei";
        
        Person *bPerson = [[Person alloc] init];
        bPerson.firstName = @"fan";
        bPerson.lastName = @"yicheng";
        
        _allPersons = @[aPerson, bPerson];
        
        _countTool = [[CountTool alloc] init];
        _countTool.delegate = self;
        _countTool.dataSource = self;
    }
    return self;
}

// 计算所有人的数目
- (void)countAllPerson
{
    [self.countTool count];// count方法中会调用CountToolDelegate和CountToolDataSource
}

// CountToolDelegate
- (void)willCountAllPerson
{
    NSLog(@"调用了即将计算人数的委托方法");
}

- (void)didCountedAllPerson
{
    NSLog(@"调用了完成计算人数的委托方法");
}

// CountToolDataSource
- (NSArray *)personArray
{
    return self.allPersons;// 返回包含所有人的数组
}

@end

#pragma mark - 人

@implementation Person

// WorkProtocol
- (void)printJobNumber
{
    NSLog(@"打印工号为：%@", self.jobNumber);
}

- (void)codingAsProgrammer
{
    NSLog(@"编程者");
}

@end

#pragma mark - 使用

@interface BaseUseViewController ()

@end

@implementation BaseUseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    Person *aPerson = [[Person alloc] init];
    
    // protocol
    aPerson.jobNumber = @"10004847";
    [aPerson printJobNumber];
    [aPerson codingAsProgrammer];
    
    // delegate, dataSource
    Administrator *admin = [[Administrator alloc] init];
    [admin countAllPerson];
}

@end
