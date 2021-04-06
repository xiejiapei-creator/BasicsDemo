//
//  URLSessionDownloadViewController.h
//  BreakpointContinuationDemo
//
//  Created by 谢佳培 on 2021/2/20.
//  Copyright © 2021 xiejiapei. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface URLSessionDownloadViewController : UIViewController

@property (strong, nonatomic) UIProgressView *progressView;
@property (strong, nonatomic) UILabel *progressLabel;

@end

NS_ASSUME_NONNULL_END

