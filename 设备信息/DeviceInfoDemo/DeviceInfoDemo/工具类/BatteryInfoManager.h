//
//  BatteryInfoManager.h
//  DeviceInfoDemo
//
//  Created by 谢佳培 on 2020/9/7.
//  Copyright © 2020 xiejiapei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol BatteryInfoDelegate

- (void)batteryStatusUpdated;

@end

@interface BatteryInfoManager : NSObject

#pragma mark - 单例

+ (instancetype)sharedManager;

@property (nonatomic, weak) id<BatteryInfoDelegate> delegate;

#pragma mark - 电量术语

// 电池容量，单位 mA 毫安
@property (nonatomic, assign) NSUInteger capacity;
// 电池电压，单位 V 福特
@property (nonatomic, assign) CGFloat voltage;
// 电池电量
@property (nonatomic, assign) NSUInteger levelPercent;
// 当前电池剩余电量
@property (nonatomic, assign) NSUInteger levelMAH;
@property (nonatomic, copy)   NSString *status;

#pragma mark - 监测电池电量

/** 开始监测电池电量 */
- (void)startBatteryMonitoring;
/** 停止监测电池电量 */
- (void)stopBatteryMonitoring;

@end

NS_ASSUME_NONNULL_END
