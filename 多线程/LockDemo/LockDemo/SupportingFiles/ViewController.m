//
//  ViewController.m
//  LockDemo
//
//  Created by 谢佳培 on 2021/4/6.
//

#import "ViewController.h"
#import "BaseLock.h"
#import "OSSpinLockDemo.h"
#import "os_unfair_lockDemo.h"
#import "pthread_mutexDemo.h"
#import "MutexRecursiveLockDemo.h"
#import "MutexConditionLockDemo.h"
#import "NSLockDemo.h"
#import "NSRecursiveLockDemo.h"
#import "NSConditionDemo.h"
#import "NSConditionLockDemo.h"
#import "SemaphoreDemo.h"
#import "SynchronizedDemo.h"
#import "pthread_rwlockDemo.h"
#import "dispatch_barrier_asyncDemo.h"
#import "dispatch_group_tDemo.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    dispatch_group_tDemo *baseLock = [[dispatch_group_tDemo alloc] init];
    [baseLock otherTest];
}

@end
