//
//  testUIViewViewController.m
//  CategoryDemo
//
//  Created by 谢佳培 on 2020/11/3.
//

#import "testUIViewViewController.h"
#import "UIView+Custom.h"

@interface testUIViewViewController ()

@end

@implementation testUIViewViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(100, 300, 200, 50)];
    label.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:label];
    
    NSLog(@"Label的X坐标：%f，Y坐标：%f",[label x],[label y]);
    NSLog(@"Label的宽：%f，高：%f",[label width],[label height]);
    NSLog(@"Label的右边坐标：%f，底部坐标：%f",[label right],[label bottom]);
    NSLog(@"Label的中心点X坐标：%f，中心点Y坐标：%f",[label centerX],[label centerY]);
    NSLog(@"Label的起始点X坐标：%f，起始点Y坐标：%f",[label origin].x,[label origin].y);
}

@end
