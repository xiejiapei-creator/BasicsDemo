//
//  TableViewController.h
//  UIKitGrammarDemo
//
//  Created by 谢佳培 on 2020/10/30.
//

#import <UIKit/UIKit.h>

/**
 * 通讯录cell
 */
@interface PersonTableViewCell : UITableViewCell

@property (nonatomic, strong, readonly) UILabel *nameLabel;// 姓名
@property (nonatomic, strong, readonly) UILabel *namePinyinLabel;// 姓名拼音
@property (nonatomic, strong, readonly) UILabel *mobileLabel;// 手机
@property (nonatomic, strong, readonly) UILabel *introductionLabel;// 介绍

@end

/**
 * 通讯录model
 */
@interface PersonModel : NSObject

@property (nonatomic, copy) NSString *name;// 姓名
@property (nonatomic, copy) NSString *namePinyin;// 姓名拼音
@property (nonatomic, copy) NSString *nameFirstLetter;// 姓名首字母
@property (nonatomic, copy) NSString *mobile;// 手机
@property (nonatomic, copy) NSString *introduction;// 介绍

@end

@interface TableViewController : UIViewController

@end
 
