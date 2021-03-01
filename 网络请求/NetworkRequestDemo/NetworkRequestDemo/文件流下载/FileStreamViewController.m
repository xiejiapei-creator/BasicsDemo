//
//  FileStreamViewController.m
//  NetworkRequestDemo
//
//  Created by 谢佳培 on 2021/2/22.
//  Copyright © 2021 xiejiapei. All rights reserved.
//

#import "FileStreamViewController.h"
#import "FileStreamNetworkTool.h"

@interface FileStreamViewController ()

@property(nonatomic,strong) UILabel *progressLabel;

@end

@implementation FileStreamViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self createSubview];
}

- (void)createSubview
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(100, 300, 200, 50)];
    label.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:label];
    self.progressLabel = label;
    
    UIButton *downloadButton = [[UIButton alloc] initWithFrame:CGRectMake(50.f, 420.f, 300, 50.f)];
    [downloadButton addTarget:self action:@selector(downloadButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [downloadButton setTitle:@"下载文件" forState:UIControlStateNormal];
    [downloadButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    downloadButton.layer.cornerRadius = 5.f;
    downloadButton.clipsToBounds = YES;
    downloadButton.layer.borderWidth = 1.f;
    downloadButton.layer.borderColor = [UIColor blackColor].CGColor;
    [self.view addSubview:downloadButton];
}

- (void)downloadButtonClicked
{
    __weak typeof(self) weakSelf = self;
    
    FileStreamNetworkTool *fileStream = [FileStreamNetworkTool new];
    [fileStream  getDownFileUrl:@"https://pic.ibaotu.com/00/48/71/79a888piCk9g.mp4" backBlock:^(NSURL *fileUrl,NSString *progress) {
        
        weakSelf.progressLabel.text = progress;
        if (fileUrl)
        {
            NSLog(@"下载到文件路径为：%@",[fileUrl absoluteString]);
        }
    }];
}

@end
