//
//  WallView.h
//  UseUIControlFramework
//
//  Created by 谢佳培 on 2020/11/13.
//

#import <UIKit/UIKit.h>
#import "WallViewConfig.h"

NS_ASSUME_NONNULL_BEGIN

@class WallView;

#pragma mark - Model

@interface WallItemModel : NSObject

+ (instancetype)modelWithImage:(UIImage *)image text:(NSString *)text;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSString *text;

@end

#pragma mark - CollectionCell

@interface WallViewCollectionCell : UICollectionViewCell

@property (nonatomic, strong, readonly) UIButton *imageView;
@property (nonatomic, strong, readonly) UILabel *textLabel;

@end

#pragma mark - CollectionView

@interface WallCollectionView : UITableViewCell <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) WallViewLayout *wallLayout;
@property (nonatomic, strong) WallViewAppearance *wallAppearance;

@property (nonatomic, strong) NSArray<WallItemModel *> *models;

@property (nonatomic, weak) WallView *wallView;
@property (nonatomic, assign) NSInteger rowIndex;

@end

#pragma mark - Delegate

@protocol WallViewDelegate <NSObject>

@optional
// 点击了每个item事件
- (void)wallView:(WallView *)wallView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;

@end

@protocol WallViewDelegateConfig <WallViewDelegate>

@optional
// 布局相关
- (WallViewLayout *)layoutOfItemInWallView:(WallView *)wallView;
// 外观颜色相关
- (WallViewAppearance *)appearanceOfItemInWallView:(WallView *)wallView;

@end

#pragma mark - WallView

@interface WallView : UIView

@property (nonatomic, weak, nullable) id <WallViewDelegate> delegate;
@property (nonatomic, strong, readonly) UILabel *wallFooterLabel;
@property (nonatomic, strong, readonly) UILabel *wallHeaderLabel;

@property (nonatomic, strong) NSArray<NSArray<WallItemModel *> *> *models;

@property (nonatomic, copy) void (^didClickHeader)(WallView *wallView);
@property (nonatomic, copy) void (^didClickFooter)(WallView *wallView);

@end



NS_ASSUME_NONNULL_END
