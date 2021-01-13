//
//  SignIncodeViewController.h
//  FunctionCodeBlockDemo
//
//  Created by 谢佳培 on 2020/9/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

// 签到码展示视图，由一个label和一个下划线组成
@interface Code : UIView

@property (nonatomic, copy) NSString *text;

@property (strong, nonatomic) UILabel *codeLabel;
@property (strong, nonatomic) UIView *lineView;

@end

typedef void(^InputCompleted)(NSString *content);
typedef void(^InputUnCompleted)(NSString *content);

// 签到码视图，使用时只需要创建对应的View进行布局就OK了
@interface VerificationCode : UIView

/** 设置签到码输入完成的处理方案 */
@property(nonatomic, copy) InputCompleted inputCompleted;
/** 设置签到码输入未完成对应的处理方案 */
@property(nonatomic, copy) InputUnCompleted inputUnCompleted;

/** 提供了一个可以修改签到码位数的入口 */
- (instancetype)initWithCodeBits:(NSInteger)codeBits;

@end

@interface SignIncodeViewController : UIViewController



@end

NS_ASSUME_NONNULL_END
