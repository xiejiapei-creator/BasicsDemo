//
//  UserDefaultViewController.m
//  LocalCacheDemo
//
//  Created by 谢佳培 on 2020/10/16.
//

#import "UserDefaultViewController.h"

@interface UserDefaultViewController ()

@end

@implementation UserDefaultViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self saveData];
    [self readData];
}

// 存入数据
- (void)saveData
{
    // 获得NSUserDefaults文件
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    // 向文件中写入内容
    [defaults setObject:@"谢佳培" forKey:@"name"];
    [defaults setInteger:22 forKey:@"age"];
    [defaults setFloat:18.0f forKey:@"text_size"];
    
    UIImage *image = [UIImage imageNamed:@"luckcoffee.JPG"];
    NSData *imageData = UIImageJPEGRepresentation(image, 100);
    [defaults setObject:imageData forKey:@"image"];
    
    // synchronize强制存储，并非必要，因为系统会默认调用，但是你确认了就会马上存储
    [defaults synchronize];
}

// 取出数据
- (void)readData
{
    // 获得NSUserDefaults文件
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *name = [defaults valueForKey:@"name"];
    NSInteger age = [defaults integerForKey:@"age"];
    UIImage *image = [defaults valueForKey:@"image"];
    float textSize = [defaults floatForKey:@"text_size"];
    
    NSLog(@"姓名：%@",name);
    NSLog(@"年龄：%ld",(long)age);
    NSLog(@"图片：%@",image);
    NSLog(@"字号：%f",textSize);
}

@end
