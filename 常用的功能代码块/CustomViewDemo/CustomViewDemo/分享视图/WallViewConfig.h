//
//  WallViewConfig.h
//  UseUIControlFramework
//
//  Created by 谢佳培 on 2020/11/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - 配置布局

@interface WallViewLayout : NSObject

/// Set item size. default is CGSizeMake(60, 90)
@property (nonatomic, assign) CGSize itemSize;

/// 设置内部image视图边长 (imageView.height = imageView.width). default is (itemSize.width - 10)
@property (nonatomic, assign) CGFloat imageViewSideLength;

/// 设置水平item之间的间距 (|item1| <- itemPadding -> |item2|). default is 5
@property (nonatomic, assign) CGFloat itemPadding;

/// 纵向item内子视图间距 (textLabel.y = imageView.bottom + itemSubviewsSpacing). default is 7
@property (nonatomic, assign) CGFloat itemSubviewsSpacing;

/// Set section insets. default is UIEdgeInsetsMake(15, 10, 5, 10)
@property (nonatomic, assign) UIEdgeInsets itemEdgeInset;

/// 设置表头高 (wallHeaderLabel.height = wallHeaderHeight). default is 30
@property (nonatomic, assign) CGFloat wallHeaderHeight;

/// 设置底部视图高 (wallFooterLabel.height = wallFooterHeight). default is 50
@property (nonatomic, assign) CGFloat wallFooterHeight;

@end

#pragma mark - 配置外观

@interface WallViewAppearance : NSObject

/// default is [UIColor clearColor]
@property (nonatomic, strong) UIColor *sectionBackgroundColor;

/// default is [UIColor clearColor]
@property (nonatomic, strong) UIColor *itemBackgroundColor;

/// default is [UIColor whiteColor]
@property (nonatomic, strong) UIColor *imageViewBackgroundColor;

/// default is [UIColor grayColor]
@property (nonatomic, strong) UIColor *imageViewHighlightedColor;

/// default is UIViewContentModeScaleToFill
@property (nonatomic, assign) UIViewContentMode imageViewContentMode;

/// default is 15.0
@property (nonatomic, assign) CGFloat imageViewCornerRadius;

/// default is [UIColor clearColor]
@property (nonatomic, strong) UIColor *textLabelBackgroundColor;

/// default is [UIColor darkGrayColor]
@property (nonatomic, strong) UIColor *textLabelTextColor;

/// default is [UIFont systemFontOfSize:10]
@property (nonatomic, strong) UIFont  *textLabelFont;

@end

NS_ASSUME_NONNULL_END
