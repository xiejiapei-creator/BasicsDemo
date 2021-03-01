//
//  NSObject+CustomKVOAdvanced.h
//  KVO_KVC_Demo
//
//  Created by 谢佳培 on 2021/2/23.
//

#import <Foundation/Foundation.h>
#import "KVOInfo.h"

@interface NSObject (CustomKVOAdvanced)

- (void)customAdvancedAddObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(KeyValueObservingOptions)options context:(void *)context handBlock:(KVOBlock)handBlock;

- (void)customAdvancedRemoveObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath;

@end
 
