//
//  CollectionViewController.h
//  UIKitGrammarDemo
//
//  Created by 谢佳培 on 2020/10/30.
//

#import <UIKit/UIKit.h>

/**
 * 通讯录cell
 */
@interface PersonCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong, readonly) UILabel *nameLabel;// 姓名
@property (nonatomic, strong, readonly) UILabel *namePinyinLabel;// 姓名拼音
@property (nonatomic, strong, readonly) UILabel *mobileLabel;// 手机
@property (nonatomic, strong, readonly) UILabel *introductionLabel;// 介绍

@end

@interface CollectionViewController : UIViewController

@end
 
