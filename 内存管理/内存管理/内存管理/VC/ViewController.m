//
//  ViewController.m
//  内存管理
//
//  Created by 谢佳培 on 2021/3/2.
//

#import "ViewController.h"

@implementation Person

- (void)run
{
    personNum++;
    NSLog(@"self：%@，&personNum：%p，personNum：%d",self,&personNum,personNum);
}

- (NSString *)description
{
    return @"那一天，人类终于想起了曾一度被它们所支配的恐怖和被囚禁于鸟笼中的那份屈辱。";
}

@end

@interface ViewController ()

@property (nonatomic, strong) dispatch_queue_t  queue;
@property (nonatomic, strong) NSString *nameStr;

@end

@implementation ViewController

// 静态常量
int pureInt;
static int staticInt;
static NSString *staticNSString;

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self touchTaggedPointer];
}

#pragma mark - 内存5大区域

- (void)fiveArea
{
    // 局部变量
    int money = 10;
    NSLog(@"小学生的零花钱：%p",&money);
    NSLog(@"小学生的年龄：%lu",sizeof(money));
    
    // 对象
    NSObject *student = [NSObject new];
    NSLog(@"中学生：%@，中学生的姓名：%p",student,&student);
    NSLog(@"中学生的年龄：%lu",sizeof(&student));
    
    // 数组
    NSArray *class = [[NSArray alloc] init];
    NSLog(@"班级：%@，几年级几班：%p",class,&class);
    
    // 静态常量
    NSLog(@"int == \t%p",&pureInt);
    NSLog(@"static int == \t%p",&staticInt);
    NSLog(@"static NSString == \t%p",&staticNSString);
}

#pragma mark - TaggedPointer

- (void)taggedPointer
{
    int intNumber = 1;
    float floatNumber = 2.5;
    long longNumber = 3;
    double doubleNumber = 4.9;
    
    NSNumber *number0 = @(intNumber);
    NSNumber *number1 = @(2);
    NSNumber *number2 = @(floatNumber);
    NSNumber *number3 = @(longNumber);
    NSNumber *number4 = @(doubleNumber);
    NSNumber *numberFFFF = @(0xFFFF);

    NSLog(@"number1 pointer is %p", number0);
    NSLog(@"number1 pointer is %p", number1);
    NSLog(@"number2 pointer is %p", number2);
    NSLog(@"number3 pointer is %p", number3);
    NSLog(@"number3 pointer is %p", number4);
    NSLog(@"numberffff pointer is %p", numberFFFF);
}

- (void)taggedPointerBug
{
    self.queue = dispatch_queue_create("com.xiejiapei", DISPATCH_QUEUE_CONCURRENT);
    
    for (int i = 0; i<100000; i++)
    {
        dispatch_async(self.queue, ^{
            // 文字够短属于小对象符合taggedPointer的存储标准，故未崩溃
            self.nameStr = [NSString stringWithFormat:@"xjp"];
        });
    }
}

- (void)touchTaggedPointer
{
    for (int i = 0; i<100000; i++) {
        dispatch_async(self.queue, ^{
            // 文字太长不符合taggedPointer的存储标准，采用其他方式存储，生成100000个临时变量超负荷故未崩溃
            self.nameStr = [NSString stringWithFormat:@"dsggkdashjksda"];
        });
    }
}


@end
