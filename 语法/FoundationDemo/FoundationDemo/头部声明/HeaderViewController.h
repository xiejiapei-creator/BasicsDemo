//
//  HeaderViewController.h
//  FoundationDemo
//
//  Created by 谢佳培 on 2020/10/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PersonClass : NSObject<NSCopying>

@property (atomic, strong, readwrite) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;

@property (nonatomic, strong) NSObject *objStrong;
@property (nonatomic, weak) NSObject *objWeak;
@property (nonatomic, assign) NSObject *objAssign;
@property (nonatomic, copy) NSString *objCopy;

- (void)printPetPhrase:(NSString *)petPhrase;

@end

@interface HeaderViewController : UIViewController

@end

NS_ASSUME_NONNULL_END
