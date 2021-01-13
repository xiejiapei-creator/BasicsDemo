//
//  SQLiteViewController.m
//  LocalCacheDemo
//
//  Created by 谢佳培 on 2020/10/21.
//

#import "SQLiteViewController.h"
#import <sqlite3.h>

@interface SQLiteManager()

@property (nonatomic,assign) sqlite3 *dataBase;

@end

@implementation SQLiteManager

static SQLiteManager *instance;

// 创建单例
+ (instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

// 打开数据库
- (BOOL)openDB
{
    // app内数据库文件存放路径为沙盒
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *dataBasePath = [documentPath stringByAppendingPathComponent:@"sqliteDemo.sqlite"];
    
    if (sqlite3_open(dataBasePath.UTF8String, &_dataBase) != SQLITE_OK)// 数据库打开失败
    {
        return NO;
    }
    else// 数据库打开成功则创建表
    {
        // 用户表
        NSString *creatUserTable = @"CREATE TABLE IF NOT EXISTS 't_User' ( 'ID' INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,'name' TEXT,'age' INTEGER,'icon' TEXT);";
        
        // 车表
        NSString *creatCarTable = @"CREATE TABLE IF NOT EXISTS 't_Car' ('ID' INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,'type' TEXT,'output' REAL,'master' TEXT)";
        
        // 项目中一般不会只有一个表
        NSArray *SQL_ARR = [NSArray arrayWithObjects:creatUserTable,creatCarTable, nil];
        
        return [self creatTableExecSQL:SQL_ARR];
    }
}

// 用sql语句数组创建表
- (BOOL)creatTableExecSQL:(NSArray *)SQL_ARR
{
    for (NSString *SQL in SQL_ARR)
    {
        if (![self execuSQL:SQL])// 创建表失败
        {
            return NO;
        }
    }
    return YES;
}

// 执行Sql语句
- (BOOL)execuSQL:(NSString *)SQL
{
    // 参数一:数据库对象  参数二:需要执行的SQL语句  其余参数不需要处理
    char *error;
    if (sqlite3_exec(self.dataBase, SQL.UTF8String, nil, nil, &error) == SQLITE_OK)
    {
        return YES;
    }
    else
    {
        NSLog(@"SQLiteManager执行SQL语句出错:%s",error);
        return NO;
    }
}

// 查询sql
-(NSArray *)querySQL:(NSString *)SQL
{
    /**1、准备查询
     * 参数一:数据库对象
     * 参数二:查询语句
     * 参数三:查询语句的长度:-1
     * 参数四:句柄(游标对象)
     */
    sqlite3_stmt *stmt = nil;
    if (sqlite3_prepare_v2(self.dataBase, SQL.UTF8String, -1, &stmt, nil) != SQLITE_OK)
    {
        NSLog(@"准备查询失败!");
        return NULL;
    }
    
    // 2、准备成功，开始查询数据
    
    // 定义一个存放数据字典的可变数组
    NSMutableArray *dictMutableArray = [[NSMutableArray alloc] init];
    while (sqlite3_step(stmt) == SQLITE_ROW)
    {
        // 获取表中所有列数(字段数)
        int columnCount = sqlite3_column_count(stmt);
        
        // 定义存放字段数据的字典
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        for (int i = 0; i < columnCount; i++)
        {
            // 取出i位置列的字段名，作为字典的键key
            const char *cKey = sqlite3_column_name(stmt, i);
            NSString *key = [NSString stringWithUTF8String:cKey];
            
            // 取出i位置存储的值，作为字典的值value
            const char *cValue = (const char *)sqlite3_column_text(stmt, i);
            NSString *value = [NSString stringWithUTF8String:cValue];
            
            // 将此行数据中此字段中key和value包装成字典
            [dict setObject:value forKey:key];
        }
        [dictMutableArray addObject:dict];
    }
    return dictMutableArray;
}

// 关闭数据库
- (BOOL)closeSqlite
{
    if (sqlite3_close(self.dataBase) != SQLITE_OK)
    {
        return NO;
    }
    else
    {
        return YES;
    }
    
}

@end


@interface SQLiteViewController ()

@end

@implementation SQLiteViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 打开数据库
    [[SQLiteManager shareInstance] openDB];
    
    // 执行插入语句
    NSString *insertSql = @"insert into t_User (name,age,icon) values ('XieJiaPei',22,'http://...');";
    [[SQLiteManager shareInstance] execuSQL:insertSql];
    
    // 执行查询语句
    NSString *querySql = @"select name,age,icon from t_User;";
    NSArray *queryResultArray = [[SQLiteManager shareInstance] querySQL:querySql];
    NSLog(@"查询结果为：%@",queryResultArray);
    
    // 关闭数据库
    [[SQLiteManager shareInstance] closeSqlite];
}

@end
