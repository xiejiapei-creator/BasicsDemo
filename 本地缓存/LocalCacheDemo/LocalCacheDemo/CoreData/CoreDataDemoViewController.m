//
//  CoreDataDemoViewController.m
//  LocalCacheDemo
//
//  Created by 谢佳培 on 2020/10/29.
//

#import "CoreDataDemoViewController.h"
#import "AppDelegate.h"

@interface CoreDataDemoViewController ()

@end

@implementation CoreDataDemoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self insert];
    [self findAll];
}

// 保存数据
- (void)saveContext
{
    AppDelegate *delegate =  (AppDelegate *)[[UIApplication sharedApplication] delegate];// 强制转换
    NSManagedObjectContext *context = delegate.persistentContainer.viewContext;
    
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error])
    {
        NSLog(@"数据保存错误：%@", error.localizedDescription);
        abort();
    }
    else
    {
        NSLog(@"save ok");
    }
}

// 插入数据
- (void)insert
{
    // 1. 获得context
    AppDelegate *delegate =  (AppDelegate *)[[UIApplication sharedApplication] delegate];// 强制转换
    NSManagedObjectContext *context = delegate.persistentContainer.viewContext;
    
    // 2. 找到实体结构，并生成一个实体对象
    NSManagedObject *robot = [NSEntityDescription insertNewObjectForEntityForName:@"Robot" inManagedObjectContext:context];
    [robot setValue:@555 forKey:@"id"];
    [robot setValue:@"XieJiaPei" forKey:@"name"];
    
    // NSEntityDescription实体描述，也就是表的结构
    // 参数1：表名字，参数2:实例化的对象由谁来管理，就是context
    NSManagedObject *robotArm = [NSEntityDescription insertNewObjectForEntityForName:@"RobotArm" inManagedObjectContext:context];
    [robotArm setValue:@1010 forKey:@"id"];
    [robotArm setValue:@10 forKey:@"numberOfFingers"];
    [robot setValue:robotArm forKey:@"robotArm"];
    
    // 3. 调用context保存实体，如果没有成功，返回错误信息
    [self saveContext];
    
    // 4. 察看文件的存储路径
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
    NSLog(@"察看文件的存储路径:%@",documentPath);
}

// 查询所有数据
- (NSArray *)findAll
{
    // 1. 获得Entity
    AppDelegate *delegate =  (AppDelegate *)[[UIApplication sharedApplication] delegate];// 强制转换
    NSManagedObjectContext *context = delegate.persistentContainer.viewContext;
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Robot" inManagedObjectContext:context];
    
    // 2. 构造查询对象
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    // 3. 构造排序对象
    // 根据某个属性（相当于数据库某个字段）来排序
    // 是否升序
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"id" ascending:TRUE];
    NSArray *sortDescriptors = @[sortDescriptor];
    request.sortDescriptors = sortDescriptors;
    
    // 4. 执行查询，返回结果集
    NSError *error = nil;
    NSArray *listData = [context executeFetchRequest:request error:&error];
    
    // 5. 遍历结果集
    for (NSManagedObject *enity in listData)
    {
        NSLog(@"id=%i name=%@ arm=%@",[[enity valueForKey:@"id"] intValue],[enity valueForKey:@"name"],[[enity valueForKey:@"robotArm"] valueForKey:@"numberOfFingers"]);
    }

    return listData;
}

// 通过主键查询并修改
- (void)modifyById:(int)robotID
{
    // 1. 获得Entity
    AppDelegate *delegate =  (AppDelegate *)[[UIApplication sharedApplication] delegate];// 强制转换
    NSManagedObjectContext *context = delegate.persistentContainer.viewContext;
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Robot" inManagedObjectContext:context];
    
    // 2. 构造查询对象
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.entity = entityDescription;
    
    // 3. 构造查询条件，相当于where子句
    fetchRequest.predicate = [NSPredicate predicateWithFormat: @"id = %@",robotID];
    
    // 4. 执行查询，返回结果集
    NSError *error = nil;
    NSArray *listData = [context executeFetchRequest:fetchRequest error:&error];
    
    // 5. 更新里面的值(find-replace)后存储
    if (error == nil && [listData count] > 0)
    {
        NSManagedObject *obj = listData[0];
        [obj setValue:@"FanYiCheng" forKey:@"name"];
        NSLog(@"更新后的名称为：%@",[obj valueForKey:@"name"]);
         
        [context save:nil];
    }
    
    // 6. 显示
    [self findAll];
}

// 通过主键删除
- (void)removeById:(int)robotID
{
    // 1. 获得Entity
    AppDelegate *delegate =  (AppDelegate *)[[UIApplication sharedApplication] delegate];// 强制转换
    NSManagedObjectContext *context = delegate.persistentContainer.viewContext;
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Robot" inManagedObjectContext:context];
    
    // 2. 构造查询对象
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    // 3. 构造查询条件，相当于where子句
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id = %@",robotID];
    [request setPredicate:predicate];
    
    // 4. 执行查询，返回结果集
    NSError *error = nil;
    NSArray *listData = [context executeFetchRequest:request error:&error];
    
    // 5. 删除后存储
    if (error == nil && listData.count > 0)
    {
        NSManagedObject *noteManagedObject = [listData lastObject];
        [context deleteObject:noteManagedObject];
        
        [self saveContext];
    }
    
    // 6. 显示
    [self findAll];
}


@end
