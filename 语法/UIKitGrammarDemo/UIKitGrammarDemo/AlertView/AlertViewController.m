//
//  AlertViewController.m
//  UIKitGrammarDemo
//
//  Created by 谢佳培 on 2020/10/30.
//

#import "AlertViewController.h"

@interface AlertViewController ()

@end

@implementation AlertViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self createAlertView];
}


// 点击按钮弹出提示框
- (void)createAlertView
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(50.f, 820.f, 300, 50.f)];
    [button addTarget:self action:@selector(textFieldForAlert) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"按钮" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.layer.cornerRadius = 5.f;
    button.clipsToBounds = YES;
    button.layer.borderWidth = 1.f;
    button.layer.borderColor = [UIColor blackColor].CGColor;
    [self.view addSubview:button];
}

// 选择面板
- (void)showActionSheetController
{
    UIAlertController *actionSheetController = [UIAlertController alertControllerWithTitle:@"作家" message:@"每个人的名字都像一幅水墨画" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"点击了取消");
    }];
    [actionSheetController addAction:cancelAction];
    
    UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"查看白落梅" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"查看白落梅");
    }];
    [actionSheetController addAction:firstAction];
    
    UIAlertAction *secondAction = [UIAlertAction actionWithTitle:@"查看丰子恺" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"查看丰子恺");
    }];
    [actionSheetController addAction:secondAction];
    
    UIAlertAction *thirdAction = [UIAlertAction actionWithTitle:@"查看郁达夫" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"查看郁达夫");
    }];
    [actionSheetController addAction:thirdAction];
    
    [self presentViewController:actionSheetController animated:YES completion:nil];
}

// 利用KVC方法进行UIAlertController属性的自定义
- (void)customAlert
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"提示内容" preferredStyle:UIAlertControllerStyleAlert];
    
    // 修改title
    NSMutableAttributedString *alertControllerStr = [[NSMutableAttributedString alloc] initWithString:@"提示"];
    [alertControllerStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, 2)];
    [alertControllerStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:NSMakeRange(0, 2)];
    // 利用KVC方法进行UIAlertController属性的自定义
    // 有时候使用第三方控件会带来很多不必要的代码量和bug，所以能用系统自带最好
    [alertController setValue:alertControllerStr forKey:@"attributedTitle"];
    
    // 修改message
    NSMutableAttributedString *alertControllerMessageStr = [[NSMutableAttributedString alloc] initWithString:@"提示内容"];
    [alertControllerMessageStr addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:NSMakeRange(0, 4)];
    [alertControllerMessageStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:NSMakeRange(0, 4)];
    [alertController setValue:alertControllerMessageStr forKey:@"attributedMessage"];
    
    // 常规按钮
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"Default" style:UIAlertActionStyleDefault handler:nil];
    // 销毁按钮
    UIAlertAction *destructiveAction = [UIAlertAction actionWithTitle:@"Destructive" style:UIAlertActionStyleDestructive handler:nil];
    // 取消按钮
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    [alertController addAction:defaultAction];
    [alertController addAction:destructiveAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

// UIAlertController上添加文本框
- (void)textFieldForAlert
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"title" message:@"message" preferredStyle:UIAlertControllerStyleAlert];
    
    // 添加文本框
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        // 设置键盘输入为数字键盘
        textField.keyboardType = UIKeyboardTypeNumberPad;
        textField.placeholder = @"请填写";
    }];
    
    // 添加取消按钮
    UIAlertAction *cancelButton = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        // 取消
    }];
    [alert addAction: cancelButton];
        
    // 添加确定按钮
    UIAlertAction *confirmButton = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        // 文本框结束编辑，收起键盘
        [[alert.textFields firstObject] endEditing:YES];
        // 获取文本框填写的内容
        NSString *meetingId = [alert.textFields firstObject].text;
        if (meetingId.length > 12)
        {
            //[weakSelf showText:@"会议号过长"];
        }
        else
        {
            //[weakSelf enterVideoMeeting:meetingId];
        }
    }];
    [alert addAction: confirmButton];
    
    //显示
    [self presentViewController:alert animated:YES completion:nil];
}
 

@end
