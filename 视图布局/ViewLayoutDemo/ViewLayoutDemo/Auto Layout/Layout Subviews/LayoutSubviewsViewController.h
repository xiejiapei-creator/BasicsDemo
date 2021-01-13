//
//  LayoutSubviewsViewController.h
//  ViewLayoutDemo
//
//  Created by 谢佳培 on 2020/10/14.
//

#import <UIKit/UIKit.h>

@interface LayoutHeaderView : UIView

@end

@interface LayoutFooterView : UIView

@end

@interface LayoutBodyView : UIView

@property (nonatomic, copy) NSString *text;
@property (nonatomic, strong) UILabel *textLabel;

@end

NS_ASSUME_NONNULL_BEGIN

@interface LayoutSubviewsViewController : UIViewController

@end

NS_ASSUME_NONNULL_END
