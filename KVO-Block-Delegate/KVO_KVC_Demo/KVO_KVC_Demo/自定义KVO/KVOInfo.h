//
//  KVOInfo.h
//  KVO_KVC_Demo
//
//  Created by 谢佳培 on 2021/2/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_OPTIONS(NSUInteger, KeyValueObservingOptions)
{
    KeyValueObservingOptionNew = 0x01,
    KeyValueObservingOptionOld = 0x02,
};

typedef void(^KVOBlock)(NSObject *observer,NSString *keyPath,id oldValue ,id newValue);

@interface KVOInfo : NSObject

@property (nonatomic, weak) NSObject *observer;
@property (nonatomic, copy) NSString *keyPath;
@property (nonatomic, assign) KeyValueObservingOptions options;
@property (nonatomic, copy) KVOBlock handBlock;

- (instancetype)initWithObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(KeyValueObservingOptions)options handBlock:(KVOBlock)handBlock;

@end

NS_ASSUME_NONNULL_END
