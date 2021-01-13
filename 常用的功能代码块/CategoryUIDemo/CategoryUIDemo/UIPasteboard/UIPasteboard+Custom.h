//
//  UIPasteboard+Custom.h
//  CategoryUIDemo
//
//  Created by 谢佳培 on 2020/11/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIPasteboard (Custom)

/** 设置剪贴板 */
+ (void)setContent:(NSString *)text;

/** 获取剪贴板 */
+ (NSString *)content;

@end

NS_ASSUME_NONNULL_END
