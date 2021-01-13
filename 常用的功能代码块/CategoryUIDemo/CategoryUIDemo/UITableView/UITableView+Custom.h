//
//  UITableView+Custom.h
//  CategoryUIDemo
//
//  Created by 谢佳培 on 2020/11/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITableView (Custom)

/** 滚动到顶部 */
- (void)scrollToTop;

/** 滚动到底部 */
- (void)scrollToBottom:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
