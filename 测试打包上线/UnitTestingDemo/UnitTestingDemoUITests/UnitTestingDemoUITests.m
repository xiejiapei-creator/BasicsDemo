//
//  UnitTestingDemoUITests.m
//  UnitTestingDemoUITests
//
//  Created by 谢佳培 on 2021/2/24.
//

#import <XCTest/XCTest.h>

@interface UnitTestingDemoUITests : XCTestCase

@end

@implementation UnitTestingDemoUITests

- (void)setUp
{
    // 当发生错误的时候立即停止UI测试
    self.continueAfterFailure = NO;
    
    NSLog(@"UI测试-初始化");
}

- (void)tearDown
{
    NSLog(@"UI测试-销毁");
}

// 逻辑测试
- (void)testExample
{
    // UI测试需要启动APP
    XCUIApplication *app = [[XCUIApplication alloc] init];
    [app launch];
    
    XCUIElement *element = [[[[[[[[[[XCUIApplication alloc] init] childrenMatchingType:XCUIElementTypeWindow] elementBoundByIndex:0] childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element;
    XCUIElement *textField = [[element childrenMatchingType:XCUIElementTypeTextField] elementBoundByIndex:0];
    [textField tap];
    [textField typeText:@"xiejiapei"];
}

// 性能测试
- (void)testLaunchPerformance
{
    [self measureWithMetrics:@[[[XCTApplicationLaunchMetric alloc] init]] block:^{
        [[[XCUIApplication alloc] init] launch];
    }];
}

@end
