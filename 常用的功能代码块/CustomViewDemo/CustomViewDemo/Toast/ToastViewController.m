//
//  ToastViewController.m
//  FunctionCodeBlockDemo
//
//  Created by 谢佳培 on 2020/9/28.
//

#import "ToastViewController.h"
#import "Masonry.h"

@interface ToastView ()

@property (nonatomic, strong, readwrite) UIView *toast;
@property (nonatomic, strong, readwrite) UILabel *toastLabel;

@property (nonatomic, strong, readwrite) UIView *succeedToast;
@property (nonatomic, strong, readwrite) UIView *circle;
@property (nonatomic, strong, readwrite) UILabel *succeedToastLabel;

@end

@implementation ToastView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self createSubViews];
        [self createSubViewsConstraints];
    }
    return self;
}

// 添加子视图
- (void)createSubViews
{
    self.toast = [[UIView alloc]initWithFrame:CGRectZero];
    self.toast.backgroundColor = [UIColor grayColor];
    self.toast.layer.cornerRadius = 10.0;
    self.toast.alpha = 0.0;
    [self addSubview:self.toast];
    
    self.toastLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    self.toastLabel.textAlignment = NSTextAlignmentCenter;
    self.toastLabel.font = [UIFont systemFontOfSize:16];
    self.toastLabel.textColor = UIColor.whiteColor;
    self.toastLabel.text = @"谢佳培";
    [self.toast addSubview:self.toastLabel];
    
    self.succeedToast = [[UIView alloc]initWithFrame:CGRectZero];
    self.succeedToast.backgroundColor = [UIColor grayColor];
    self.succeedToast.layer.cornerRadius = 10.0;
    self.succeedToast.alpha = 0.0;
    [self addSubview:self.succeedToast];
    
    self.succeedToastLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    self.succeedToastLabel.textAlignment = NSTextAlignmentCenter;
    self.succeedToastLabel.font = [UIFont boldSystemFontOfSize:18];
    self.succeedToastLabel.textColor = UIColor.whiteColor;
    self.succeedToastLabel.text = @"OK";
    [self.succeedToast addSubview:self.succeedToastLabel];
    
    CAShapeLayer *binggo = [CAShapeLayer layer];
    UIBezierPath *binggoPath = [UIBezierPath bezierPath];
    [binggoPath moveToPoint:CGPointMake(63, 33)];
    [binggoPath addLineToPoint:CGPointMake(63 + 15*sin(M_PI/4), 33 + 15*cos(M_PI/4))];
    [binggoPath addLineToPoint:CGPointMake(63 + 15*sin(M_PI/4)+20*sin(M_PI/4), 33 + 15*sin(M_PI/4)-20*sin(M_PI/4))];
    binggo.path = binggoPath.CGPath;
    binggo.lineWidth = 2.0;
    binggo.strokeColor = UIColor.whiteColor.CGColor;
    binggo.fillColor = [UIColor grayColor].CGColor;
    [self.succeedToast.layer addSublayer:binggo];
    
    _circle = [[UIView alloc]initWithFrame:CGRectZero];
    _circle.layer.borderColor = UIColor.whiteColor.CGColor;
    _circle.layer.borderWidth = 2.0;
    _circle.layer.cornerRadius = 20;
    [self.succeedToast addSubview:_circle];
}

// 添加约束
- (void)createSubViewsConstraints
{
    [self.toast mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.height.equalTo(@50);
        make.width.equalTo(@200);
    }];
    [self.toastLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.height.equalTo(@50);
        make.width.equalTo(@200);
    }];
    [self.succeedToast mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.height.equalTo(@100);
        make.width.equalTo(@150);
    }];
    [self.succeedToastLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.succeedToast);
        make.bottom.equalTo(self.succeedToast.mas_bottom).mas_offset(-20);
        make.height.equalTo(@20);
        make.width.equalTo(@150);
    }];
    [self.circle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.succeedToast);
        make.top.equalTo(self.succeedToast.mas_top).mas_offset(15);
        make.height.equalTo(@40);
        make.width.equalTo(@40);
    }];
}

- (void)showToast:(void (^)(void))completion
{
    if (self.duration == 0.0)
    {
        self.duration = 1.0;
    }
    
    if ([self.toastType isEqualToString:@"success"])
    {
        [UIView animateWithDuration:self.duration delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.succeedToast.alpha = 1.0;;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:self.duration animations:^{
                self.succeedToast.alpha = 0.0;
            } completion:^(BOOL finished) {
                completion();
            }];
        }];
    }
    else
    {
        [UIView animateWithDuration:self.duration delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.toast.alpha = 1.0;;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:self.duration animations:^{
                self.toast.alpha = 0.0;
            } completion:^(BOOL finished) {
                completion();
            }];
        }];
    }
}

@end

@implementation ToastViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    ToastView *toastView = [[ToastView alloc] initWithFrame:CGRectMake(100, 300, 200, 50)];
    toastView.duration = 5;
    toastView.toastType = @"success";
    [toastView showToast:^{
        NSLog(@"提示");
    }];
    [self.view addSubview:toastView];
}

@end
