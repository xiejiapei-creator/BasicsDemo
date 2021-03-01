//
//  NSObject+CustomKVOAdvanced.m
//  KVO_KVC_Demo
//
//  Created by 谢佳培 on 2021/2/23.
//

#import "NSObject+CustomKVOAdvanced.h"
#import <objc/message.h>

static NSString *const kAdvancedKVOPrefix = @"KVO_Notifying_";
static NSString *const kAdvancedKVOAssiociateKey = @"KVO_AssiociateKey";

@implementation NSObject (CustomKVOAdvanced)

#pragma mark - 接口方法

- (void)customAdvancedAddObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(KeyValueObservingOptions)options context:(void *)context handBlock:(KVOBlock)handBlock
{
    // 1: 验证setter方法
    [self judgeSetterMethodFromKeyPath:keyPath];
    
    // 2: 动态生成子类
    Class newClass = [self creatAdvancedChildClass:keyPath];
    
    // 3：isa指向动态生成的子类
    object_setClass(self,newClass);
    
    // 4: 保存多个观察者的信息
    KVOInfo *info = [[KVOInfo alloc] initWithObserver:observer forKeyPath:keyPath options:options handBlock:handBlock];
    
    NSMutableArray *infoArray = objc_getAssociatedObject(self, (__bridge const void * _Nonnull)(kAdvancedKVOAssiociateKey));
    if (!infoArray)
    {
        infoArray = [NSMutableArray arrayWithCapacity:1];
        objc_setAssociatedObject(self, (__bridge const void * _Nonnull)(kAdvancedKVOAssiociateKey), infoArray, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    [infoArray addObject:info];
}

- (void)customAdvancedRemoveObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath
{
    NSMutableArray *infoArray = objc_getAssociatedObject(self, (__bridge const void * _Nonnull)(kAdvancedKVOAssiociateKey));

    [infoArray enumerateObjectsUsingBlock:^(KVOInfo *info , NSUInteger idx, BOOL * _Nonnull stop)
    {
        if ([info.keyPath isEqualToString:keyPath] && (observer == info.observer))
        {
            [infoArray removeObject:info];
            *stop = YES;
        }
    }];
    
    // 如果关联数组为空，则移除关联数组
    if (infoArray.count == 0)
    {
        objc_removeAssociatedObjects(infoArray);
    }
    
    // isa重新指向原类
    Class superClass = [self class];
    object_setClass(self, superClass);
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
- (Class)creatAdvancedChildClass:(NSString *)keyPath
{
    // 子类名称
    NSString *oldClassName = NSStringFromClass([self class]);
    NSString *newClassName = [NSString stringWithFormat:@"%@%@",kAdvancedKVOPrefix,oldClassName];
    Class newClass = NSClassFromString(newClassName);
    // 防止重复创建新类
    if (newClass) return newClass;
    // 创建子类
    newClass = objc_allocateClassPair([self class], newClassName.UTF8String, 0);
    // 注册子类
    objc_registerClassPair(newClass);
    
    // 为子类添加class方法，class指向的是原始类
    SEL classSEL = NSSelectorFromString(@"class");
    Method classMethod = class_getInstanceMethod([self class], classSEL);
    const char *type = method_getTypeEncoding(classMethod);
    class_addMethod(newClass, classSEL, (IMP)customAdvancedClass, type);
    
    // 重写子类的setter方法
    SEL setterSEL = NSSelectorFromString(setterForGetter(keyPath));
    Method setterMethod = class_getInstanceMethod([self class], setterSEL);
    const char *setterType = method_getTypeEncoding(setterMethod);
    class_addMethod(newClass, setterSEL, (IMP)customSetter, setterType);
    
    // 为子类添加dealloc方法
    SEL deallocSEL = NSSelectorFromString(@"dealloc");
    Method deallocMethod = class_getInstanceMethod([self class], deallocSEL);
    const char *deallocTypes = method_getTypeEncoding(deallocMethod);
    class_addMethod(newClass, deallocSEL, (IMP)customDealloc, deallocTypes);
    
    return newClass;
}

#pragma mark - 子类添加的方法

// 子类的Superclass为原始类
Class customAdvancedClass(id self,SEL _cmd)
{
    return class_getSuperclass(object_getClass(self));
}

// 重写子类的setter方法
static void customSetter(id self,SEL _cmd,id newValue)
{
    // 获取旧值
    NSString *keyPath = getterForSetter(NSStringFromSelector(_cmd));
    id oldValue = [self valueForKey:keyPath];
    NSLog(@"customSetter方法中，旧值为：%@，新值为：%@",oldValue,newValue);
    
    // 给父类发送消息
    void (*objc_msgSendSuperCasted)(void *, SEL, id) = (void *)objc_msgSendSuper;
    struct objc_super custom_objc_super =
    {
        .receiver = self,
        .super_class = class_getSuperclass(object_getClass(self)),
    };
    objc_msgSendSuperCasted(&custom_objc_super,_cmd,newValue);

    // 获取通过关联属性存储的观察者
    NSMutableArray *infoArray = objc_getAssociatedObject(self, (__bridge const void * _Nonnull)(kAdvancedKVOAssiociateKey));
    
    for (KVOInfo *info in infoArray)
    {
        if ([info.keyPath isEqualToString:keyPath])
        {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                NSMutableDictionary<NSKeyValueChangeKey,id> *change = [NSMutableDictionary dictionaryWithCapacity:1];
                
                if (info.options & KeyValueObservingOptionNew)// 新值
                {
                    [change setObject:newValue forKey:NSKeyValueChangeNewKey];
                }
                
                if (info.options & KeyValueObservingOptionOld && oldValue)// 旧值
                {
                    [change setObject:oldValue forKey:NSKeyValueChangeOldKey];
                }
                
                if (info.handBlock)
                {
                    info.handBlock(info.observer, keyPath, oldValue, newValue);
                }
            });
        }
    }
}

static void customDealloc(id self,SEL _cmd)
{
    // isa指回原类
    Class superClass = [self class]; 
    object_setClass(self, superClass);

    NSLog(@"自定义KVO类被销毁了");
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
