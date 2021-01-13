//
//  NetWorkInfoManager.h
//  DeviceInfoDemo
//
//  Created by 谢佳培 on 2020/9/7.
//  Copyright © 2020 xiejiapei. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NetWorkInfoManager : NSObject

+ (instancetype)sharedManager;

/** 获取ip地址 */
- (NSString *)getDeviceIPAddresses;
/** 获取WIFI IP地址 */
- (NSString *)getIpAddressWIFI;
/** 获取蜂窝地址 */
- (NSString *)getIpAddressCell;

@end

NS_ASSUME_NONNULL_END
