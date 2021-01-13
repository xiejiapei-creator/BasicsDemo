//
//  DeviceInfoManager.h
//  DeviceInfoDemo
//
//  Created by 谢佳培 on 2020/9/7.
//  Copyright © 2020 xiejiapei. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DeviceInfoManager : NSObject

// 如果API声明包含NS_EXTENSION_UNAVAILABLE宏，则此API在扩展中将不可用
/** 能否打电话 */
@property (nonatomic, assign, readonly) BOOL canMakePhoneCall NS_EXTENSION_UNAVAILABLE_IOS("");

#pragma mark - 单例

+ (instancetype)sharedManager;

#pragma mark - 设备信息

/** 获取用户的本地化信息:货币类型，国家，语言，数字，日期格式的格式化 */
- (void)localInfo;
/** 获取设备型号 */
- (const NSString *)getDeviceName;
/** 获取设备颜色 */
- (NSString *)getDeviceColor;
/** 获取设备外壳颜色 */
- (NSString *)getDeviceEnclosureColor;
/** 获取设备Model */
- (NSString *)getDeviceModel;
/** 获取设备装机时的系统版本（最低支持版本） */
- (const NSString *)getInitialFirmware;
/** 获取设备可支持的最高系统版本 */
- (const NSString *)getLatestFirmware;
/** 获取设备上次重启的时间 */
- (NSDate *)getSystemUptime;
/** 获取总线程频率 */
- (NSUInteger)getBusFrequency;
/** 获取当前设备主存 */
- (NSUInteger)getRamSize;

#pragma mark - 网络信息

/** 获取广告标识符 */
- (NSString *)getIDFA;
/** 获取mac地址 */
- (NSString *)getMacAddress;

#pragma mark - CPU

/** 获取CPU处理器名称 */
- (NSString *)getCPUProcessor;
/** 获取CPU数量 */
- (NSUInteger)getCPUCount;
/** 获取CPU总的使用百分比 */
- (float)getCPUUsage;
/** 获取单个CPU使用百分比 */
- (NSArray *)getPerCPUUsage;
/** 获取CPU频率 */
- (NSUInteger)getCPUFrequency;

#pragma mark - 磁盘

/** 获取本 App 所占磁盘空间 */
- (NSString *)getApplicationSize;
/** 获取磁盘总空间 */
- (int64_t)getTotalDiskSpace;
/** 获取未使用的磁盘空间 */
- (int64_t)getFreeDiskSpace;
/** 获取已使用的磁盘空间 */
- (int64_t)getUsedDiskSpace;

#pragma mark - 内存

/** 获取总内存空间 */
- (int64_t)getTotalMemory;
/** 获取活跃的内存空间 */
- (int64_t)getActiveMemory;
/** 获取不活跃的内存空间 */
- (int64_t)getInActiveMemory;
/** 获取空闲的内存空间 */
- (int64_t)getFreeMemory;
/** 获取正在使用的内存空间 */
- (int64_t)getUsedMemory;
/** 获取存放内核的内存空间 */
- (int64_t)getWiredMemory;
/** 获取可释放的内存空间 */
- (int64_t)getPurgableMemory;

#pragma mark - UIDevice中对状态信息的监控

/** 添加状态通知：即将某种状态的监控信息添加到通知中心 */
- (void)registerNotification;

/** 开启监控开关: 状态通知都对应有一个开关来控制是否开启对应的监控和通知 */
- (void)openNotification;

@end

NS_ASSUME_NONNULL_END
