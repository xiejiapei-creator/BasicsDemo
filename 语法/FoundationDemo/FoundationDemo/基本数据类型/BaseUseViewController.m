//
//  BaseUseViewController.m
//  BasicGrammarDemo
//
//  Created by 谢佳培 on 2020/10/20.
//

#import "BaseUseViewController.h"

@interface BaseUseViewController ()

@end

@implementation BaseUseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self useCG];
}

// BOOL
- (void)useBOOL
{
    BOOL hidden = YES;
    BOOL bigger = 0 > 1;
    
    if (-1)
    {
        NSLog(@"not 0 = YES");
    }
    
    NSObject *boolObj = [[NSObject alloc] init];
    if (boolObj)
    {
        NSLog(@"not nil = YES");
    }
}

// NSNumber
- (void)useNSNumber
{
    NSNumber *intNumber = @(-1);
    NSNumber *boolNumber = @(YES);
    NSNumber *charNumber = @('A');
    NSLog(@"int(-1)值：%@，bool(YES)值：%@ ，char(A)值：%@", intNumber, boolNumber, charNumber);
    NSLog(@"字面A的charValue值：%d，stringValue值：%@，intValue值：%d", charNumber.charValue, charNumber.stringValue, charNumber.intValue);
}

// NSData
- (void)useNSData
{
    NSString *dataString = @"XieJiaPei";
    NSData *data = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"string(XieJiaPei) 转化为 data：%@", data);
    
    NSData *zeroData = [NSData data];
    NSLog(@"空数据为：%@", zeroData);
    
    NSMutableData *appendData = [zeroData mutableCopy];
    [appendData appendData:data];
    NSLog(@"在空数据后追加数据后结果为：%@", appendData);
}

// CG
- (void)useCG
{
    // 状态栏高度
    CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    NSLog(@"状态栏高度:%f",statusBarHeight);
    
    // 如何把一个CGPoint存入数组里
    CGPoint point = CGPointMake(0, 0);
    NSMutableArray *array = [[NSMutableArray alloc] initWithObjects:NSStringFromCGPoint(point), nil];
    point = CGPointFromString(array[0]);
    NSLog(@"如何把一个CGPoint存入数组里: %@",array);
}

@end







