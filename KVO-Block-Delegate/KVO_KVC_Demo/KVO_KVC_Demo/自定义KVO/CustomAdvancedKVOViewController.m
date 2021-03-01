//
//  CustomAdvancedKVOViewController.m
//  KVO_KVC_Demo
//
//  Created by 谢佳培 on 2021/2/23.
//

#import "CustomAdvancedKVOViewController.h"
#import "KVOPrincipleModel.h"
#import "NSObject+CustomKVOAdvanced.h"
#import <objc/runtime.h>


@interface CustomAdvancedKVOViewController ()

@end

@implementation CustomAdvancedKVOViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    PrinciplePerson *person = [[PrinciplePerson alloc] init];

    [person customAdvancedAddObserver:self forKeyPath:@"nickName" options:(KeyValueObservingOptionNew | KeyValueObservingOptionOld) context:NULL handBlock:^(NSObject * _Nonnull observer, NSString * _Nonnull keyPath, id  _Nonnull oldValue, id  _Nonnull newValue) {
        
        NSLog(@"customAdvancedKVO方法中，nickName的旧值：%@，新值：%@",oldValue,newValue);
    }];

    [person customAdvancedAddObserver:self forKeyPath:@"bookName" options:(KeyValueObservingOptionNew | KeyValueObservingOptionOld) context:NULL handBlock:^(NSObject * _Nonnull observer, NSString * _Nonnull keyPath, id  _Nonnull oldValue, id  _Nonnull newValue) {
        
        NSLog(@"customAdvancedKVO方法中，bookName的旧值：%@，新值：%@",oldValue,newValue);
    }];
   
    person.nickName = @"FanYiCheng";
    person.bookName = @"HuXiaoShanZhuang";
}

@end
