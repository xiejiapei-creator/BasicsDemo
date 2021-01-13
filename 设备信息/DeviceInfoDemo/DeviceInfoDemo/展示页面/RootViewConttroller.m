//
//  RootViewConttroller.m
//  DeviceInfoDemo
//
//  Created by 谢佳培 on 2020/9/7.
//  Copyright © 2020 xiejiapei. All rights reserved.
//

#import "RootViewConttroller.h"
#import "BasicInfoViewController.h"
#import "DeviceInfoManager.h"

@implementation RootViewConttroller

#pragma mark - Life Circle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[DeviceInfoManager sharedManager] registerNotification];
    [[DeviceInfoManager sharedManager] openNotification];

    UIButton *hardWareButton = [[UIButton alloc] initWithFrame:CGRectMake(50, 100, 300, 80)];
    hardWareButton.backgroundColor = [UIColor blackColor];
    [hardWareButton setTitle:@"HardWareInfo" forState:UIControlStateNormal];
    [hardWareButton addTarget:self action:@selector(hardWareInfoButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:hardWareButton];
    
    UIButton *batteryButton = [[UIButton alloc] initWithFrame:CGRectMake(50, 200, 300, 80)];
    batteryButton.backgroundColor = [UIColor blackColor];
    [batteryButton setTitle:@"BatteryInfo" forState:UIControlStateNormal];
    [batteryButton addTarget:self action:@selector(batteryInfoButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:batteryButton];
    
    UIButton *addressButton = [[UIButton alloc] initWithFrame:CGRectMake(50, 300, 300, 80)];
    addressButton.backgroundColor = [UIColor blackColor];
    [addressButton setTitle:@"AddressInfo" forState:UIControlStateNormal];
    [addressButton addTarget:self action:@selector(addressInfoButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addressButton];
    
    UIButton *CPUButton = [[UIButton alloc] initWithFrame:CGRectMake(50, 400, 300, 80)];
    CPUButton.backgroundColor = [UIColor blackColor];
    [CPUButton setTitle:@"CPUInfo" forState:UIControlStateNormal];
    [CPUButton addTarget:self action:@selector(CPUInfoButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:CPUButton];
    
    UIButton *diskButton = [[UIButton alloc] initWithFrame:CGRectMake(50, 500, 300, 80)];
    diskButton.backgroundColor = [UIColor blackColor];
    [diskButton setTitle:@"DiskInfo" forState:UIControlStateNormal];
    [diskButton addTarget:self action:@selector(diskInfoButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:diskButton];
}

#pragma mark - Events

// HardWare VC
- (void)hardWareInfoButtonTapped:(id)sender
{
    [self pushVCWithType:BasicInfoTypeHardWare sender:sender];
}

// Battery VC
- (void)batteryInfoButtonTapped:(id)sender
{
    [self pushVCWithType:BasicInfoTypeBattery sender:sender];
}

// IpAddress VC
- (void)addressInfoButtonTapped:(id)sender
{
    [self pushVCWithType:BasicInfoTypeIpAddress sender:sender];
}

// CPU VC
- (void)CPUInfoButtonTapped:(id)sender
{
    [self pushVCWithType:BasicInfoTypeCPU sender:sender];
}

// Disk VC
- (void)diskInfoButtonTapped:(id)sender
{
    [self pushVCWithType:BasicInfoTypeDisk sender:sender];
}

// 进入信息页面
- (void)pushVCWithType:(BasicInfoType)type sender:(UIButton *)sender {
    BasicInfoViewController *basicVC = [[BasicInfoViewController alloc] initWithType:type];
    basicVC.navigationItem.title = sender.titleLabel.text;
    [self.navigationController pushViewController:basicVC  animated:YES];
}

@end
