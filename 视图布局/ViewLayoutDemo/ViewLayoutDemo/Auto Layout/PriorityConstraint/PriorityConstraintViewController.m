//
//  PriorityConstraintViewController.m
//  ViewLayoutDemo
//
//  Created by 谢佳培 on 2020/10/14.
//

#import "PriorityConstraintViewController.h"
#import <Masonry.h>

static NSString *const NameText = @"这是一个很长很长的昵称";
static NSInteger changeLength = -1;// 记录单次变化长度

@interface PriorityConstraintViewController ()

@property(nonatomic,assign) double topLeftValue;
@property(nonatomic,assign) double topRightValue;
@property(nonatomic,assign) double bottomLeftValue;
@property(nonatomic,assign) double bottomRightValue;

@property (strong,nonatomic) UILabel *topLeftLabel;
@property (strong,nonatomic) UILabel *topRightLabel;
@property (strong,nonatomic) UILabel *bottomLeftLabel;
@property (strong,nonatomic) UILabel *bottomRightLabel;

@property (strong,nonatomic) UIImageView *portrait;
@property (strong,nonatomic) UILabel *nameLeftLabel;
@property (strong,nonatomic) UILabel *timeRightLabel;

@end

@implementation PriorityConstraintViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self createSubviews];
    
    self.nameLeftLabel.text = NameText;
    self.timeRightLabel.text = @"一周以前一周以前一周以前一周以前";

    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(action) userInfo:nil repeats:YES];
}

- (void)createSubviews
{
// Hug
    
    UILabel *topLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    topLabel.text = @"Content Hugging Priority";
    topLabel.textColor = [UIColor blackColor];
    [self.view addSubview:topLabel];
    [topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(20);
        make.centerX.equalTo(self.view);
        make.height.equalTo(@40);
    }];
    
    UIStepper *topLeftStepper = [[UIStepper alloc] initWithFrame:CGRectZero];
    [topLeftStepper addTarget:self action:@selector(clickTopLeftStepper:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:topLeftStepper];
    [topLeftStepper mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(50);
        make.top.equalTo(topLabel.mas_bottom).offset(20);
        make.height.equalTo(@100);
    }];
    

    UIStepper *topRightStepper = [[UIStepper alloc] initWithFrame:CGRectZero];
    [topRightStepper addTarget:self action:@selector(clickTopRightStepper:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:topRightStepper];
    [topRightStepper mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topLeftStepper.mas_right).offset(60);
        make.top.equalTo(topLabel.mas_bottom).offset(20);
        make.height.equalTo(@100);
    }];
    
    UILabel *topLeftLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    topLeftLabel.text = @"宇";
    topLeftLabel.backgroundColor = [UIColor redColor];
    // 设置Hug，不想变大被拉伸
    [topLeftLabel setContentHuggingPriority:251 forAxis:UILayoutConstraintAxisHorizontal];
    [self.view addSubview:topLeftLabel];
    [topLeftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topLeftStepper.mas_bottom).offset(20);
        make.left.equalTo(self.view).offset(10);
        make.width.mas_lessThanOrEqualTo(200);
        make.height.equalTo(@100);
    }];
    self.topLeftLabel = topLeftLabel;
    
    UILabel *topRightLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    topRightLabel.text = @"宙";
    topRightLabel.backgroundColor = [UIColor yellowColor];
    // 设置Hug
    [topRightLabel setContentHuggingPriority:250 forAxis:UILayoutConstraintAxisHorizontal];
    [self.view addSubview:topRightLabel];
    [topRightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topRightStepper.mas_bottom).offset(20);
        make.left.equalTo(topLeftLabel.mas_right).offset(8);
        make.right.equalTo(self.view);
        make.height.equalTo(@100);
    }];
    self.topRightLabel = topRightLabel;
    
    
// Compress
    
    UILabel *bottomLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    bottomLabel.text = @"Content Compression Resistance Priority";
    [self.view addSubview:bottomLabel];
    [bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topRightLabel.mas_bottom).offset(50);
        make.centerX.equalTo(self.view);
        make.width.equalTo(@350);
        make.height.equalTo(@40);
    }];
    
    UIStepper *bottomLeftStepper = [[UIStepper alloc] initWithFrame:CGRectZero];
    [bottomLeftStepper addTarget:self action:@selector(clickBottomLeftStepper:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bottomLeftStepper];
    [bottomLeftStepper mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topLeftStepper.mas_left);
        make.top.equalTo(bottomLabel.mas_bottom).offset(20);
        make.height.equalTo(@50);
    }];
    
    UIStepper *bottomRightStepper = [[UIStepper alloc] initWithFrame:CGRectZero];
    [bottomRightStepper addTarget:self action:@selector(clickBottomRightStepper:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bottomRightStepper];
    [bottomRightStepper mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topRightStepper.mas_left);
        make.top.equalTo(bottomLabel.mas_bottom).offset(20);
        make.height.equalTo(@50);
    }];
    
    UISwitch *bottomSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
    [bottomSwitch addTarget:self action:@selector(setPriority:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bottomSwitch];
    [bottomSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(bottomLeftStepper.mas_bottom).offset(20);
        make.width.height.equalTo(@50);
    }];
    
    UILabel *bottomLeftLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    bottomLeftLabel.text = @"洪";
    bottomLeftLabel.backgroundColor = [UIColor redColor];
    [self.view addSubview:bottomLeftLabel];
    [bottomLeftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomSwitch.mas_bottom).offset(20);
        make.left.equalTo(self.view).offset(10);
        make.width.mas_greaterThanOrEqualTo(50);
        make.height.equalTo(@100);
    }];
    self.bottomLeftLabel = bottomLeftLabel;
    
    UILabel *bottomRightLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    bottomRightLabel.text = @"荒";
    bottomRightLabel.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:bottomRightLabel];
    [bottomRightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomSwitch.mas_bottom).offset(20);
        make.left.equalTo(bottomLeftLabel.mas_right).offset(8);
        make.right.equalTo(self.view);
        make.height.equalTo(@100);
        make.width.mas_greaterThanOrEqualTo(100);
    }];
    self.bottomRightLabel = bottomRightLabel;
    
