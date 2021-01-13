//
//  FirstViewController.m
//  Demo
//
//  Created by 谢佳培 on 2020/9/23.
//

#import "FirstViewController.h"
#import "SecondViewController.h"

@interface FirstViewController ()<contentDelegate>

@property (nonatomic, strong) SecondViewController *secondVC;

@end

@implementation FirstViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self createSubviews];
    [self registerNotification];
}

- (void)createSubviews
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(120, 200, 200, 100)];
    button.backgroundColor = [UIColor blackColor];
    [button setTitle:@"进入第二个页面" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(notificationClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UIButton *userDefaultsButton = [[UIButton alloc] initWithFrame:CGRectMake(120, 400, 200, 100)];
    userDefaultsButton.backgroundColor = [UIColor blackColor];
    [userDefaultsButton setTitle:@"NSUserDefaults传值" forState:UIControlStateNormal];
    [userDefaultsButton addTarget:self action:@selector(useDefaults) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:userDefaultsButton];
}

#pragma mark - 属性正向传值

- (void)proprety
{
    SecondViewController *postVC = [[SecondViewController alloc] init];
    postVC.content = @"刘盈池";
    
    // 这样传递是有问题的，因为子页面中的textfield是在viewDidLoad中进行初始化和布局的
    // 在这时候textfield还没有初始化，为nil，所以赋值是失效的
    postVC.contentTextField.text = @"谢佳培";
    
    [self.navigationController pushViewController:postVC animated:YES];
}

#pragma mark - KVC正向传值

- (void)useKVC
{
    SecondViewController *postVC = [[SecondViewController alloc] init];
    
    // 通过Key名给对象的属性赋值，而不需要调用明确的存取方法，这样就可以在运行时动态地访问和修改对象的属性
    [postVC setValue:@"刘盈池" forKey:@"content"];
    
    [self.navigationController pushViewController:postVC animated:YES];
}

#pragma mark - Delegate反向传值

- (void)useDelegate
{
    SecondViewController *postVC = [[SecondViewController alloc] init];
    
    // 在第一个页面中遵从该代理：第二个页面的代理是第一个页面自身self
    postVC.delegate = self;
    
    [self.navigationController pushViewController:postVC animated:YES];
}

// 实现代理中定义的方法，第二个页面调用的时候会回调该方法
- (void)transferString:(NSString *)content
{
    // 在方法的实现代码中将参数传递给第一个页面的属性
    self.title = content;
    NSLog(@"Delegate反向传值，第一个页面接收到的content为：%@",content);
}

#pragma mark - Block逆向传值

- (void)useBlock
{
    SecondViewController *postVC = [[SecondViewController alloc] init];
    
    // 通过子页面的block回传拿到数据后进行处理，赋值给当前页面的textfield
    postVC.transDataBlock = ^(NSString * _Nonnull content) {
        self.title = content;
        NSLog(@"Block逆向传值，第一个页面接收到的content为：%@",content);
    };
    
    [self.navigationController pushViewController:postVC animated:YES];
}

#pragma mark - KVO反向传值

- (void)useKVO
{
    self.secondVC = [[SecondViewController alloc] init];
    
    // 在第一个页面注册观察者
    [self.secondVC addObserver:self forKeyPath:@"content" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];
    
    [self.navigationController pushViewController:self.secondVC animated:YES];
}

// 实现KVO的回调方法，当观察者中的数据有变化时会回调该方法
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"content"])
    {
        self.title = self.secondVC.content;
        NSLog(@"KVO反向传值，第一个页面接收到的content为：%@",self.secondVC.content);
    }
}

#pragma mark - Notification反向传值

// 点击跳转到第二个页面
- (void)notificationClick
{
    SecondViewController *postVC = [[SecondViewController alloc] init];
    [self.navigationController pushViewController:postVC animated:YES];
}

// 1.注册通知
- (void)registerNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(infoAction:) name:@"info" object:nil];
}

// 2.实现收到通知时触发的方法
- (void)infoAction:(NSNotification *)notification
{
    NSLog(@"接收到通知，内容为：%@",notification.userInfo);
    self.title = notification.userInfo[@"name"];
}

// 3.在注册通知的页面消毁时一定要移除已经注册的通知，否则会造成内存泄漏
- (void)dealloc
{
    // 移除所有通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    // 移除某个通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"info" object:nil];
    
    // 在第一个页面销毁时移除KVO观察者
    [self.secondVC removeObserver:self forKeyPath:@"content"];
}

#pragma mark - NSUserDefaults传值

// 需要使用值时通过NSUserDefaults从沙盒目录里面取值进行处理
- (void)useDefaults
{
    NSString *content = [[NSUserDefaults standardUserDefaults] valueForKey:@"Girlfriend"];
    NSLog(@"NSUserDefaults传值，内容为：%@",content);
}

@end
