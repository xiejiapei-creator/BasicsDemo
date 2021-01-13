//
//  JumpToOtherAPPViewController.m
//  DeviceInfoDemo
//
//  Created by 谢佳培 on 2020/10/28.
//  Copyright © 2020 xiejiapei. All rights reserved.
//

#import "JumpToOtherAPPViewController.h"

@interface JumpToOtherAPPViewController ()

@end

@implementation JumpToOtherAPPViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(50.f, 820.f, 300, 50.f)];
    [button addTarget:self action:@selector(checkVersion) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"跳转APP" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.layer.cornerRadius = 5.f;
    button.clipsToBounds = YES;
    button.layer.borderWidth = 1.f;
    button.layer.borderColor = [UIColor blackColor].CGColor;
    [self.view addSubview:button];
}

// 跳转到App Store的链接itms-apps://itunes.apple.com/cn/app/id（你的APPID）
// AppID的查询方法为APP Store里面的分享链接 https://apps.apple.com/cn/app/%E7%9F%A5%E4%B9%8E-%E6%9C%89%E9%97%AE%E9%A2%98-%E4%B8%8A%E7%9F%A5%E4%B9%8E/id432274380
- (void)checkVersion
{
    // 你的项目ID
    NSString *storeAppID = @"414478124";// 微信的AppID
    
    // 参数appid指的是你在app在创建后的唯一标识，在iTunes Connect里可以查找到此信息
    NSString *storeAppIDString = [NSString stringWithFormat:@"http://itunes.apple.com/cn/lookup?id=%@",storeAppID];
    NSURL *url = [NSURL URLWithString:storeAppIDString];
    
    // 联网检测项目在AppStore上的版本号
    // 此接口将返回一个JSON格式的字串内容，其中一个就是版本信息，如"version":"1.2.0"
    [[[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSDictionary * dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        NSArray *results = dataDic[@"results"];
        if (results && results.count > 0)
        {
            NSDictionary *response = results.firstObject;
            
            NSLog(@"接口返回的APP信息包括：%@",response);
            
            // APP的当前版本
            NSString *currentVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
            // AppStore 上软件的最新版本
            NSString *lastestVersion = response[@"version"];
            
            NSLog(@"APP的当前版本：%@，AppStore 上软件的最新版本：%@",currentVersion,lastestVersion);
            
            if (currentVersion && lastestVersion && ![self isLastestVersion:currentVersion compare:lastestVersion])
            {
                // 新版本更新内容
                NSString *releaseNotes = response[@"releaseNotes"];
                NSString *alertContent = [NSString stringWithFormat:@"%@\n\n是否前往 AppStore 更新版本？",releaseNotes];
                NSLog(@"新版本更新内容：%@",releaseNotes);
                
                // 给出提示是否前往 AppStore 更新
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"检测到有版本更新" message:alertContent preferredStyle:UIAlertControllerStyleAlert];
                
                [alert addAction:[UIAlertAction actionWithTitle:@"前往" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    
                    // AppStore 上APP的地址
                    NSString *trackViewUrl = response[@"trackViewUrl"];
                    NSLog(@"AppStore 上APP的地址：%@",trackViewUrl);
                    if (trackViewUrl)
                    {
                        NSURL *appStoreURL = [NSURL URLWithString:trackViewUrl];
                        if ([[UIApplication sharedApplication] canOpenURL:appStoreURL])
                        {
                            [[UIApplication sharedApplication] openURL:appStoreURL options:@{} completionHandler:nil];
                            NSLog(@"进入到了APP Store更新APP");
                        }
                    }
                }]];
                [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
                });
            }
        }
    }] resume];
}

// 判断是否最新版本号（大于或等于为最新）
- (BOOL)isLastestVersion:(NSString *)currentVersion compare:(NSString *)lastestVersion
{
    if (currentVersion && lastestVersion)
    {
        // 拆分成数组
        NSMutableArray *currentItems = [[currentVersion componentsSeparatedByString:@"."] mutableCopy];
        NSMutableArray *lastestItems = [[lastestVersion componentsSeparatedByString:@"."] mutableCopy];
        
        // 如果数量不一样补0
        NSInteger currentCount = currentItems.count;
        NSInteger lastestCount = lastestItems.count;
        
        if (currentCount != lastestCount)
        {
            // 取绝对值
            NSInteger count = labs(currentCount - lastestCount);
            for (int i = 0; i < count; ++i)
            {
                if (currentCount > lastestCount)
                {
                    [lastestItems addObject:@"0"];
                }
                else
                {
                    [currentItems addObject:@"0"];
                }
            }
        }
        
        // 依次比较
        BOOL isLastest = YES;
        for (int i = 0; i < currentItems.count; ++i)
        {
            NSString *currentItem = currentItems[i];
            NSString *lastestItem = lastestItems[i];
            if (currentItem.integerValue != lastestItem.integerValue)
            {
                isLastest = currentItem.integerValue > lastestItem.integerValue;
                break;
            }
        }
        return isLastest;
    }
    return NO;
}

@end
