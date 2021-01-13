//
//  DatePickerViewController.h
//  FunctionCodeBlockDemo
//
//  Created by 谢佳培 on 2020/9/28.
//

#import <UIKit/UIKit.h>

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

#define DatePictureHeight 200
#define TopViewHeight 44

@interface DatePickerSuperView : UIView

/** 初始化子视图 ，整体布局*/
- (void)createSubViews;

// 属性
@property (nonatomic, strong) UIView *backgroundView;// 背景蒙层视图
@property (nonatomic, strong) UIView *alertView;// 弹出视图
@property (nonatomic, strong) UIView *topView;// 标题行顶部视图
@property (nonatomic, strong) UIButton *cancelButton;// 左边取消按钮
@property (nonatomic, strong) UIButton *sureButton;// 右边确定按钮
@property (nonatomic, strong) UILabel *titleLabel;// 中间标题
@property (nonatomic, strong) UIView *lineView;// 分割线视图


// 点击背景遮罩图层和取消、确定按钮的点击事件实现效果在基类中都是空白的，具体效果在子类中进行重写来控制
/** 点击背景遮罩图层事件 */
- (void)didTapBackgroundView:(UITapGestureRecognizer *)sender;
/** 取消按钮的点击事件 */
- (void)clickCancelButton;
/** 确定按钮的点击事件 */
- (void)clickSureButton;

@end

// 日期选择完成之后的操作
typedef void(^DateResultBlock)(NSString *selectValue);

@interface DatePickerSubview : DatePickerSuperView

// 让使用者提供选择器的标题、最小日期、日期选择完成后的操作
+ (void)showDatePickerWithTitle:(NSString *)title minDateString:(NSString *)minDateString resultBlock:(DateResultBlock)resultBlock;

@end

@interface DatePickerViewController : UIViewController

@end
 
