//
//  KVOPrincipleViewController.m
//  KVO_KVC_Demo
//
//  Created by 谢佳培 on 2021/2/22.
//

#import "KVOPrincipleViewController.h"
#import "KVOPrincipleModel.h"
#import <objc/runtime.h>

@interface KVOPrincipleViewController ()

@property (nonatomic, strong) PrinciplePerson *person;
@property (nonatomic, strong) PrincipleStudent *student;

@end

@implementation KVOPrincipleViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self useKVO];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"实际值——昵称：%@，姓名：%@",self.person.nickName,self.person->name);
}

#pragma mark - KVO

- (void)useKVO
{
    NSLog(@"*******打印*********");
    [self printClassAllMethod:[PrinciplePerson class]];
    [self printClassAllMethod:[PrincipleStudent class]];
    [self printClasses:[PrinciplePerson class]];
    
    NSLog(@"*******中间类还不存在*********");
    self.person = [[PrinciplePerson alloc] init];
    //[self printClasses:NSClassFromString(@"NSKVONotifying_PrinciplePerson")];
    
    NSLog(@"*******产生了中间类*********");
    [self.person addObserver:self forKeyPath:@"nickName" options:(NSKeyValueObservingOptionNew) context:NULL];
    [self.person addObserver:self forKeyPath:@"name" options:(NSKeyValueObservingOptionNew) context:NULL];
    [self printClassAllMethod:NSClassFromString(@"NSKVONotifying_PrinciplePerson")];
    
    NSLog(@"*******改变成员变量和属性的值*********");
    self.person.nickName = @"JiaPei";
    self.person->name    = @"XieJiapei";// 通过setter方法改变
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    NSLog(@"观察到值的改变：%@",change);
}

- (void)dealloc
{
    [self.person removeObserver:self forKeyPath:@"name"];
    [self.person removeObserver:self forKeyPath:@"nickName"];
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
