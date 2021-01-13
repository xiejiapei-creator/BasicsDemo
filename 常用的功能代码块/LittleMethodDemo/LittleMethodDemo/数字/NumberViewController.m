//
//  NumberViewController.m
//  LittleMethodDemo
//
//  Created by 谢佳培 on 2020/11/3.
//

#import "NumberViewController.h"

@interface NumberViewController ()

@end

@implementation NumberViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    int randomNumber = [self getRandomNumber:0 to:100];
    NSLog(@"随机数：%d",randomNumber);
}

// 获取一个随机整数，范围在[from,to]，包括from，包括to
- (int)getRandomNumber:(int)from to:(int)to
{
    return (int)(from + (arc4random() % (to - from + 1)));
}

@end
