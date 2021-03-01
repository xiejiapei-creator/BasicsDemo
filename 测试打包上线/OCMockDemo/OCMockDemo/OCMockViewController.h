//
//  OCMockViewController.h
//  OCMockDemo
//
//  Created by 谢佳培 on 2021/2/27.
//

#import <UIKit/UIKit.h>
#import "Manager.h"

NS_ASSUME_NONNULL_BEGIN

@interface OCMockViewController : UIViewController

@property(nonatomic, strong) Manager *manager;
@property(nonatomic, strong) IDCardView *idCardView;

- (void)updateIDCardView;

@end

NS_ASSUME_NONNULL_END
