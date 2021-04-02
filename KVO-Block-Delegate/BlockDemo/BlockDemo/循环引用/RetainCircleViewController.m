//
//  PersonViewController.m
//  内存管理
//
//  Created by 谢佳培 on 2021/3/2.
//

#import "RetainCircleViewController.h"

typedef void(^CircleBlock)(void);
typedef void(^CircleBlockVC)(RetainCircleViewController *vc);

@interface RetainCircleViewController ()

@property (nonatomic, copy) CircleBlock block;
@property (nonatomic, copy) CircleBlockVC blockVC;
@property (nonatomic, copy) NSString *name;

@end

@implementation RetainCircleViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}


- (void)simpleBlockRetainCircle
{
    // self -> block -> self
    self.name = @"XieJiapei";
    self.block = ^{
        NSLog(@"在下行不更名，坐不改姓：%@",self.name);
    };
    self.block();
}

- (void)weakBlockRetainCircle
{
    self.name = @"XieJiapei";
    __weak typeof(self) weakSelf = self;
    self.block = ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog(@"在下行不更名，坐不改姓：%@",weakSelf.name);
        });
    };
    self.block();
}

- (void)strongBlockRetainCircle
{
    self.name = @"XieJiapei";
    __weak typeof(self) weakSelf = self;
    self.block = ^{
        __strong typeof(self) strongSelf = weakSelf;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog(@"在下行不更名，坐不改姓：%@",strongSelf.name);
        });
    };
    self.block();
}

- (void)__blockRetainCircle
{
    // 原：self-持有-block-持有-vc-self
    // 打破：self-持有-block-持有-vc(用完后置为nil)-self
    self.name = @"XieJiapei";
    __block RetainCircleViewController *vc = self;
    self.block = ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            NSLog(@"在下行不更名，坐不改姓：%@",vc.name);
            // 该结构体不再需要，可以直接被释放掉，以打破循环引用
            vc = nil;
        });
    };
    self.block();
}

- (void)blockVCRetainCircle
{
    self.name = @"XieJiapei";
    self.blockVC = ^(RetainCircleViewController *vc) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            NSLog(@"在下行不更名，坐不改姓：%@",vc.name);
        });
    };
    self.blockVC(self);
}

- (void)dealloc
{
    NSLog(@"人送外号浪里小白龙：%s",__func__);
}

@end

