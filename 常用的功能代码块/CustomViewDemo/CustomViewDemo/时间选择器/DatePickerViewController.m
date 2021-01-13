//
//  DatePickerViewController.m
//  FunctionCodeBlockDemo
//
//  Created by 谢佳培 on 2020/9/28.
//

#import "DatePickerViewController.h"

@implementation DatePickerSuperView

- (void)createSubViews
{
    self.frame = [UIScreen mainScreen].bounds;
    
    // 子视图的透明度是和父视图保持一致的，如果直接将弹出视图加载到蒙层遮罩视图上，会导致弹出视图的透明度也为0.3，所以需要加在当前界面上
    [self addSubview:self.backgroundView];// 背景遮罩图层
    [self addSubview:self.alertView];// 弹出视图
    
    [self.alertView addSubview:self.topView];// 添加顶部标题栏
    
    [self.topView addSubview:self.cancelButton];// 添加左边取消按钮
    [self.topView addSubview:self.sureButton];// 添加右边确定按钮
    [self.topView addSubview:self.titleLabel];// 添加中间标题按钮
    [self.topView addSubview:self.lineView];// 添加分割线
}

// 提供给子类重载
- (void)didTapBackgroundView:(UITapGestureRecognizer *)sender {}
- (void)clickCancelButton {}
- (void)clickSureButton {}

#pragma mark - Getter/Setter

// 背景遮罩图层
- (UIView *)backgroundView
{
    if (!_backgroundView)
    {
        _backgroundView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _backgroundView.backgroundColor = [UIColor blackColor] ;
        _backgroundView.alpha = 0.3f ;
        _backgroundView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapBackgroundView:)];
        [_backgroundView addGestureRecognizer:tap];
    }
    return _backgroundView;
}

// 弹出视图
- (UIView *)alertView
{
    if (!_alertView)
    {
        CGFloat y = [UIScreen mainScreen].bounds.size.height - TopViewHeight - DatePictureHeight;
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        CGFloat height = TopViewHeight + DatePictureHeight;
        _alertView = [[UIView alloc] initWithFrame:CGRectMake(0, y, width, height)];
        _alertView.backgroundColor = [UIColor whiteColor];
    }
    return _alertView;
}

// 顶部标题栏视图
- (UIView *)topView
{
    if (!_topView)
    {
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, TopViewHeight + 0.5)];
        _topView.backgroundColor = [UIColor whiteColor];
    }
    return _topView;
}

