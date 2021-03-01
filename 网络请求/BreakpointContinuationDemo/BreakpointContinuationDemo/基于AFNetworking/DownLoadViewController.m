//
//  DownLoadViewController.m
//  BreakpointContinuationDemo
//
//  Created by 谢佳培 on 2020/7/27.
//  Copyright © 2020 xiejiapei. All rights reserved.
//

#import "DownLoadViewController.h"
#import "NetworkServerDownLoadTool.h"

@interface DownLoadViewController () 

@property (nonatomic,copy) NSString *downLoadUrl;// 下载地址
@property (nonatomic,strong) NSURL *fileUrl;// 本地保存地址
@property (nonatomic,strong) NSURLSessionDownloadTask *downloadTask;// 下载任务
@property (nonatomic,assign) BOOL isDownLoading;

@end

@implementation DownLoadViewController

#pragma mark - Life Circle

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
    
    UIButton *pauseAllButton = [[UIButton alloc] initWithFrame:CGRectMake(50.f, 520.f, 300, 50.f)];
    [pauseAllButton addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    [pauseAllButton setTitle:@"暂停所有下载任务" forState:UIControlStateNormal];
    [pauseAllButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    pauseAllButton.layer.cornerRadius = 5.f;
    pauseAllButton.clipsToBounds = YES;
    pauseAllButton.layer.borderWidth = 1.f;
    pauseAllButton.layer.borderColor = [UIColor blackColor].CGColor;
    [self.view addSubview:pauseAllButton];
    
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"断点续传Demo";
    self.view.backgroundColor = [UIColor whiteColor];
    [self createSubviews];
    
    // 下载进度
    self.progressView.progress = 0;
    
    // 未开始下载
    self.isDownLoading = NO;
    
    // 资源不确定一直都在，自己可以找一个能下载的资源使用
    self.downLoadUrl = @"https://www.apple.com/105/media/cn/iphone-x/2017/01df5b43-28e4-4848-bf20-490c34a926a7/films/feature/iphone-x-feature-cn-20170912_1280x720h.mp4";
    
    // 要检查的文件目录
    NSString *localPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [localPath stringByAppendingPathComponent:@"iphoneX.mp4"];
    self.fileUrl = [NSURL fileURLWithPath:filePath isDirectory:NO];
}

#pragma mark - Events


// 点击开始/继续下载
- (void)startNew
{
    // 正处于下载之中则直接返回
    if (self.isDownLoading)
    {
        return;
    }
    
    self.isDownLoading = YES;
    // 根据封装的断点续传工具类创建下载任务
    NSURLSessionDownloadTask *tempTask = [[NetworkServerDownLoadTool sharedTool] AFDownLoadFileWithUrl:self.downLoadUrl progress:^(CGFloat progress) {
        // 回到主线程刷新显示进度
        dispatch_async(dispatch_get_main_queue(), ^{
            self.progressView.progress = progress;
            NSLog(@"当前的进度 = %f",progress);
            self.progressLabel.text = [NSString stringWithFormat:@"进度:%.3f",progress];
        });
    } fileLocalUrl:self.fileUrl success:^(NSURL *fileUrlPath, NSURLResponse *response) {
        NSLog(@"下载成功 下载的文档路径是 %@, ",fileUrlPath);
    } failure:^(NSError *error, NSInteger statusCode) {
        NSLog(@"下载尚未完成，下载的data被downLoad工具暂存了起来，下次可以继续下载");
    }];
    self.downloadTask = tempTask;
}

// 暂停下载任务
- (void)pause
{
    // 可以在这里存储resumeData ,也可以去NetworkServerDownLoadTool里面，根据那个通知去处理，都会回调
    if (self.isDownLoading)
    {
        [self.downloadTask cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
            NSLog(@"已经下载好的data = %@", resumeData);
        }];
    }
    self.isDownLoading = NO;
}

- (void)cancel
{
    if (self.isDownLoading)
    {
        NSLog(@"暂停所有下载任务，能够获取到每个任务的resumeData");
        [[NetworkServerDownLoadTool sharedTool] stopAllDownLoadTasks];
    }
    self.isDownLoading = NO;
}


@end
