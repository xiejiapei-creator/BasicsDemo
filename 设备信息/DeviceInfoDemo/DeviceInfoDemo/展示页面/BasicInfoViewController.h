//
//  BasicInfoViewController.h
//  DeviceInfoDemo
//
//  Created by 谢佳培 on 2020/9/7.
//  Copyright © 2020 xiejiapei. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, BasicInfoType)
{
    BasicInfoTypeHardWare,
    BasicInfoTypeBattery,
    BasicInfoTypeIpAddress,
    BasicInfoTypeCPU,
    BasicInfoTypeDisk,
};

@interface BasicInfoViewController : UIViewController

- (instancetype)initWithType:(BasicInfoType)type;

@end

NS_ASSUME_NONNULL_END
