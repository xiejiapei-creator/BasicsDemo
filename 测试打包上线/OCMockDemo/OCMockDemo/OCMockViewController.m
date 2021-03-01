//
//  OCMockViewController.m
//  OCMockDemo
//
//  Created by 谢佳培 on 2021/2/27.
//

#import "OCMockViewController.h"

@interface OCMockViewController ()

@end

@implementation OCMockViewController

// 更新每条狗的身份证信息
- (void)updateIDCardView
{
    NSArray *dogs = [self.manager fetchDogs];
    if (dogs != nil)
    {
        for (Dog *dog in dogs)
        {
            [self.idCardView dogIDCardView:dog];
        }
    }
}

@end
