//
//  ImageButton.m
//  UseUIControlFramework
//
//  Created by 谢佳培 on 2020/11/11.
//

#import "ImageButton.h"

@implementation ImageButtonModel

+ (instancetype)modelWithTitle:(NSString *)title image:(UIImage *)image
{
    ImageButtonModel *model = [ImageButtonModel new];
    model.text = title;
    model.icon = image;
    return model;
}

@end

@interface ImageButton ()

@property (nonatomic, assign, readonly) CGSize adjustImageSize;// 调整的图片尺寸
@property (nonatomic, assign, readonly) CGFloat adjustSpacing;// 调整的空白
@property (nonatomic, assign, readonly) ImageButtonPosition adjustPosition;// 调整位置
@property (nonatomic, assign, readonly) BOOL isNeedAdjust;// 是否需要调整

@end

@implementation ImageButton

- (void)imagePosition:(ImageButtonPosition)postion spacing:(CGFloat)spacing
{
    _adjustPosition = postion;
    _adjustSpacing = spacing;
    _isNeedAdjust = YES;
    [self setNeedsLayout];
}

- (void)imagePosition:(ImageButtonPosition)postion spacing:(CGFloat)spacing imageViewResize:(CGSize)size
{
    _adjustPosition = postion;
    _adjustImageSize = size;
    _adjustSpacing = spacing;
    _isNeedAdjust = YES;
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 处理极限值
    if (!_isNeedAdjust) return;
    if (_adjustSpacing <= 0) _adjustSpacing = 10;
    if (CGSizeEqualToSize(CGSizeZero, _adjustImageSize)) _adjustImageSize = self.imageView.size;
    
    [self adjustImagePosition:_adjustPosition];
}

- (void)adjustImagePosition:(ImageButtonPosition)position
{
    CGSize imageSize = _adjustImageSize;
    // 视图的自然大小，仅考虑视图本身的属性
    CGSize labelSize = self.titleLabel.intrinsicContentSize;
    
    switch (position)
    {
        case ImageButtonPositionLeft:
        {
            CGFloat _allW = imageSize.width + labelSize.width + _adjustSpacing;
            CGFloat _padding = (self.bounds.size.width - _allW) / 2;
            CGFloat imageY = (self.bounds.size.height - imageSize.height) / 2;
            self.imageView.frame = CGRectMake(_padding, imageY, imageSize.width, imageSize.height);
            CGFloat labelX = CGRectGetMaxX(self.imageView.frame) + _adjustSpacing;
            CGFloat labelY = (self.bounds.size.height - labelSize.height) / 2;
            self.titleLabel.frame = CGRectMake(labelX, labelY, labelSize.width, labelSize.height);
        }
            break;
        case ImageButtonPositionRight:
        {
            CGFloat _allW = imageSize.width + labelSize.width + _adjustSpacing;
            CGFloat _padding = (self.bounds.size.width - _allW) / 2;
            CGFloat labelY = (self.bounds.size.height - labelSize.height) / 2;
            self.titleLabel.frame = CGRectMake(_padding, labelY, labelSize.width, labelSize.height);
            CGFloat imageX = CGRectGetMaxX(self.titleLabel.frame) + _adjustSpacing;
            CGFloat imageY = (self.bounds.size.height - imageSize.height) / 2;
            self.imageView.frame = CGRectMake(imageX, imageY, imageSize.width, imageSize.height);
        }
            break;
        case ImageButtonPositionTop:
        {
            CGFloat _allH = imageSize.height + labelSize.height + _adjustSpacing;
            CGFloat _padding = (self.height - _allH) / 2;
            CGFloat imageX = (self.bounds.size.width - imageSize.width) / 2;
            self.imageView.frame = CGRectMake(imageX, _padding, imageSize.width, imageSize.height);
            CGFloat labelX = (self.size.width - labelSize.width) / 2;
            CGFloat labelY = CGRectGetMaxY(self.imageView.frame) + _adjustSpacing;
            self.titleLabel.frame = CGRectMake(labelX, labelY, labelSize.width, labelSize.height);
        }
            break;
        case ImageButtonPositionBottom:
        {
            CGFloat _allH = imageSize.height + labelSize.height + _adjustSpacing;
            CGFloat _padding = (self.height - _allH) / 2;
            CGFloat labelX = (self.size.width - labelSize.width) / 2;
            self.titleLabel.frame = CGRectMake(labelX, _padding, labelSize.width, labelSize.height);
            CGFloat imageX = (self.bounds.size.width - imageSize.width) / 2;
            CGFloat imageY = CGRectGetMaxY(self.titleLabel.frame) + _adjustSpacing;
            self.imageView.frame = CGRectMake(imageX, imageY, imageSize.width, imageSize.height);
        }
            break;
        default: break;
    }
}

@end
