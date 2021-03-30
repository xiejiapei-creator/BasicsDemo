//
//  ViewController.m
//  AnimationDemo
//
//  Created by 谢佳培 on 2021/3/29.
//

#import "ViewController.h"

#define UIAnimationDuration 5.0

@interface ViewController ()

@property(nonatomic, assign) CGRect redOriginFrame;
@property(nonatomic, assign) CGRect blueOriginFrame;
@property(nonatomic, strong) UIView *redView;
@property(nonatomic, strong) UIView *blueView;

@end

@implementation ViewController

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 红方块起始frame
    if (CGRectEqualToRect(self.redOriginFrame, CGRectZero))
    {
        self.redOriginFrame = self.redView.frame;
    }
    
    // 蓝方块起始frame
    if (CGRectEqualToRect(self.blueOriginFrame, CGRectZero))
    {
        self.blueOriginFrame = self.blueView.frame;
    }
    
    
    switch (indexPath.item)
    {
        case 0:// 重置
        {
            self.redView.frame = self.redOriginFrame;// 红方块起始frame
            self.redView.alpha = 1.0;// 透明
            self.redView.transform = CGAffineTransformIdentity;// 移动
            self.redView.backgroundColor = [UIColor redColor];
            
            self.blueView.frame = self.blueOriginFrame;// 蓝方块起始frame
            
            break;
        }
        case 1:// 移动红色方块
        {
            CGRect redFrame = self.redView.frame;
            
            // 下移100点
            redFrame.origin.y += 100;
            // 产生动画效果
            [UIView animateWithDuration:UIAnimationDuration animations:^{
                // 红方块新的frame
                self.redView.frame = redFrame;
            }];
            break;
        }
        case 2:// 缩小红色方块，蛮奇怪的，它放大以后再缩小，我明明是减小宽高
        {
            CGRect redFrame = self.redView.frame;
            
            // 缩小宽高
            redFrame.size.width -= 50;
            redFrame.size.height -= 50;
            // 产生动画效果
            [UIView animateWithDuration:UIAnimationDuration animations:^{
                // 红方块新的frame
                self.redView.frame = redFrame;
            }];
            break;
        }
        case 3:// 旋转红色方块
        {
            // 获取初始transform属性
            CGAffineTransform transform = self.redView.transform;
            // 旋转90度
            transform = CGAffineTransformRotate(transform, M_PI/4);
            // 产生动画效果
            [UIView animateWithDuration:UIAnimationDuration animations:^{
                // 红方块新的transform属性
                self.redView.transform = transform;
            }];
            break;
        }
        case 4:// 改变红色为紫色
        {
            [UIView animateWithDuration:UIAnimationDuration animations:^{
                self.redView.backgroundColor = [UIColor purpleColor];
            }];
            break;
        }
        case 5:// 改变透明度为半透明
        {
            [UIView animateWithDuration:UIAnimationDuration animations:^{
                self.redView.alpha = 0.5;
            }];
            break;
        }
        case 6:// 移动红色方块并同时旋转90度
        {
            // 下移
            CGRect redFrame = self.redView.frame;
            redFrame.origin.y += 100;
            
            // 旋转
            CGAffineTransform transform = self.redView.transform;
            transform = CGAffineTransformRotate(transform, M_PI/2);
            
            // 产生动画效果
            [UIView animateWithDuration:UIAnimationDuration animations:^{
                // 新的transform和frame属性
                self.redView.frame = redFrame;
                self.redView.transform = transform;
            }];
            break;
        }
        case 7:// 先移动后旋转
        {
            // 下移
            CGRect redFrame = self.redView.frame;
            redFrame.origin.y += 100;
            
            // 旋转
            CGAffineTransform transform = self.redView.transform;
            transform = CGAffineTransformRotate(transform, M_PI/2);
            
            [UIView animateWithDuration:UIAnimationDuration animations:^{// 下移动画
                self.redView.frame = redFrame;
            } completion:^(BOOL finished) {// 完成后进入旋转动画
                [UIView animateWithDuration:UIAnimationDuration animations:^{
                    self.redView.transform = transform;
                } completion:^(BOOL finished) {// 完成后输出旋转完成
                    NSLog(@"旋转完成");
                }];
            }];
            break;
        }
        case 8:// 通过中心下移
        {
            CGPoint center = self.redView.center;
            // 下移100点
            center.y += 100;
            [UIView animateWithDuration:UIAnimationDuration animations:^{
                // 新的中心
                self.redView.center = center;
            }];
            break;
        }
        case 9:// 渐变方式进行缩放
        {
            // 缩放一半
            CGAffineTransform transform = self.redView.transform;
            transform = CGAffineTransformScale(transform, 0.5, 0.5);
            // 产生动画效果
            [UIView animateWithDuration:UIAnimationDuration delay:1.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                // 新的transform属性
                self.redView.transform = transform;
            } completion:^(BOOL finished) {
                NSLog(@"缩放完成");
            }];
            break;
        }
        case 10:// 通过中心让蓝色和红色方块同时右移
        {
            CGPoint redCenter = self.redView.center;
            CGPoint blueCenter = self.blueView.center;
            
            // 下移100点
            redCenter.x += 100;
            blueCenter.x += 100;
            
            // 产生动画效果
            [UIView animateWithDuration:UIAnimationDuration animations:^{
                self.redView.center = redCenter;
                self.blueView.center = blueCenter;
            }];
            break;
        }
        case 11:// 重复来回移动
        {
            CGPoint center = self.redView.center;
            
            // 下移100点
            center.y += 100;
            // 重复/自动逆向
            [UIView animateWithDuration:UIAnimationDuration delay:0 options:UIViewAnimationOptionRepeat|UIViewAnimationOptionAutoreverse animations:^{
                self.redView.center = center;
            } completion:nil];
            break;
        }
        default:
            break;
    }
}

@end
