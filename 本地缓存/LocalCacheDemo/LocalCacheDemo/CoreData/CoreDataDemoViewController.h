//
//  CoreDataDemoViewController.h
//  LocalCacheDemo
//
//  Created by 谢佳培 on 2020/10/29.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

// Model
struct Robot
{
    NSDate *date;
    NSString *content;
};
typedef struct Note Note;

@interface CoreDataDemoViewController : UIViewController

@end

NS_ASSUME_NONNULL_END
