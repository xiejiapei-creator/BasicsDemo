//
//  RootViewController.m
//  EncryptedDemo
//
//  Created by 谢佳培 on 2020/9/9.
//  Copyright © 2020 xiejiapei. All rights reserved.
//

#import "RootViewController.h"
#import "NSString+Hash.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self MD5Demo];
}

// MD5加密
- (void)MD5Demo
{
    NSString *originString = @"123";
    NSString *MD5String = [originString md5String];
    NSLog(@"原字符串为：%@",originString);
    NSLog(@"MD5加密后的字符为：%@",MD5String);
    
    // 加盐（Salt）
    NSString *salt = @"fdsfjf)*&*JRhuhew7HUH^&udn&&86&*";
    NSString *saltString = [originString stringByAppendingString:salt];
    NSString *MD5SaltString = [saltString md5String];
    NSLog(@"加盐（Salt）+ MD5加密后的字符为：%@",MD5SaltString);
    
    // HMAC + MD5
    NSString *HMACMD5String = [originString hmacMD5StringWithKey:@"xiejiapei"];
    NSLog(@"HMAC + MD5 加密后的字符为：%@",HMACMD5String);
}

@end
