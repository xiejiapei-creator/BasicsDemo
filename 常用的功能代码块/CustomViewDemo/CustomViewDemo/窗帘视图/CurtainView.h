//
//  CurtainView.h
//  UseUIControlFramework
//
//  Created by 谢佳培 on 2020/11/11.
//

#import <UIKit/UIKit.h>
#import "ImageButton.h"

NS_ASSUME_NONNULL_BEGIN

@interface CurtainView : UIView

/// 图片按钮的Model数组
@property (nonatomic, strong) NSArray<ImageButtonModel *> *models;
/// ImageButton数组
@property (nonatomic, strong, readonly) NSMutableArray<ImageButton *> *items;
/// 关闭按钮
@property (nonatomic, strong) UIButton *closeButton;
/// Item的尺寸
@property (nonatomic, assign) CGSize itemSize;
/// 点击关闭按钮的回调
@property (nonatomic, copy) void (^closeClicked)(UIButton *closeButton);
/// 点击Item按钮的回调
@property (nonatomic, copy) void (^didClickItems)(CurtainView *curtainView, NSInteger index);

@end

NS_ASSUME_NONNULL_END
