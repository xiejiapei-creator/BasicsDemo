//
//  Regex.h
//  FunctionCodeBlockDemo
//
//  Created by 谢佳培 on 2020/9/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Regex : NSObject

#pragma mark - 数字格式校验

/** 判断文本框字数是否符合规范 */
+ (BOOL)validateTextCount:(NSString *)text;

/** 判断验证码是否正确 */
+ (BOOL)validateAuthen:(NSString *)text;

/** 判断输入金额是否正确 */
+ (BOOL)validateMoney:(NSString *)text;

/** 判断是否是手机号 */
+ (BOOL)isMobilePhone:(NSString *)phoneNumber;

/** 判断是否是移动号 */
+ (BOOL)isCMMobilePhone:(NSString *)phoneNumber;

/** 判断是否是联通号 */
+ (BOOL)isCUMobilePhone:(NSString *)phoneNumber;

/** 判断是否是电信号 */
+ (BOOL)isCTMobilePhone:(NSString *)phoneNumber;

/** 18位身份证格式和合法性验证 */
+(BOOL)checkUserID:(NSString *)userID;

/** 车牌号格式校验(粤A8888澳) */
+ (BOOL)checkCarID:(NSString *)carID;

/** 银行卡格式验证 */
+ (BOOL)isBankCard:(NSString *)bankCard;

#pragma mark - 混合校验

/** 6~16位数字/字母/下划线组成的密码格式校验 */
+ (BOOL)checkPassword:(NSString *)passwordString;

/** 判断密码格式是否正确 */
+ (BOOL)validatePassword:(NSString *)passwordString;

/** 判断字符串是否全为[(数字)、(字母)、(数字|字母)、(汉字)] */
+ (BOOL)isAllNumber:(NSString *)string;

/** 邮箱格式验证 */
+ (BOOL)isEmail:(NSString *)email;

#pragma mark - 文字校验

/** 昵称 */
+ (BOOL)validateNickname:(NSString *)nickname;

@end

NS_ASSUME_NONNULL_END
