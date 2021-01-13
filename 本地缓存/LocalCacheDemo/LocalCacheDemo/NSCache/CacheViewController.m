//
//  CacheViewController.m
//  LocalCacheDemo
//
//  Created by 谢佳培 on 2020/10/30.
//

#import "CacheViewController.h"

@interface CacheViewController ()<NSCacheDelegate>

@property (strong,nonatomic) NSCache * cache;

@end

@implementation CacheViewController

- (void)viewDidLoad
{
    [self createSubviews];
    
    self.cache = [[NSCache alloc]init];
    self.cache.totalCostLimit = 5;// 缓存大小
    self.cache.delegate = self;
    NSLog(@"缓存的名称：%@",self.cache.name);
    NSLog(@"缓存对象：%@",self.cache);
}

- (void)createSubviews
{
    [self createButtonWithFrame:CGRectMake(50.f, 820.f, 300, 50.f) selector:@selector(cleanCache) title:@"清理缓存"];
    [self createButtonWithFrame:CGRectMake(50.f, 720.f, 300, 50.f) selector:@selector(checkCache) title:@"检查缓存"];
    [self createButtonWithFrame:CGRectMake(50.f, 620.f, 300, 50.f) selector:@selector(addCache) title:@"添加缓存"];
}

- (void)createButtonWithFrame:(CGRect)rect selector:(SEL)selector title:(NSString *)title
{
    UIButton *button = [[UIButton alloc] initWithFrame:rect];
    [button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.layer.cornerRadius = 5.f;
    button.clipsToBounds = YES;
    button.layer.borderWidth = 1.f;
    button.layer.borderColor = [UIColor blackColor].CGColor;
    [self.view addSubview:button];
}

// 添加缓存
- (void)addCache
{
    for (int i = 1; i<10; i++)
    {
        // 在缓存中设置指定键名对应的值，并且指定回收成本，以便进行计算存储在缓存中对象的总成本，当出现内存警告或者超出总成本时，缓存就会进行删除部分元素的操作
        NSString *str = [NSString stringWithFormat:@"在这里进行了存储数据：%@",@(i)];
        [self.cache setObject:str forKey:@(i) cost:1];
    }
}

// 检查缓存
- (void)checkCache
{
    for (int i = 0; i < 10 ; i++)
    {
        NSString *str = [self.cache objectForKey:@(i)];
        if (str)
        {
            NSLog(@"取出缓存中存储的数据：%@",@(i));
        }
    }
}

// 清理缓存
- (void)cleanCache
{
    [self.cache removeAllObjects];
    NSLog(@"清理缓存");
}

// 即将回收对象的时候进行调用，实现代理方法之前要遵守NSCacheDelegate协议
- (void)cache:(NSCache *)cache willEvictObject:(id)obj
{
    NSLog(@"即将回收对象的时候进行调用：%@",obj);
}

@end
