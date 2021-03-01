//
//  ViewController.m
//  UnitTestingDemo
//
//  Created by 谢佳培 on 2021/2/24.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (int)getPlus:(int)num1 num2:(int)num2
{
    return num1 + num2 + 10;
}

- (void)loadData:(void (^)(id data))dataBlock
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [NSThread sleepForTimeInterval:2];
        
        NSString *dataString = @"海子的诗";
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"更新UI");
            dataBlock(dataString);
        });
    });
}

- (void)openCamera
{
   for (int i = 0; i<100; i++)
    {
       NSLog(@"摄影写真");
   }
}

@end
