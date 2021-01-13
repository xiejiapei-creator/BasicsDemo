//
//  ToastViewController.h
//  FunctionCodeBlockDemo
//
//  Created by 谢佳培 on 2020/9/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ToastView : UIView

@property (nonatomic, strong, readwrite) NSString *toastType;
@property (nonatomic, strong, readonly) UILabel *succeedToastLabel;
@property (nonatomic, strong, readonly) UILabel *toastLabel;
@property (nonatomic, assign, readwrite) CGFloat duration;

- (void)showToast:(void(^)(void))completion;

@end

@interface ToastViewController : UIViewController

@end

NS_ASSUME_NONNULL_END
