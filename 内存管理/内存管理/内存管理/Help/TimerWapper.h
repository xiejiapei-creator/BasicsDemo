//
//  TimerWapper.h
//  内存管理
//
//  Created by 谢佳培 on 2021/3/3.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TimerWapper : NSObject

- (instancetype)timerWapperInitWithTimeInterval:(NSTimeInterval)timeInterval target:(id)aTarget selector:(SEL)aSelector userInfo:(nullable id)userInfo repeats:(BOOL)yesOrNo;

- (void)timerWapperInvalidate;

@end

NS_ASSUME_NONNULL_END
