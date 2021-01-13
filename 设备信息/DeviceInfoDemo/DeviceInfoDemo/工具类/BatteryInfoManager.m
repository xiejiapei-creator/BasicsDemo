//
//  BatteryInfoManager.m
//  DeviceInfoDemo
//
//  Created by 谢佳培 on 2020/9/7.
//  Copyright © 2020 xiejiapei. All rights reserved.
//

#import "BatteryInfoManager.h"
#import "DeviceDataLibrery.h"

@interface BatteryInfoManager ()

@property (nonatomic, assign) BOOL batteryMonitoringEnabled;// 是否正在监测电量

@end

@implementation BatteryInfoManager

#pragma mark - 单例

+ (instancetype)sharedManager
{
    static BatteryInfoManager *_manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[BatteryInfoManager alloc] init];
    });
    return _manager;
}

#pragma mark - 监测电池

// 开始监测电池电量
- (void)startBatteryMonitoring
{
    if (!self.batteryMonitoringEnabled)
    {
        self.batteryMonitoringEnabled = YES;
        
        UIDevice *device = [UIDevice currentDevice];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(batteryLevelUpdated:) name:UIDeviceBatteryLevelDidChangeNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(batteryStatusUpdated:) name:UIDeviceBatteryStateDidChangeNotification object:nil];
        
        [device setBatteryMonitoringEnabled:YES];
        
        // If by any chance battery value is available - update it immediately
        if ([device batteryState] != UIDeviceBatteryStateUnknown)
        {
            [self doUpdateBatteryStatus];
        }
    }
}

#pragma mark - 更新

- (void)batteryLevelUpdated:(NSNotification*)notification
{
    [self doUpdateBatteryStatus];
}

- (void)batteryStatusUpdated:(NSNotification*)notification
{
    [self doUpdateBatteryStatus];
}

- (void)doUpdateBatteryStatus
{
    float batteryMultiplier = [[UIDevice currentDevice] batteryLevel];
    self.levelPercent = batteryMultiplier * 100;
    self.levelMAH =  self.capacity * batteryMultiplier;
    
    switch ([[UIDevice currentDevice] batteryState])
    {
        case UIDeviceBatteryStateCharging:// 充电
            if (self.levelPercent == 100)
            {
                self.status = @"Fully charged";
            }
            else
            {
                self.status = @"Charging";
            }
            break;
        case UIDeviceBatteryStateFull:// 满电
            self.status = @"Fully charged";
            break;
        case UIDeviceBatteryStateUnplugged:// 未插入
            self.status = @"Unplugged";
            break;
        case UIDeviceBatteryStateUnknown:// 未知
            self.status = @"Unknown";
            break;
    }
    
    // 状态更改
    [self.delegate batteryStatusUpdated];
}

#pragma mark - Setters && Getters

- (CGFloat)voltage
{
    return [[DeviceDataLibrery sharedLibrery] getBatterVolocity];
}

- (NSUInteger)capacity
{
    return [[DeviceDataLibrery sharedLibrery] getBatteryCapacity];
}

@end
