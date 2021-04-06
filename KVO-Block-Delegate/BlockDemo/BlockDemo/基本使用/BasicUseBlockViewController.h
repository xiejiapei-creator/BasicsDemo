//
//  BasicUseBlockViewController.h
//  BlockDemo
//
//  Created by 谢佳培 on 2020/10/16.
//

#import <UIKit/UIKit.h>

// 声明
typedef void(^personBlock)(void);
typedef void(^finishBlock)(NSString *imageURL);
typedef NSString *(^fetchPersonMobileBlock)(void);

@interface Person : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) int age;
@property (nonatomic, copy) fetchPersonMobileBlock fetchPersonMobileBlock;

/** 运行私有block */
- (void)runPrivatePersonBlock;
/** 运行完成的block */
- (void)runFinishBlock:(finishBlock)finishBlock;// blcok作为入参
/** 打印手机号 */
- (void)printPersonMobile;

@end

NS_ASSUME_NONNULL_BEGIN

@interface BasicUseBlockViewController : UIViewController

@end

NS_ASSUME_NONNULL_END

 




