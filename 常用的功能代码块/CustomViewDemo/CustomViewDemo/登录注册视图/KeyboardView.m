//
//  KeyboardView.m
//  UseUIControlFramework
//
//  Created by 谢佳培 on 2020/11/13.
//

#import "KeyboardView.h"

#pragma mark - 带下划线的输入框

@implementation UnderlineTextField

// 绘制下划线
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIColor *fillColor = _underlineColor ?: [UIColor darkGrayColor];
    CGContextSetFillColorWithColor(context, fillColor.CGColor);
    CGRect fillRect = CGRectMake(0, CGRectGetHeight(self.bounds) - 0.5, CGRectGetWidth(self.bounds), 0.5);
    CGContextFillRect(context,fillRect);
}

- (void)setUnderlineColor:(UIColor *)underlineColor
{
    _underlineColor = underlineColor;
    [self setNeedsDisplay];
}

@end

#pragma mark - 登陆键盘

@implementation CenterKeyboardView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 2;
        
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews
{
    _phoneNumberField = [[UnderlineTextField alloc] init];
    _phoneNumberField.font = [UIFont systemFontOfSize:17];
    _phoneNumberField.underlineColor = [UIColor grayColor];
    _phoneNumberField.placeholder = @" 请输入手机号";
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loginuser"]];
    imageView.contentMode = UIViewContentModeCenter;
    _phoneNumberField.leftView = imageView;
    _phoneNumberField.leftViewMode = UITextFieldViewModeAlways;
    _phoneNumberField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _phoneNumberField.keyboardType = UIKeyboardTypePhonePad;
    [self addSubview:_phoneNumberField];
    
    _passwordField = [[UnderlineTextField alloc] init];
    _passwordField.font = [UIFont systemFontOfSize:17];
    _passwordField.underlineColor = [UIColor grayColor];
    _passwordField.placeholder = @" 输入密码";
    [_passwordField setSecureTextEntry:YES];
    UIImageView *imageView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loginpswd"]];
    imageView2.contentMode = UIViewContentModeCenter;
    _passwordField.leftView = imageView2;
    _passwordField.leftViewMode = UITextFieldViewModeAlways;
    _passwordField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _phoneNumberField.keyboardType = UIKeyboardTypeDefault;
    [self addSubview:_passwordField];
    
    _loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _loginButton.backgroundColor = [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1.0];
    _loginButton.layer.borderColor = [UIColor grayColor].CGColor;
    _loginButton.layer.borderWidth = 0.5;
    _loginButton.layer.cornerRadius = 2;
    _loginButton.layer.masksToBounds = YES;
    [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [_loginButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [_loginButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [self addSubview:_loginButton];
    [_loginButton addTarget:self action:@selector(loginButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    _registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _registerButton.userInteractionEnabled = YES;
    _registerButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [_registerButton setTitle:@"注册账号" forState:UIControlStateNormal];
    [_registerButton setTitleColor: [UIColor colorWithHex:@"569EED"] forState:UIControlStateNormal];
    [_registerButton setTitleColor: [UIColor grayColor] forState:UIControlStateHighlighted];
    [_registerButton addTarget:self action:@selector(registerClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_registerButton];
    
    __block NSMutableArray *buttons = @[].mutableCopy;
    NSArray *array = @[@"loginsina", @"loginqq", @"loginfacebook"];
    [array enumerateObjectsUsingBlock:^(NSString *imageName, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        button.imageView.contentMode = UIViewContentModeCenter;
        button.size = CGSizeMake(30, 30);
        [self addSubview:button];
        [buttons addObject:button];
    }];
    _otherLoginMethodButtons = buttons;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat width = (self.width - 40), height = 35, spacing = 17;
    
    _phoneNumberField.size = CGSizeMake(width, height);
    _phoneNumberField.y = 20;
    _phoneNumberField.centerX = self.width / 2;
    
    _passwordField.size = _phoneNumberField.size;
    _passwordField.y = _phoneNumberField.bottom + spacing;
    _passwordField.centerX = self.width / 2;
    
    _loginButton.size = CGSizeMake(width, 40);
    _loginButton.centerX = self.width / 2;
    _loginButton.y = _passwordField.bottom + spacing + 5;
    
    _registerButton.size = CGSizeMake(70, 30);
    _registerButton.y = _loginButton.bottom + 27;
    _registerButton.right = self.width - 20;
    
    [_otherLoginMethodButtons enumerateObjectsUsingBlock:^(UIButton * _Nonnull button, NSUInteger idx, BOOL * _Nonnull stop) {
        button.y = _registerButton.y;
        button.x = (button.width + 10) * idx + 20;
    }];
}

- (void)loginButtonClicked:(UIButton *)sender
{
    if (self.loginClickedBlock)
    {
        self.loginClickedBlock(self);
    }
}

- (void)registerClicked:(UIButton *)sender
{
    if (self.registerClickedBlock)
    {
        self.registerClickedBlock(self, sender);
    }
}

@end

#pragma mark - 注册键盘
 
@implementation RegisterKeyboardView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 2;
        
        [self CreateSubview];
    }
    return self;
}

- (void)CreateSubview
{
    _titleLabel = [UILabel new];
    _titleLabel.text = @"注册账号";
    _titleLabel.font = [UIFont boldSystemFontOfSize:17];
    _titleLabel.textColor = [UIColor blackColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_titleLabel];
    
    _phoneNumberField = [[UnderlineTextField alloc] init];
    _phoneNumberField.font = [UIFont systemFontOfSize:17];
    _phoneNumberField.underlineColor = [UIColor grayColor];
    _phoneNumberField.placeholder = @" 输入手机号";
    _phoneNumberField.clearButtonMode=UITextFieldViewModeWhileEditing;
    _phoneNumberField.keyboardType = UIKeyboardTypePhonePad;
    [self addSubview:_phoneNumberField];
    
    _verificationCodeField = [[UnderlineTextField alloc] init];
    _verificationCodeField.font = [UIFont systemFontOfSize:17];
    _verificationCodeField.underlineColor = [UIColor grayColor];
    _verificationCodeField.placeholder = @" 输入验证码";
    _verificationCodeField.clearButtonMode=UITextFieldViewModeWhileEditing;
    _verificationCodeField.keyboardType = UIKeyboardTypePhonePad;
    [self addSubview:_verificationCodeField];
    
    _sendCodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _sendCodeButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [_sendCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_sendCodeButton setTitleColor: [UIColor colorWithHex:@"569EED"] forState:UIControlStateNormal];
    [_sendCodeButton setTitleColor: [UIColor grayColor] forState:UIControlStateHighlighted];
    [self addSubview:_sendCodeButton];
    
    _nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _nextButton.backgroundColor = [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1.0];;
    _nextButton.layer.borderColor = [UIColor grayColor].CGColor;
    _nextButton.layer.borderWidth = 0.5;
    _nextButton.layer.cornerRadius = 2;
    _nextButton.layer.masksToBounds = YES;
    [_nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    [_nextButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [_nextButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [_nextButton addTarget:self action:@selector(nextClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_nextButton];
    
    _gobackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _gobackButton.userInteractionEnabled = YES;
    [_gobackButton setImage:[UIImage imageNamed:@"loginback"] forState:UIControlStateNormal];
    [_gobackButton addTarget:self action:@selector(goBackClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_gobackButton];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat width = (self.width - 40), height = 35, spacing = 17;
    _phoneNumberField.size = CGSizeMake(width, height);
    _phoneNumberField.y = 55;
    _phoneNumberField.centerX = self.width / 2;
    
    _verificationCodeField.size = _phoneNumberField.size;
    _verificationCodeField.width /= 2;
    _verificationCodeField.y = _phoneNumberField.bottom + spacing;
    _verificationCodeField.x = 20;
    
    _sendCodeButton.size = _verificationCodeField.size;
    _sendCodeButton.y = _verificationCodeField.y;
    _sendCodeButton.x = _verificationCodeField.width + 10;
    
    _nextButton.size = CGSizeMake(width, 40);
    _nextButton.centerX = self.width / 2;
    _nextButton.y = _verificationCodeField.bottom + spacing + 5;
    
    _gobackButton.size = CGSizeMake(30, 30);
    _gobackButton.origin = CGPointMake(20, 10);
    
    _titleLabel.size = CGSizeMake(70, 30);
    _titleLabel.y = 10;
    _titleLabel.centerX = self.width / 2;
}

- (void)nextClicked:(UIButton *)sender
{
    if (self.nextClickedBlock)
    {
        self.nextClickedBlock(self, sender);
    }
}

- (void)goBackClicked:(UIButton *)sender
{
    if (self.gobackClickedBlock)
    {
        self.gobackClickedBlock(self, sender);
    }
}

@end

#pragma mark - 评论键盘

@implementation CommentKeyboardView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor colorWithHex:@"FFFFF0"];
        
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews
{
    _commentTextField = [[UITextField alloc] init];
    _commentTextField.font = [UIFont systemFontOfSize:17];
    _commentTextField.placeholder = @" 请输入你的评论内容";
    _commentTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _commentTextField.layer.masksToBounds = YES;
    _commentTextField.layer.cornerRadius = 4;
    _commentTextField.layer.borderWidth = 0.5;
    _commentTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _commentTextField.backgroundColor = [UIColor lightTextColor];
    _commentTextField.tintColor = [UIColor colorWithHex:@"569EED"];
    [self addSubview:_commentTextField];
    
    _sendCommentButton= [UIButton buttonWithType:UIButtonTypeCustom];
    _sendCommentButton.userInteractionEnabled = YES;
    [_sendCommentButton setImage:[UIImage imageNamed:@"sender"] forState:UIControlStateNormal];
    [_sendCommentButton addTarget:self action:@selector(senderClicked:) forControlEvents:UIControlEventTouchUpInside];
    _sendCommentButton.imageView.contentMode = UIViewContentModeCenter;
    [self addSubview:_sendCommentButton];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat height = self.height - 20;
    CGFloat padding = 15;
    
    _sendCommentButton.size = CGSizeMake(height, height);
    _sendCommentButton.right = self.width - padding;
    _sendCommentButton.centerY = self.height / 2;
    
    CGFloat spacing = 15;
    _commentTextField.height = height;
    _commentTextField.width = self.width - 2 * padding - _sendCommentButton.width - spacing;
    _commentTextField.x = 20;
    _commentTextField.centerY = self.height / 2;
}

- (void)senderClicked:(UIButton *)sender
{
    if (self.senderClickedBlock)
    {
        self.senderClickedBlock(self, sender);
    }
}

@end


