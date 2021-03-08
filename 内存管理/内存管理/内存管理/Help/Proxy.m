//
//  Proxy.m
//  内存管理
//
//  Created by 谢佳培 on 2021/3/3.
//

#import "Proxy.h"

@interface Proxy()

@property (nonatomic, weak) id object;

@end

@implementation Proxy

+ (instancetype)proxyWithTransformObject:(id)object
{
    Proxy *proxy = [Proxy alloc];
    proxy.object = object;
    return proxy;
}

// 外界的target对象为self.proxy，由于self.proxy没有实现selector方法所以就进入了消息转发流程
- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector
{
    // 指定消息转发的接受者为self.object
    return [self.object methodSignatureForSelector:selector];
}

- (void)forwardInvocation:(NSInvocation *)invocation
{
    // 指定方法的响应者为self.object
    [invocation invokeWithTarget:self.object];
}

@end
