//
//  Manager.h
//  OCMockDemo
//
//  Created by 谢佳培 on 2021/2/27.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Dog : NSObject

@property(nonatomic, copy) NSString *userName;

@end

@interface IDCardView : UIView

- (void)dogIDCardView:(Dog *)dog;

@end

@interface Manager : NSObject

- (NSArray *)fetchDogs;

- (void)fetchDogsWithBlock:(void (^)(NSDictionary *result, NSError *error))block;

@end

NS_ASSUME_NONNULL_END
