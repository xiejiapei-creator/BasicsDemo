//
//  KeyChainViewController.m
//  LocalCacheDemo
//
//  Created by 谢佳培 on 2020/10/16.
//

#import "KeyChainViewController.h"

@interface KeyChainViewController ()

@end

@implementation KeyChainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 往keychain里面添加一个账户
    BOOL isSuccess = [self addItemWithService:@"com.szzc.driver" account:@"xiejiapei" password:@"1997"];
    if (isSuccess)
    {
        NSLog(@"成功往keychain里面添加一个账户，账户为：xiejiapei，密码为：1997");
    }
    
    // 从keychain里面查询密码
    NSString *password = [self passwordForService:@"com.szzc.driver" account:@"xiejiapei"];
    NSLog(@"查询到的密码为：%@",password);
}

// 从keychain里面查询密码
- (NSString *)passwordForService:(nonnull NSString *)service account:(nonnull NSString *)account
{
    // 1、生成一个查询用的可变字典
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:4];
    // 表明为一般密码，也可能是证书或者其他东西
    [dict setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
    // 输入service
    [dict setObject:service forKey:(__bridge id)kSecAttrService];
    // 输入account
    [dict setObject:account forKey:(__bridge id)kSecAttrAccount];
    // 返回Data
    [dict setObject:@YES forKey:(__bridge id)kSecReturnData];
    
    // 2、查询
    OSStatus status = -1;
    CFTypeRef result = NULL;
    // 核心API，查找是否匹配并且返回密码！
    status = SecItemCopyMatching((__bridge CFDictionaryRef)dict,&result);
    
    // 3、判断状态是否查询成功
    if (status != errSecSuccess)
    {
        return nil;
    }
    
    // 4、将返回数据转换成string
    NSString *password = [[NSString alloc] initWithData:(__bridge_transfer NSData *)result encoding:NSUTF8StringEncoding]; 
    return password;
}

// 往keychain里面添加一个账户
- (BOOL)addItemWithService:(NSString *)service account:(NSString *)account password:(NSString *)password
{
    // 1、构造一个操作字典用于查询
    NSMutableDictionary *searchDict = [[NSMutableDictionary alloc]initWithCapacity:4];
    // 表明存储的是一个密码
    [searchDict setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
    // 输入service
    [searchDict setObject:service forKey:(__bridge id)kSecAttrService];
    // 输入account
    [searchDict setObject:account forKey:(__bridge id)kSecAttrAccount];


    // 2、先查查是否已经存在
    OSStatus status = -1;
    CFTypeRef result =NULL;
    // 核心API，查找是否匹配并且返回密码！
    status = SecItemCopyMatching((__bridge CFDictionaryRef)searchDict, &result);
    
    // 3、判断状态是否查询成功
    if (status == errSecItemNotFound)// 没有找到则添加
    {
        // 把 password 转换为 NSData
        NSData *passwordData = [password dataUsingEncoding:NSUTF8StringEncoding];
        
        // 添加密码
        [searchDict setObject:passwordData forKey:(__bridge id)kSecValueData];
        
        // !!!!!关键的添加API
        status = SecItemAdd((__bridge CFDictionaryRef)searchDict, NULL);
    }
    else if (status == errSecSuccess)// 成功找到，说明钥匙已经存在则进行更新
    {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:searchDict];
        
        // 把password 转换为 NSData
        NSData *passwordData = [password dataUsingEncoding:NSUTF8StringEncoding];
        
        // 添加密码
        [dict setObject:passwordData forKey:(__bridge id)kSecValueData];
        
        // !!!!关键的更新API
        status = SecItemUpdate((__bridge CFDictionaryRef)searchDict, (__bridge CFDictionaryRef)dict);
    }
    
    // 返回添加一个账户是否成功的状态
    return (status == errSecSuccess);
}

@end
 


