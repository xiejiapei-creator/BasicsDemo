//
//  DeviceInfoManager.m
//  DeviceInfoDemo
//
//  Created by 谢佳培 on 2020/9/7.
//  Copyright © 2020 xiejiapei. All rights reserved.
//

#import "DeviceInfoManager.h"
#import "DeviceDataLibrery.h"
#import <UIKit/UIKit.h>

// 下面是获取mac地址需要导入的头文件
#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#import <sys/sockio.h>
#import <sys/ioctl.h>
#import <arpa/inet.h>

#import "sys/utsname.h" //获取设备Model
#import <AdSupport/AdSupport.h> //获取广告标识符
#include <ifaddrs.h> //获取ip需要的头文件
#include <mach/mach.h> //获取CPU信息所需要引入的头文件

@implementation DeviceInfoManager

#pragma mark - 单例

+ (instancetype)sharedManager
{
    static DeviceInfoManager *_manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[DeviceInfoManager alloc] init];
    });
    return _manager;
}

#pragma mark - 设备信息

// 获取用户的本地化信息:货币类型，国家，语言，数字，日期格式的格式化
- (void)localInfo
{
    NSArray *languageArray = [NSLocale preferredLanguages];
    NSString *language = [languageArray objectAtIndex:0];
    NSLog(@"语言：%@", language);//en
    
    NSLocale *local = [NSLocale currentLocale];
    NSString *country = [local localeIdentifier];
    NSLog(@"国家：%@", country); //en_US
}

// 获取设备型号
- (const NSString *)getDeviceName
{
    return [[DeviceDataLibrery sharedLibrery] getDiviceName];
}

// 获取设备颜色
- (NSString *)getDeviceColor
{
    return [self getDeviceColorWithKey:@"DeviceColor"];
}

// 获取设备外壳颜色，私有API，上线会被拒
- (NSString *)getDeviceEnclosureColor
{
    return [self getDeviceColorWithKey:@"DeviceEnclosureColor"];
}

// 获取设备Model
- (NSString *)getDeviceModel
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceModel = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    return deviceModel;
}

// 获取设备装机时的系统版本（最低支持版本）
- (const NSString *)getInitialFirmware
{
    return [[DeviceDataLibrery sharedLibrery] getInitialVersion];
}

// 获取设备可支持的最高系统版本
- (const NSString *)getLatestFirmware
{
    return [[DeviceDataLibrery sharedLibrery] getLatestVersion];
}

// 能否打电话
#ifdef __IPHONE_OS_VERSION_MIN_REQUIRED
- (BOOL)canMakePhoneCall
{
    __block BOOL can;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        can = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tel://"]];
    });
    return can;
}
#endif

// 获取设备上次重启的时间
- (NSDate *)getSystemUptime
{
    NSTimeInterval time = [[NSProcessInfo processInfo] systemUptime];
    return [[NSDate alloc] initWithTimeIntervalSinceNow:(0 - time)];
}

// 获取总线程频率
- (NSUInteger)getBusFrequency
{
    return [self getSystemInfo:HW_BUS_FREQ];
}

// 获取当前设备主存
- (NSUInteger)getRamSize
{
    return [self getSystemInfo:HW_MEMSIZE];
}

#pragma mark - Private Method

// 获取设备颜色，私有API，上线会被拒
- (NSString *)getDeviceColorWithKey:(NSString *)key
{
    UIDevice *device = [UIDevice currentDevice];
    SEL selector = NSSelectorFromString(@"deviceInfoForKey:");
    if (![device respondsToSelector:selector])
    {
        selector = NSSelectorFromString(@"_deviceInfoForKey:");
    }
    
    if ([device respondsToSelector:selector])
    {
        // 消除警告“performSelector may cause a leak because its selector is unknown”
        IMP imp = [device methodForSelector:selector];
        NSString * (*func)(id, SEL, NSString *) = (void *)imp;
        
        return func(device, selector, key);
    }
    return @"unKnown";
}

- (NSUInteger)getSystemInfo:(uint)typeSpecifier
{
    size_t size = sizeof(int);
    int result;
    int mib[2] = {CTL_HW, typeSpecifier};
    sysctl(mib, 2, &result, &size, NULL, 0);
    return (NSUInteger)result;
}

#pragma mark - 网络信息

