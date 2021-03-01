//
//  ViewController.h
//  UnitTestingDemo
//
//  Created by 谢佳培 on 2021/2/24.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

- (int)getPlus:(int)num1 num2:(int)num2;

- (void)loadData:(void (^)(id data))dataBlock;

- (void)openCamera;

@end

