//
//  KVODependentKeyViewController.m
//  KVO_KVC_Demo
//
//  Created by 谢佳培 on 2020/9/25.
//

#import "KVODependentKeyViewController.h"

@implementation TargetObject

- (id) init
{
    self = [super init];
    if (nil != self)
    {
        _age = 10;
        _grade = 5;
    }
    
    return self;
}

@end

@implementation TargetWrapper
 
- (id)init:(TargetObject *)aTarget
{
    self = [super init];
    if (nil != self) {
        _target = aTarget;
    }
    return self;
}
 
- (NSString *)information
{
    // information 属性依赖于 target 的 age 和 grade 属性
    return [[NSString alloc] initWithFormat:@"%d#%d", _target.grade, _target.age];
}

- (void)setInformation:(NSString *)theInformation
{
    // target 的 age/grade 属性任一发生变化，information 的观察者都会得到通知
    NSArray * array = [theInformation componentsSeparatedByString:@"#"];
    [_target setGrade:[[array objectAtIndex:0] intValue]];
    [_target setAge:[[array objectAtIndex:1] intValue]];
}

// 告诉系统 information 属性依赖于哪些其他属性
+ (NSSet *)keyPathsForValuesAffectingInformation
{
    NSSet * keyPaths = [NSSet setWithObjects:@"target.age", @"target.grade", nil];
    
    // 返回一个key-path 的集合
    return keyPaths;
}

// 实现 keyPathsForValuesAffectingInformation 或 keyPathsForValuesAffectingValueForKey: 方法
/*
+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key
{
    // 要先获取 super 返回的结果 set
    NSSet * keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
    NSArray * moreKeyPaths = nil;

    // 然后判断 key 是不是目标 key
    if ([key isEqualToString:@"information"])
    {
        moreKeyPaths = [NSArray arrayWithObjects:@"target.age", @"target.grade", nil];
    }

    if (moreKeyPaths)
    {
        // 如果是就将依赖属性的 key-path 结合追加到 super 返回的结果 set 中
        // 否则直接返回 super的结果
        keyPaths = [keyPaths setByAddingObjectsFromArray:moreKeyPaths];
    }

    return keyPaths;
}
*/

@end

@interface KVODependentKeyViewController ()

@property(nonatomic, strong) TargetWrapper *wrapper;

@end

@implementation KVODependentKeyViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    TargetObject *target = [[TargetObject alloc] init];
    TargetWrapper * wrapper = [[TargetWrapper alloc] init:target];
    [wrapper addObserver:self
    forKeyPath:@"information"
       options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                 context:(__bridge void * _Nullable)([TargetWrapper class])];

    [target setAge:100];
    [target setGrade:55];

    self.wrapper = wrapper;
}

- (void)dealloc
{
    [self.wrapper removeObserver:self forKeyPath:@"information"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"information"])
    {
        Class classInfo = (__bridge Class)context;
        NSString * className = [NSString stringWithCString:object_getClassName(classInfo)
                                                  encoding:NSUTF8StringEncoding];
        NSLog(@" class: %@, Information changed", className);
        NSLog(@" old information is %@", [change objectForKey:@"old"]);
        NSLog(@" new information is %@", [change objectForKey:@"new"]);
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





