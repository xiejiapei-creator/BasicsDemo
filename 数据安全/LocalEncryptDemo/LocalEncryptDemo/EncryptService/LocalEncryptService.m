//
//  LocalEncryptService.m
//  LocalEncryptDemo
//
//  Created by 谢佳培 on 2020/9/8.
//  Copyright © 2020 xiejiapei. All rights reserved.
//

#import "LocalEncryptService.h"
#import "SAMKeychain.h"
#import "NSData+AES.h"

// 添加到sku前面的前缀
static NSString *AESPriPerfix = @"AES";

@interface LocalEncryptService ()

// 绑定标识和有效期
@property (nonatomic, strong) NSMutableDictionary *validityPeriods;

@end

@implementation LocalEncryptService

#pragma mark - 接口

// 单例
+ (instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    static LocalEncryptService *service;
    dispatch_once(&onceToken, ^{
        service = LocalEncryptService.new;
        service.validityPeriods = @{}.mutableCopy;
    });
    return service;
}

// 绑定标识和有效期
- (void)bindSku:(NSString *)sku validityPeriod:(NSNumber *)seconds
{
    if ([sku isKindOfClass:NSString.class] && [seconds isKindOfClass:NSNumber.class] && seconds.integerValue != 0)
    {
        [self.validityPeriods setValue:seconds forKey:sku];
    }
}

// 强制清除加密秘钥
- (void)forceClearPriEncryptKeyWithSkuNum:(NSString *)sku
{
    [SAMKeychain deletePasswordForService:sku account:sku];
}

// 加密并保存
- (NSString *)encryptAndSaveInfo:(NSString *)info SkuNum:(NSString *)sku;
{
    // 加密
    NSString *encryptInfo = [self encodeWithString:info sku:sku];
    
    if (encryptInfo)
    {
        // 保存
        [[NSUserDefaults standardUserDefaults] setObject:encryptInfo forKey:[AESPriPerfix stringByAppendingString:sku]];
    }
    
    return encryptInfo;
}

// 解密并获取
- (NSString *)decryptAndQueryWithSkuNum:(NSString *)sku error:(NSError **)error;
{
    // 获取
    NSString *decryptInfo = [[NSUserDefaults standardUserDefaults] objectForKey:[AESPriPerfix stringByAppendingString:sku]];
    
    if (decryptInfo)
    {
        // 解密
        return [self decodeWithString:decryptInfo sku:sku error:error];
    }
    
    return nil;
}

#pragma mark - 算法

// 加密算法
- (NSString*)encodeWithString:(NSString *)string sku:(NSString *)sku
{
    // 1.将内容转化为数据
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    
    // 2.获取秘钥
    NSString *key = [self codeKeyWithSuk:sku error:nil];
    
    // 3.根据秘钥对内容进行aes加密
    NSData *aesData = [data AES128EncryptWithKey:key];
    NSLog(@"aes128加密后：%@",aesData);
    
    // 4.再进行base64编码
    NSString *base64Data = [NSData encodeBase64Data:aesData];
    NSLog(@"base64编码后：%@",base64Data);
    return base64Data;
}

// 解密算法
- (NSString*)decodeWithString:(NSString *)string sku:(NSString *)sku error:(NSError **)error;
{
    // 1.解开base64编码
    NSData *decodeBase64Data = [NSData decodeBase64String:string];
    NSLog(@"base64解密后：%@",decodeBase64Data);
    
    // 2.获取秘钥
    NSError *keyError;
    NSString *key = [self codeKeyWithSuk:sku error:&keyError];
    if(keyError)
    {
        if (error != NULL)
        {
            *error = [[NSError alloc] initWithDomain:keyError.domain code:keyError.code userInfo:keyError.userInfo];
        }
        return nil;
    }
    
    // 3.根据秘钥解开aes加密内容
    NSData *decryptAesData = [decodeBase64Data AES128DecryptWithKey:key];
    
    // 4.将数据转化为字符串
    NSString *resultString = [[NSString alloc] initWithData:decryptAesData encoding:NSUTF8StringEncoding];
    NSLog(@"aes128解密后的：%@",resultString);
    return resultString;
}

// 获取秘钥算法
- (NSString*)codeKeyWithSuk:(NSString *)sku error:(NSError **)error;
{
    // 1.根据绑定标识创建秘钥
    NSString *key = [SAMKeychain passwordForService:sku account:sku];
    
    // 2.根据绑定标识获取有效期
    NSInteger validityPeriod = [[self.validityPeriods valueForKey:sku] integerValue];
    
    // 3.最近生成的本地秘钥
    if (validityPeriod && key.length >= 10)
    {
        // 取以秒为单位时间作比较
        NSString *keyTime = [key substringWithRange:NSMakeRange(0, 10)];
        long long last = keyTime.longLongValue;
        long long now = (long long)[NSDate date].timeIntervalSince1970;
        
        if (now - last > validityPeriod || last > now) //秘钥失效
        {
            key = nil;
            NSLog(@"加密秘钥已过期 %lld 秒",now - last - validityPeriod);
            
            if (error != NULL)
            {
                *error = [[NSError alloc] initWithDomain:@"加密秘钥过期" code:-1 userInfo:nil];
            }
        }
        else// 尚未失效
        {
            NSLog(@"加密秘钥 %lld 秒后过期",validityPeriod - (now - last));
        }
    }
    
    // 4.key不存在
    // 首次随机生成用于信息加密KEY，确保不同手机的加密key是不同的
    // 可以凭借时间戳设定key的时效性
    if (!key.length)
    {
        // 4.1 当前时间
        NSString *time = [NSString stringWithFormat:@"%lld",(long long)[NSDate date].timeIntervalSince1970 * 1000];
        
        // 4.2 随机生成用于信息加密KEY
        key = [time stringByAppendingString:[NSString stringWithFormat:@"%ld",(long)arc4random()]];
        
        // 4.3 添加salt
        NSString *salt = nil;
        if ([NSUUID UUID].UUIDString.length >= 2)
        {
            salt = [[NSUUID UUID].UUIDString substringWithRange:NSMakeRange(0, 5)];
        }
        else
        {
            salt = @"xjpjm";
        }
        key = [key stringByAppendingString:salt];
        
        // 4.4 存储加密秘钥
        [SAMKeychain setPassword:key forService:sku account:sku];
        NSLog(@"LocalEncryptService:秘钥重新生成");
    }
    
    // 5. 16字节128位秘钥
    if (key.length >= 16)
    {
        // aes128
        key = [key substringWithRange:NSMakeRange(key.length - 16, 16)];
        NSLog(@"秘钥为:%@",key);
    }
    return key;
}

@end
