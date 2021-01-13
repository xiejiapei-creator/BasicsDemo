//
//  BookMarkViewController.h
//  LocalCacheDemo
//
//  Created by 谢佳培 on 2020/10/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BookMarkViewController : UIViewController

/** 创建BookMark */
- (NSData *)bookmarkForURL:(NSURL *)url;

@end

NS_ASSUME_NONNULL_END