// 昵称
    UIImageView *portrait = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"luckcoffee.JPG"]];
    [self.view addSubview:portrait];
    [portrait mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10);
        make.width.height.equalTo(@50);
        make.top.equalTo(bottomLeftLabel.mas_bottom).offset(20);
    }];
    
    UILabel *nameLeftLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    nameLeftLabel.backgroundColor = [UIColor blueColor];
    [self.view addSubview:nameLeftLabel];
    // 设置Hug，不想变大被拉伸
    [nameLeftLabel setContentHuggingPriority:251 forAxis:UILayoutConstraintAxisHorizontal];// 251抗拒拉伸
    // 设置抗压缩，不想缩小
    [nameLeftLabel setContentCompressionResistancePriority:749 forAxis:UILayoutConstraintAxisHorizontal];// 749想缩小
    [self.view addSubview:topLeftLabel];
    [nameLeftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomLeftLabel.mas_bottom).offset(20);
        make.left.equalTo(portrait.mas_right).offset(10);
        make.height.equalTo(@50);
    }];
    self.nameLeftLabel = nameLeftLabel;
    
    UILabel *timeRightLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    timeRightLabel.backgroundColor = [UIColor greenColor];
    // 设置Hug，不想变大被拉伸
    [nameLeftLabel setContentHuggingPriority:250 forAxis:UILayoutConstraintAxisHorizontal];// 250默认值
    // 设置抗压缩，不想缩小
    [nameLeftLabel setContentCompressionResistancePriority:750 forAxis:UILayoutConstraintAxisHorizontal];// 750默认值
    [self.view addSubview:timeRightLabel];
    [timeRightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomLeftLabel.mas_bottom).offset(20);
        make.left.equalTo(nameLeftLabel.mas_right).offset(8);
        make.right.equalTo(self.view);
        make.height.equalTo(@50);
    }];
    self.timeRightLabel = timeRightLabel;
}

#pragma mark - Events

- (void)clickTopLeftStepper:(id)sender
{
    UIStepper *stepper = (UIStepper *)sender;
    NSLog(@"stepperValue:%f，topLeftValue:%f",stepper.value,self.topLeftValue);
    if (stepper.value > self.topLeftValue)
    {
        self.topLeftLabel.text = [self.topLeftLabel.text stringByAppendingString:@"宇"];
    }
    else
    {
        self.topLeftLabel.text = [self.topLeftLabel.text substringToIndex:(self.topLeftLabel.text.length - 1)];
    }
    self.topLeftValue = stepper.value;
}

- (void)clickTopRightStepper:(id)sender
{
    UIStepper *stepper = (UIStepper *)sender;
    if (stepper.value > self.topRightValue)
    {
        self.topRightLabel.text = [self.topRightLabel.text stringByAppendingString:@"宙"];
    }
    else
    {
        self.topRightLabel.text = [self.topRightLabel.text substringToIndex:(self.topRightLabel.text.length - 1)];
    }
    self.topRightValue = stepper.value;
}

- (void)clickBottomLeftStepper:(id)sender
{
    UIStepper *stepper = (UIStepper *)sender;
    if (stepper.value > self.bottomLeftValue)
    {
        self.bottomLeftLabel.text = [self.bottomLeftLabel.text stringByAppendingString:@"洪"];
    }
    else
    {
        self.bottomLeftLabel.text = [self.bottomLeftLabel.text substringToIndex:(self.bottomLeftLabel.text.length - 1)];
    }
    self.bottomLeftValue = stepper.value;
}

- (void)clickBottomRightStepper:(id)sender
{
    UIStepper *stepper = (UIStepper *)sender;
    if (stepper.value > self.bottomRightValue)
    {
        self.bottomRightLabel.text = [self.bottomRightLabel.text stringByAppendingString:@"荒"];
    }
    else
    {
        self.bottomRightLabel.text = [self.bottomRightLabel.text substringToIndex:(self.bottomRightLabel.text.length - 1)];
    }
    self.bottomRightValue = stepper.value;
}

- (void)setPriority:(UISwitch *)sender
{
    // 设置抗压缩，不想缩小
    if (sender.isOn)
    {
        [self.bottomRightLabel setContentCompressionResistancePriority:755 forAxis:UILayoutConstraintAxisHorizontal];
    }
    else
    {
        [self.bottomRightLabel setContentCompressionResistancePriority:745 forAxis:UILayoutConstraintAxisHorizontal];
    }
}

-(void)action
{
    // 当前昵称
    NSString *name = [NameText substringToIndex:self.nameLeftLabel.text.length + changeLength];
    
    // 设置昵称
    self.nameLeftLabel.text = name;
    
    
    if(self.nameLeftLabel.text.length <= 3)
    {
        // 达到最小宽度后开始增加，步数为1
        changeLength = 1;
    }
    else if(self.nameLeftLabel.text.length == NameText.length)
    {
        // 达到最大宽度后开始减少，步数为1
        changeLength = -1;;
    }
}


@end
