//
//  NSObject+Custom.m
//  内存管理
//
//  Created by 谢佳培 on 2021/3/3.
//

#import "NSObject+Custom.h"

static int num = 0;

@implementation NSObject (Custom)

- (void)fireHome
{
    num++;
    NSLog(@"你好，大叔：%d",num);
}

@end
