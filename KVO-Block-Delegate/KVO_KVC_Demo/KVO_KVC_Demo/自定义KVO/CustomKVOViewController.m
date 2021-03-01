//
//  CustomKVOViewController.m
//  KVO_KVC_Demo
//
//  Created by 谢佳培 on 2021/2/22.
//

#import "CustomKVOViewController.h"
#import "KVOPrincipleModel.h"
#import "NSObject+CustomKVO.h"
#import <objc/runtime.h>

@interface CustomKVOViewController ()

@end

@implementation CustomKVOViewController

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    NSLog(@"观察到值的改变：%@",change);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    PrinciplePerson *person = [[PrinciplePerson alloc] init];
    NSLog(@"未观察之前的class方法：%@",[person class]);
    
    NSLog(@"*******开始使用自定义的KVO进行观察*********");
    [person customAddObserver:self forKeyPath:@"nickName" options:(NSKeyValueObservingOptionNew) context:NULL];
    [self printClassAllMethod:NSClassFromString(@"KVO_Notifying_PrinciplePerson")];
    
    NSLog(@"*******改变属性的值*********");
    person.nickName = @"JiaPei";
}

#pragma mark - 辅助方法

// 遍历方法
- (void)printClassAllMethod:(Class)cls
{
    unsigned int count = 0;
    Method *methodList = class_copyMethodList(cls, &count);
    for (int i = 0; i<count; i++)
    {
        Method method = methodList[i];
        SEL sel = method_getName(method);
        IMP imp = class_getMethodImplementation(cls, sel);
        NSLog(@"方法名称：%@，方法的实现：%p",NSStringFromSelector(sel),imp);
    }
    free(methodList);
}

// 遍历类以及子类
- (void)printClasses:(Class)cls
{
    // 注册类的总数
    int count = objc_getClassList(NULL, 0);
    
    // 创建一个数组，其中包含给定对象
    NSMutableArray *mArray = [NSMutableArray arrayWithObject:cls];
    
    // 获取所有已注册的类
    Class* classes = (Class*)malloc(sizeof(Class)*count);
    objc_getClassList(classes, count);
    for (int i = 0; i<count; i++)
    {
        if (cls == class_getSuperclass(classes[i]))
        {
            [mArray addObject:classes[i]];
        }
    }
    free(classes);
    
    NSLog(@"所有已注册的类为：%@", mArray);
}

@end
