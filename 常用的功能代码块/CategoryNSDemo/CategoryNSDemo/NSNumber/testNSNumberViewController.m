//
//  testNSNumberViewController.m
//  CategoryNSDemo
//
//  Created by 谢佳培 on 2020/11/25.
//

#import "testNSNumberViewController.h"
#import "NSNumber+Custom.h"

@interface testNSNumberViewController ()

@end

@implementation testNSNumberViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSNumber *firstNumber = @(7.1243545);
    NSNumber *secondNumber = @(3.093543325665);
    double result = [firstNumber minusDecimalNumber:secondNumber];
    NSLog(@"金额浮点数高精度减法运算，默认两位小数处理:%f",result);
    
    if ([firstNumber compareDecimalNumber:secondNumber])
    {
        NSLog(@"金额浮点数高精度比较，默认两位小数处理");
    }
}

@end
