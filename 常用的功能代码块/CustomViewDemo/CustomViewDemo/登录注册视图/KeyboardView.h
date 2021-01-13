//
//  KeyboardView.h
//  UseUIControlFramework
//
//  Created by 谢佳培 on 2020/11/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - 带下划线的输入框

@interface UnderlineTextField : UITextField

/// 下划线的颜色
@property (nonatomic, strong) UIColor *underlineColor;

@end

#pragma mark - 登陆键盘

@interface CenterKeyboardView : UIView

/// 点击注册的回调
@property (nonatomic, copy) void (^registerClickedBlock)(CenterKeyboardView *keyboardView, UIButton *button);
/// 点击登录的回调
@property (nonatomic, copy) void (^loginClickedBlock)(CenterKeyboardView *keyboardView);

/// 输入手机号
@property (nonatomic, strong) UnderlineTextField *phoneNumberField;
/// 输入密码
@property (nonatomic, strong) UnderlineTextField *passwordField;
/// 登录按钮
@property (nonatomic, strong) UIButton *loginButton;
/// 注册按钮
@property (nonatomic, strong) UIButton *registerButton;
/// 其他登录方式按钮数组
@property (nonatomic, strong) NSArray<UIButton *> *otherLoginMethodButtons;

@end

#pragma mark - 注册键盘

@interface RegisterKeyboardView : UIView

/// 点击返回的回调
@property (nonatomic, copy) void (^gobackClickedBlock)(RegisterKeyboardView *keyboardView, UIButton *button);
/// 点击下一步的回调
@property (nonatomic, copy) void (^nextClickedBlock)(RegisterKeyboardView *keyboardView, UIButton *button);

@property (nonatomic, strong) UILabel *titleLabel;
/// 输入手机号
@property (nonatomic, strong) UnderlineTextField *phoneNumberField;
/// 输入验证码
@property (nonatomic, strong) UnderlineTextField *verificationCodeField;
/// 发送验证码按钮
@property (nonatomic, strong) UIButton *sendCodeButton;
/// 下一步按钮
@property (nonatomic, strong) UIButton *nextButton;
/// 返回按钮
@property (nonatomic, strong) UIButton *gobackButton;

@end

#pragma mark - 评论键盘

@interface CommentKeyboardView : UIView

/// 点击发送评论的回调
@property (nonatomic, copy) void (^senderClickedBlock)(CommentKeyboardView *keyboardView, UIButton *button);

@property (nonatomic, strong) UILabel *titleLabel;
/// 评论输入框
@property (nonatomic, strong) UITextField *commentTextField;
/// 发送评论按钮
@property (nonatomic, strong) UIButton *sendCommentButton;

@end

NS_ASSUME_NONNULL_END