// 获取广告标识符
- (NSString *)getIDFA
{
    return [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
}

// 获取mac地址
- (NSString *)getMacAddress
{
    int mib[6];
    size_t len;
    char *buf;
    unsigned char *ptr;
    struct if_msghdr *ifm;
    struct sockaddr_dl *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0)
    {
        printf("Error: if_nametoindex error/n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0)
    {
        printf("Error: sysctl, take 1/n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL)
    {
        printf("Could not allocate memory. error!/n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0)
    {
        printf("Error: sysctl, take 2");
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    
    NSString *outstring = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    
    return [outstring uppercaseString];
}

#pragma mark - CPU

// 获取CPU处理器名称
- (NSString *)getCPUProcessor
{
    return [[DeviceDataLibrery sharedLibrery] getCPUProcessor] ? : @"unKnown";
}

// 获取CPU数量
- (NSUInteger)getCPUCount
{
    return [NSProcessInfo processInfo].activeProcessorCount;
}
 
// 获取CPU频率
- (NSUInteger)getCPUFrequency
{
    return [self getSystemInfo:HW_CPU_FREQ];
}

// 获取CPU总的使用百分比
- (float)getCPUUsage
{
    float cpu = 0;
    NSArray *cpus = [self getPerCPUUsage];
    if (cpus.count == 0) return -1;
    for (NSNumber *n in cpus)
    {
        cpu += n.floatValue;
    }
    return cpu;
}

// 获取单个CPU使用百分比
- (NSArray *)getPerCPUUsage
{
    processor_info_array_t _cpuInfo, _prevCPUInfo = nil;
    mach_msg_type_number_t _numCPUInfo, _numPrevCPUInfo = 0;
    unsigned _numCPUs;
    NSLock *_cpuUsageLock;
    
    int _mib[2U] = { CTL_HW, HW_NCPU };
    size_t _sizeOfNumCPUs = sizeof(_numCPUs);
    int _status = sysctl(_mib, 2U, &_numCPUs, &_sizeOfNumCPUs, NULL, 0U);
    if (_status)
        _numCPUs = 1;
    
    _cpuUsageLock = [[NSLock alloc] init];
    
    natural_t _numCPUsU = 0U;
    kern_return_t err = host_processor_info(mach_host_self(), PROCESSOR_CPU_LOAD_INFO, &_numCPUsU, &_cpuInfo, &_numCPUInfo);
    if (err == KERN_SUCCESS)
    {
        [_cpuUsageLock lock];
        
        NSMutableArray *cpus = [NSMutableArray new];
        for (unsigned i = 0U; i < _numCPUs; ++i)
        {
            Float32 _inUse, _total;
            if (_prevCPUInfo)
            {
                _inUse = (
                          (_cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_USER]   - _prevCPUInfo[(CPU_STATE_MAX * i) + CPU_STATE_USER])
                          + (_cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_SYSTEM] - _prevCPUInfo[(CPU_STATE_MAX * i) + CPU_STATE_SYSTEM])
                          + (_cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_NICE]   - _prevCPUInfo[(CPU_STATE_MAX * i) + CPU_STATE_NICE])
                          );
                _total = _inUse + (_cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_IDLE] - _prevCPUInfo[(CPU_STATE_MAX * i) + CPU_STATE_IDLE]);
            }
            else
            {
                _inUse = _cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_USER] + _cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_SYSTEM] + _cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_NICE];
                _total = _inUse + _cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_IDLE];
            }
            [cpus addObject:@(_inUse / _total)];
        }
        
        [_cpuUsageLock unlock];
        if (_prevCPUInfo)
        {
            size_t prevCpuInfoSize = sizeof(integer_t) * _numPrevCPUInfo;
            vm_deallocate(mach_task_self(), (vm_address_t)_prevCPUInfo, prevCpuInfoSize);
        }
        return cpus;
    }
    else
    {
        return nil;
    }
}

#pragma mark - 磁盘

// 获取本 App 所占磁盘空间
- (NSString *)getApplicationSize
{
    unsigned long long documentSize   =  [self getSizeOfFolder:[self getDocumentPath]];
    unsigned long long librarySize   =  [self getSizeOfFolder:[self getLibraryPath]];
    unsigned long long cacheSize =  [self getSizeOfFolder:[self getCachePath]];
    
    unsigned long long total = documentSize + librarySize + cacheSize;
    
    NSString *applicationSize = [NSByteCountFormatter stringFromByteCount:total countStyle:NSByteCountFormatterCountStyleFile];
    return applicationSize;
}

// 获取磁盘总空间
- (int64_t)getTotalDiskSpace
{
    NSError *error = nil;
    NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:&error];
    if (error) return -1;
    
    int64_t space =  [[attrs objectForKey:NSFileSystemSize] longLongValue];
    if (space < 0) space = -1;
    return space;
}

// 获取未使用的磁盘空间
- (int64_t)getFreeDiskSpace
{
    NSError *error = nil;
    NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:&error];
    if (error) return -1;
    int64_t space =  [[attrs objectForKey:NSFileSystemFreeSize] longLongValue];
    if (space < 0) space = -1;
    return space;
    
}

// 获取已使用的磁盘空间
- (int64_t)getUsedDiskSpace
{
    int64_t totalDisk = [self getTotalDiskSpace];
    int64_t freeDisk = [self getFreeDiskSpace];
    if (totalDisk < 0 || freeDisk < 0) return -1;
    
    int64_t usedDisk = totalDisk - freeDisk;
    if (usedDisk < 0) usedDisk = -1;
    return usedDisk;
}

#pragma mark - 内存

// 获取总内存空间
- (int64_t)getTotalMemory
{
    int64_t totalMemory = [[NSProcessInfo processInfo] physicalMemory];
    if (totalMemory < -1) totalMemory = -1;
    return totalMemory;
}

