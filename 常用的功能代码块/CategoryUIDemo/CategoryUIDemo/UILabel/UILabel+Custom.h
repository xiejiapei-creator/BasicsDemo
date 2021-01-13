//
//  UILabel+Custom.h
//  FunctionCodeBlockDemo
//
//  Created by 谢佳培 on 2020/9/28.
//

#import <UIKit/UIKit.h>

@interface UILabel (Custom)

/** 改变行、字间距 */
- (void)changeLabelWithLineSpace:(float)lineSpace WordSpace:(float)wordSpace;

/**高亮显示某一个特定的子串
 * @param fullString 全量的字符串
 * @param lightString 高亮的子串
 * @param color 设置高亮颜色
 * @param font 设置高亮字体
 */
- (void)setHighlightfullString:(NSString *)fullString lightString:(NSString *)lightString lightColor:(UIColor *)color lightFont:(UIFont *)font;

/** 当特长的时候 降低一下优先级 */
- (void)lowPriority;
/** 当特长的时候 固定不被拉伸 也不被压缩 */
- (void)highPriority;

@end

 
