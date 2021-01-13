//
//  PickerViewController.m
//  UIKitGrammarDemo
//
//  Created by 谢佳培 on 2020/10/30.
//

#import "PickerViewController.h"
#import <Masonry/Masonry.h>

@interface PickerViewController ()<UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) UIPickerView *pickerView;// 选择器视图
@property (nonatomic, strong) UIDatePicker *datePicker;// 日期选择器
@property (nonatomic, strong) NSArray<NSArray *> *pickerData;// 选择器的数据源

@end

@implementation PickerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self createPickerView];
}

// 创建选择器视图
- (void)createPickerView
{
    self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectZero];
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    [self.view addSubview:self.pickerView];
    [self.pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        make.height.equalTo(@200);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
    }];
    
    self.datePicker = [[UIDatePicker alloc] initWithFrame:CGRectZero];
    [self.datePicker addTarget:self action:@selector(datePickerChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.datePicker];
    [self.datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(300);
        make.height.equalTo(@200);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
    }];
}

- (void)datePickerChanged:(id)sender
{
    UIDatePicker *datePicker = sender;
    NSLog(@"选择的日期为：%@", datePicker.date);
}

// UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView// 转盘数目
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component// 每个转盘的行数
{
    return 5;
}

// UIPickerViewDelegate
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component// 每个转盘的宽度
{
    return self.view.bounds.size.width/2;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component// 转盘中每一行的高度
{
    return 44.0;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component// 每一行的标题
{
    return self.pickerData[component][row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSLog(@"选择的转盘为：%@, 选择的行数上的内容为：%@", @(component), self.pickerData[component][row]);
    if (component == 0)// 滚动第一个转盘时候需要联动第二个转盘
    {
        [pickerView reloadComponent:1];
    }
}

// 数据源
- (void)configuePickerData
{
    NSArray *columnFirst = @[@"谢佳培", @"王德胜", @"白落梅", @"车行迟", @"林风眠"];
    NSArray *columnSecond = @[@"IOS开发", @"院士", @"作家", @"虚构", @"画家"];
    self.pickerData = @[columnFirst, columnSecond];
    
    // 重新加载表盘
    [self.pickerView reloadAllComponents];
}

@end
