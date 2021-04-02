//
//  RootViewController.m
//  RNCryptorDemo
//
//  Created by 谢佳培 on 2020/9/9.
//  Copyright © 2020 xiejiapei. All rights reserved.
//

#import "RootViewController.h"
#import "RNCryptor iOS.h"
#import "ReaderViewController.h"

#define Password  @"xiejiapei"

@interface RootViewController ()<ReaderViewControllerDelegate>

@property(nonatomic, strong) UIImageView *appleImageView;
@property(nonatomic, strong) UIImageView *luckcoffeeImageView;
@property(copy,nonatomic) NSString *filepath;// PDF文件存储路径

@end

@implementation RootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self createSubviews];
    [self decryptCXYRNCryptorTool];
}

- (void)createSubviews
{
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(50.f, 820.f, 300, 50.f)];
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"查看PDF" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.layer.cornerRadius = 5.f;
    button.clipsToBounds = YES;
    button.layer.borderWidth = 1.f;
    button.layer.borderColor = [UIColor blackColor].CGColor;
    [self.view addSubview:button];

    
    self.appleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(50, 100, 300, 300)];
    [self.view addSubview:self.appleImageView];
    
    self.luckcoffeeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(50, 500, 300, 300)];
    [self.view addSubview:self.luckcoffeeImageView];
}

// PDF加密
-(void)buttonClicked:(id)sender
{
    [self PDFEncryption];
}

#pragma mark - 基本使用

// 基本使用Demo
- (void)basicUse
{
    // 获得需要加密的数据
    NSString *str = @"谢佳培";
    NSLog(@"加密内容为：%@",str);
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    // 加密秘钥
    NSString *privateKey = @"123456";
    // 错误
    NSError *error;
    
    // RNCryptor加密
    NSData *encryptedData = [RNEncryptor encryptData:data withSettings:kRNCryptorAES256Settings password: privateKey error:&error];
    
    // RNCryptor解密
    NSData *decryptedData = [RNDecryptor decryptData:encryptedData withSettings:kRNCryptorAES256Settings password: privateKey error:&error];
    
    // 转为字符串
    NSString *resultStr = [[NSString alloc] initWithData:decryptedData encoding:NSUTF8StringEncoding];
    
    NSLog(@"解密内容为：%@",resultStr);
}

#pragma mark - CXYRNCryptorTool

// 针对 CXYRNCryptorTool mac端加密小工具 进行解密Demo
- (void)decryptCXYRNCryptorTool
{
    NSData *encryptedAppleData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"apple" ofType:@"cxy"]];
    
    NSData *encryptedLuckcoffeeData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"luckcoffee" ofType:@"cxy"]];
    
    NSError *appleError;
    NSError *luckcoffeeError;
    
    NSData *decryptedAppleData = [RNDecryptor decryptData:encryptedAppleData withPassword:@"xiejiapei" error:&appleError];
    NSData *decryptedLuckcoffeeData = [RNDecryptor decryptData:encryptedLuckcoffeeData withPassword:@"xiejiapei" error:&luckcoffeeError];
    
    if (!appleError)
    {
        NSLog(@"======解开苹果!=====");
        UIImage *image = [UIImage imageWithData:decryptedAppleData];
        self.appleImageView.image = image;
    }
    else
    {
        NSLog(@"======苹果坏了!=====");
    }
    
    if (!luckcoffeeError)
    {
        NSLog(@"======解开瑞幸咖啡!=====");
        UIImage *image = [UIImage imageWithData:decryptedLuckcoffeeData];
        self.luckcoffeeImageView.image = image;
    }
    else
    {
        NSLog(@"======瑞幸咖啡喝光了!=====");
    }
}

#pragma mark - PDF

