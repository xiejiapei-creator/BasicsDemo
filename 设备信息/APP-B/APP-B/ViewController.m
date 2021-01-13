//
//  ViewController.m
//  APP-B
//
//  Created by 谢佳培 on 2020/9/4.
//  Copyright © 2020 xiejiapei. All rights reserved.
//

#import "ViewController.h"
#import "WasteMaterialsViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"App-B";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"废材" style:UIBarButtonItemStylePlain target:self action:@selector(wasteMaterials)];
    self.navigationItem.rightBarButtonItem = rightButton;
}

- (void)wasteMaterials
{
    WasteMaterialsViewController *vc = [[WasteMaterialsViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES]; 
}

@end
