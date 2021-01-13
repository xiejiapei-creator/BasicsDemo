//
//  DeviceDataLibrery.h
//  DeviceInfoDemo
//
//  Created by 谢佳培 on 2020/9/7.
//  Copyright © 2020 xiejiapei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DeviceDataLibrery : NSObject

#pragma mark - 单例

+ (instancetype)sharedLibrery;

#pragma mark - 设备信息

/** 获取设备型号 */
- (const NSString *)getDiviceName;
/** 获取设备初始系统型号 */
- (const NSString *)getInitialVersion;
/** 获取设备支持的最高系统型号 */
- (const NSString *)getLatestVersion;

#pragma mark - 电池信息

/** 获取设备电池容量，单位 mA 毫安 */
- (NSInteger)getBatteryCapacity;
/** 获取电池电压，单位 V 福特 */
- (CGFloat)getBatterVolocity;

#pragma mark - CPU

/** 获取CPU处理器名称 */
- (const NSString *)getCPUProcessor;

@end

NS_ASSUME_NONNULL_END