// 左边取消按钮
- (UIButton *)cancelButton
{
    if (!_cancelButton)
    {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelButton.frame = CGRectMake(5, 8, 60, 28);
        _cancelButton.backgroundColor = [UIColor clearColor];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:17.0f];
        
        _cancelButton.layer.masksToBounds = YES;
        
        [_cancelButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(clickCancelButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

// 右边确定按钮
- (UIButton *)sureButton
{
    if (!_sureButton) {
        _sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        _sureButton.frame = CGRectMake(width - 65, 8, 60, 28);
        _sureButton.backgroundColor = [UIColor clearColor];
        _sureButton.titleLabel.font = [UIFont systemFontOfSize:17.0f];
        
        _sureButton.layer.masksToBounds = YES;
        
        [_sureButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_sureButton setTitle:@"确定" forState:UIControlStateNormal];
        [_sureButton addTarget:self action:@selector(clickSureButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureButton;
}

// 中间标题按钮
- (UILabel *)titleLabel
{
    if (!_titleLabel)
    {
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(65, 0, width - 130, TopViewHeight)];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = [UIFont systemFontOfSize:17.0f];
        _titleLabel.textColor = [UIColor grayColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

// 分割线
- (UIView *)lineView
{
    if (!_lineView)
    {
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        _lineView = [[UIView alloc]initWithFrame:CGRectMake(0, TopViewHeight, width, 0.5)];
        _lineView.backgroundColor  = [UIColor colorWithRed:225 / 255.0 green:225 / 255.0 blue:225 / 255.0 alpha:1.0];
        [self.alertView addSubview:_lineView];
    }
    return _lineView;
}

@end

@interface DatePickerSubview() <UIPickerViewDelegate, UIPickerViewDataSource>

@property (strong, nonatomic) UIPickerView *picker;// 选择器
@property (copy, nonatomic) NSString *selectValue;// 选择的值
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *minDateString;

@property (assign, nonatomic) DateResultBlock resultBlock;

@property (strong, nonatomic) NSMutableArray<NSString *> *data;

@end

@implementation DatePickerSubview

#pragma mark - 初始化

// 自定义初始化方法（重写）
- (instancetype)initWithTitle:(NSString *)title minDateString:(NSString *)minDateString resultBlock:(DateResultBlock)resultBlock
{
    if (self = [super init])
    {
        _title = title;
        _minDateString = minDateString;
        _resultBlock = resultBlock;
        
        [self createSubViews];
    }
    return self;
}

// 在弹出视图上添加选择器(重写)
- (void)createSubViews
{
    [super createSubViews];
    
    self.titleLabel.text = _title;
    [self.alertView addSubview:self.picker];
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.data.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.data[row];
}

#pragma mark - UIPickerViewDelegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.selectValue = self.data[row];
}

// 高度
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 35.0f;
}

// 宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return 100;
}

#pragma mark - Events

// 取消(重写)
- (void)clickCancelButton
{
    [self dismissWithAnimation:YES];
}

// 确定（重写）
- (void)clickSureButton
{
    NSLog(@"点击确定按钮后，执行block回调");
    
    [self dismissWithAnimation:YES];
    if (_resultBlock)
    {
        _resultBlock(_selectValue);
    }
}

// 背景（重写）
- (void)didTapBackgroundView:(UITapGestureRecognizer *)sender
{
     // 蒙层背景点击事件看需求，有的需要和取消一样的效果，有的可能就无效果
     [self dismissWithAnimation:YES];
}

#pragma mark - Private Methods

// 关闭视图
- (void)dismissWithAnimation:(BOOL)animation
{
    [UIView animateWithDuration:0.2 animations:^{
        // 动画隐藏
        CGRect rect = self.alertView.frame;
        rect.origin.y += (DatePictureHeight + TopViewHeight);
        self.alertView.frame = rect;
        
        self.backgroundView.alpha = 0;
    } completion:^(BOOL finished) {
        // 父视图移除
        [self.cancelButton removeFromSuperview];
        [self.sureButton removeFromSuperview];
        [self.titleLabel removeFromSuperview];
        [self.lineView removeFromSuperview];
        [self.topView removeFromSuperview];
        
        [self.picker removeFromSuperview];
        [self.alertView removeFromSuperview];
        [self.backgroundView removeFromSuperview];
        [self removeFromSuperview];
        
        // 清空 dealloc，创建的视图要清除，避免内存泄露
        self.cancelButton = nil;
        self.sureButton = nil;
        self.titleLabel = nil;
        self.lineView = nil;
        self.topView = nil;
        
        self.picker = nil;
        self.alertView = nil;
        self.backgroundView = nil;
    }];
}

// 弹出视图
- (void)showWithAnimation:(BOOL)animation
{
    // 获取当前应用的主窗口
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    [keyWindow addSubview:self];
    
    if (animation)
    {
        // 动画前初始位置
        CGRect rect = self.alertView.frame;
        rect.origin.y = SCREEN_HEIGHT;
        self.alertView.frame = rect;
        
        // 浮现动画
        [UIView animateWithDuration:0.3 animations:^{
            CGRect rect = self.alertView.frame;
            rect.origin.y -= DatePictureHeight + TopViewHeight;
            self.alertView.frame = rect;
        }];
    }
}

// 弹出选择器
+ (void)showDatePickerWithTitle:(NSString *)title minDateString:(NSString *)minDateString resultBlock:(DateResultBlock)resultBlock
{
    DatePickerSubview *datePicker = [[DatePickerSubview alloc] initWithTitle:title minDateString:minDateString resultBlock:resultBlock];
    [datePicker showWithAnimation:YES];
}

#pragma mark - Getter/Setter

// 选择器数据的加载，从设定的最小日期到当前月
- (NSMutableArray<NSString *> *)data
{
    if (!_data)
    {
        _data = [[NSMutableArray alloc] init];
        
        NSDate *currentDate = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM"];
        NSString *dateString = [formatter stringFromDate:currentDate];
        NSDate *newDate;
        
        // 通过日历可以直接获取前几个月的日期，所以这里直接用该类的方法进行循环获取数据
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *lastMonthComps = [[NSDateComponents alloc] init];
        NSInteger lastIndex = 0;

        // 循环获取可选月份，从当前月份到最小月份，用字符串比较来判断是否大于设定的最小日期
        while (!([dateString compare:self.minDateString] == NSOrderedAscending))
        {
            [_data addObject:dateString];
            lastIndex--;
            
            // 获取之前n个月, setMonth的参数为正则向后，为负则表示之前
            [lastMonthComps setMonth:lastIndex];
            newDate = [calendar dateByAddingComponents:lastMonthComps toDate:currentDate options:0];
            dateString = [formatter stringFromDate:newDate];
        }
    }
    return _data;
}

// 选择器的初始化
- (UIPickerView *)picker
{
    if (!_picker)
    {
        _picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, TopViewHeight + 0.5, SCREEN_WIDTH, DatePictureHeight)];
        // 设置代理
        _picker.delegate =self;
        _picker.dataSource =self;
    }
    return _picker;
}

@end

@interface DatePickerViewController ()

@end

@implementation DatePickerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [DatePickerSubview showDatePickerWithTitle:@"日期选择器" minDateString:@"2019-08" resultBlock:^(NSString *selectValue) {
        NSLog(@"选择的日期为：%@",selectValue);
    }];
}

@end
