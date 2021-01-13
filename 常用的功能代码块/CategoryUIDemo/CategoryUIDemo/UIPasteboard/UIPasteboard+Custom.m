//
//  UIPasteboard+Custom.m
//  CategoryUIDemo
//
//  Created by 谢佳培 on 2020/11/26.
//

#import "UIPasteboard+Custom.h"

@implementation UIPasteboard (Custom)

// 设置剪贴板
+ (void)setContent:(NSString *)text
{
    if (text == nil || [text isEqualToString:@""])
    {
        return;
    }
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = text;
}

// 获取剪贴板
+ (NSString *)content
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    return  pasteboard.string;
}


@end
