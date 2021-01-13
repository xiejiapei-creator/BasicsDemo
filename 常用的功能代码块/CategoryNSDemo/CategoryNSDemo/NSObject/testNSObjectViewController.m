//
//  testNSObjectViewController.m
//  CategoryNSDemo
//
//  Created by 谢佳培 on 2020/11/4.
//

#import "testNSObjectViewController.h"
#import "NSObject+Custom.h"

static char valueKey;

@interface testNSObjectViewController ()

@end

@implementation testNSObjectViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self associatedObject];
}

- (void)associatedObject
{
    NSArray *object = [[NSArray alloc] initWithObjects:@"Xie", @"Jia",@"Pei",nil];
    NSString *value = [[NSString alloc] initWithFormat:@"%@",@"97Boy"];
    
    [object setAssociatedValue:value withKey:&valueKey];
    
    NSString *associatedValue = (NSString *)[object getAssociatedValueForKey:&valueKey];
    NSLog(@"被关联的值为: %@", associatedValue);
}

@end
