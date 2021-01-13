//
//  SandboxViewController.m
//  LocalCacheDemo
//
//  Created by 谢佳培 on 2020/10/19.
//

#import "SandboxViewController.h"
#import "BookMarkViewController.h"

@interface SandboxViewController ()

@property (nonatomic, strong) BookMarkViewController *bookMarkVC;

@end

@implementation SandboxViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.bookMarkVC = [[BookMarkViewController alloc] init];
    
    [self getSandBoxPath];
}

// 获取沙盒的相关路径
- (void)getSandBoxPath
{
    // 获取APP沙盒位置
    NSString *homeDirectory = NSHomeDirectory();
    NSLog(@"APP沙盒位置：%@",homeDirectory);
    
    // 获取Document目录
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSLog(@"获取Document目录：%@",documentPath);
    
    // 获取Library目录
    NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
    NSLog(@"获取Library目录：%@",libraryPath);
    
    // 获取Caches目录
    NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSLog(@"获取Caches目录：%@",cachesPath);
    
    // 获取Preferences目录 通常情况下，Preferences有系统维护，所以我们很少去操作它。
    NSString *preferencesPath = [libraryPath stringByAppendingPathComponent:@"Preferences"];
    NSLog(@"获取Preferences目录：%@",preferencesPath);
    
    // 获取tmp目录
    NSString *temporaryPath = NSTemporaryDirectory();
    NSLog(@"获取tmp目录：%@",temporaryPath);
}

// NSDocumentationDirectory
- (void)URLSForNSDocumentationDirectory
{
    NSArray<NSURL *> *arrayURLs = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentationDirectory inDomains:NSUserDomainMask];
    if (arrayURLs)
    {
        for (NSURL *urlItem in arrayURLs)
        {
            NSLog(@"绝对路径：%@",urlItem.absoluteString);
            NSLog(@"相对路径：%@",urlItem.path);
        }
    }
    else
    {
        NSLog(@"arrayURLs 为空");
    }
}

// NSDocumentDirectory
- (void)URLSForNSDocumentDirectory
{
    NSArray<NSURL *> *arrayURLs = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    if (arrayURLs)
    {
        for (NSURL *urlItem in arrayURLs)
        {
            NSLog(@"路径为：%@",urlItem.path);
            NSData *bookmark = [self.bookMarkVC bookmarkForURL:urlItem];
            NSLog(@"书签为：%@",bookmark);
        }
    }
    else
    {
        NSLog(@"arrayURLs 为空");
    }
}


@end
