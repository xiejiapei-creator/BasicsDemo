//
//  KVCUseViewController.m
//  KVO_KVC_Demo
//
//  Created by 谢佳培 on 2020/9/25.
//

#import "KVCUseViewController.h"

@implementation School

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.name = @"Xia Men Da Xue";
        self.age = 98;
    }
    return self;
}

@end

@implementation Person

// 默认值
- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _name = @"xiejiapei";
        _age = 22;
        _currentSchool = [[School alloc] init];

        BankAccount account = {14000, 3000};
        _bankAccount = account;
    }
    return self;
}

+ (Person *)randomPerson
{
    Person *person = [[Person alloc] init];
    
    uint32_t randomAge = arc4random() % 100;
    person.age = randomAge;
    person.name = [person.name stringByAppendingString:@(randomAge).stringValue];
    return person;
}

+ (NSArray<Person *> *)randomPersonsWithCount:(NSUInteger)count
{
    NSMutableArray *persons = [NSMutableArray array];
    for (int i = 0; i < count; i++)
    {
        [persons addObject:[self randomPerson]];
    }
    
    return [persons copy];// 可变数组转变为不可变
}

@end

@interface KVCUseViewController ()

@end

@implementation KVCUseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self testSinglePerson];
    [self testPersons];
}

- (void)testSinglePerson
{
    Person *person = [[Person alloc] init];
    
// 人物
    // get
    NSString *originName = [person valueForKey:@"name"];
    NSNumber *originAge = [person valueForKey:@"age"];
    NSLog(@"获取到的人物的原始名称：%@，原始年龄：%@", originName, originAge);
    
    // set
    [person setValue:@"FanYiCheng" forKey:@"name"];
    [person setValue:@(18) forKey:@"age"];
    NSString *newName = [person valueForKey:@"name"];
    NSNumber *newAge = [person valueForKey:@"age"];
    NSLog(@"设置后人物的新名称：%@，新年龄：%@", newName, newAge);

// 学校
    // keyPath
    NSString *originSchoolName = [person valueForKeyPath:@"currentSchool.name"];
    NSLog(@"获取到学校的原始名称：%@", originSchoolName);
    
    [person setValue:@"Guo Li Tai Wan Da Xue" forKeyPath:@"currentSchool.name"];
    NSString *newSchoolName = [person valueForKeyPath:@"currentSchool.name"];
    NSLog(@"设置后学校的新名称 %@", newSchoolName);
    
    
// 银行账户
    // NSValue
    NSValue *originAccountValue = [person valueForKey:@"bankAccount"];
    BankAccount originAccount;
    [originAccountValue getValue:&originAccount size:sizeof(originAccount)];
    NSLog(@"获取到账户的原始收入：%i，支出：%i", originAccount.income, originAccount.balance);
    
    BankAccount newAccount = {18000, 5000};
    NSValue *newAccountValue = [NSValue valueWithBytes:&newAccount objCType:@encode(BankAccount)];
    [person setValue:newAccountValue forKey:@"bankAccount"];
    NSLog(@"设置后账户的新收入：%i，新支出：%i", person.bankAccount.income, person.bankAccount.balance);
}

- (void)testPersons
{
    NSArray<Person *> *persons = [Person randomPersonsWithCount:10];
    
    // 聚合运算符
    NSNumber *count = [persons valueForKeyPath:@"@count"];
    NSNumber *avgAge = [persons valueForKeyPath:@"@avg.age"];
    NSNumber *maxAge = [persons valueForKeyPath:@"@max.age"];
    NSNumber *minAge = [persons valueForKeyPath:@"@min.age"];
    NSNumber *sumAge = [persons valueForKeyPath:@"@sum.age"];
    NSLog(@"总数目：%@，平均年龄：%@，最大年龄：%@，最小年龄：%@， 总年龄：%@",count,avgAge,maxAge,minAge,sumAge);
    
    // 数组运算符
    NSArray *distinctAges = [persons valueForKeyPath:@"@distinctUnionOfObjects.age"];
    NSArray *unionAges = [persons valueForKeyPath:@"@unionOfObjects.age"];
    NSLog(@"年龄差集：%@，年龄并集：%@",distinctAges,unionAges);
    
    // 嵌套运算符
    NSArray *personArray1 = [Person randomPersonsWithCount:10];
    NSArray *personArray2 = [Person randomPersonsWithCount:10];
    NSArray *personArrays = @[personArray1,personArray2];
    NSArray *collectedDistinctAges = [personArrays valueForKeyPath:@"@distinctUnionOfArrays.age"];
    NSArray *collectedAges = [personArrays valueForKeyPath:@"@unionOfArrays.age"];
    NSLog(@"嵌套集合的年龄差集：%@，嵌套集合的年龄并集：%@", collectedDistinctAges,collectedAges);
    
}

@end
