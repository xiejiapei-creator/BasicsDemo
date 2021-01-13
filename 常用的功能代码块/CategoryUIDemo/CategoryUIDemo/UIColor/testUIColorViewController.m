//
//  testUIColorViewController.m
//  CategoryDemo
//
//  Created by 谢佳培 on 2020/11/3.
//

#import "testUIColorViewController.h"
#import "UIColor+Custom.h"

@interface testUIColorViewController ()

@end

@implementation testUIColorViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(100, 300, 200, 50)];
    [self.view addSubview:label];
}


@end
