//
//  FileStreamNetworkTool.h
//  NetworkRequestDemo
//
//  Created by 谢佳培 on 2021/2/22.
//  Copyright © 2021 xiejiapei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^fileHandleBlock)(NSURL* fileUrl, NSString *progress);

@interface FileStreamNetworkTool : NSObject

@property (nonatomic, copy) fileHandleBlock handleBlock;
- (NSURLSessionDataTask*)getDownFileUrl:(NSString *)fileUrl backBlock:(fileHandleBlock)handleBlock;

@end
