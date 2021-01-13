//
//  KVOUseViewController.h
//  KVO_KVC_Demo
//
//  Created by 谢佳培 on 2020/9/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KVOUseViewController : UIViewController

@end

@interface ScrollViewRecorder : NSObject

@property (nonatomic, strong) UIScrollView *scrollView;

- (void)beginRecordScrollViewOffset;

@end

NS_ASSUME_NONNULL_END
