//
//  CommonUseViewController.m
//  BasicGrammarDemo
//
//  Created by 谢佳培 on 2020/10/20.
//

#import "CommonUseViewController.h"

#pragma mark - 重写

@implementation Animal

// 重写isEqual:
- (BOOL)isEqual:(id)object
{
    // 自身
    if (self == object)
    {
        return YES;
    }
    
    // 类型相同
    if ([object class] == [Animal class])
    {
        // 转化
        Animal *target = (Animal *)object;
        
        // 设置判断标准
        BOOL result = ([self.name isEqualToString:target.name] && (self.age == target.age));
        return result;
    }
    return NO;
}

// 重写hash
- (NSUInteger)hash
{
    
    NSUInteger nameHash = (self.name == nil ? 0 : [self.name hash]);
    NSUInteger ageHash = (self.age == nil ? 0 : [self.age hash]);
    
    return nameHash * 31 + ageHash;
}

// 重写description
- (NSString *)description
{
    return [NSString stringWithFormat:@"name:%@,age:%@", self.name,self.age];
}

// 重写copyWithZone
- (id)copyWithZone:(NSZone *)zone
{
    Animal *new = [[[self class] allocWithZone:zone] init];
    new.name = self.name;
    new.age = self.age;
    return new;
}

@end

#pragma mark - 复制

@implementation Person

- (void)run
{
    NSLog(@"滚 能换一种说法吗？ 蹿吧，孩儿。能文明一点吗？去吧，皮卡丘。能高大上一点吗？奔跑吧，兄弟。能再上档次点吗？世界这么大，你怎么不去看看。能有点诗意吗？你来人间一趟，你要看看太阳。能有点鼓动性吗？奔涌吧，后浪！");
}

// 初始化名称
- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _firstName = @"LuoMei";
        _lastName = @"Bai";
    }
    return self;
}

// 全名
- (NSString *)fullName
{
    if (self.firstName && self.lastName)
    {
        return [NSString stringWithFormat:@"%@ %@", self.firstName, self.lastName];
    }
    return nil;
}

// 复制人物
- (instancetype)copyWithZone:(NSZone *)zone
{
    Person *person = [[Person alloc] init];
    person.firstName = self.firstName;
    person.lastName = self.lastName;
    return person;
}

@end

#pragma mark - 判断方法

@implementation Student

@end

@interface CommonUseViewController ()

@end

@implementation CommonUseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self useSharedApplication];
}

#pragma mark - sharedApplication

- (void)useSharedApplication
{
    // 获得UIApplicationDelegate对象
    [[UIApplication sharedApplication] delegate];
    
    // 获得UIWindow对象
    [[UIApplication sharedApplication] keyWindow];
    
    // 打开设置界面
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
    
    // 远程的控制相关
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    
    // 不让手机休眠
    [UIApplication sharedApplication].idleTimerDisabled = YES;
   
    // 后台剩余时间
    NSTimeInterval remainTime = [[UIApplication sharedApplication] backgroundTimeRemaining];
    NSLog(@"剩余时间 = %f",remainTime);
    
    // 后台刷新的状态
    [[UIApplication sharedApplication] backgroundRefreshStatus];
    
    // 开启/关闭任务
    [[UIApplication sharedApplication] beginBackgroundTaskWithName:@"task" expirationHandler:^{
    }];
    [[UIApplication sharedApplication] endBackgroundTask:1];
}

#pragma mark - 重写

- (void)useCover
{
    Animal *animal = [[Animal alloc] init];
    animal.name = @"xiejiapei";
    animal.age = @"23";
    NSLog(@"重写了description后，源对象为：%@",[animal description]);
    NSLog(@"源对象hash为：%lu",(unsigned long)[animal hash]);
    
    Animal *copyAnimal = [animal copy];
    NSLog(@"copy对象为：%@",copyAnimal);
    
    if ([copyAnimal isEqual:animal])
    {
        NSLog(@"两个对象相等");
    }
}

#pragma mark - 复制

- (void)useCopy
{
    // 两个源数组
    NSArray *sourceArrayI = [NSArray arrayWithObjects:@"I", @"II", nil];
    NSMutableArray *sourceArrayM = [NSMutableArray arrayWithObjects:@"M", @"MM", nil];
    NSLog(@"不可变原数组I：%@",sourceArrayI);
    NSLog(@"可变原数组M：%@",sourceArrayM);
    
    // 两个copy
    NSArray *copyArrayI = [sourceArrayI copy];
    NSArray *copyArrayM = [sourceArrayM copy];
    NSLog(@"=============使用copy后=============");
    if ([sourceArrayI isEqualToArray:copyArrayI])
    {
        NSLog(@"【不可变原数组I】NSArray——>copy——>NSArray");
    }
    
    if ([sourceArrayM isEqualToArray:copyArrayM])
    {
        NSLog(@"【可变原数组M】NSMutableArray——>copy——>NSArray");
    }
    
    // 两个mutableCopy
    NSMutableArray *mutableArrayI = [sourceArrayI mutableCopy];
    NSMutableArray *mutableArrayM = [sourceArrayM mutableCopy];
    NSLog(@"=============使用mutableCopy后=============");
    NSLog(@"【不可变原数组I】NSArray——>mutableCopy——>NSMutableArray，变为：%@",mutableArrayI);
    NSLog(@"【可变原数组M】NSMutableArray——>mutableCopy——>NSMutableArray，变为：%@",mutableArrayM);
    
    // 对象拷贝
    Person *aPerson = [[Person alloc] init];
    Person *copyPerson = [aPerson copy];
    NSLog(@"源对象为：%@",aPerson);
    NSLog(@"copy对象为：%@",copyPerson);
    NSLog(@"copy对象的姓名为：%@", [copyPerson fullName]);
}

#pragma mark - 判断方法

- (void)useJudgment
{
    // 初始化对象
    Person *person = [Person new];
    Student *studentXie = [Student new];
    Student *studentFan = studentXie;

    // 判断对象是否是个代理
    if ([studentXie isProxy])
    {
        NSLog(@"student对象是个代理");
    }

    // 判断两个对象是否相等
    if ([studentXie isEqual:studentFan])
    {
        NSLog(@"studentXie对象与studentFan对象相等，两位同学可能是同一个人");
    }

    // 判断对象是否是指定类
    if ([person isKindOfClass:[Person class]])
    {
        NSLog(@"person对象是Person类，即人是人类");
    }

    // 判断对象是否是指定类或子类
    if ([studentXie isKindOfClass:[Person class]])
    {
        NSLog(@"studentXie对象是Person类的子类，谢同学再颓废没有生气也是个活生生的人呀");
    }

    // 判断某个类是否是另一个类的子类
    if ([Student isSubclassOfClass:[Person class]])
    {
        NSLog(@"Student类是Person类的子类");
    }

    // 判判断对象是否遵从协议
    if ([studentXie conformsToProtocol:@protocol(NSObject)])
    {
        NSLog(@"studentXie对象遵循NSObject协议");
    }

    // 判断类是否遵从给定的协议
    if ([Student conformsToProtocol:@protocol(NSObject)])
    {
        NSLog(@"Student类遵循NSObject协议");
    }

    // 判断对象是否能够调用给定的方法
    if ([studentXie respondsToSelector:@selector(run)])
    {
        NSLog(@"student对象可以调用run方法");
    }

    // 判断实例是否能够调用给定的方法
    if ([Student instancesRespondToSelector:@selector(run)])
    {
        NSLog(@"Student类可以调用run方法");
    }
}

@end
