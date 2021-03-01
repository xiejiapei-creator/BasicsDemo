//
//  OCMockDemoTests.m
//  OCMockDemoTests
//
//  Created by 谢佳培 on 2021/2/26.
//

#import "Person.h"
#import "Manager.h"
#import "ViewController.h"
#import "OCMockViewController.h"
#import <OCMock.h>
#import <XCTest/XCTest.h>

@interface OCMockDemoTests : XCTestCase

@end

@implementation OCMockDemoTests

- (void)testPerson
{    
    Person *person = [[Person alloc] init];
    
    // 创建一个mock对象，相当于复制了Person类
    Person *mock_p = OCMClassMock([Person class]);
    
    // 可以给这个mock对象的方法设置预设的参数和返回值
    OCMStub([mock_p getPersonName]).andReturn(@"OCMock");
    
    // 用这个预设的值和实际的值比较看二者是否相等
    XCTAssertEqualObjects([mock_p getPersonName], [person getPersonName],@"===");
}

- (void)testTableViewDelete
{
    ViewController *vc = [[ViewController alloc] init];
    id tableMock = OCMClassMock([UITableView class]);
    
    // 创建数据
    vc.dataArray = [NSMutableArray arrayWithCapacity:1];
    for (int i = 0; i<10; i++)
    {
        [vc.dataArray insertObject:[NSString stringWithFormat:@"第%d个数据",i] atIndex:0];
    }
    
    // 创建删除位置
    NSIndexPath *path = [NSIndexPath indexPathForRow:29 inSection:0];
    
    // 进行关联
    [vc tableView:tableMock commitEditingStyle:UITableViewCellEditingStyleDelete forRowAtIndexPath:path];
    
    OCMVerify([tableMock deleteRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationFade]);
}

- (void)testMVVMDemo
{
    OCMockViewController *vc = [[OCMockViewController alloc] init];
    
    // 创建用于获取数据的工具类
    id manager = OCMClassMock([Manager class]);
    
    // 创建测试数据 (model)
    Dog *dog1 = [[Dog alloc] init];
    dog1.userName = @"旺财";
    Dog *dog2 = [[Dog alloc] init];
    dog2.userName = @"来福";
    NSArray *array = @[dog1,dog2];
    OCMStub([manager fetchDogs]).andReturn(array);
    
    // 更新UI (view)
    id cardView = OCMClassMock([IDCardView class]);
    vc.idCardView = cardView;
    
    // 验证vc中的方法是否有效
    OCMVerify([vc updateIDCardView]);
}

@end
