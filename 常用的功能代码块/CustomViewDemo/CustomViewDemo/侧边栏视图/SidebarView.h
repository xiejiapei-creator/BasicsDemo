//
//  SidebarView.h
//  UseUIControlFramework
//
//  Created by 谢佳培 on 2020/11/12.
//

#import <UIKit/UIKit.h>
#import "ImageButton.h"

NS_ASSUME_NONNULL_BEGIN

@interface SidebarView : UIView

/// 文本数组
@property (nonatomic, strong) NSArray<NSString *> *models;
/// 图片按钮数组
@property (nonatomic, strong, readonly) NSMutableArray<ImageButton *> *items;
/// 点击图片按钮的回调
@property (nonatomic, copy) void (^didClickItems)(SidebarView *sidebarView, NSInteger index);

@end

NS_ASSUME_NONNULL_END
