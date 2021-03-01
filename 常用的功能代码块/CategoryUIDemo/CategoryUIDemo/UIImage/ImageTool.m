//
//  ImageTool.m
//  MultiThreadDemo
//
//  Created by 谢佳培 on 2021/2/23.
//  Copyright © 2021 xiejiapei. All rights reserved.
//

#import "ImageTool.h"

@implementation ImageTool

// 模糊图片
+ (UIImage *)filterImage:(UIImage *)sourceImage
{
    if (!sourceImage)
    {
        sourceImage = [UIImage imageNamed:@"backImage"];
    }
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *image = [[CIImage alloc] initWithImage:sourceImage];
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:image forKey:kCIInputImageKey];
    [filter setValue:@10.0f forKey:@"inputRadius"];
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    CGImageRef outImage = [context createCGImage:result fromRect:[result extent]];
    UIImage *bluerImage = [UIImage imageWithCGImage:outImage];
    
    return bluerImage;
}

// 给指定图片加文字水印
+ (UIImage *)WaterImageWithText:(NSString *)text backImage:(UIImage *)backImage
{
    if (!backImage)
    {
        backImage = [UIImage imageNamed:@"backImage"];
    }
    
    NSDictionary *attDict = @{NSFontAttributeName:[UIFont systemFontOfSize:40],NSForegroundColorAttributeName:[UIColor blueColor]};
    return [self WaterImageWithImage:backImage text:text textPoint:CGPointZero attributedString:attDict];
}

+ (UIImage *)WaterImageWithImage:(UIImage *)image text:(NSString *)text textPoint:(CGPoint)point attributedString:(NSDictionary * )attributed
{
    // 1.开启上下文
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0);
    
    // 2.绘制图片
    [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    // 添加水印文字
    [text drawAtPoint:point withAttributes:attributed];
    
    // 3.从上下文中获取新图片
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 4.关闭图形上下文
    UIGraphicsEndImageContext();
    
    // 返回图片
    return newImage;
}

// 给指定图片加图片水印
+ (UIImage *)WaterImageWithWaterImage:(UIImage *)waterImage backImage:(UIImage *)backImage waterImageRect:(CGRect)rect
{
    UIImage *newBackImage = backImage;
    if (!newBackImage)
    {
        newBackImage = [UIImage imageNamed:@"backImage"];
    }
    return [self WaterImageWithImage:newBackImage waterImage:waterImage waterImageRect:rect];
}

+ (UIImage *)WaterImageWithImage:(UIImage *)image waterImage:(UIImage *)waterImage waterImageRect:(CGRect)rect
{
    // 1.获取图片
    // 2.开启上下文
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0);
    
    // 3.绘制背景图片
    [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    // 绘制水印图片到当前上下文
    [waterImage drawInRect:rect];
    
    // 4.从上下文中获取新图片
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 5.关闭图形上下文
    UIGraphicsEndImageContext();
    
    // 返回图片
    return newImage;
}

@end

