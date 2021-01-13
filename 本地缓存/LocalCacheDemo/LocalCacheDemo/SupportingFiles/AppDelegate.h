//
//  AppDelegate.h
//  LocalCacheDemo
//
//  Created by 谢佳培 on 2020/10/16.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

// 返回持久化存储容器
@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;

@end

