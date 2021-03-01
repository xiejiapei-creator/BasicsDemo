//
//  UnitTestingDemoTests.m
//  UnitTestingDemoTests
//
//  Created by 谢佳培 on 2021/2/24.
//

#import <XCTest/XCTest.h>

@interface UnitTestingDemoTests : XCTestCase

@end

@implementation UnitTestingDemoTests

- (void)setUp
{
    [super setUp];
    NSLog(@"初始化");
}

- (void)tearDown
{
    [super tearDown];
    
    NSLog(@"销毁清除");
}

- (void)testExample
{
    NSLog(@"冬天在毛衣上会摸到静电");
}

- (void)testPerformanceExample
{
    NSLog(@"性能测试");

    [self measureBlock:^{
        NSLog(@"耗时操作");
    }];
}

@end
