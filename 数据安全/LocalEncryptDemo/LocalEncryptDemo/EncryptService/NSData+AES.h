//
//  NSData+AES.h
//  LocalEncryptDemo
//
//  Created by 谢佳培 on 2020/9/8.
//  Copyright © 2020 xiejiapei. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSData(AES)

/** base64编码 */
+ (NSString*)encodeBase64Data:(NSData *)data;

/** base64解码 */
+ (NSData*)decodeBase64String:(NSString * )input;

/** 加密 */
- (NSData *)AES128EncryptWithKey:(NSString *)key;

/** 解密 */
- (NSData *)AES128DecryptWithKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