// 获取活跃的内存空间
- (int64_t)getActiveMemory
{
    mach_port_t host_port = mach_host_self();
    mach_msg_type_number_t host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    vm_size_t page_size;
    vm_statistics_data_t vm_stat;
    kern_return_t kern;
    
    kern = host_page_size(host_port, &page_size);
    if (kern != KERN_SUCCESS) return -1;
    kern = host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size);
    if (kern != KERN_SUCCESS) return -1;
    return vm_stat.active_count * page_size;
}

// 获取不活跃的内存空间
- (int64_t)getInActiveMemory
{
    mach_port_t host_port = mach_host_self();
    mach_msg_type_number_t host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    vm_size_t page_size;
    vm_statistics_data_t vm_stat;
    kern_return_t kern;
    
    kern = host_page_size(host_port, &page_size);
    if (kern != KERN_SUCCESS) return -1;
    kern = host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size);
    if (kern != KERN_SUCCESS) return -1;
    return vm_stat.inactive_count * page_size;
}

// 获取空闲的内存空间
- (int64_t)getFreeMemory
{
    mach_port_t host_port = mach_host_self();
    mach_msg_type_number_t host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    vm_size_t page_size;
    vm_statistics_data_t vm_stat;
    kern_return_t kern;
    
    kern = host_page_size(host_port, &page_size);
    if (kern != KERN_SUCCESS) return -1;
    kern = host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size);
    if (kern != KERN_SUCCESS) return -1;
    return vm_stat.free_count * page_size;
}

// 获取正在使用的内存空间
- (int64_t)getUsedMemory
{
    mach_port_t host_port = mach_host_self();
    mach_msg_type_number_t host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    vm_size_t page_size;
    vm_statistics_data_t vm_stat;
    kern_return_t kern;
    
    kern = host_page_size(host_port, &page_size);
    if (kern != KERN_SUCCESS) return -1;
    kern = host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size);
    if (kern != KERN_SUCCESS) return -1;
    return page_size * (vm_stat.active_count + vm_stat.inactive_count + vm_stat.wire_count);
}

// 获取存放内核的内存空间
- (int64_t)getWiredMemory
{
    mach_port_t host_port = mach_host_self();
    mach_msg_type_number_t host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    vm_size_t page_size;
    vm_statistics_data_t vm_stat;
    kern_return_t kern;
    
    kern = host_page_size(host_port, &page_size);
    if (kern != KERN_SUCCESS) return -1;
    kern = host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size);
    if (kern != KERN_SUCCESS) return -1;
    return vm_stat.wire_count * page_size;
}

// 获取可释放的内存空间
- (int64_t)getPurgableMemory
{
    mach_port_t host_port = mach_host_self();
    mach_msg_type_number_t host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    vm_size_t page_size;
    vm_statistics_data_t vm_stat;
    kern_return_t kern;
    
    kern = host_page_size(host_port, &page_size);
    if (kern != KERN_SUCCESS) return -1;
    kern = host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size);
    if (kern != KERN_SUCCESS) return -1;
    return vm_stat.purgeable_count * page_size;
}

// DocumentPath
- (NSString *)getDocumentPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = [paths firstObject];
    return basePath;
}

// LibraryPath
- (NSString *)getLibraryPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *basePath = [paths firstObject];
    return basePath;
}

// CachePath
- (NSString *)getCachePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *basePath = [paths firstObject];
    return basePath;
}

// getSizeOfFolder
- (unsigned long long)getSizeOfFolder:(NSString *)folderPath
{
    NSArray *contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:folderPath error:nil];
    NSEnumerator *contentsEnumurator = [contents objectEnumerator];
    
    NSString *file;
    unsigned long long folderSize = 0;
    
    while (file = [contentsEnumurator nextObject])
    {
        NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:[folderPath stringByAppendingPathComponent:file] error:nil];
        folderSize += [[fileAttributes objectForKey:NSFileSize] intValue];
    }
    return folderSize;
}

#pragma mark - UIDevice中对状态信息的监控

// 添加状态通知：即将某种状态的监控信息添加到通知中心
- (void)registerNotification
{
    // 添加设备方向的监控通知，状态发生变化是就会自动调用对应的方法执行
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeOrientation) name:UIDeviceOrientationDidChangeNotification object:nil];
    
    // 添加距离状态的监控通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeProximityState) name:UIDeviceProximityStateDidChangeNotification object:nil];
}

// 开启监控开关: 状态通知都对应有一个开关来控制是否开启对应的监控和通知
- (void)openNotification
{
    //打开设备方向监测，这是用方法控制
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];

    //不需要时可以关闭设备方向监控
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];

    //打开电池状态和电池电量监测开关，不需要时可以关闭
    [UIDevice currentDevice].batteryMonitoringEnabled=YES;

    //打开手机距离传感器监测开关，不需要时可以关闭
    [UIDevice currentDevice].proximityMonitoringEnabled=YES;
}

// 设备方向改变时调用该方法
-(void)changeOrientation
{
    NSLog(@"设备方向改变");
}

// 设备离用户的距离状态发生变化时调用该方法
- (void)changeProximityState
{
    if ([UIDevice currentDevice].proximityState)
    {
        NSLog(@"近距离");
    }
    else
    {
        NSLog(@"远距离");
    }
}

@end
