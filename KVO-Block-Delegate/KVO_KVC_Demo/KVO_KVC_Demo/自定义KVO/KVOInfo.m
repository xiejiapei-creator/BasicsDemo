//
//  KVOInfo.m
//  KVO_KVC_Demo
//
//  Created by 谢佳培 on 2021/2/23.
//

#import "KVOInfo.h"

@implementation KVOInfo

- (instancetype)initWithObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(KeyValueObservingOptions)options handBlock:(KVOBlock)handBlock
{
    if (self = [super init])
    {
        self.observer = observer;
        self.keyPath  = keyPath;
        self.options  = options;
        self.handBlock= handBlock;
    }
    return self;
}

- (void)dealloc
{
    NSLog(@"KVOInfo类观察者：%@",self.observer);
    NSLog(@"KVOInfo类被销毁了");
}

@end
