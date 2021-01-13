//
//  SupportIpv6ViewController.m
//  DeviceInfoDemo
//
//  Created by 谢佳培 on 2020/10/28.
//  Copyright © 2020 xiejiapei. All rights reserved.
//

#import "SupportIpv6ViewController.h"

// 需要用到以下文件
# import <ifaddrs.h>
# import <arpa/inet.h>
# import <net/if.h>
// 宏
#define IOS_CELLULAR    @"pdp_ip0"
#define IOS_WIFI        @"en0"
#define IOS_VPN         @"utun0"
#define IP_ADDR_IPv4    @"ipv4"
#define IP_ADDR_IPv6    @"ipv6"

// 需要用到以下文件
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <SystemConfiguration/SCNetworkReachability.h>

@interface SupportIpv6ViewController ()

@end

@implementation SupportIpv6ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *ipAddress = [SupportIpv6ViewController getNetworkIPAddress];
    NSLog(@"IP地址为：%@",ipAddress);
}

// 取IP地址
+ (NSString *)getNetworkIPAddress
{
    NSArray *searchArray = [self isSupportIpv6] ?
    @[ IOS_WIFI @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4 ] :
    @[ IOS_WIFI @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6 ] ;
    
    NSDictionary *addresses = [self getDeviceIPAddresses];
    
    __block NSString *address;
    [searchArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop)
     {
        address = addresses[key];
        if([self isIPAddress:address])
        {
            *stop = YES;
        }
    }];
    NSLog(@"IPAddress: %@", address);
    return address ? address : @"0.0.0.0";
}

// 获取到硬件设备的各个IP
+ (NSDictionary *)getDeviceIPAddresses
{
    NSMutableDictionary *addresses = [NSMutableDictionary dictionaryWithCapacity:8];
    // retrieve the current interfaces - returns 0 on succes
    struct ifaddrs *interfaces;
    if(!getifaddrs(&interfaces))
    {
        // Loop through linked list of interfaces
        struct ifaddrs *interface;
        for(interface = interfaces; interface; interface = interface->ifa_next)
        {
            // deeply nested code harder to read
            if(!(interface->ifa_flags & IFF_UP))
            {
                continue;
            }
            const struct sockaddr_in *addr = (const struct sockaddr_in*)interface->ifa_addr;
            char addrBuf[ MAX(INET_ADDRSTRLEN, INET6_ADDRSTRLEN) ];
            if(addr && (addr->sin_family == AF_INET || addr->sin_family == AF_INET6))
            {
                NSString *name = [NSString stringWithUTF8String:interface->ifa_name];
                NSString *type;
                if(addr->sin_family == AF_INET)
                {
                    if(inet_ntop(AF_INET, &addr->sin_addr, addrBuf, INET_ADDRSTRLEN))
                    {
                        type = IP_ADDR_IPv4;
                    }
                }
                else
                {
                    const struct sockaddr_in6 *addr6 = (const struct sockaddr_in6*)interface->ifa_addr;
                    if(inet_ntop(AF_INET6, &addr6->sin6_addr, addrBuf, INET6_ADDRSTRLEN))
                    {
                        type = IP_ADDR_IPv6;
                    }
                }
                if(type)
                {
                    NSString *key = [NSString stringWithFormat:@"%@/%@", name, type];
                    addresses[key] = [NSString stringWithUTF8String:addrBuf];
                }
            }
        }
        // Free memory
        freeifaddrs(interfaces);
    }
    return [addresses count] ? addresses : nil;
}

// 判断是否支持IPv6
+ (BOOL)isSupportIpv6
{
    NSArray *searchArray =
    @[ IOS_VPN @"/" IP_ADDR_IPv6,
       IOS_VPN @"/" IP_ADDR_IPv4,
       IOS_WIFI @"/" IP_ADDR_IPv6,
       IOS_WIFI @"/" IP_ADDR_IPv4,
       IOS_CELLULAR @"/" IP_ADDR_IPv6,
       IOS_CELLULAR @"/" IP_ADDR_IPv4 ] ;
    
    NSDictionary *addresses = [self getDeviceIPAddresses];
    NSLog(@"addresses: %@", addresses);
    
    __block BOOL isSupportIpv6 = NO;
    [searchArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
        NSLog(@"key: %@---addresses[key]: %@",key, addresses[key] );
        
        if ([key rangeOfString:@"ipv6"].length > 0  && ![[NSString stringWithFormat:@"%@",addresses[key]] hasPrefix:@"(null)"] )
        {
            if (![addresses[key] hasPrefix:@"fe80"])
            {
                isSupportIpv6 = YES;
            }
        }
    }];
    return isSupportIpv6;
}

/**
 * 判断字符串是否为IP地址
 * param iPAddress IP地址字符串
 * return BOOL 是返回YES，否返回NO
 */
+ (BOOL)isIPAddress:(NSString *)iPAddress
{
    NSString *pattern = @"^(\\d{1,2}|1\\d\\d|2[0-4]\\d|25[0-5]).(\\d{1,2}|1\\d\\d|2[0-4]\\d|25[0-5]).(\\d{1,2}|1\\d\\d|2[0-4]\\d|25[0-5]).(\\d{1,2}|1\\d\\d|2[0-4]\\d|25[0-5])$";
    return [self isText:iPAddress pattern:pattern];
}

+ (BOOL)isText:(NSString *)text pattern:(NSString *)pattern
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",pattern];
    return [predicate evaluateWithObject:text];
}

@end
