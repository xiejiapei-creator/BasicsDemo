//
//  InputViewViewController.m
//  UIKitGrammarDemo
//
//  Created by 谢佳培 on 2020/10/30.
//

#import "InputViewViewController.h"
#import <Masonry/Masonry.h>

@interface InputViewViewController ()<UITextFieldDelegate, UITextViewDelegate>

@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) UITextField *passwordTextField;
@property (nonatomic, strong) UITextView *textView;

@end

@implementation InputViewViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self createLabelView];
}

// 创建label视图
- (void)createLabelView
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(150, 100, 100, 50)];

    // 位置位于视图中央
    label.center = self.view.center;

    // 自适应大小的方法，即标签的大小由字体的大小长度决定
    // 这个打开后会让label不再显示，慎用！！！
    // [label sizeToFit];

    // 设置字体大小是否适应label宽度
    label.adjustsFontSizeToFitWidth = YES;

    // 设置label的换行模式为根据单词进行换行
    label.lineBreakMode = NSLineBreakByWordWrapping;
    
    // 设置label显示几行，0表示可以有无限行
    label.numberOfLines = 0;

    // 设置文本是否高亮和高亮时的颜色
    label.highlighted = YES;
    label.highlightedTextColor = [[UIColor orangeColor] colorWithAlphaComponent:0.5];
    
    // 设置阴影的颜色和阴影的偏移位置
    label.shadowColor = [UIColor redColor];
    label.shadowOffset = CGSizeMake(1.0, 1.9);
    
    // 设置label中的文字是否可变，默认值是YES
    label.enabled = YES;

    // 如果adjustsFontSizeToFitWidth属性设置为YES，这个属性就来控制文本基线的行为
    // 将文本缩小到基于原始基线的位置时使用，默认不使用
    label.baselineAdjustment = UIBaselineAdjustmentNone;
    
    // 设置背景色为透明
    label.backgroundColor = [UIColor clearColor];
    
    // 设置label的旋转角度
    label.transform = CGAffineTransformMakeRotation(0.2);
    
    // 让label自适应里面的文字，自动调整宽度和高度
    NSString *string = @"天地之间隐有梵音";
    [string boundingRectWithSize:CGSizeMake(320, 2000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil];
    
    // 让UILabel具有链接功能
    // 如果我并没有安装app那它就会失败，同时会调用safari来打开这个链接
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http:baidu.com"] options:@{UIApplicationOpenURLOptionUniversalLinksOnly : @YES} completionHandler:nil];
    
    // 让label显示出来
    label.backgroundColor = [UIColor blackColor];
    label.text = string;
    [self.view addSubview:label];
}

// 创建textField视图
- (void)createTextFieldView
{
    self.passwordTextField = [[UITextField alloc] initWithFrame:CGRectZero];
    
    self.passwordTextField.borderStyle = UITextBorderStyleRoundedRect;// 圆角矩形
    self.passwordTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 22, 22)];// 左视图大小
    self.passwordTextField.leftView.backgroundColor = [UIColor redColor];// 左视图背景颜色
    self.passwordTextField.leftViewMode = UITextFieldViewModeAlways;// 左视图总是显示
    self.passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;// 显示清空按钮
    self.passwordTextField.secureTextEntry = YES;// 加密显示，该属性通常用于设置密码输入框
    self.passwordTextField.clearsOnBeginEditing = YES;// 当重复开始编辑时候清除文字
    //  返回类型：Default换行 Go前往 Google/Search搜索 Join加入 Next下一项 Route路线 Send发送 Done完成 Continue继续
    self.passwordTextField.returnKeyType = UIReturnKeySearch;
    // 设置弹出视图inputView，即弹出的不是键盘而是这个视图
    // 默认的整个键盘宽度，只有设置高度会有用
    self.passwordTextField.inputView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"luckcoffee.JPG"]];
    // 纵向对齐方式，默认是居中
    self.passwordTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    // 设置调整文字大小以适配宽度（即输入不下时缩小文字，实在缩小不了了，就向后滚动），默认是向右滚动的
    self.passwordTextField.adjustsFontSizeToFitWidth = YES;
    // 设置最小字号，和上面有关，即小于这个字号的时候就不缩小了，直接向右滚动
    self.passwordTextField.minimumFontSize = 2;
    // 设置字母大小样式 AllCharacters-所有字母大写 Words-单词首字母大写 Sentences-句首字母大写
    self.passwordTextField.autocapitalizationType = UITextAutocapitalizationTypeSentences;

    self.passwordTextField.delegate = self;
    [self.passwordTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

    [self.view addSubview:self.passwordTextField];
    [self.passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(60);
        make.height.equalTo(@44);
        make.left.equalTo(self.view.mas_left).offset(20);
        make.right.equalTo(self.view.mas_right).offset(-20);
    }];
}

// UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField// 是否可以编辑
{
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField// 开始编辑
{
    NSLog(@"开始编辑");
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField// 是否应该结束编辑
{
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField// 结束编辑
{
    NSLog(@"结束编辑");
}

- (void)textFieldDidChange:(UITextField *)textField// 获取编辑完成的文本
{
    NSLog(@"获取编辑完成的文本 %@", textField.text);
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string// 编辑过程中会不断调用
{
    if (string.length > 0)// 有输入字符
    {
        if ([string isEqualToString:@"0"])// 输入0则允许改变，可以继续输入
        {
            return YES;
        }
        return NO;
    }
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField// 是否可以清空
{
    // 点击清除按钮，应该同时将本地数据源里的文本清空
    if (textField == self.passwordTextField)
    {
        self.password = @"";
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField// 是否可以返回
{
    return YES;
}

// 创建textView视图
- (void)createTextView
{
    self.textView = [[UITextView alloc] initWithFrame:CGRectZero];
    
    self.textView.layer.borderColor = [UIColor blackColor].CGColor;
    self.textView.layer.borderWidth = 1.0;
    
    self.textView.delegate = self;
    self.textView.text = @"孟子，既然男女授受不亲，嫂子掉到水里，要不要伸手去拉，假如“礼”是那么重要，人命就不要了吗？，不去救嫂子则“是豺狼也”，但这要怪嫂子干吗要掉进水里。他没有说戴上了手套再去拉嫂子，唯一的不幸就是自己的无能，对数学家来说，只要他能证明费尔马定理，就可以获得全球数学家的崇敬，自己也可以得到极大的快感，问题在于你证不出来。";
    
    [self.view addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(120);
        make.height.equalTo(@100);
        make.left.equalTo(self.view.mas_left).offset(20);
        make.right.equalTo(self.view.mas_right).offset(-20);
    }];
}

// UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView// 是否可以编辑
{
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView// 是否应该结束编辑
{
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    NSLog(@"开始编辑");
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    NSLog(@"结束编辑");
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text// 编辑过程中会不断调用
{
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView// 获取编辑完成的文本
{
    NSLog(@"获取编辑完成的文本 %@", textView.text);
}

- (void)textViewDidChangeSelection:(UITextView *)textView// 编辑完成的文本
{
    NSLog(@"改变了选中部分的文本");
}

@end
