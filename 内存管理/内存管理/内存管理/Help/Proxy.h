//
//  Proxy.h
//  内存管理
//
//  Created by 谢佳培 on 2021/3/3.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

// 代理：相当于帮你解决杂务的秘书
@interface Proxy : NSProxy

+ (instancetype)proxyWithTransformObject:(id)object;

@end

NS_ASSUME_NONNULL_END
