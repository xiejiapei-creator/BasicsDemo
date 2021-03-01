//
//  ViewControllerUnitTest.m
//  UnitTestingTests
//
//  Created by 谢佳培 on 2021/2/24.
//

#import <XCTest/XCTest.h>
#import "ViewController.h"

@interface ViewControllerUnitTest : XCTestCase

@property (nonatomic, strong) ViewController *vc;

@end

@implementation ViewControllerUnitTest

- (void)setUp
{
    self.vc = [[ViewController alloc] init];
}

- (void)tearDown
{
    self.vc = nil;
}

- (void)testExample
{
    // 给出测试条件
    int num1 = 10;
    int num2 = 20;
    
    // 在接口方法中使用测试条件返回计算结果
    int num3 = [self.vc getPlus:num1 num2:num2];
    
    // 计算结果未符合预期结果则测试失败提出警告
    XCTAssertEqual(num3, 40,@"加法接口测试失败");
}

// 异步测试
- (void)testAsync
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"不符合期望时长"];

    [self.vc loadData:^(id data) {
        XCTAssertNotNil(data);
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:5 handler:^(NSError * _Nullable error) {
        NSLog(@"超时错误信息 = %@",error);
    }];
}

// 性能测试
- (void)testPerformanceExample
{
    [self measureBlock:^{
        [self.vc openCamera];
    }];
}

// 局部性能测试
- (void)testPerformanceLocal
{
    [self measureMetrics:@[XCTPerformanceMetric_WallClockTime] automaticallyStartMeasuring:NO forBlock:^{
        [self.vc openCamera];
        
        [self startMeasuring];
        [self.vc openCamera];
        [self stopMeasuring];
    }];
}

@end

