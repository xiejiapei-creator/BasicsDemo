//
//  CycleRefViewController.h
//  内存管理
//
//  Created by 谢佳培 on 2021/3/3.
//

#import <UIKit/UIKit.h>

@interface MemoryObject : NSObject

@property (strong, nonatomic) id obj;

@end

NS_ASSUME_NONNULL_BEGIN

// 循环引用
@interface CycleRefViewController : UIViewController

@end

NS_ASSUME_NONNULL_END
