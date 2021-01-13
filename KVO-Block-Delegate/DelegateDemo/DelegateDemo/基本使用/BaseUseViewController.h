//
//  BaseUseViewController.h
//  DelegateDemo
//
//  Created by 谢佳培 on 2020/10/20.
//

#import <UIKit/UIKit.h>

#pragma mark - 计数工具

// Delegate
@protocol CountToolDelegate <NSObject>

- (void)willCountAllPerson;// 即将计算人数的委托方法
- (void)didCountedAllPerson;// 完成计算人数的委托方法

@end

// DataSource
@protocol CountToolDataSource <NSObject>

- (NSArray *)personArray;// 返回包含所有人的数组

@end

// 计算人数工具类
@interface CountTool : NSObject

@property (nonatomic, weak) id<CountToolDelegate> delegate;// 委托
@property (nonatomic, weak) id<CountToolDataSource> dataSource;// 数据源

- (void)count;// 计数方法

@end

#pragma mark - 人

// 工号和职位的协议
#ifndef WorkProtocol_h
#define WorkProtocol_h

@protocol WorkProtocol <NSObject>

@property (nonatomic, strong) NSString *jobNumber;// 工号

@required
- (void)printJobNumber;// 打印工号

@optional
- (void)codingAsProgrammer;// 职位

@end

#endif /* WorkProtocol_h */

@interface Person : NSObject <WorkProtocol>

@property (atomic, strong, readwrite) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (readonly, strong) NSString *fullName;
@property (nonatomic, strong) NSString *jobNumber;
@property (nonatomic, weak) id<WorkProtocol> delegate;

@end

#pragma mark - 管理者

// 管理者
@interface Administrator : Person

@property (nonatomic, strong, readonly) NSArray *allPersons;// 所有人

- (void)countAllPerson;// 计算所有人的数目

@end

NS_ASSUME_NONNULL_BEGIN

@interface BaseUseViewController : UIViewController

@end

NS_ASSUME_NONNULL_END
