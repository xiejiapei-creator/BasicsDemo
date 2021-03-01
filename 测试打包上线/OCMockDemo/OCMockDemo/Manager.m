//
//  Manager.m
//  OCMockDemo
//
//  Created by 谢佳培 on 2021/2/27.
//

#import "Manager.h"

@implementation Dog

@end

@implementation IDCardView

- (void)dogIDCardView:(Dog *)dog
{
    NSLog(@"为🐶创建身份证");
}

@end

@implementation Manager

- (NSArray *)fetchDogs
{
    return @[];
}

- (void)fetchDogsWithBlock:(void (^)(NSDictionary *result, NSError *error))block
{
    block(@{@"旺仔":@"发财"},nil);
}

@end
