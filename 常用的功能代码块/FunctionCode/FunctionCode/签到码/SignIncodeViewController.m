//
//  VerificationCodeViewController.m
//  FunctionCodeBlockDemo
//
//  Created by 谢佳培 on 2020/9/25.
//

#import "SignIncodeViewController.h"
#import <Masonry.h>

@implementation Code

// 初始化
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        self.userInteractionEnabled = NO;
        
        // 布局就是一个数字编码UILabel在上面，最下面一个UIView的下划线
        
        // 数字编码
        _codeLabel = [[UILabel alloc] init];
        _codeLabel.textColor = [UIColor redColor];
        _codeLabel.font = [UIFont systemFontOfSize:18];
        _codeLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_codeLabel];
        [_codeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_equalTo(self).mas_offset(0.0f);
            make.bottom.mas_equalTo(self).mas_offset(-10.0f);
        }];
        
        // 下划线
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor grayColor];
        [self addSubview:_lineView];
        [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.mas_equalTo(self).mas_offset(0.0f);
            make.height.mas_equalTo(2.0f);
        }];
    }
    return self;
}

// 如何根据是否有内容进行颜色变化，重写text的设置方法就OK了
- (void)setText:(NSString *)text
{
    if (text.length > 0)
    {
        // 当设置的text内容不为空时，我们就设置对应的颜色为需要的颜色（蓝色）
        self.codeLabel.text = [text substringToIndex:1];
        self.lineView.backgroundColor = [UIColor blueColor];
    }
    else
    {
        // 否则设置为灰色
        self.codeLabel.text = @"";
        self.lineView.backgroundColor = [UIColor grayColor];
    }
}

@end

@interface VerificationCode () <UITextFieldDelegate>

// 监听内容输入。用一个透明的UITextField来接收键盘的输入信息
@property (strong, nonatomic) UITextField *contentTextField;
// 显示输入内容的codeView数组。用4个CodeView来分别展示输入的签到码信息，放在一个数组中，方便后续的访问和调用
@property (strong, nonatomic) NSArray<Code *> *codeArray;
// 当前待输入的codeView的下标
@property (assign, nonatomic) NSInteger currentIndex;
// 位数
@property (assign, nonatomic) NSInteger codeBits;

@end

@implementation VerificationCode

// 初始化
- (instancetype)initWithCodeBits:(NSInteger)codeBits
{
    self = [super init];
    self.backgroundColor = [UIColor whiteColor];
    self.codeBits = codeBits;
    
    if (self)
    {
        // 签到码默认是4位
        if (self.codeBits < 1)
        {
            self.codeBits = 4;
        }
        
        // 输入框
        [self addSubview:self.contentTextField];
        [self.contentTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        // code框
        for (NSInteger i = 0; i < self.codeBits; i++)
        {
            Code *codeView = self.codeArray[i];
            [self addSubview:codeView];
        }
    }
    
    return self;
}

// 布局
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 设定每个数字之间的间距为数字view宽度的一半，总宽度就是 bits + （bits - 1）* 0.5
    CGFloat codeViewWidth = self.bounds.size.width / (self.codeBits * 1.5 - 0.5);
    
    // CodeView布局
    for (NSInteger i=0; i<self.codeBits; i++)
    {
        Code *codeView = self.codeArray[i];
        [codeView mas_updateConstraints:^(MASConstraintMaker *make) {
            CGFloat left = codeViewWidth * 1.5 * i;
            make.left.mas_equalTo(self).mas_offset(left);
            make.top.bottom.mas_equalTo(self).mas_offset(0.0f);
            make.width.mas_equalTo(codeViewWidth);
        }];
    }
}

#pragma mark --- UITextField delegate

