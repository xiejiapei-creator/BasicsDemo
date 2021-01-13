//
//  ShareModeViewController.m
//  DesignPatternsDemo
//
//  Created by 谢佳培 on 2020/8/26.
//  Copyright © 2020 xiejiapei. All rights reserved.
//

#import "ShareModeViewController.h"
#import <objc/runtime.h>
#import <malloc/malloc.h>

@implementation FlowerView

- (void) drawRect:(CGRect)rect
{
  [self.image drawInRect:rect];
}

@end

@implementation FlyweightView

extern NSString *FlowerObjectKey, *FlowerLocationKey;

- (void)drawRect:(CGRect)rect
{
  for (NSDictionary *dic in self.flowerList)
  {
      NSValue *key = (NSValue *)[dic allKeys][0];
      FlowerView *flowerView = (FlowerView *)[dic allValues][0];
      CGRect area = [key CGRectValue];
      [flowerView drawRect:area];
  }
}

@end

@implementation FlowerFactory

- (UIImageView *)flowerViewWithType:(FlowerType)type
{
  if (flowerPool_ == nil)
  {
    flowerPool_ = [[NSMutableDictionary alloc] initWithCapacity:kTotalNumberOfFlowerTypes];
  }

  UIImageView *flowerView = [flowerPool_ objectForKey:[NSNumber numberWithInt:type]];

  if (flowerView == nil)
  {
    UIImage *flowerImage;

    switch (type)
    {
      case kAnemone:
          flowerImage = [UIImage imageNamed:@"anemone.jpg"];
          break;
      case kCosmos:
          flowerImage = [UIImage imageNamed:@"cosmos.jpg"];
          break;
      case kGerberas:
          flowerImage = [UIImage imageNamed:@"gerberas.jpeg"];
          break;
      case kHollyhock:
          flowerImage = [UIImage imageNamed:@"hollyhock.jpg"];
          break;
      case kJasmine:
          flowerImage = [UIImage imageNamed:@"jasmine.jpeg"];
          break;
      case kZinnia:
          flowerImage = [UIImage imageNamed:@"zinnia.jpg"];
          break;
      default:
        break;
    }

    flowerView = [[FlowerView alloc]
                   initWithImage:flowerImage];
      
    [flowerPool_ setObject:flowerView
                    forKey:[NSNumber numberWithInt:type]];
  }

  return flowerView;
}

@end

@implementation ShareModeViewController
{
  @private NSMutableDictionary *flowerPool_;
}



- (void)viewDidLoad
{
    [super viewDidLoad];

    // 使用普通模式
    // [self useNormalMode];
    
    // 使用享元模式
    [self useShareMode];
}

#pragma mark - 使用普通模式

- (void)useNormalMode
{
    for (int i = 0; i < 100000; i++)
    {
        @autoreleasepool
        {
            CGRect screenBounds = [[UIScreen mainScreen] bounds];
            CGFloat x = (arc4random() % (NSInteger)screenBounds.size.width);
            CGFloat y = (arc4random() % (NSInteger)screenBounds.size.height);
            NSInteger minSize = 10;
            NSInteger maxSize = 50;
            CGFloat size = (arc4random() % (maxSize - minSize + 1)) + minSize;
            CGRect area = CGRectMake(x, y, size, size);

            FlowerType flowerType = arc4random() % kTotalNumberOfFlowerTypes;
            
            //新建对象
            UIImageView *imageview = [self flowerViewWithType:flowerType];
            imageview.frame = area;
            [self.view addSubview:imageview];
        }
    }
}

- (UIImageView *)flowerViewWithType:(FlowerType)type
{
    UIImageView *flowerView = nil;
    UIImage *flowerImage;

    switch (type)
    {
        case kAnemone:
            flowerImage = [UIImage imageNamed:@"anemone.jpg"];
            break;
        case kCosmos:
            flowerImage = [UIImage imageNamed:@"cosmos.jpg"];
            break;
        case kGerberas:
            flowerImage = [UIImage imageNamed:@"gerberas.jpeg"];
            break;
        case kHollyhock:
            flowerImage = [UIImage imageNamed:@"hollyhock.jpg"];
            break;
        case kJasmine:
            flowerImage = [UIImage imageNamed:@"jasmine.jpeg"];
            break;
        case kZinnia:
            flowerImage = [UIImage imageNamed:@"zinnia.jpg"];
            break;
        default: 
            break;
    }

    flowerView = [[UIImageView alloc]initWithImage:flowerImage];

    return flowerView;
}

#pragma mark - 使用享元模式

- (void)useShareMode
{
    FlowerFactory *factory = [[FlowerFactory alloc] init];
    NSMutableArray *flowerList = [[NSMutableArray alloc] initWithCapacity:500];
    
    for (int i = 0; i < 10000; ++i)
    {
        @autoreleasepool
        {
            FlowerType flowerType = arc4random() % kTotalNumberOfFlowerTypes;
            
            //重复利用对象
            UIImageView *flowerView = [factory flowerViewWithType:flowerType];
            
            CGRect screenBounds = [[UIScreen mainScreen] bounds];
            CGFloat x = (arc4random() % (NSInteger)screenBounds.size.width);
            CGFloat y = (arc4random() % (NSInteger)screenBounds.size.height);
            NSInteger minSize = 10;
            NSInteger maxSize = 50;
            CGFloat size = (arc4random() % (maxSize - minSize + 1)) + minSize;
            
            CGRect area = CGRectMake(x, y, size, size);
            NSValue *key = [NSValue valueWithCGRect:area];
            
            //新建对象
            NSDictionary *dic = [NSDictionary dictionaryWithObject:flowerView forKey:key];
            [flowerList addObject:dic];
        }
    }
    
    FlyweightView *view = [[FlyweightView alloc] initWithFrame:self.view.bounds];
    view.flowerList = flowerList;
    self.view = view;
}

@end
