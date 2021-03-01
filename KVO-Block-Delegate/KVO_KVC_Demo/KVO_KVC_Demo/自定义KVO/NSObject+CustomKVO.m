//
//  NSObject+CustomKVO.m
//  KVO_KVC_Demo
//
//  Created by 谢佳培 on 2021/2/22.
//

#import "NSObject+CustomKVO.h"
#import <objc/message.h>

static NSString *const kKVOPrefix = @"KVO_Notifying_";
static NSString *const kKVOAssiociateKey = @"KVO_AssiociateKey";

@implementation NSObject (CustomKVO)

#pragma mark - 接口方法

- (void)customAddObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context
{
    // 1: 验证setter方法
    [self judgeSetterMethodFromKeyPath:keyPath];
    
    // 2: 动态生成子类
    Class newClass = [self creatChildClass:keyPath];
    // isa指向动态生成的子类
    object_setClass(self,newClass);
    
    // 4: 保存观察者
    objc_setAssociatedObject(self, (__bridge const void * _Nonnull)(kKVOAssiociateKey), observer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)customObserveValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    
}

- (void)customRemoveObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath
{
    
}

#pragma mark - 辅助方法

// 验证是否存在setter方法
- (void)judgeSetterMethodFromKeyPath:(NSString *)keyPath
{
    Class superClass = object_getClass(self);
    SEL setterSeletor = NSSelectorFromString(setterForGetter(keyPath));
    Method setterMethod = class_getInstanceMethod(superClass, setterSeletor);
    if (!setterMethod)
    {
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"%@的setter方法不存在",keyPath] userInfo:nil];
    }
}

// 动态生成子类：KVO_Notifying_Person - Person
- (Class)creatChildClass:(NSString *)keyPath
{
    // 子类名称
    NSString *oldName = NSStringFromClass([self class]);
    NSString *newName = [NSString stringWithFormat:@"%@%@",kKVOPrefix,oldName];
    
    // 注册子类
    Class newClass = objc_allocateClassPair([self class], newName.UTF8String, 0);
    objc_registerClassPair(newClass);
    
    // 为子类添加class方法
    SEL classSEL = NSSelectorFromString(@"class");
    Method classMethod = class_getInstanceMethod([self class], classSEL);
    const char *type = method_getTypeEncoding(classMethod);
    class_addMethod(newClass, classSEL, (IMP)customClass, type);
    
    // 重写子类的setter方法
    SEL setterSEL = NSSelectorFromString(setterForGetter(keyPath));
    Method setterMethod = class_getInstanceMethod([self class], setterSEL);
    const char *setterType = method_getTypeEncoding(setterMethod);
    class_addMethod(newClass, setterSEL, (IMP)customSetter, setterType);
    
    return newClass;
}

#pragma mark - 子类添加的方法

// 子类的Superclass为原始类
Class customClass(id self,SEL _cmd)
{
    return class_getSuperclass([self class]);
}

// 重写子类的setter方法
static void customSetter(id self,SEL _cmd,id newValue)
{
    NSString *keyPath = getterForSetter(NSStringFromSelector(_cmd));

    [self willChangeValueForKey:keyPath];

    // 给父类发送消息
    void (*custom_objc_msgSendSuper)(id,SEL,id,id,void *) = (void *)objc_msgSend;
    void (*objc_msgSendSuperCasted)(void *, SEL, id) = (void *)objc_msgSendSuper;
    struct objc_super custom_objc_super =
    {
        .receiver = self,
        .super_class = class_getSuperclass(object_getClass(self)),
    };
    objc_msgSendSuperCasted(&custom_objc_super,_cmd,newValue);

    [self didChangeValueForKey:keyPath];

    // 获取通过关联属性存储的观察者
    id observer = objc_getAssociatedObject(self, (__bridge const void * _Nonnull)(kKVOAssiociateKey));

    // 响应回调
    SEL obserSEL = @selector(observeValueForKeyPath:ofObject:change:context:);
    custom_objc_msgSendSuper(observer, obserSEL, self, @{keyPath:newValue},NULL);
}

#pragma mark - Setter/Getter的名称转化

// 通过get方法获取到set方法的名称 key ===>>> setKey:
static NSString *setterForGetter(NSString *getter)
{
    if (getter.length <= 0) { return nil;}
    
    NSString *firstString = [[getter substringToIndex:1] uppercaseString];
    NSString *leaveString = [getter substringFromIndex:1];
    
    return [NSString stringWithFormat:@"set%@%@:",firstString,leaveString];
}

// 通过set方法获取到get方法的名称 set<Key>:===> key
static NSString *getterForSetter(NSString *setter)
{
    if (setter.length <= 0 || ![setter hasPrefix:@"set"] || ![setter hasSuffix:@":"])
    {
        return nil;
    }
    
    NSRange range = NSMakeRange(3, setter.length-4);
    NSString *getter = [setter substringWithRange:range];
    NSString *firstString = [[getter substringToIndex:1] lowercaseString];
    
    return  [getter stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:firstString];
}

@end
