//
//  SecondViewController.h
//  Demo
//
//  Created by 谢佳培 on 2020/9/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

// 声明代理
@protocol contentDelegate <NSObject>

/** 代理方法 */
- (void)transferString:(NSString *)content;

@end

// block，用于回传数据
typedef void(^TransDataBlock)(NSString *content);

@interface SecondViewController : UIViewController

/** 内容 */
@property(nonatomic, copy) NSString *content;

/** 文本框内容 */
@property(nonatomic, strong) UITextField *contentTextField;

/** 代理属性 */
@property(nonatomic, weak) id<contentDelegate> delegate;

/** 定义一个block属性，用于回传数据 */
@property(nonatomic, copy) TransDataBlock transDataBlock;

@end

NS_ASSUME_NONNULL_END
