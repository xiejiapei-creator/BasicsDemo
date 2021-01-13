//
//  ImageButton.h
//  UseUIControlFramework
//
//  Created by 谢佳培 on 2020/11/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ImageButtonModel : NSObject

@property (nonatomic, strong) UIImage *icon;
@property (nonatomic, strong) NSString *text;

+ (instancetype)modelWithTitle:(NSString *)title image:(UIImage *)image;

@end

typedef NS_ENUM(NSInteger, ImageButtonPosition) {
    ImageButtonPositionLeft = 0,    // 图片在左，文字在右，默认
    ImageButtonPositionRight,       // 图片在右，文字在左
    ImageButtonPositionTop,         // 图片在上，文字在下
    ImageButtonPositionBottom,      // 图片在下，文字在上
};

@interface ImageButton : UIButton

- (void)imagePosition:(ImageButtonPosition)postion spacing:(CGFloat)spacing;
- (void)imagePosition:(ImageButtonPosition)postion spacing:(CGFloat)spacing imageViewResize:(CGSize)size;

@end

NS_ASSUME_NONNULL_END
