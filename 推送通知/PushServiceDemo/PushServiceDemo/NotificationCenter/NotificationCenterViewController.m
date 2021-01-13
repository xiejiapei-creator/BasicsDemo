//
//  NotificationCenterViewController.m
//  PushServiceDemo
//
//  Created by 谢佳培 on 2020/10/23.
//

#import "NotificationCenterViewController.h"
#import <Masonry.h>

@interface NotificationCenterViewController ()

// 用来显示推送服务的功能提示信息
@property (nonatomic, strong) UILabel* noteInfoLabel;

@end

@implementation NotificationCenterViewController

#pragma mark - Life Circle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self createSubViews];
}

- (void)createSubViews
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 创建推送通知按钮
    UIButton *createNotificationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [createNotificationButton.layer setCornerRadius:22.0f];
    [createNotificationButton setBackgroundColor:[UIColor redColor]];
    [createNotificationButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [createNotificationButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [createNotificationButton setTitle:@"创建推送通知"
                              forState:UIControlStateNormal];
    [createNotificationButton addTarget:self
                                 action:@selector(createNotification:)
                       forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:createNotificationButton];
    [createNotificationButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-10.0f);
        make.left.equalTo(self.view).offset(20.0f);
        make.centerX.equalTo(self.view);
        make.height.offset(44.0f);
    }];

    // 用来显示推送服务的功能提示信息
    self.noteInfoLabel = [[UILabel alloc] init];
    [self.noteInfoLabel.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [self.noteInfoLabel.layer setBorderWidth:1.0f];
    [self.noteInfoLabel setNumberOfLines:0];
    [self.noteInfoLabel setTextColor:[UIColor grayColor]];
    [self.view addSubview:self.noteInfoLabel];
    [self.noteInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.left.equalTo(self.view).offset(10.0f);
        make.top.equalTo(self.view).offset(44 + 20 + 10.0f);
        make.height.offset(200.0f);
    }];
}

#pragma mark - 创建通知

// 创建通知
- (void)createNotification:(UIButton *)sender
{
    NSAssert(NO, @"该方法需要重写，并且创建不同的通知信息");
}

// 构建通知按钮的功能描述信息
- (void)buildNotificationDescribe:(NSString *)describeString
{
    NSAssert(YES, @"该方法需要重写，并且创建不同的提示信息");
    [self.noteInfoLabel setText:describeString];
}

@end
