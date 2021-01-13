//
//  LocalEncryptService.h
//  LocalEncryptDemo
//
//  Created by 谢佳培 on 2020/9/8.
//  Copyright © 2020 xiejiapei. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LocalEncryptService : NSObject

/** 单例 */
+ (instancetype)shareInstance;

/** 绑定标识和有效期 */
- (void)bindSku:(NSString *)sku validityPeriod:(NSNumber *)seconds;
/** 强制清除加密秘钥 */
- (void)forceClearPriEncryptKeyWithSkuNum:(NSString *)sku;
/** 加密并保存 */
- (NSString *)encryptAndSaveInfo:(NSString *)info SkuNum:(NSString *)sku;
/** 解密并获取 */
- (NSString *)decryptAndQueryWithSkuNum:(NSString *)sku error:(NSError **)error;

@end

NS_ASSUME_NONNULL_END
