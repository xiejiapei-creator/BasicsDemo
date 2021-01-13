//
//  NSString+Hash.h
//  EncryptedDemo
//
//  Created by 谢佳培 on 2020/9/9.
//  Copyright © 2020 xiejiapei. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Hash)

#pragma mark - MD5 散列函数

/** 计算MD5散列结果
 *  @return 32个字符的MD5散列字符串
 */
- (NSString *)md5String;

#pragma mark - SHA 散列函数

/** 计算SHA1散列结果
 *  @return 40个字符的SHA1散列字符串
 */
- (NSString *)sha1String;

/** 计算SHA224散列结果
 *  @return 56个字符的SHA224散列字符串
 */
- (NSString *)sha224String;

/** 计算SHA256散列结果
 *  @return 64个字符的SHA256散列字符串
 */
- (NSString *)sha256String;

/** 计算SHA 384散列结果
 *  @return 96个字符的SHA 384散列字符串
 */
- (NSString *)sha384String;

/** 计算SHA 512散列结果
 *  @return 128个字符的SHA 512散列字符串
 */
- (NSString *)sha512String;

#pragma mark - HMAC 散列函数

/** 计算HMAC MD5散列结果
 *  @return 32个字符的HMAC MD5散列字符串
 */
- (NSString *)hmacMD5StringWithKey:(NSString *)key;

/** 计算HMAC SHA1散列结果
 *  @return 40个字符的HMAC SHA1散列字符串
 */
- (NSString *)hmacSHA1StringWithKey:(NSString *)key;

/** 计算HMAC SHA256散列结果
 *  @return 64个字符的HMAC SHA256散列字符串
 */
- (NSString *)hmacSHA256StringWithKey:(NSString *)key;

/** 计算HMAC SHA512散列结果
 *  @return 128个字符的HMAC SHA512散列字符串
 */
- (NSString *)hmacSHA512StringWithKey:(NSString *)key;

#pragma mark - 文件的散列函数

/** 计算文件的MD5散列结果
 *  @return 32个字符的MD5散列字符串
 */
- (NSString *)fileMD5Hash;

/** 计算文件的SHA1散列结果
 *  @return 40个字符的SHA1散列字符串
 */
- (NSString *)fileSHA1Hash;

/** 计算文件的SHA256散列结果
 *  @return 64个字符的SHA256散列字符串
 */
- (NSString *)fileSHA256Hash;

/** 计算文件的SHA512散列结果
 *  @return 128个字符的SHA512散列字符串
 */
- (NSString *)fileSHA512Hash;

@end

NS_ASSUME_NONNULL_END
