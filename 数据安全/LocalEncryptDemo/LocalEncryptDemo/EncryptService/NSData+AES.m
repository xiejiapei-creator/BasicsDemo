//
//  NSData+AES.m
//  LocalEncryptDemo
//
//  Created by 谢佳培 on 2020/9/8.
//  Copyright © 2020 xiejiapei. All rights reserved.
//

#import "NSData+AES.h"
#import "GTMBase64.h" //使用GTMBase64
#import <CommonCrypto/CommonCryptor.h> //使用kCCKeySizeAES128

@implementation NSData(AES)

#pragma mark - GTMBase64

// GTMBase64编码
+ (NSString*)encodeBase64Data:(NSData *)data
{
    // 进行GTMBase64编码
    data = [GTMBase64 encodeData:data];
    
    // 转为字符串 
    NSString *base64String = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return base64String;
}

// GTMBase64解码
+ (NSData*)decodeBase64String:(NSString * )input
{
    // 转为数据
    // usedLossyConversion：是否使用有损转化
    NSData *data = [input dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    // 进行GTMBase64解码
    data = [GTMBase64 decodeData:data];
    return data;
}

#pragma mark - AES

// AES加密 
- (NSData *)AES128EncryptWithKey:(NSString *)key
{
    char keyPtr[kCCKeySizeAES128 + 1];
    memset(keyPtr, 0, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];

    NSUInteger dataLength = [self length];

    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);

    size_t numBytesEncrypted = 0;
    // keyPtr加解密的密钥
    // 加密模式kCCOptionECBMode
    // 补码方式kCCOptionPKCS7Padding
    // iv向量，此属性可选，但只能用于CBC模式
    // kCCEncrypt: 编码 or 解码
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                          kCCAlgorithmAES,
                                          kCCOptionPKCS7Padding|kCCOptionECBMode,
                                          keyPtr,
                                          kCCBlockSizeAES128,
                                          NULL /* initialization vector (optional) */,
                                          [self bytes],
                                          dataLength, /* input */
                                          buffer,
                                          bufferSize, /* output */
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess)
    {
        //the returned NSData takes ownership of the buffer and will free it on deallocation
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }

    free(buffer); //free the buffer;
    return nil;
}

// AES解密
- (NSData *)AES128DecryptWithKey:(NSString *)key
{
    // 'key' should be 32 bytes for AES256, will be null-padded otherwise
    char keyPtr[kCCKeySizeAES128+1]; // room for terminator (unused)
    bzero(keyPtr, sizeof(keyPtr)); // fill with zeroes (for padding)

    // fetch key data
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];

    NSUInteger dataLength = [self length];

    //See the doc: For block ciphers, the output size will always be less than or
    //equal to the input size plus the size of one block.
    //That's why we need to add the size of one block here
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);

    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding|kCCOptionECBMode,
                                          keyPtr,
                                          kCCBlockSizeAES128,
                                          NULL /* initialization vector (optional) */,
                                          [self bytes],
                                          dataLength, /* input */
                                          buffer,
                                          bufferSize, /* output */
                                          &numBytesDecrypted);

    if (cryptStatus == kCCSuccess) {
        //the returned NSData takes ownership of the buffer and will free it on deallocation
        return [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
    }

    free(buffer); //free the buffer;
    return nil;
}

@end
