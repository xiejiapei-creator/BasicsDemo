//
//  testNSStringViewController.m
//  CategoryDemo
//
//  Created by 谢佳培 on 2020/11/3.
//

#import "testNSStringViewController.h"
#import "NSString+Custom.h"

@interface testNSStringViewController ()

@end

@implementation testNSStringViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self testSafeSubstring];
}

#pragma mark - 字符串尺寸

// 根据字体、行数、行间距和constrainedWidth计算文本占据的size
- (void)textSizeWithFont
{
    NSString *text = @"老伯爵看到列文的好，是站在一个成熟男人角度，看出列文有实干，成熟，不做作，理智的许多优点，他实诚，不虚伪，真实。而大多数他眼中的青年都是在一个模子里刻出来那种，旧的上流社会沾染了的虚伪，狡诈，奉承的习气，相比之下，列文在他心中才是真是，优秀，能够給女儿真正幸福生活的人选。很可惜，安娜就没有这样好的父亲给她在人生最初把关。";
    CGSize size = [text textSizeWithFont:[UIFont systemFontOfSize:18] numberOfLines:0 lineSpacing:0.5 constrainedWidth:300];
    NSLog(@"根据字体、行数、行间距和constrainedWidth计算文本占据的size，宽度：%f，高度：%f",size.width,size.height);
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 300,  300, size.height)];
    label.text = text;
    label.numberOfLines = 0;
    label.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:label];
}

// 计算字符串长度（一行时候）
- (void)testLimitTextWidth
{
    NSString *limitText = @"他还没有学会阅读便在头脑里构思故事";
    CGSize limitWidth = [limitText textSizeWithFont:[UIFont systemFontOfSize:18] limitWidth:400];
    NSLog(@"计算字符串长度（一行时候），宽度：%f，高度：%f",limitWidth.width,limitWidth.height);
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 300,  limitWidth.width, limitWidth.height)];
    label.text = limitText;
    label.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:label];
}

#pragma mark - 安全截取字符串

- (void)testSafeSubstring
{
    NSString *text = @"XieJia";
    NSString *subToString = [text substringToIndexSafe:9];
    NSString *subFromString = [text substringFromIndexSafe:9];
    NSLog(@"ToIndex超范围了：%@，FromIndex超范围了：%@",subToString,subFromString);
    
    NSString *deleteFirstCharacter = [text deleteFirstCharacter];
    NSString *deleteLastCharacter = [text deleteLastCharacter];
    NSLog(@"删除第一个字符：%@，删除最后一个字符：%@",deleteFirstCharacter,deleteLastCharacter);
}

@end
