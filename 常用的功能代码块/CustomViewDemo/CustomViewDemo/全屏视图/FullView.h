//
//  FullView.h
//  UseUIControlFramework
//
//  Created by 谢佳培 on 2020/11/12.
//

#import <UIKit/UIKit.h>
#import "ImageButton.h"

#define ROW_COUNT 4// 每行显示4个
#define ROWS 2// 每页显示2行
#define PAGES 2// 共2页

NS_ASSUME_NONNULL_BEGIN

@interface FullView : UIView

/// 图片按钮的尺寸
@property (nonatomic, assign) CGSize itemSize;
/// 图片按钮的Model数组
@property (nonatomic, strong) NSArray<ImageButtonModel *> *models;
/// 图片按钮数组
@property (nonatomic, strong, readonly) NSMutableArray<ImageButton *> *items;

/// 点击全屏视图的回调
@property (nonatomic, copy) void (^didClickFullView)(FullView *fullView);
/// 点击图片按钮的回调
@property (nonatomic, copy) void (^didClickItems)(FullView *fullView, NSInteger index);

/// 开始动画
- (void)startAnimationsWithCompletion:(void (^)(BOOL finished))completion;

/// 结束动画
- (void)endAnimationsWithCompletion:(void (^)(FullView *fullView))completion;

@end

NS_ASSUME_NONNULL_END