// 在输入和删除时进内容进行判断，并将对应的内容显示
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    // 完成、删除操作的判断一定要在是否是纯数字以及位数过长判断之前，否则可能会导致完成、删除操作失效
    
    // 1.完成则收回键盘
    if ([string isEqualToString:@"\n"])
    {
        [textField resignFirstResponder];
        return NO;
    }
    
    // 2.删除操作
    if ([string isEqualToString:@""])
    {
        // 待输入的下标为0时，删除按钮不起作用，删除时下标不变化
        if (self.currentIndex == 0)
        {
            self.codeArray[self.currentIndex].text = string;
            NSLog(@"输入尚未完成，未输入签到码");
        }
        else
        {
            // 否则当删除一个签到码时，currIndex要减1
            self.codeArray[self.currentIndex].text = string;

            if (self.inputUnCompleted)
            {
                NSString *content = [textField.text substringToIndex:self.currentIndex];
                self.inputUnCompleted(content);
            }
            
            self.currentIndex--;
        }
        return YES;
    }
    
    // 3.判断输入的是否是纯数字，不是纯数字则输入无效
    if (![self judgeIsPureInt:string])
    {
        return NO;
    }
    
    // 4.如果输入的内容超过了签到码的长度 则输入无效
    if ((textField.text.length + string.length) > self.codeBits)
    {
        return NO;
    }
    
    NSLog(@"currentIndex:%ld",(long)self.currentIndex);
    
    // 5.通过判断 currIndex 是否等于 self.codeBits 来确定签到码输入是否完成，相等则完成，否则没有完成
    // 调用对应的block进行处理
    if (self.currentIndex == (self.codeBits - 1) && self.inputCompleted)
    {
        // 在完成时提供输入的签到码信息
        self.codeArray[self.currentIndex].text = string;
        NSString *content = [NSString stringWithFormat:@"%@%@", textField.text, string];
        self.inputCompleted(content);
    }
    else
    {
        // 当输入一个合法的签到码时，当前待输入的下标对应的view中添加输入的数字string，currIndex要加1
        self.codeArray[self.currentIndex].text = string;
        self.currentIndex++;
        
        if (self.inputUnCompleted)
        {
            NSString *content = [NSString stringWithFormat:@"%@%@", textField.text, string];
            self.inputUnCompleted(content);
        }
    }
    
    return YES;
}

- (BOOL)judgeIsPureInt:(NSString *)string
{
    NSScanner *scan = [NSScanner scannerWithString:string];
    int value;
    return [scan scanInt:&value] && [scan isAtEnd];
}

#pragma mark --- Get/Set方法

- (UITextField *)contentTextField
{
    if (!_contentTextField)
    {
        _contentTextField = [[UITextField alloc] init];
        
        // 背景颜色和字体颜色都设置为透明的，这样在界面上就看不到
        _contentTextField.backgroundColor = [UIColor clearColor];
        _contentTextField.textColor = [UIColor clearColor];
        
        // 数字键盘
        _contentTextField.keyboardType = UIKeyboardTypeNumberPad;
        
        // 完成
        _contentTextField.returnKeyType = UIReturnKeyDone;
        // 用于接收签到码的输入，但是对应的光标肯定是不能显示出来的
        _contentTextField.tintColor = [UIColor clearColor];
        // 而且该UITextField不能进行复制、粘贴、选择等操作
        //- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
        _contentTextField.delegate = self;
    }
    return _contentTextField;
}

- (NSArray<Code *> *)codeArray
{
    if (!_codeArray)
    {
        NSMutableArray *array = [NSMutableArray array];
        for (NSInteger i = 0; i < self.codeBits; i++)
        {
            Code *codeView = [[Code alloc] init];
            [array addObject:codeView];
        }
        _codeArray = [NSArray arrayWithArray:array];
    }
    return _codeArray;
}

@end

@implementation UITextField (Custom)

// 该函数控制是否允许选择、全选、剪切、粘贴等功能，可以针对不同功能进行限制
// 返回YES表示允许对应的功能，直接返回NO则表示不允许任何编辑
//- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
//{
//    return YES;
//}

@end

@interface SignIncodeViewController ()
 

@end

@implementation SignIncodeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self createSubviews];
}

- (void)createSubviews
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(100, 500, 200, 50)];
    button.enabled = NO;
    button.backgroundColor = [UIColor blackColor];
    [button setTitle:@"提交" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(nextPage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    VerificationCode *verificationCode = [[VerificationCode alloc] initWithFrame:CGRectMake(100, 200, 200, 80)];
    verificationCode = [verificationCode initWithCodeBits:3];
    [self.view addSubview:verificationCode];
    verificationCode.inputCompleted = ^(NSString * _Nonnull content) {
        
        // 当四位签到码全部输入时，提交按钮是可以提交的，否则提交按钮失效，不允许提交
        NSLog(@"输入完成，四位签到码为：%@",content);
        button.enabled = YES;
    };
    
    verificationCode.inputUnCompleted = ^(NSString * _Nonnull content) {
        NSLog(@"输入尚未完成，已输入的签到码为：%@",content);
        button.enabled = NO;
    };
}

- (void)nextPage
{
    NSLog(@"提交了，翻到下页");
}

@end

