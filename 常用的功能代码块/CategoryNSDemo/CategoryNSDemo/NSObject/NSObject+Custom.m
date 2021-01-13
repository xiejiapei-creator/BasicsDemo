//
//  NSObject+Custom.m
//  CategoryNSDemo
//
//  Created by 谢佳培 on 2020/11/4.
//

#import "NSObject+Custom.h"
#import  <objc/runtime.h>

@implementation NSObject (Custom)

#pragma mark - AssociatedObject

- (id)getAssociatedValueForKey:(void *)key
{
    return objc_getAssociatedObject(self, key);
}

- (void)setAssociatedValue:(id)value withKey:(void *)key
{
    objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)removeAssociatedObjects
{
    objc_removeAssociatedObjects(self);
}

// ASSIGN
- (void)setAssignValue:(id)value withKey:(SEL)key
{
    objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_ASSIGN);
}

// COPY
- (void)setCopyValue:(id)value withKey:(SEL)key
{
    objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_COPY_NONATOMIC);
}



@end
