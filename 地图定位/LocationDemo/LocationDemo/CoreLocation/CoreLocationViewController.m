//
//  CoreLocationViewController.m
//  LocationDemo
//
//  Created by 谢佳培 on 2020/11/6.
//

#import "CoreLocationViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface CoreLocationViewController ()<CLLocationManagerDelegate>

@property (nonatomic ,strong) CLLocationManager *locationManager;// 定位管理者
@property (nonatomic, strong) UIImageView *compasspointer;
@property(nonatomic, copy) NSString *place;

@end

@implementation CoreLocationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self createSubview];
    [self configLocationManager];
    [self areaDetection];
    [self geocoding];
    [self antiGeocoding];
}

- (void)createSubview
{
    UIImage *luckcoffee = [UIImage imageNamed:@"luckcoffee.JPG"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage: luckcoffee];
    imageView.frame = CGRectMake(100, 100, 150, 150);
    [self.view addSubview:imageView];
    self.compasspointer = imageView;
}

// 设置定位管理者
- (void)configLocationManager
{
    self.place = @"";
    
    // 判断定位权限是否打开
    if ([CLLocationManager locationServicesEnabled])
    {
        _locationManager = [[CLLocationManager alloc] init];
        // 成为CoreLocation管理者的代理监听获取到的位置
        _locationManager.delegate = self;
        
        // 设置寻址精度
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        
        // 设置多远获取一次
        _locationManager.distanceFilter = 100.0f;
        
        // 开始定位
        [_locationManager startUpdatingLocation];
    }
    else
    {
        // 必须再info.plist文件中配置一项属性才能弹出授权窗口
        // 要主动请求授权定位权限 授权状态改变就会通知代理
        [_locationManager requestAlwaysAuthorization];
    }
    
    // 判断设备是否支持则开启磁力感应
    if ([CLLocationManager headingAvailable])
    {
        _locationManager.headingFilter = kCLHeadingFilterNone;
        [_locationManager startUpdatingHeading];
        
        NSLog(@"设备支持则开启磁力感应");
    }
    else
    {
        NSLog(@"设备不支持则开启磁力感应");
    }
}

// 区域检测
- (void)areaDetection
{
    // 创建中心点
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(24.477117, 118.183691);
    // 创建圆形区域, 指定区域中心点的经纬度, 以及半径
    CLCircularRegion *circular = [[CLCircularRegion alloc] initWithCenter:center radius:0.001 identifier:@"厦门"];
    [_locationManager startMonitoringForRegion:circular];
}

// 地理编码: 地名—>经纬度坐标
- (void)geocoding
{
    // 根据传入的地址获取该地址对应的经纬度信息
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:@"岭兜南片区156号楼" completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        // 如果有错误信息，或者是数组中获取的地名元素数量为0，那么说明没有找到
        if (error || placemarks.count == 0)
        {
            NSLog(@"你输入的地址没找到，可能在月球上");
        }
        else
        {
            // 打印查看找到的所有的位置信息
            // locality:城市  country:国家 postalCode:邮政编码
            for (CLPlacemark *placemark in placemarks)
            {
                NSLog(@"name=%@ locality=%@ country=%@ postalCode=%@",placemark.name, placemark.locality, placemark.country, placemark.postalCode);
            }
            
            // 取出获取的地理信息数组中的第一个显示在界面上
            CLPlacemark *firstPlacemark = [placemarks firstObject];
            
            // 详细地址名称
            NSString *latitude = [NSString stringWithFormat:@"%.2f",firstPlacemark.location.coordinate.latitude];
            NSString *longitude = [NSString stringWithFormat:@"%.2f",firstPlacemark.location.coordinate.longitude];
            NSLog(@"地理编码，获取到的详细地址名称：%@，纬度：%@，经度：%@",firstPlacemark.name,latitude,longitude);
        }
    }];
}

// 反地理编码：经纬度坐标—>地名
- (void)antiGeocoding
{
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    // 1.获得输入的经纬度
    CLLocationDegrees latitude = [@"24.477139" doubleValue];
    CLLocationDegrees longitude = [@"118.183671" doubleValue];
    CLLocation *location = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    
    // 2.反地理编码
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error)
     {
        if (error||placemarks.count==0)
        {
            NSLog(@"你输入的地址没找到，可能在月球上");
        }
        else
        {
            // 显示最前面的地标信息
            CLPlacemark *firstPlacemark= [placemarks firstObject];
            // 详细地址名称
            NSLog(@"反地理编码获取到的位置名称为: %@",firstPlacemark.name);
        }
    }];
}

#pragma mark - CLLocationManagerDelegate

// 授权状态发生改变时调用
- (void)locationManagerDidChangeAuthorization:(CLLocationManager *)manager
{

    if (manager.authorizationStatus == kCLAuthorizationStatusNotDetermined)
    {
        NSLog(@"等待用户授权");
    }
    else if (manager.authorizationStatus == kCLAuthorizationStatusAuthorizedAlways || manager.authorizationStatus == kCLAuthorizationStatusAuthorizedWhenInUse)
    {
        NSLog(@"授权成功，开始定位");
        [_locationManager startUpdatingLocation];
    }
    else
    {
        NSLog(@"授权失败");
    }
}

// 获取到位置信息之后就会调用(调用频率非常高)
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    // 如果只需要获取一次, 可以获取到位置之后就停止
    [_locationManager stopUpdatingHeading];
    [_locationManager stopUpdatingLocation];
    
    // 获取最后一次的位置
    CLLocation *location = [locations lastObject];
    NSLog(@"纬度：%f，经度：%f，速度：%f", location.coordinate.latitude, location.coordinate.longitude, location.speed);
    
    CLLocation *currentLocation = [locations lastObject];
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    // 利用经纬度进行反编译获取位置信息
    [geoCoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (placemarks.count > 0)
        {
            // 获取当前定位信息
            CLPlacemark *placeMark = [placemarks firstObject];
            if (placeMark)
            {
                //省、市、县、街
                self.place = [NSString stringWithFormat:@"省：%@，市：%@，街道：%@ %@",placeMark.administrativeArea,placeMark.locality,placeMark.subLocality,placeMark.thoroughfare];
                NSLog(@"在下当前所在位置为：%@",self.place);
            }
        }
    }];
}

// 当获取到用户方向时就会调用
- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading
{
    // magneticHeading: 设备与磁北的相对角度
    // trueHeading：设备与真北的相对角度，真北始终指向地理北极点
    NSLog(@"设备与磁北的相对角度：%f",newHeading.magneticHeading);

    // 将获取到的角度转为弧度 = (角度 * π) / 180;
    CGFloat angle = newHeading.magneticHeading * M_PI / 180;

    // 如果需要根据角度来旋转图片如指南针等，可以这样调用
    // 顺时针 正  逆时针 负
    self.compasspointer.transform = CGAffineTransformMakeRotation(-angle);
}

// 定位失败时调用
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [_locationManager startUpdatingLocation];
}

// 进入监听区域时调用
- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    NSLog(@"进入监听区域时调用");
}

// 离开监听区域时调用
- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    NSLog(@"离开监听区域时调用");
}

 

@end
