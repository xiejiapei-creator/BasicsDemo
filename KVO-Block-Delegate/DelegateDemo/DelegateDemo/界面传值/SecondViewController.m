//
//  SecondViewController.m
//  Demo
//
//  Created by 谢佳培 on 2020/9/23.
//

#import "SecondViewController.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self createSubviews];
}

- (void)createSubviews
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.contentTextField = [[UITextField alloc] initWithFrame:CGRectMake(120, 400, 200, 100)];
    self.contentTextField.backgroundColor = [UIColor greenColor];
    [self.view addSubview:self.contentTextField];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(120, 200, 200, 100)];
    button.backgroundColor = [UIColor blackColor];
    [button setTitle:@"返回第一个页面" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(userDefaultsClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

#pragma mark - 属性正向传值

- (void)proprety
{
    NSLog(@"属性正向传值，content内容为：%@",self.content);
    NSLog(@"属性正向传值，contentTextField内容为：%@",self.contentTextField.text);
}

#pragma mark - KVC正向传值

- (void)useKVC
{
    NSLog(@"KVC正向传值，content内容为：%@",self.content);
}

#pragma mark - Delegate逆向传值

// 返回第一个页面之前调用代理中定义的数据传递方法，方法参数就是要传递的数据
- (void)backDelegate
{
    // 如果当前的代理存在，并且实现了代理方法，则调用代理方法进行传递数据
    if (self.delegate && [self.delegate respondsToSelector:@selector(transferString:)])
    {
        [self.delegate transferString:@"刘盈池"];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - Block块逆向传值

- (void)backBlock
{
    if (self.transDataBlock)
    {
        self.transDataBlock(@"刘盈池");
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - KVO逆向传值

- (void)backKVO
{
    // 修改属性的内容
    self.content = @"刘盈池";

    // 返回第一个界面回传数据
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Notification逆向传值

// 返回到上个界面
- (void)backNotification
{
    // 1.创建字典，将数据包装到字典中
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:@"刘盈池",@"name",@"19",@"age", nil];
    
    // 2.创建通知
    NSNotification *notification = [NSNotification notificationWithName:@"info" object:nil userInfo:dict];
    
    // 3.通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
    // 4.回传数据
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - NSUserDefaults传值

- (void)userDefaultsClick
{
    // 需要传值时将数据通过NSUserDefaults保存到沙盒目录里面，比如用户名之类
    // 当用户下次登录或者使用`app`的时候，可以直接从本地读取
    [[NSUserDefaults standardUserDefaults] setObject:@"刘盈池" forKey:@"Girlfriend"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // 跳转到第一个界面
    [self.navigationController popViewControllerAnimated:YES];
}

@end
