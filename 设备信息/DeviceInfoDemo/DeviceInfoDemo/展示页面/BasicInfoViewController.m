//
//  BasicInfoViewController.m
//  DeviceInfoDemo
//
//  Created by 谢佳培 on 2020/9/7.
//  Copyright © 2020 xiejiapei. All rights reserved.
//

#import "BasicInfoViewController.h"
#import "DeviceInfoManager.h"
#import "BatteryInfoManager.h"
#import "NetWorkInfoManager.h"

@interface BasicInfo : NSObject

@property (nonatomic, copy) NSString *infoKey;
@property (nonatomic, strong) NSObject *infoValue;

@end

@implementation BasicInfo

@end

@interface BasicInfoViewController () <UITableViewDataSource, UITableViewDelegate, BatteryInfoDelegate>

@property (nonatomic, strong) NSMutableArray *infoArray;

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation BasicInfoViewController

#pragma mark - Life Circle

- (instancetype)initWithType:(BasicInfoType)type
{
    self = [super init];
    if (self)
    {
        if (type == BasicInfoTypeHardWare) //Hardware
        {
            [self setupHardwareInfo];
        }
        else if (type == BasicInfoTypeBattery) //Battery
        {
            [self setupBatteryInfo];
        }
        else if (type == BasicInfoTypeIpAddress) //IpAddress
        {
            [self setupAddressInfo];
        }
        else if (type == BasicInfoTypeCPU) //CPU
        {
            [self setupCPUInfo];
        }
        else if (type == BasicInfoTypeDisk) //Disk
        {
            [self setupDiskInfo];
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 80;
    [self.view addSubview:self.tableView];
    
    if (@available(iOS 11.0, *))
    {
        // 标题
        self.navigationController.navigationBar.prefersLargeTitles = YES;
        self.navigationController.navigationBar.largeTitleTextAttributes = @{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Medium" size:28],NSForegroundColorAttributeName:[UIColor blackColor]};
    }
}

- (void)dealloc
{
    //[[BatteryInfoManager sharedManager] stopBatteryMonitoring];
}

#pragma mark - 获取信息

// Hardware
- (void)setupHardwareInfo
{
    // 获取用户的本地化信息:货币类型，国家，语言，数字，日期格式的格式化
    [[DeviceInfoManager sharedManager] localInfo];
    
    // 获取DeviceModel
    NSString *device_model = [[DeviceInfoManager sharedManager] getDeviceModel];
    [self addInfoWithKey:@"device_model" infoValue:device_model];
    
    // 获取localizedModel
    NSString *localizedModel = [UIDevice currentDevice].localizedModel;
    [self addInfoWithKey:@"localizedModel" infoValue:localizedModel];
    
    // 获取设备型号
    const NSString *deviceName = [[DeviceInfoManager sharedManager] getDeviceName];
    [self addInfoWithKey:@"设备型号" infoValue:[deviceName copy]];
    
    // 获取设备名称
    NSString *iPhoneName = [UIDevice currentDevice].name;
    [self addInfoWithKey:@"设备名称" infoValue:iPhoneName];
    
    // 获取设备颜色
    NSString *deviceColor = [[DeviceInfoManager sharedManager] getDeviceColor];
    [self addInfoWithKey:@"设备颜色(Private API)" infoValue:deviceColor];
    
    // 获取设备外壳颜色
    NSString *deviceEnclosureColor = [[DeviceInfoManager sharedManager] getDeviceEnclosureColor];
    [self addInfoWithKey:@"设备外壳颜色(Private API)" infoValue:deviceEnclosureColor];
    
    // 获取app名称
    NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    NSLog(@"App应用名称：%@", appName);
    
    // 获取app版本号
    NSString *appVerion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [self addInfoWithKey:@"app版本号" infoValue:appVerion];
    
    // 获取app应用Build版本号
    NSString *appBuild = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    NSLog(@"app应用Build版本号：%@", appBuild);
    
    // 获取当前系统名称
    NSString *systemName = [UIDevice currentDevice].systemName;
    [self addInfoWithKey:@"当前系统名称" infoValue:systemName];
    
    // 当前系统版本号
    NSString *systemVersion = [UIDevice currentDevice].systemVersion;
    [self addInfoWithKey:@"当前系统版本号" infoValue:systemVersion];
    
    // 设备支持最低系统版本
    const NSString *initialFirmware = [[DeviceInfoManager sharedManager] getInitialFirmware];
    [self addInfoWithKey:@"设备支持最低系统版本" infoValue:[initialFirmware copy]];
    
    // 设备支持的最高系统版本
    const NSString *latestFirmware = [[DeviceInfoManager sharedManager] getLatestFirmware];
    [self addInfoWithKey:@"设备支持的最高系统版本" infoValue:[latestFirmware copy]];
    
    // 能否打电话
    BOOL canMakePhoneCall = [DeviceInfoManager sharedManager].canMakePhoneCall;
    [self addInfoWithKey:@"能否打电话" infoValue:@(canMakePhoneCall ? "能" : "不能")];
    
    // 获取设备上次重启的时间
    NSDate *systemUptime = [[DeviceInfoManager sharedManager] getSystemUptime];
    [self addInfoWithKey:@"设备上次重启的时间" infoValue:systemUptime];
    
    // 当前设备的总线频率
    NSUInteger busFrequency = [[DeviceInfoManager sharedManager] getBusFrequency];
    [self addInfoWithKey:@"当前设备的总线频率" infoValue:@(busFrequency)];
    
    // 当前设备的主存大小(随机存取存储器（Random Access Memory)）
    NSUInteger ramSize = [[DeviceInfoManager sharedManager] getRamSize];
    [self addInfoWithKey:@"当前设备的主存大小" infoValue:@(ramSize)];
}

// Battery
- (void)setupBatteryInfo
{
    BatteryInfoManager *batteryManager = [BatteryInfoManager sharedManager];
    batteryManager.delegate = self;
    // 开始监测电池电量
    [batteryManager startBatteryMonitoring];
    
    // 获得电池电量
    CGFloat batteryLevel = [[UIDevice currentDevice] batteryLevel];
    NSString *levelValue = [NSString stringWithFormat:@"%.2f", batteryLevel];
    [self addInfoWithKey:@"电池电量" infoValue:levelValue];
    
    // 获得电池容量
    NSInteger batteryCapacity = batteryManager.capacity;
    NSString *capacityValue = [NSString stringWithFormat:@"%ld mA", batteryCapacity];
    [self addInfoWithKey:@"电池容量" infoValue:capacityValue];
    
    // 获得当前电池剩余电量
    CGFloat batteryMAH = batteryCapacity * batteryLevel;
    NSString *mahValue = [NSString stringWithFormat:@"%.2f mA", batteryMAH];
    [self addInfoWithKey:@"当前电池剩余电量" infoValue:mahValue];
    
    // 获得电池电压
    CGFloat batteryVoltage = batteryManager.voltage;
    NSString *voltageValue = [NSString stringWithFormat:@"%.2f V", batteryVoltage];
    [self addInfoWithKey:@"电池电压" infoValue:voltageValue];
    
    // 获得电池状态
    NSString *batterStatus = batteryManager.status ? : @"unkonwn";
    [self addInfoWithKey:@"电池状态" infoValue:batterStatus];
}

// 当电池状态改变时，会调用该方法，应该在此处reload对应的cell，进行更新UI操作
- (void)batteryStatusUpdated
{
    NSLog(@"电池状态改变，reload对应的cell，进行更新UI操作");
}

// Address
- (void)setupAddressInfo
{
    // 获取广告位标识符
    NSString *idfa = [[DeviceInfoManager sharedManager] getIDFA];
    [self addInfoWithKey:@"广告位标识符idfa:" infoValue:idfa];
    
    // 获取UUID
    NSString *uuid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    [self addInfoWithKey:@"唯一识别码uuid" infoValue:uuid];
    
    // 这个 ！还存在问题
    NSString *device_token_crc32 = [[NSUserDefaults standardUserDefaults] objectForKey:@"device_token_crc32"] ? : @"";
    [self addInfoWithKey:@"device_token_crc32真机测试才会显示" infoValue:device_token_crc32];

    // 获取mac地址
    NSString *macAddress = [[DeviceInfoManager sharedManager] getMacAddress];
    [self addInfoWithKey:@"macAddress" infoValue:macAddress];
    
    // 获取设备的IP地址
    NSString *deviceIP = [[NetWorkInfoManager sharedManager] getDeviceIPAddresses];
    [self addInfoWithKey:@"deviceIP" infoValue:deviceIP];
    
    // 获取蜂窝地址
    NSString *cellIP = [[NetWorkInfoManager sharedManager] getIpAddressCell];
    [self addInfoWithKey:@"蜂窝地址" infoValue:cellIP];
    
    // 获取WIFI IP地址
    NSString *wifiIP = [[NetWorkInfoManager sharedManager] getIpAddressWIFI];
    [self addInfoWithKey:@"WIFI IP地址" infoValue:wifiIP];
}

// CPU
- (void)setupCPUInfo
{
    // 获取CPU处理器名称
    NSString *cpuName = [[DeviceInfoManager sharedManager] getCPUProcessor];
    [self addInfoWithKey:@"CPU 处理器名称" infoValue:cpuName];
    
    // 获取CPU总数目
    NSUInteger cpuCount = [[DeviceInfoManager sharedManager] getCPUCount];
    [self addInfoWithKey:@"CPU总数目" infoValue:@(cpuCount)];
    
    // 获取CPU使用的总比例
    CGFloat cpuUsage = [[DeviceInfoManager sharedManager] getCPUUsage];
    [self addInfoWithKey:@"CPU使用的总比例" infoValue:@(cpuUsage)];
    
    // 获取CPU 频率
    NSUInteger cpuFrequency = [[DeviceInfoManager sharedManager] getCPUFrequency];
    [self addInfoWithKey:@"CPU 频率" infoValue:@(cpuFrequency)];
    
    // 获取单个CPU使用比例
    NSArray *perCPUArr = [[DeviceInfoManager sharedManager] getPerCPUUsage];
    NSMutableString *perCPUUsage = [NSMutableString string];
    for (NSNumber *per in perCPUArr)
    {
        [perCPUUsage appendFormat:@"%.2f<-->", per.floatValue];
    }
    [self addInfoWithKey:@"单个CPU使用比例" infoValue:perCPUUsage];
}

// Disk
- (void)setupDiskInfo
{
    // 获得当前App所占内存空间
    NSString *applicationSize = [[DeviceInfoManager sharedManager] getApplicationSize];
    [self addInfoWithKey:@"当前 App 所占内存空间" infoValue:applicationSize];
    
    // 获得磁盘总空间
    int64_t totalDisk = [[DeviceInfoManager sharedManager] getTotalDiskSpace];
    NSString *totalDiskInfo = [NSString stringWithFormat:@"== %.2f MB == %.2f GB", totalDisk/1024/1024.0, totalDisk/1024/1024/1024.0];
    [self addInfoWithKey:@"磁盘总空间" infoValue:totalDiskInfo];
    
    // 获得磁盘已使用空间
    int64_t usedDisk = [[DeviceInfoManager sharedManager] getUsedDiskSpace];
    NSString *usedDiskInfo = [NSString stringWithFormat:@" == %.2f MB == %.2f GB", usedDisk/1024/1024.0, usedDisk/1024/1024/1024.0];
    [self addInfoWithKey:@"磁盘已使用空间" infoValue:usedDiskInfo];
    
    // 获得磁盘空闲空间
    int64_t freeDisk = [[DeviceInfoManager sharedManager] getFreeDiskSpace];
    NSString *freeDiskInfo = [NSString stringWithFormat:@" %.2f MB == %.2f GB", freeDisk/1024/1024.0, freeDisk/1024/1024/1024.0];
    [self addInfoWithKey:@"磁盘空闲空间" infoValue:freeDiskInfo];
    
    // 系统总内存空间
    int64_t totalMemory = [[DeviceInfoManager sharedManager] getTotalMemory];
    NSString *totalMemoryInfo = [NSString stringWithFormat:@" %.2f MB == %.2f GB", totalMemory/1024/1024.0, totalMemory/1024/1024/1024.0];
    [self addInfoWithKey:@"系统总内存空间" infoValue:totalMemoryInfo];
    
    // 获得空闲的内存空间
    int64_t freeMemory = [[DeviceInfoManager sharedManager] getFreeMemory];
    NSString *freeMemoryInfo = [NSString stringWithFormat:@" %.2f MB == %.2f GB", freeMemory/1024/1024.0, freeMemory/1024/1024/1024.0];
    [self addInfoWithKey:@"空闲的内存空间" infoValue:freeMemoryInfo];
    
    // 获得已使用的内存空间
    int64_t usedMemory = [[DeviceInfoManager sharedManager] getUsedMemory];
    NSString *usedMemoryInfo = [NSString stringWithFormat:@" %.2f MB == %.2f GB", usedMemory/1024/1024.0, usedMemory/1024/1024/1024.0];
    [self addInfoWithKey:@"已使用的内存空间" infoValue:usedMemoryInfo];
    
    // 获得正在使用或者很短时间内被使用过的内存
    int64_t activeMemory = [[DeviceInfoManager sharedManager] getActiveMemory];
    NSString *activeMemoryInfo = [NSString stringWithFormat:@"正在使用或者很短时间内被使用过 %.2f MB == %.2f GB", activeMemory/1024/1024.0, activeMemory/1024/1024/1024.0];
    [self addInfoWithKey:@"活跃的内存" infoValue:activeMemoryInfo];
    
    // 获得最近使用过但是目前处于不活跃状态的内存
    int64_t inActiveMemory = [[DeviceInfoManager sharedManager] getInActiveMemory];
    NSString *inActiveMemoryInfo = [NSString stringWithFormat:@"但是目前处于不活跃状态的内存 %.2f MB == %.2f GB", inActiveMemory/1024/1024.0, inActiveMemory/1024/1024/1024.0];
    [self addInfoWithKey:@"最近使用过" infoValue:inActiveMemoryInfo];
    
    // 获得用来存放内核和数据结构的内存
    int64_t wiredMemory = [[DeviceInfoManager sharedManager] getWiredMemory];
    NSString *wiredMemoryInfo = [NSString stringWithFormat:@"framework、用户级别的应用无法分配 %.2f MB == %.2f GB", wiredMemory/1024/1024.0, wiredMemory/1024/1024/1024.0];
    [self addInfoWithKey:@"用来存放内核和数据结构的内存" infoValue:wiredMemoryInfo];
    
    // 获得大对象存放所需的大块内存空间，内存吃紧自动释放
    int64_t purgableMemory = [[DeviceInfoManager sharedManager] getPurgableMemory];
    NSString *purgableMemoryInfo = [NSString stringWithFormat:@"大对象存放所需的大块内存空间 %.2f MB == %.2f GB", purgableMemory/1024/1024.0, purgableMemory/1024/1024/1024.0];
    [self addInfoWithKey:@"可释放的内存空间：内存吃紧自动释放" infoValue:purgableMemoryInfo];
}

#pragma mark - 数据源

- (void)addInfoWithKey:(NSString *)infoKey infoValue:(NSObject *)infoValue
{
    BasicInfo *info = [[BasicInfo alloc] init];
    info.infoKey = infoKey;
    info.infoValue = infoValue;
    NSLog(@"infoKey:%@---infoValue:%@", infoKey, infoValue);
    [self.infoArray addObject:info];
}

#pragma mark - UITableViewDelegate && UITableViewDatasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.infoArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    // 为cell设置标识符
    static NSString *idetifier = @"kIndentifier";
    
    //从缓存池中取出对应标示符的cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idetifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:idetifier];
    }
    
    // 获取数据字典
    BasicInfo *infoModel = self.infoArray[indexPath.row];
    cell.textLabel.text = infoModel.infoKey;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"------>%@", infoModel.infoValue];
    cell.detailTextLabel.numberOfLines = 0;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Setters && Getters
- (NSMutableArray *)infoArray
{
    if (!_infoArray)
    {
        _infoArray = [NSMutableArray array];
    }
    return _infoArray;
}

@end
