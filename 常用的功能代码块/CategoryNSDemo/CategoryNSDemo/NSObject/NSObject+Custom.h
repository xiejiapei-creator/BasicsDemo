//
//  NSObject+Custom.h
//  CategoryNSDemo
//
//  Created by 谢佳培 on 2020/11/4.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (Custom)

#pragma mark - AssociatedObject
/*
 id object ：关联的源对象
 const void *key：关联的key
 id value：关联对象，通过将此个值置成nil来清除关联
 objc_AssociationPolicy policy：关联的策略

 关键策略是一个enum值
 OBJC_ASSOCIATION_ASSIGN = 0,      <指定一个弱引用关联的对象>
 OBJC_ASSOCIATION_RETAIN_NONATOMIC = 1,<指定一个强引用关联的对象>
 OBJC_ASSOCIATION_COPY_NONATOMIC = 3,  <指定相关的对象复制>
 OBJC_ASSOCIATION_RETAIN = 01401,      <指定强参考>
 OBJC_ASSOCIATION_COPY = 01403    <指定相关的对象复制>
 */

- (id)getAssociatedValueForKey:(void *)key;

- (void)setAssociatedValue:(id)value withKey:(void *)key;

- (void)removeAssociatedObjects;

// ASSIGN
- (void)setAssignValue:(id)value withKey:(SEL)key;

// COPY
- (void)setCopyValue:(id)value withKey:(SEL)key;

@end

NS_ASSUME_NONNULL_END
