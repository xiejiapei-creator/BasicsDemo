//
//  URLSessionDownloadViewController.m
//  BreakpointContinuationDemo
//
//  Created by 谢佳培 on 2021/2/20.
//  Copyright © 2021 xiejiapei. All rights reserved.
//

#import "URLSessionDownloadViewController.h"
#import "DownloadNetworkTool.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>

@interface URLSessionDownloadViewController ()<DownLoadDelegate>

@property (nonatomic, strong) DownloadNetworkTool *fileDownloadNetwork;

@end

@implementation URLSessionDownloadViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"断点续传Demo";
    self.view.backgroundColor = [UIColor whiteColor];
    [self createSubviews];
}

- (void)createSubviews
{
    UIButton *startButton = [[UIButton alloc] initWithFrame:CGRectMake(50.f, 320.f, 300, 50.f)];
    [startButton addTarget:self action:@selector(startNew) forControlEvents:UIControlEventTouchUpInside];
    [startButton setTitle:@"开始/继续下载" forState:UIControlStateNormal];
    [startButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    startButton.layer.cornerRadius = 5.f;
    startButton.clipsToBounds = YES;
    startButton.layer.borderWidth = 1.f;
    startButton.layer.borderColor = [UIColor blackColor].CGColor;
    [self.view addSubview:startButton];
    
    UIButton *pauseButton = [[UIButton alloc] initWithFrame:CGRectMake(50.f, 420.f, 300, 50.f)];
    [pauseButton addTarget:self action:@selector(pause) forControlEvents:UIControlEventTouchUpInside];
    [pauseButton setTitle:@"暂停下载" forState:UIControlStateNormal];
    [pauseButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    pauseButton.layer.cornerRadius = 5.f;
    pauseButton.clipsToBounds = YES;
    pauseButton.layer.borderWidth = 1.f;
    pauseButton.layer.borderColor = [UIColor blackColor].CGColor;
    [self.view addSubview:pauseButton];
    
    UIButton *pauseAndSaveButton = [[UIButton alloc] initWithFrame:CGRectMake(50.f, 520.f, 300, 50.f)];
    [pauseAndSaveButton addTarget:self action:@selector(suspendAndSaveFileDownload) forControlEvents:UIControlEventTouchUpInside];
    [pauseAndSaveButton setTitle:@"暂停并保存下载进度" forState:UIControlStateNormal];
    [pauseAndSaveButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    pauseAndSaveButton.layer.cornerRadius = 5.f;
    pauseAndSaveButton.clipsToBounds = YES;
    pauseAndSaveButton.layer.borderWidth = 1.f;
    pauseAndSaveButton.layer.borderColor = [UIColor blackColor].CGColor;
    [self.view addSubview:pauseAndSaveButton];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 200, 50)];
    label.text = @"下载进度";
    label.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:label];
    self.progressLabel = label;
    
    UIProgressView *progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(100, 200, 200, 50)];
    progressView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:progressView];
    self.progressView = progressView;
}

#pragma mark - 控制下载

- (void)startNew
{
    NSString *fileUrl = @"https://pic.ibaotu.com/00/48/71/79a888piCk9g.mp4";
    if(self.fileDownloadNetwork == nil)
    {
        self.fileDownloadNetwork = [DownloadNetworkTool new];
        self.fileDownloadNetwork.tag = 1;
        self.fileDownloadNetwork.myDeleate = self;
    }
    [self.fileDownloadNetwork downFile:fileUrl];
}

- (void)pause
{
    [self.fileDownloadNetwork suspendDownload];
}

- (void)suspendAndSaveFileDownload
{
    [self.fileDownloadNetwork suspendAndSaveFileDownload];
}

#pragma mark - 下载进度

// 每返回一个数据包就调用一次以显示下载进度
- (void)backDownprogress:(float)progress tag:(NSInteger)tag
{
    self.progressView.progress = progress;
    self.progressLabel.text = [NSString stringWithFormat:@"%0.1f%@",progress*100,@"%"];
}

// 下载成功
- (void)downSucceed:(NSURL*)url tag:(NSInteger)tag
{
    NSLog(@"下载成功,准备播放");
    [self paly: url];
    
    self.progressView.progress = 0;
    self.progressLabel.text = @"0.0%";
    self.fileDownloadNetwork = nil;
}

// 下载失败
- (void)downError:(NSError*)error tag:(NSInteger)tag
{
    NSLog(@"下载失败，请重新下载 :%@",error);
    
    self.fileDownloadNetwork = nil;
    self.progressView.progress = 0;
    self.progressLabel.text = @"0.0%";
}

#pragma mark - 视频播放

- (void)paly:(NSURL*)playUrl
{
    // 系统的视频播放器
    AVPlayerViewController *controller = [[AVPlayerViewController alloc]init];
    // 播放器的播放类
    AVPlayer * player = [[AVPlayer alloc]initWithURL:playUrl];
    controller.player = player;
    // 自动开始播放
    [controller.player play];
    // 展示视屏播放器
    [self presentViewController:controller animated:YES completion:nil];
}

@end