// PDF加密
- (void)PDFEncryption
{
    __block NSData *encryptedData;// 用于加密的数据
    __block NSError *error;// 出错
    
    // 1.获取待加密PDF
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"天域苍穹小说.pdf" ofType:nil];
    
    // 2.用于加密成功后存入的沙盒目录
    NSString *fileEncryPath = [NSHomeDirectory()stringByAppendingPathComponent:@"/Documents/novel.xiejiapei"];
    
    // 3.判断是否已存在加密文件，若存在直接执行解密过程
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:fileEncryPath])
    {
        // PDF解密
        [self PDFDecryptedData:[NSData dataWithContentsOfFile:fileEncryPath]];
        return;
    }
    
    // 4.异步去加密，防止占用太多内存
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 将PDF转化为数据
        NSData *data = [NSData dataWithContentsOfFile:filePath];
        
        // 对数据进行加密
        encryptedData = [RNEncryptor encryptData:data withSettings:kRNCryptorAES256Settings password:Password error:&error ];
        
        // 加密成功
        if (!error)
        {
            NSLog(@"^_^ PDF加密成功 ……——(^_^)\n");
            NSLog(@"加密后数据为 == %@",encryptedData);
        }
        
        // 5.在主线程上写入加密后的文件到沙盒目录
        dispatch_sync(dispatch_get_main_queue(), ^{
            BOOL isSuccessfullyStored = [encryptedData writeToFile:fileEncryPath atomically:NO];
           
            if (isSuccessfullyStored)
            {
                NSLog(@"加密文件写入到沙盒目录成功");

            }
            else
            {
                NSLog(@"加密文件写入到沙盒目录失败");
            }
            
            NSLog(@"写入PDF的路径：%@",fileEncryPath);
            
            // 6.PDF解密
            [self PDFDecryptedData:encryptedData];
        });
    });
  
}

// PDF解密
- (void)PDFDecryptedData:(NSData *)encryptedData
{
    // 1.用于解密成功后存入的沙盒目录
    NSString *fileDecryPath = [NSHomeDirectory() stringByAppendingPathComponent:@"/Documents/novel.pdf"];
    
    // 2.异步去解密，防止占用太多内存
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSError *error;// 出错
        
        if (encryptedData != nil || Password != nil)
        {
            // 解密
            NSData *decryptedData = [RNDecryptor decryptData:encryptedData withPassword:Password error:&error];
            
            // 3.在主线程上写入解密后的文件到沙盒目录
            dispatch_sync(dispatch_get_main_queue(), ^{
                 BOOL isSuccessfullyStored = [decryptedData writeToFile:fileDecryPath atomically:NO];
                
                if (isSuccessfullyStored)
                {
                    NSLog(@"解密文件写入成功");
                    NSLog(@"解密PDF写入的路径为：%@",fileDecryPath);
                    
                    self.filepath = fileDecryPath;
                    [self pushReaderVC];
                }
                else
                {
                    NSLog(@"解密文件写入失败");
                }
            });
        }
        else
        {
            NSLog(@"加密数据为空");
        }
    });
}

// 跳转到阅读器视图
-(void)pushReaderVC
{
    // 1.实例化控制器
    NSString *phrase = nil;
    ReaderDocument *document = [ReaderDocument withDocumentFilePath:self.filepath password:phrase];
    
    // 2.跳转到阅读器视图
    if (document != nil)
    {
        ReaderViewController *readerViewController = [[ReaderViewController alloc] initWithReaderDocument:document];
        readerViewController.delegate = self;
        
        readerViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        readerViewController.modalPresentationStyle = UIModalPresentationFullScreen;
        
        [self presentViewController:readerViewController animated:YES completion:NULL];
        
    }
    else// 3.没有PDF文件
    {
        NSLog(@"%s [ReaderDocument withDocumentFilePath:'%@' password:'%@'] failed.", __FUNCTION__, self.filepath, phrase);
        NSLog(@"没有PDF文件");
    }

}

// ReaderViewControllerDelegate
- (void)dismissReaderViewController:(ReaderViewController *)viewController
{
    // 退出查看PDF时删除解密存储文件
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:self.filepath error:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
