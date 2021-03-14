//
//  HeaderViewController.m
//  FoundationDemo
//
//  Created by 谢佳培 on 2020/10/30.
//

#import "HeaderViewController.h"

@implementation PersonClass

// 复制人物
- (instancetype)copyWithZone:(NSZone *)zone
{
    PersonClass *person = [[PersonClass alloc] init];
    person.firstName = self.firstName;
    person.lastName = self.lastName;
    return person;
}

- (void)printPetPhrase:(NSString *)petPhrase
{
    NSLog(@"你的口头禅是什么呀？%@",petPhrase);
}

@end


#pragma mark - 常量和宏

// const常量：后跟谁定谁
const NSString *constString = @"谢佳培";
NSString *const stringConst = @"甜的";

// 常用宏定义的颜色、字体字号
#define ROW_SIZE 20
#define Blue  [UIColor colorWithRed:(0x##r)/255.0 green:(0x##g)/255.0 blue:(0x##b)/255.0 alpha:1]

// 宏定义获取rootViewController
#define RootVC [UIApplication sharedApplication].delegate.window.rootViewController

// 宏定义获取当前的界面
#define TopVC ([RootVC isKindOfClass:[UITabBarController class]]?[((UITabBarController *)RootVC).selectedViewController topViewController]:RootVC)


#pragma mark - Typedef

// 给NSTimeInterval取别名为MyTime
typedef NSTimeInterval MyTime;

// c语言格式，给Person结构体取别名为MyPerson
// 使用:MyPerson p = {"jack"};
typedef struct Person {
    char *name;
} MyPerson;

// c语言格式，给Gender枚举取别名为MyGender
// 使用:MyGender g = Man;
typedef enum Gender {
    Man,
    Woman
} MyGender;

// OC语言格式
typedef NS_ENUM(NSInteger, NumberType)
{
     NumberTypeInt = 0,
     NumberTypeFloat = 1,
     NumberTypeDouble = 2
};
NumberType type = NumberTypeInt;

typedef NS_OPTIONS(NSUInteger, TMEnumTest)
{
    TMEnumTestOne     = 0,          // 0
    TMEnumTestTwo     = 1 << 0,     // 1
    TMEnumTestThree   = 1 << 1,     // 2
    TMEnumTestFour    = 1 << 2,     // 4
};
TMEnumTest test = TMEnumTestTwo | TMEnumTestThree;


typedef NS_OPTIONS(NSUInteger, LifeRoleOptions)
{
    LifeRoleOptionsFather =   1UL << 0,
    LifeRoleOptionsSon = 1UL << 1,
    LifeRoleOptionsHusband = 1UL << 3,
};
LifeRoleOptions lifeRole = LifeRoleOptionsFather | LifeRoleOptionsSon;

// 给block取别名MyBlock
typedef void(^MyBlock) (int a,int b);

@interface HeaderViewController ()

@end

@implementation HeaderViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self useAttributeKey];
}

#pragma mark - 使用属性关键字

- (void)useAttributeKey
{
    PersonClass *aPerson = [[PersonClass alloc] init];
    aPerson.objStrong = [[NSObject alloc] init];
    
    // 系统会警告，但不会报错
    aPerson.objWeak = [[NSObject alloc] init];
    aPerson.objAssign = [[NSObject alloc] init];
    
    NSMutableString *testStr = [[NSMutableString alloc] initWithString:@"我知道什么呢？"];
    aPerson.objCopy = testStr;
    [aPerson setObjCopy:testStr];
    [testStr appendString:@"什么都知道"];
    
    // 正确的方式
    NSLog(@"objStrong %@", aPerson.objStrong);
    
    // weak会释放为null
    NSLog(@"objWeak %@", aPerson.objWeak);
    
    // Assign会崩溃
    // NSLog(@"objAssign %@", aPerson.objAssign);
    
    // Copy后，原字符串改变对新字符串无影响
    NSLog(@"testStr %@", testStr);
    NSLog(@"objCopy %@", aPerson.objCopy);
}

#pragma mark - 使用枚举

- (void)useTypedef
{
    // 添加TMEnumTestFour到test中
    test += TMEnumTestFour;
    // 将TMEnumTestThree从test中去除
    test -= TMEnumTestThree;
    // 判断 TMEnumTestFour枚举 是否被包含
    if (test & TMEnumTestFour)
    {
        NSLog(@"数字是：四");
    }
    // 判断 TMEnumTestThree枚举 是否被包含
    if (test & TMEnumTestThree)
    {
        NSLog(@"数字是：三");
    }
    
    if (lifeRole & LifeRoleOptionsFather)
    {
        NSLog(@"人生角色：父亲");
    }
    
    if (lifeRole & LifeRoleOptionsHusband)
    {
        NSLog(@"人生角色：丈夫");
    }
}

@end
