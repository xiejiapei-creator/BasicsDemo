//
//  WallViewConfig.m
//  UseUIControlFramework
//
//  Created by 谢佳培 on 2020/11/13.
//

#import "WallViewConfig.h"

@implementation WallViewLayout

- (CGSize)itemSize
{
    if (CGSizeEqualToSize(_itemSize, CGSizeZero))
    {
        return CGSizeMake(65, 100);
    }
    return _itemSize;
}

- (UIEdgeInsets)itemEdgeInset
{
    if (UIEdgeInsetsEqualToEdgeInsets(_itemEdgeInset, UIEdgeInsetsZero))
    {
        return UIEdgeInsetsMake(15, 10, 5, 10);
    }
    return _itemEdgeInset;
}

- (CGFloat)imageViewSideLength
{
    if (_imageViewSideLength > 0)
    {
        return _imageViewSideLength;
    }
    return self.itemSize.width - 10;
}

- (CGFloat)itemPadding
{
    if (_itemPadding > 0)
    {
        return _itemPadding;
    }
    return 5;
}

- (CGFloat)itemSubviewsSpacing
{
    if (_itemSubviewsSpacing > 0)
    {
        return _itemSubviewsSpacing;
    }
    return 7;
}

- (CGFloat)wallHeaderHeight
{
    if (_wallHeaderHeight > 0)
    {
        return _wallHeaderHeight;
    }
    return 40;
}

- (CGFloat)wallFooterHeight
{
    if (_wallFooterHeight > 0)
    {
        return _wallFooterHeight;
    }
    return 50;
}

@end

@implementation WallViewAppearance

- (UIColor *)sectionBackgroundColor
{
    if (_sectionBackgroundColor)
    {
        return _sectionBackgroundColor;
    }
    return [UIColor clearColor];
}

- (UIColor *)itemBackgroundColor
{
    if (_itemBackgroundColor)
    {
        return _itemBackgroundColor;
    }
    return [UIColor clearColor];
}

- (UIColor *)imageViewBackgroundColor
{
    if (_imageViewBackgroundColor)
    {
        return _imageViewBackgroundColor;
    }
    return [UIColor whiteColor];
}

- (UIColor *)imageViewHighlightedColor
{
    if (_imageViewHighlightedColor)
    {
        return _imageViewHighlightedColor;
    }
    return [UIColor grayColor];
}

- (UIViewContentMode)imageViewContentMode
{
    if (_imageViewContentMode)
    {
        return _imageViewContentMode;
    }
    return UIViewContentModeScaleToFill;
}

- (CGFloat)imageViewCornerRadius
{
    if (_imageViewCornerRadius > 0)
    {
        return _imageViewCornerRadius;
    }
    return 15.0;
}

- (UIColor *)textLabelBackgroundColor
{
    if (_textLabelBackgroundColor)
    {
        return _textLabelBackgroundColor;
    }
    return [UIColor clearColor];
}

- (UIColor *)textLabelTextColor
{
    if (_textLabelTextColor)
    {
        return _textLabelTextColor;
    }
    return [UIColor darkGrayColor];
}

- (UIFont *)textLabelFont
{
    if (_textLabelFont)
    {
        return _textLabelFont;
    }
    return [UIFont systemFontOfSize:10];
}

@end
