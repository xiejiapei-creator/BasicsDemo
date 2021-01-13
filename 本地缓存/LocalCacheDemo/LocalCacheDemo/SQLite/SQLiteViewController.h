//
//  SQLiteViewController.h
//  LocalCacheDemo
//
//  Created by 谢佳培 on 2020/10/21.
//

#import <UIKit/UIKit.h>

@interface SQLiteManager : NSObject

// 单例创建对象
+ (instancetype)shareInstance;

// 打开数据库
- (BOOL)openDB;

// 用sql语句数组创建表
-(BOOL)creatTableExecSQL:(NSArray *)SQL_ARR;

// 执行Sql
- (BOOL)execuSQL:(NSString *)SQL;

// 查询sql
-(NSArray *)querySQL:(NSString *)SQL;

// 关闭数据库
- (BOOL)closeSqlite;

@end

NS_ASSUME_NONNULL_BEGIN

@interface SQLiteViewController : UIViewController

@end

NS_ASSUME_NONNULL_END
