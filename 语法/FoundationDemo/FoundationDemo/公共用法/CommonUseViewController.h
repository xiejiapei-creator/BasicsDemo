//
//  CommonUseViewController.h
//  BasicGrammarDemo
//
//  Created by 谢佳培 on 2020/10/20.
//

#import <UIKit/UIKit.h>

#pragma mark - 重写

@interface Animal : NSObject <NSCopying>

@property(nonatomic, copy) NSString *name;
@property(nonatomic, assign) NSString *age;

@end


#pragma mark - 复制

@interface Person : NSObject<NSCopying>

@property (atomic, strong, readwrite) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (readonly, strong) NSString *fullName;

- (void)run;

@end

#pragma mark - 判断方法

@interface Student : Person

@end

NS_ASSUME_NONNULL_BEGIN

@interface CommonUseViewController : UIViewController

@end

NS_ASSUME_NONNULL_END
