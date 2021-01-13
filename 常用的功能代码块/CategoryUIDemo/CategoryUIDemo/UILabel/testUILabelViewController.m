//
//  testUILabelViewController.m
//  CategoryDemo
//
//  Created by 谢佳培 on 2020/11/3.
//

#import "testUILabelViewController.h"
#import "UILabel+Custom.h"

@interface testUILabelViewController ()

@end

@implementation testUILabelViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self createHighlightLabel];
}

// 字体高亮显示
- (void)createHighlightLabel
{
    self.view.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(100, 300, 200, 50)];
    label.backgroundColor = [UIColor yellowColor];
    [label setHighlightfullString:@"天下第一的剑客" lightString:@"剑客" lightColor:nil lightFont:nil];
    [self.view addSubview:label];
}

@end
