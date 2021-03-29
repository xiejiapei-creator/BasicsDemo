//
//  UITableView+Custom.m
//  CategoryUIDemo
//
//  Created by 谢佳培 on 2020/11/26.
//

#import "UITableView+Custom.h"

@implementation UITableView (Custom)

// 滚动到顶部
- (void)scrollToTop
{
    [self setContentOffset:CGPointMake(0,0) animated:NO];
}

// 滚动到底部
- (void)scrollToBottom:(BOOL)animated
{
    if (self.contentSize.height > self.frame.size.height)
    {
        CGPoint pointOffset = CGPointMake(0, self.contentSize.height - self.bounds.size.height);
        [self setContentOffset:pointOffset animated:YES];
    }
}

@end
