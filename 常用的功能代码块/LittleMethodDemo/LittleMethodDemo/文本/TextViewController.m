//
//  TextViewController.m
//  LittleMethodDemo
//
//  Created by 谢佳培 on 2020/11/3.
//

#import "TextViewController.h"

@interface TextViewController ()

@property(nonatomic, strong) UITextField *textField;
@property(nonatomic, strong) UITextView *textView;

@end

@implementation TextViewController

- (void)createSubviews
{
    self.title = @"小方法合集";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(100, 300, 200, 50)];
    self.textField.placeholder = @"请输入";
    self.textField.backgroundColor = [UIColor grayColor];
    [self.view addSubview:self.textField];
    
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(100, 400, 200, 50)];
    self.textView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:self.textView];
}

// 打印系统中所有字体的类型名字
- (void)getFontNames
{
    NSArray *familyNames = [UIFont familyNames];
    for(NSString *familyName in familyNames )
    {
        printf("字体家族名称: %s \n", [familyName UTF8String]);
        
        NSArray *fontNames = [UIFont fontNamesForFamilyName:familyName];
        for(NSString *fontName in fontNames)
        {
            printf("\t字体名称: %s \n", [fontName UTF8String]);
        }
    }
}

// 点击背景隐藏键盘
- (void)tapBackgroundHideKeyboard
{
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    
    // 设置成NO表示当前控件响应后会传播到其他控件上，默认为YES
    tapGestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

- (void)keyboardHide:(UITapGestureRecognizer*)tap
{
    [self.textField resignFirstResponder];
    NSLog(@"点击了背景，键盘被隐藏了");
}

// 点击链接跳转
- (void)ClickLinkToJump
{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"百度"];
    
    NSDictionary *linkDict = @{ NSLinkAttributeName:[NSURL URLWithString:@"http://www.baidu.com"] };
    
    [str setAttributes:linkDict range:[[str string] rangeOfString:@"百度"]];
    
    self.textView.attributedText = str;
    self.textView.editable = NO;
    self.textView.dataDetectorTypes = UIDataDetectorTypeLink;
}
@end
