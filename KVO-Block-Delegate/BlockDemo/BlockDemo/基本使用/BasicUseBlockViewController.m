//
//  BasicUseBlockViewController.m
//  BlockDemo
//
//  Created by 谢佳培 on 2020/10/16.
//

#import "BasicUseBlockViewController.h"

@interface Person()

// 私有block
@property (nonatomic, copy) personBlock privatePersonBlock;

@end

@implementation Person

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _age = 22;
        _name = @"谢佳培";
        
        [self initPrivateBlock];
    }
    return self;
}

// 初始化私有block
- (void)initPrivateBlock
{
    __weak Person *weakSelf = self;
    self.privatePersonBlock = ^{
        // 报错，强引用self
        // NSLog(@"person name %@", self.name);
        // 报错，强引用self
        // NSLog(@"person age %d", _age);
        
        NSLog(@"人名：%@", weakSelf.name);
        NSLog(@"年龄：%d", weakSelf.age);
    };
}

// 运行私有block
- (void)runPrivatePersonBlock
{
    // 调用
    self.privatePersonBlock();
}

// 运行完成的block
- (void)runFinishBlock:(finishBlock)finishBlock
{
    finishBlock(@"http://.......");
}

// 打印手机号
- (void)printPersonMobile
{
    if (self.fetchPersonMobileBlock)
    {
        NSString *mobile = self.fetchPersonMobileBlock();
        NSLog(@"手机号为：%@", mobile);
    }
}

@end

static int globalCount = 0;

@interface BasicUseBlockViewController ()

@end

@implementation BasicUseBlockViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self testBlockEnumerate];
}

#pragma mark - 跨层传值

// 测试Person里面的block
- (void)testPersonBlock
{
    Person *person = [[Person alloc] init];
    [person runPrivatePersonBlock];
    [person runFinishBlock:^(NSString *imageURL) {
        NSLog(@"获得图片的url为：%@",imageURL);
    }];
    person.fetchPersonMobileBlock = ^NSString *{
        return @"15659281708";
    };
    [person printPersonMobile];
}

#pragma mark - 语法

// 测试Block的语法
- (void)testBlockGrammer
{
    void(^aBlock)(void) = ^{
        NSLog(@"齐天大圣孙悟空在此，妖精还不快现原形!");
    };
    aBlock();
    
    // 拷贝
    void(^bBlock)(void) = aBlock;
    bBlock();
    
    // 拷贝
    void(^cBlock)(void) = [aBlock copy];
    cBlock();
    
    // 入参和返回值
    int(^sumBlock)(int, int) = ^(int a, int b){
        return a + b;
    };
    int sum = sumBlock(1, 2);
    NSLog(@"和为：%d", sum);
}

#pragma mark - 捕获变量

// 测试block的捕获变量
- (void)testBlockCaptureVar
{
    // int
    int aNumber = 0;
    __block int bNumber = 10;
    
    // string
    NSString *aStr = @"金鳞岂是池中物";
    __block NSString *bStr = @"一遇风云便化龙";
    
    // object
    Person *aPerson = [[Person alloc] init];
    
    // block
    void(^aBlock)(void) = ^{
        NSLog(@"捕获到的全局变量值为：%d", globalCount);
        testFunc();// 调用block外的方法
        NSLog(@"捕获到的局部字符串值为：%@", aStr);
        
        // 更改捕获到的全局变量值
        globalCount = 1;
        
        // 内部定义的int变量和block外的重名了
        int aNumber = 1;
        // 嵌套block
        void(^bBlock)(void) = ^{
            NSLog(@"在block内部定义的int变量值为：%d", aNumber);
        };
        bBlock();
        
        // 更改用block修饰的局部int值
        bNumber = 11;
        
        // 更改用block修饰的字符串值
        bStr = [bStr stringByAppendingString:@"【聂风 步惊云】"];
        
        // 给对象的属性赋值
        aPerson.name = @"谢佳培";
    };
    aBlock();
    
    NSLog(@"更改后全局变量值为：%d", globalCount);
    NSLog(@"更改后用block修饰的局部int值为：%d", bNumber);
    NSLog(@"更改后用block修饰的字符串值:%@", bStr);
    NSLog(@"给对象的属性赋值后，人物名称为：%@", aPerson.name);
    
    // 说明更改无效
    void(^cBlock)(void) = ^{
        NSLog(@"内部定义的int变量和block外的重名了，更改外面的值为2后，block捕获到的该值为：%d", aNumber);
    };
    aNumber = 2;
    cBlock();
}

void testFunc()
{
    NSLog(@"天地之间隐有梵音");
}

#pragma mark - 遍历

// 测试block的遍历方法
- (void)testBlockEnumerate
{
    // 遍历数组
    NSArray<NSString *> *strArray = @[@"谢佳培", @"胡适之", @"丰子恺"];
    [strArray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"索引为：%ld ，内容为：%@", idx, obj);
    }];
    
    // 遍历字典
    NSDictionary<NSString *, NSString *> *strDict = @{@"student": @"谢佳培", @"teacher": @"郁达夫"};
    [strDict enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
        NSLog(@"键： %@ ，值： %@", key, obj);
    }];
}

@end



