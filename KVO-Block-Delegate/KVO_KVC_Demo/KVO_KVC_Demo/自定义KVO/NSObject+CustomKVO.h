//
//  NSObject+CustomKVO.h
//  KVO_KVC_Demo
//
//  Created by 谢佳培 on 2021/2/22.
//

#import <Foundation/Foundation.h>

//NS_ASSUME_NONNULL_BEGIN

@interface NSObject (CustomKVO)

- (void)customAddObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context;

- (void)customObserveValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey, id> *)change context:(void *)context;

- (void)customRemoveObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath;

@end

//NS_ASSUME_NONNULL_END
