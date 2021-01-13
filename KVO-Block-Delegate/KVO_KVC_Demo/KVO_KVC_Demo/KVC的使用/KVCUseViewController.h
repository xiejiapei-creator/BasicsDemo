//
//  KVCUseViewController.h
//  KVO_KVC_Demo
//
//  Created by 谢佳培 on 2020/9/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

// 学校
@interface School : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger age;

@end

// 银行账户
struct BankAccount
{
    int income;
    int balance;
};
typedef struct BankAccount BankAccount;

// 个人
@interface Person : NSObject

@property(nonatomic, copy) NSString *name;
@property(nonatomic, assign) NSInteger age;

@property(nonatomic, strong) School *currentSchool;
@property(nonatomic, assign) BankAccount bankAccount;

/** 随机某人 */
+ (Person *)randomPerson;
/** 随机某些人 */
+ (NSArray<Person *> *)randomPersonsWithCount:(NSUInteger)count;

@end

@interface KVCUseViewController : UIViewController

@end

NS_ASSUME_NONNULL_END
