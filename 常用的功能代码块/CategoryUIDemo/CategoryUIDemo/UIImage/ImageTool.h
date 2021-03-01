//
//  ImageTool.h
//  MultiThreadDemo
//
//  Created by 谢佳培 on 2021/2/23.
//  Copyright © 2021 xiejiapei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ImageTool : NSObject

// 模糊图片
+ (UIImage *)filterImage:(UIImage *)sourceImage;

// 给指定图片加文字水印
+ (UIImage *)WaterImageWithText:(NSString *)text backImage:(UIImage *)backImage;

// 给指定图片加图片水印
+ (UIImage *)WaterImageWithWaterImage:(UIImage *)waterImage backImage:(UIImage *)backImage waterImageRect:(CGRect)rect;

@end
 
