//
//  ShareModeViewController.h
//  DesignPatternsDemo
//
//  Created by 谢佳培 on 2020/8/26.
//  Copyright © 2020 xiejiapei. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum
{
  kAnemone,
  kCosmos,
  kGerberas,
  kHollyhock,
  kJasmine,
  kZinnia,
  kTotalNumberOfFlowerTypes
} FlowerType;

@interface ShareModeViewController : UIViewController

@end

@interface FlowerView : UIImageView

- (void) drawRect:(CGRect)rect;

@end

@interface FlyweightView : UIView

@property (nonatomic, retain) NSArray *flowerList;

@end

@interface FlowerFactory : NSObject
{
  @private NSMutableDictionary *flowerPool_;
}

- (UIImageView *)flowerViewWithType:(FlowerType)type;

@end

NS_ASSUME_NONNULL_END
