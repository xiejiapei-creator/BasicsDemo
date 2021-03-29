//
//  textFieldCheckViewController.m
//  FunctionCodeBlockDemo
//
//  Created by 谢佳培 on 2020/9/27.
//

#import "textFieldCheckViewController.h"
#import "Regex.h"

@interface textFieldCheckViewController ()<UITextFieldDelegate>

@property(nonatomic, strong) UITextField *textField;

@end

@implementation textFieldCheckViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *testString = @"谢佳培";
    NSLog(@"待校验的字符串为：%@",testString);
    if ([Regex validateNickname:testString])
    {
        NSLog(@"格式正确");
    }
    else
    {
        NSLog(@"格式错误");
    }
    
    [self createSubviews];
}

- (void)createSubviews
{
    self.view.backgroundColor = [UIColor whiteColor];

    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(100, 300, 200, 50)];
    self.textField.placeholder = @"请输入";
    self.textField.backgroundColor = [UIColor grayColor];
    self.textField.delegate = self;
    [self.view addSubview:self.textField];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(50.f, 820.f, 300, 50.f)];
    [button addTarget:self action:@selector(customAlert) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"查看PDF" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.layer.cornerRadius = 5.f;
    button.clipsToBounds = YES;
    button.layer.borderWidth = 1.f;
    button.layer.borderColor = [UIColor blackColor].CGColor;
    [self.view addSubview:button];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    BOOL judgeTwoDecimalPlaces = [self JudgeTwoDecimalPlaces:textField shouldChangeCharactersInRange:range replacementString:string];
    return judgeTwoDecimalPlaces;
}

#pragma mark - 校验方法

// 输入判断小数点后两位
- (BOOL)JudgeTwoDecimalPlaces:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    // 如果输入的是“.”  判断之前已经有"."或者字符串为空
     if ([string isEqualToString:@"."] && ([textField.text rangeOfString:@"."].location != NSNotFound || [textField.text isEqualToString:@""]))
     {
         NSLog(@"文本框内容为：%@，已经有小数点了，禁止再输入小数点",textField.text);
         return NO;
     }
    
     // 拼出输入完成的str，判断str的长度大于等于“.”的位置＋4，则返回false，此次插入string失败
     // "379132.424",长度10,"."的位置6, 10>=6+4
     NSMutableString *str = [[NSMutableString alloc] initWithString:textField.text];
     [str insertString:string atIndex:range.location];
    
     if (str.length >= [str rangeOfString:@"."].location + 4)
     {
         NSLog(@"文本框内容为：%@，小数点后两位以上了，禁止输入",str);
         return NO;
     }
    
     return YES;
}

@end
