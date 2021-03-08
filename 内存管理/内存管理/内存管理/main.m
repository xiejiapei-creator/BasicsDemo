//
//  main.m
//  内存管理
//
//  Created by 谢佳培 on 2021/3/2.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

extern void _objc_autoreleasePoolPrint(void);

int main(int argc, char * argv[]) {
    NSString * appDelegateClassName;
    @autoreleasepool {
        // 测试自动释放池：注意需要关闭ARC并添加autorelease才能打印出对象
        for (int i= 0; i<506; i++)
        {
            NSObject *objc = [[NSObject alloc] init];
            //NSObject *objc = [[[NSObject alloc] init] autorelease];
        }
        _objc_autoreleasePoolPrint();
        
        appDelegateClassName = NSStringFromClass([AppDelegate class]);
    }
    return UIApplicationMain(argc, argv, nil, appDelegateClassName);
}
