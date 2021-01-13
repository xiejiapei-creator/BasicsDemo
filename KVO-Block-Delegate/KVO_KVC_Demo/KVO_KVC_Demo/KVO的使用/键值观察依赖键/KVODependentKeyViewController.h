//
//  KVODependentKeyViewController.h
//  KVO_KVC_Demo
//
//  Created by 谢佳培 on 2020/9/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TargetObject : NSObject

@property (nonatomic, readwrite) int grade;
@property (nonatomic, readwrite) int age;

@end

@interface TargetWrapper : NSObject

@property (nonatomic, strong) TargetObject *target;

@end

@interface KVODependentKeyViewController : UIViewController

@end

NS_ASSUME_NONNULL_END
