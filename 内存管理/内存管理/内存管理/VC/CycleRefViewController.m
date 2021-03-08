//
//  CycleRefViewController.m
//  内存管理
//
//  Created by 谢佳培 on 2021/3/3.
//

#import "CycleRefViewController.h"

@implementation MemoryObject

@end

@interface CycleRefViewController ()

@end

@implementation CycleRefViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 创建两个对象a和b
    MemoryObject *a = [MemoryObject new];
    MemoryObject *b = [MemoryObject new];
    
    // 互相引用对方
    a.obj = b;
    b.obj = a;
}

@end
