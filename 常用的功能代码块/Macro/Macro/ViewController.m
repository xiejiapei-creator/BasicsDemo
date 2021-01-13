//
//  ViewController.m
//  Macro
//
//  Created by 谢佳培 on 2020/11/25.
//

#import "ViewController.h"
#import "SystemVersion.h"
#import "RemoveNiL.h"
#import "RemoveWarning.h"
#import "CreateObject.h"
#import "Block.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self testRemoveNiL];
}

// 判断系统版本
- (void)testSystemVersion
{
    if (SYSTEM_VERSION_GREATER_THAN(@"13.0"))
    {
        NSLog(@"系统当前版本号为14.2");
    }
}

// 移除Nil
- (void)testRemoveNiL
{
    NSString *name = nil;
    NSString *phone = nil;
    NSString *provinceName = @"福建省";
    
    NSString *detailAddress = [NSString stringWithFormat:@"%@ %@ %@",
                               StrNilToValue(name,@"谢佳培"),
                               StrRemoveNiL(phone),
                               StrRemoveNiL(provinceName)];
    NSLog(@"收货地址：%@",detailAddress);
}

@end
