//
//  ManualKVOViewController.m
//  KVO_KVC_Demo
//
//  Created by 谢佳培 on 2020/9/25.
//

#import "ManualKVOViewController.h"

@implementation Target

- (id) init
{
    self = [super init];
    if (nil != self)
    {
        age = 10;
    }
    
    return self;
}

// 手动 KVO - 监听age
- (int)age
{
    return age;
}

// 需要手动实现属性的 setter 方法
- (void)setAge:(int)theAge
{
    // 在设置操作的前后分别调用 willChangeValueForKey: 和 didChangeValueForKey方法
    // 这两个方法用于通知系统该 key 的属性值即将和已经变更了
    // 如果需要禁用该类KVO的话，实现属性的 setter 方法，不进行调用willChangeValueForKey: 和 didChangeValueForKey方法
    NSLog(@"age改变前为：%d",age);
    [self willChangeValueForKey:@"age"]; //KVO 在调用存取方法之前调用
    age = theAge;
    [self didChangeValueForKey:@"age"];
    NSLog(@"age改变后为：%d",age);//KVO 在调用存取方法之后调用
}

// 要实现类方法 automaticallyNotifiesObserversForKey，并在其中设置对该 key 不自动发送通知（返回 NO 即可）
+ (BOOL)automaticallyNotifiesObserversForKey:(NSString *)key
{
    if ([key isEqualToString:@"age"]) {// 禁用该属性的KVO
        return NO;
    }

    // 对其它非手动实现的 key，要转交给 super 来处理
    // 如果需要禁用该类KVO的话直接返回NO
    return [super automaticallyNotifiesObserversForKey:key];
}

@end

@interface ManualKVOViewController ()

@property(nonatomic, strong) Target *target;

@end

@implementation ManualKVOViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    Target *target = [[Target alloc] init];
    [target addObserver:self forKeyPath:@"age" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:(__bridge void * _Nullable)([Target class])];
    target.age = 20;
    self.target = target;
}

- (void)dealloc
{
    [self.target removeObserver:self forKeyPath:@"age"];
}

// 处理变更通知
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"age"])
    {
        Class classInfo = (__bridge Class)context;
        NSString * className = [NSString stringWithCString:object_getClassName(classInfo)
                                                  encoding:NSUTF8StringEncoding];
        NSLog(@" class: %@, Age changed", className);

        NSLog(@" old age is %@", [change objectForKey:@"old"]);
        NSLog(@" new age is %@", [change objectForKey:@"new"]);
    }
    else
    {
        [super observeValueForKeyPath:keyPath
                             ofObject:object
                               change:change
                              context:context];
    }
}


@end
