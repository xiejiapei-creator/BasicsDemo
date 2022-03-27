//
//  ViewController.m
//  LockPerformanceDemo
//
//  Created by 谢佳培 on 2022/3/17.
//

#import "ViewController.h"
#import <libkern/OSAtomic.h>
#import <pthread.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self runSynchronized];
    [self runLock];
    [self runCondition];
    [self runConditionLock];
    [self runRecursiveLock];
    [self runPthread_mutex];
    [self runDispatch_semaphore];
    [self runOSSpinLockLock];
}

// @synchronized
- (void)runSynchronized {
    CFTimeInterval timeBefore;
    CFTimeInterval timeCurrent;
    NSUInteger i;
    NSUInteger count = 1000*10000;//执行一千万次
    
    id obj = [[NSObject alloc] init];;
    timeBefore = CFAbsoluteTimeGetCurrent();

    for(i = 0; i < count; i++) {
        @synchronized(obj) {
            
        }
    }
    
    timeCurrent = CFAbsoluteTimeGetCurrent();
    printf("@synchronized used : %f\n", timeCurrent-timeBefore);
}

// NSLock
- (void)runLock {
    CFTimeInterval timeBefore;
    CFTimeInterval timeCurrent;
    NSUInteger i;
    NSUInteger count = 1000*10000;//执行一千万次

    NSLock *lock = [[NSLock alloc] init];
    timeBefore = CFAbsoluteTimeGetCurrent();
    for(i=0; i<count; i++) {
        [lock lock];
        [lock unlock];
    }
    
    timeCurrent = CFAbsoluteTimeGetCurrent();
    printf("NSLock used : %f\n", timeCurrent-timeBefore);
}

// NSCondition
- (void)runCondition {
    CFTimeInterval timeBefore;
    CFTimeInterval timeCurrent;
    NSUInteger i;
    NSUInteger count = 1000*10000;//执行一千万次
    
    NSCondition *condition = [[NSCondition alloc] init];
    timeBefore = CFAbsoluteTimeGetCurrent();

    for(i=0; i<count; i++){
        [condition lock];
        [condition unlock];
    }

    timeCurrent = CFAbsoluteTimeGetCurrent();
    printf("NSCondition used : %f\n", timeCurrent-timeBefore);
}

// NSConditionLock
- (void)runConditionLock {
    CFTimeInterval timeBefore;
    CFTimeInterval timeCurrent;
    NSUInteger i;
    NSUInteger count = 1000*10000;//执行一千万次
    
    NSConditionLock *conditionLock = [[NSConditionLock alloc]init];
    timeBefore = CFAbsoluteTimeGetCurrent();
    for(i=0; i<count; i++){
        [conditionLock lock];
        [conditionLock unlock];
    }

    timeCurrent = CFAbsoluteTimeGetCurrent();
    printf("NSConditionLock used : %f\n", timeCurrent-timeBefore);
}

// NSRecursiveLock
- (void)runRecursiveLock {
    CFTimeInterval timeBefore;
    CFTimeInterval timeCurrent;
    NSUInteger i;
    NSUInteger count = 1000*10000;//执行一千万次
    
    NSRecursiveLock *recursiveLock = [[NSRecursiveLock alloc]init];
    timeBefore = CFAbsoluteTimeGetCurrent();
    for(i=0; i<count; i++) {
        [recursiveLock lock];
        [recursiveLock unlock];
    }

    timeCurrent = CFAbsoluteTimeGetCurrent();
    printf("NSRecursiveLock used : %f\n", timeCurrent-timeBefore);
}

// pthread_mutex
- (void)runPthread_mutex {
    CFTimeInterval timeBefore;
    CFTimeInterval timeCurrent;
    NSUInteger i;
    NSUInteger count = 1000*10000;//执行一千万次
    
    pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;
    timeBefore = CFAbsoluteTimeGetCurrent();

    for(i=0; i<count; i++){
        pthread_mutex_lock(&mutex);
        pthread_mutex_unlock(&mutex);
    }

    timeCurrent = CFAbsoluteTimeGetCurrent();
    printf("pthread_mutex used : %f\n", timeCurrent-timeBefore);
}

// dispatch_semaphore
- (void)runDispatch_semaphore {
    CFTimeInterval timeBefore;
    CFTimeInterval timeCurrent;
    NSUInteger i;
    NSUInteger count = 1000*10000;//执行一千万次
    
    dispatch_semaphore_t semaphore =dispatch_semaphore_create(1);
    timeBefore = CFAbsoluteTimeGetCurrent();

    for(i=0; i<count; i++){
        dispatch_semaphore_wait(semaphore,DISPATCH_TIME_FOREVER);
        dispatch_semaphore_signal(semaphore);
    }

    timeCurrent = CFAbsoluteTimeGetCurrent();
    printf("dispatch_semaphore used : %f\n", timeCurrent-timeBefore);
}

// OSSpinLockLock
- (void)runOSSpinLockLock {
    CFTimeInterval timeBefore;
    CFTimeInterval timeCurrent;
    NSUInteger i;
    NSUInteger count = 1000*10000;//执行一千万次
    
    OSSpinLock spinlock = OS_SPINLOCK_INIT;
    timeBefore = CFAbsoluteTimeGetCurrent();

    for(i=0; i<count; i++){
        OSSpinLockLock(&spinlock);
        OSSpinLockUnlock(&spinlock);
    }

    timeCurrent = CFAbsoluteTimeGetCurrent();
    printf("OSSpinLock used : %f\n", timeCurrent-timeBefore);
}

@end
