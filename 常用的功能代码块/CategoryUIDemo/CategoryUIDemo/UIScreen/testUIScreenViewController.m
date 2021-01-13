//
//  testUIScreenViewController.m
//  CategoryDemo
//
//  Created by 谢佳培 on 2020/11/3.
//

#import "testUIScreenViewController.h"
#import "UIScreen+Custom.h"

@interface testUIScreenViewController ()

@end

@implementation testUIScreenViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"屏幕尺寸的宽：%f，高：%f，缩放率：%f",[UIScreen width],[UIScreen height],[UIScreen scale]);
}

@end
