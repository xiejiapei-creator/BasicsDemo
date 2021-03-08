//
//  TimerWapper.m
//  内存管理
//
//  Created by 谢佳培 on 2021/3/3.
//

#import "TimerWapper.h"

@interface TimerWapper()

@property (nonatomic, weak) id target;
@property (nonatomic, assign) SEL aSelector;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation TimerWapper

// runloop-持有-timer-持有-中间变量
// self-持有-中间变量
- (instancetype)timerWapperInitWithTimeInterval:(NSTimeInterval)timeInterval target:(id)aTarget selector:(SEL)aSelector userInfo:(id)userInfo repeats:(BOOL)yesOrNo
{
    if (self == [super init])
    {
        self.target     = aTarget;
        self.aSelector  = aSelector;
        self.timer      = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(fireHome) userInfo:userInfo repeats:yesOrNo];
    }
    return self;
}

- (void)fireHome
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    // 让编译器出栈，恢复状态，继续编译后续的代码！
    if ([self.target respondsToSelector:self.aSelector])
    {
        [self.target performSelector:self.aSelector];
    }
#pragma clang diagnostic pop
}

- (void)timerWapperInvalidate
{
    [self.timer invalidate];
    self.timer = nil;
}

- (void)dealloc
{
    NSLog(@"销毁了计时器");
}


@end
