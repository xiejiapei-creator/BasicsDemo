//
//  UILabel+Custom.m
//  FunctionCodeBlockDemo
//
//  Created by 谢佳培 on 2020/9/28.
//

#import "UILabel+Custom.h"

@implementation UILabel (Custom)

// 改变行、字间距
- (void)changeLabelWithLineSpace:(float)lineSpace WordSpace:(float)wordSpace
{
    NSString *labelText = self.text;
    
    // 改变字间距
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText attributes:@{NSKernAttributeName:@(wordSpace)}];
    
    // 改变行间距
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpace];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    
    self.attributedText = attributedString;
    [self sizeToFit];
}

// 高亮显示某一个特定的子串
- (void)setHighlightfullString:(NSString *)fullString lightString:(NSString *)lightString lightColor:(UIColor *)color lightFont:(UIFont *)font
{
    if (fullString == nil || [fullString isEqualToString:@""])
    {
        return;
    }
    
    NSMutableAttributedString *mutableAttributedStr = [[NSMutableAttributedString alloc] initWithString:fullString];
    if (lightString == nil || [lightString isEqualToString:@""])
    {
        [self setAttributedText:mutableAttributedStr];
    }
    
    NSRange range = [[fullString uppercaseString] rangeOfString:[lightString uppercaseString]];
    if (color == nil)
    {
        color = [UIColor redColor];
    }
    if (font)
    {
        [mutableAttributedStr addAttribute:NSFontAttributeName value:font range:range];
    }
    [mutableAttributedStr addAttribute:NSForegroundColorAttributeName value:color range:range];
    [self setAttributedText:mutableAttributedStr];
}

// 当特长的时候 降低一下优先级
- (void)lowPriority
{
    [self setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
}

// 当特长的时候 固定不被拉伸 也不被压缩
- (void)highPriority
{
    [self setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    [self setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
}

@end
