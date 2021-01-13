//
//  ArchiveViewController.h
//  LocalCacheDemo
//
//  Created by 谢佳培 on 2020/10/16.
//

#import <UIKit/UIKit.h>

@interface MODStoreDemo : NSObject<NSFileManagerDelegate>

@end

#pragma mark - 归档

@interface ArchivePerson : NSObject<NSSecureCoding>

@property (nonatomic,copy) NSString* name;
@property (nonatomic,assign) int age;
@property (nonatomic,assign) float height;

@end

NS_ASSUME_NONNULL_BEGIN

@interface ArchiveViewController : UIViewController

@end

NS_ASSUME_NONNULL_END
