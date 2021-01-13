//
//  LocalEncryptViewController.m
//  LocalEncryptDemo
//
//  Created by 谢佳培 on 2020/9/8.
//  Copyright © 2020 xiejiapei. All rights reserved.
//

#import "LocalEncryptViewController.h"
#import "LocalEncryptService.h"

@interface LocalEncryptViewController ()

// 唯一标识符
@property (strong, nonatomic) UITextField *skuTextField;
// 有效期
@property (strong, nonatomic) UITextField *validitySecondsTextField;
// 加密视图
@property (strong, nonatomic) UITextView *encryptionTextView;
// 解密视图
@property (strong, nonatomic) UITextView *decryptionTextView;
// 倒计时
@property (strong, nonatomic) UILabel *timeLabel;

@end

@implementation LocalEncryptViewController

#pragma mark - Life Circle

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self createSubviews];
}

- (void)createSubviews
{
    UILabel *skuLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, 120, 50)];
    skuLabel.text = @"唯一标示sku：";
    [self.view addSubview:skuLabel];
    
    self.skuTextField = [[UITextField alloc] initWithFrame:CGRectMake(180, 100, 200, 50)];
    self.skuTextField.placeholder = @"请输入";
    self.skuTextField.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:self.skuTextField];
    
    UILabel *validitySecondsLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 150, 100, 50)];
    validitySecondsLabel.text = @"有效期(s)";
    [self.view addSubview:validitySecondsLabel];
    
    self.validitySecondsTextField = [[UITextField alloc] initWithFrame:CGRectMake(180, 160, 200, 50)];
    self.validitySecondsTextField.placeholder = @"请输入";
    self.validitySecondsTextField.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:self.validitySecondsTextField];
    
    UIButton *encryptionButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 220, 50, 50)];
    encryptionButton.backgroundColor = [UIColor blackColor];
    [encryptionButton setTitle:@"加密" forState:UIControlStateNormal];
    [encryptionButton addTarget:self action:@selector(encodeAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:encryptionButton];
    
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 220, 200, 50)];
    self.timeLabel.text = nil;
    [self.view addSubview:self.timeLabel];
    
    self.encryptionTextView = [[UITextView alloc] initWithFrame:CGRectMake(20, 300, 300, 150)];
    self.encryptionTextView.layer.cornerRadius = 5;
    self.encryptionTextView.layer.borderColor = UIColor.grayColor.CGColor;
    self.encryptionTextView.layer.borderWidth = 0.5;
    [self.view addSubview:self.encryptionTextView];
    
    UIButton *decryptionButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 500, 100, 40)];
    decryptionButton.backgroundColor = [UIColor blackColor];
    [decryptionButton setTitle:@"解密" forState:UIControlStateNormal];
    [decryptionButton addTarget:self action:@selector(decodeAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:decryptionButton];
    
    self.decryptionTextView = [[UITextView alloc] initWithFrame:CGRectMake(20, 570, 300, 150)];
    self.decryptionTextView.layer.cornerRadius = 5;
    self.decryptionTextView.layer.borderColor = UIColor.grayColor.CGColor;
    self.decryptionTextView.layer.borderWidth = 0.5;
    [self.view addSubview:self.decryptionTextView];
    
    UIButton *clearButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 750, 100, 50)];
    clearButton.backgroundColor = [UIColor blackColor];
    [clearButton setTitle:@"清空内容" forState:UIControlStateNormal];
    [clearButton addTarget:self action:@selector(clearTextField) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:clearButton];
    
    UIButton *closeKeyboardButton = [[UIButton alloc] initWithFrame:CGRectMake(200, 750, 100, 50)];
    closeKeyboardButton.backgroundColor = [UIColor blackColor];
    [closeKeyboardButton setTitle:@"关闭键盘" forState:UIControlStateNormal];
    [closeKeyboardButton addTarget:self action:@selector(endEditing) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeKeyboardButton];
}

#pragma mark - 提示信息

- (void)showInfo:(NSString *)info title:(NSString *)title
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:title message:info preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertVC addAction:alertAction];
    [self presentViewController:alertVC animated:YES completion:nil];
}

#pragma mark - Events

// 关闭键盘
- (void)endEditing
{
    [self.view endEditing:YES];
}

// 清空内容
- (void)clearTextField
{
    NSLog(@"点击了清空按钮");
    self.encryptionTextView.text = nil;
    self.decryptionTextView.text = nil;
    _timeLabel.text = nil;
}

// 加密
- (void)encodeAction
{
    // sku为空
    if (self.skuTextField.text.length == 0)
    {
        [self showInfo:@"请输入sku" title:@"提示"];
        return;
    }
    
    // 加密内容为空
    if (self.encryptionTextView.text.length == 0)
    {
        [self showInfo:@"请输入加密内容" title:@"提示"];
        return;
    }
    
    // 有效期存在
    if (self.validitySecondsTextField.text)
    {
        // 绑定标识和有效期
         [[LocalEncryptService shareInstance] bindSku:self.skuTextField.text validityPeriod:@(self.validitySecondsTextField.text.integerValue)];
    }

    // 进行加密并保存
    NSString *encodeString =  [[LocalEncryptService shareInstance] encryptAndSaveInfo:self.encryptionTextView.text SkuNum:self.skuTextField.text];

    // 展示加密后的内容
    NSString *encodeInfo = [NSString stringWithFormat:@"\n\n加密后的内容\n%@",encodeString];
    self.encryptionTextView.text = [self.encryptionTextView.text stringByAppendingString:encodeInfo];
  
    // 倒计时
    [LocalEncryptViewController dispatchSourceTimerWithSeconds:self.validitySecondsTextField.text.integerValue inProgressBlock:^(NSInteger sec) {
        if (sec == 0)
        {
            self.timeLabel.text = @"加密秘钥已过期";
            return ;
        }
        self.timeLabel.text = [NSString stringWithFormat:@"加密秘钥%@s秒后过期", @(sec)];
    } periodOverBlock:^{
    }];
}

// 解密
- (void)decodeAction
{
    // sku为空
    if (self.skuTextField.text.length == 0)
    {
        [self showInfo:@"请输入sku" title:@"提示"];
        return;
    }
    
    // 进行解密并获取
    NSError *error;
    NSString *decodeString = [[LocalEncryptService shareInstance] decryptAndQueryWithSkuNum:self.skuTextField.text error:&error];
    
    
    if (error) //解密出错
    {
        [self showInfo:error.domain title:@"提示"];
    }
    else
    {
        // 展示解密后的内容
        NSString *decodeInfo = [NSString stringWithFormat:@"解密后的内容\n%@",decodeString];
        self.decryptionTextView.text = decodeInfo;
    }
}

#pragma mark - 倒计时

+ (void)dispatchSourceTimerWithSeconds:(NSInteger)seconds  inProgressBlock:(void (^)(NSInteger))inProgressBlock periodOverBlock:(void (^)(void))periodOverBlock
{
    NSInteger timeOut = seconds; //default:60
    __block NSInteger second = timeOut;
    
    dispatch_queue_t quene = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, quene);
    
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    
    dispatch_source_set_event_handler(timer, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (second == 0)
            {
                if(periodOverBlock)
                {
                    periodOverBlock();
                }
                second = timeOut;
                dispatch_cancel(timer);
            }
            else
            {
                second--;
                if(inProgressBlock)
                {
                    inProgressBlock(second);
                }
            }
        });
    });
    dispatch_resume(timer);
}
 
@end
