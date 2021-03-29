//
//  Regex.m
//  FunctionCodeBlockDemo
//
//  Created by 谢佳培 on 2020/9/27.
//

#import "Regex.h"

@implementation Regex

#pragma mark - 数字格式校验

// 判断文本框字数是否符合规范
+ (BOOL)validateTextCount:(NSString *)text
{
    NSString * regexExpress = @"^.{1,8}$";
    NSPredicate * predicate = [NSPredicate predicateWithFormat: @"SELF MATCHES %@", regexExpress];
    return [predicate evaluateWithObject: text];
}

// 判断验证码是否正确
+ (BOOL)validateAuthen:(NSString *)text
{
    NSString * regexExpress = @"^\\d{6}$";
    NSPredicate * predicate = [NSPredicate predicateWithFormat: @"SELF MATCHES %@", regexExpress];
    return [predicate evaluateWithObject: text];
}

// 判断输入金额是否正确
+ (BOOL)validateMoney:(NSString *)text
{
    NSString * regexExpress = @"^\\d{1,}$";
    NSPredicate * predicate = [NSPredicate predicateWithFormat: @"SELF MATCHES %@", regexExpress];
    return [predicate evaluateWithObject: text];
}

// 判断是否是手机号
+ (BOOL)isMobilePhone:(NSString *)phoneNumber
{
    NSString * Mobile = @"^1(3[0-9]|4[579]|5[0-35-9]|7[01356]|8[0-9])\\d{8}$";
    NSPredicate *regexMobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Mobile];
    if ([regexMobile evaluateWithObject:phoneNumber])
    {
        return YES;
    }
    return NO;
}

// 判断是否是移动号
+ (BOOL)isCMMobilePhone:(NSString *)phoneNumber
{
    NSString * CM = @"^1(34[0-8]|70[356]|(3[5-9]|4[7]|5[0-27-9]|7[8]|8[2-47-8])\\d)\\d{7}$";
    NSPredicate *regexTestCM = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    if ([regexTestCM evaluateWithObject:phoneNumber])
    {
        return YES;
    }
    return NO;
}

// 判断是否是联通号
+ (BOOL)isCUMobilePhone:(NSString *)phoneNumber
{
    NSString * CU = @"^1(70[07-9]|(3[0-2]|4[5]|5[5-6]|7[15-6]|8[5-6])\\d)\\d{7}$";
    NSPredicate *regexTestCU = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    if ([regexTestCU evaluateWithObject:phoneNumber])
    {
        return YES;
    }
    return NO;
}

// 判断是否是电信号
+ (BOOL)isCTMobilePhone:(NSString *)phoneNumber
{
    NSString * CT = @"^1(34[9]|70[0-2]|(3[3]|4[9]|5[3]|7[37]|8[019])\\d)\\d{7}$";
    NSPredicate *regexTestCT = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    if ([regexTestCT evaluateWithObject:phoneNumber])
    {
        return YES;
    }
    return NO;
}

// 18位身份证格式和合法性验证
+(BOOL)checkUserID:(NSString *)userID
{
    // 长度不为18的都排除掉
    if (userID.length != 18)
    {
        return NO;
    }
    
    // 校验格式
    NSString *regex = @"^(^[1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}$)|(^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])((\\d{4})|\\d{3}[Xx])$)$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    BOOL flag = [identityCardPredicate evaluateWithObject:userID];
    
    if (!flag)// 格式错误
    {
        return flag;
    }
    else// 格式正确再判断是否合法
    {
        // 将前17位加权因子保存在数组里
        NSArray *idCardWiArray = @[@"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1", @"6", @"3", @"7", @"9", @"10", @"5", @"8", @"4", @"2"];
        
        // 这是除以11后，可能产生的11位余数、验证码，也保存成数组
        NSArray *idCardYArray = @[@"1", @"0", @"10", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2"];
        
        // 用来保存前17位各自乖以加权因子后的总和
        NSInteger idCardWiSum = 0;
        for(int i = 0;i < 17;i++)
        {
            NSInteger subStrIndex = [[userID substringWithRange:NSMakeRange(i, 1)] integerValue];
            NSInteger idCardWiIndex = [[idCardWiArray objectAtIndex:i] integerValue];
            idCardWiSum += subStrIndex * idCardWiIndex;
        }
        
        // 计算出校验码所在数组的位置
        NSInteger idCardMod = idCardWiSum%11;
        
        // 得到最后一位身份证号码
        NSString * idCardLast= [userID substringWithRange:NSMakeRange(17, 1)];
        
        // 如果等于2，则说明校验码是10，身份证号码最后一位应该是X
        if(idCardMod == 2)
        {
            if([idCardLast isEqualToString:@"X"] || [idCardLast isEqualToString:@"x"])
            {
                return YES;
            }
            else
            {
                return NO;
            }
        }
        else
        {
            // 用计算出的验证码与最后一位身份证号码匹配，如果一致，说明通过，否则是无效的身份证号码
            if([idCardLast isEqualToString: [idCardYArray objectAtIndex:idCardMod]])
            {
                return YES;
            }
            else
            {
                return NO;
            }
        }
    }
}

// 车牌号格式校验(粤A8888澳)
+ (BOOL)checkCarID:(NSString *)carID
{
    if (carID.length != 7)
    {
        return NO;
    }
    
    NSString *carRegex = @"^[\u4e00-\u9fa5]{1}[a-hj-zA-HJ-Z]{1}[a-hj-zA-HJ-Z_0-9]{4}[a-hj-zA-HJ-Z_0-9_\u4e00-\u9fa5]$";
    NSPredicate *carTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",carRegex];
    return [carTest evaluateWithObject:carID];
}

// 银行卡格式验证
+ (BOOL)isBankCard:(NSString *)bankCard
{
    if (bankCard.length < 16)
    {
        return NO;
    }
    
    NSInteger oddSum = 0;// 奇数求和
    NSInteger evenSum = 0;// 偶数求和
    NSInteger allSum = 0;
    NSInteger cardNumberLength = (NSInteger)[bankCard length];
    
    // 取了最后一位数
    NSInteger lastNumber = [[bankCard substringFromIndex:cardNumberLength - 1] intValue];
    
    // 测试的是除了最后一位数外的其他数字
    bankCard = [bankCard substringToIndex:cardNumberLength - 1];
    
    for (NSInteger i = cardNumberLength - 1 ; i >= 1;i--)
    {
        NSString *tempString = [bankCard substringWithRange:NSMakeRange(i - 1, 1)];
        NSInteger tempValue = [tempString integerValue];
        if (cardNumberLength % 2 == 1 )// 卡号位数为奇数
        {
            if((i % 2) == 0)// 偶数位置
            {
                tempValue *= 2;
                if (tempValue >= 10)
                {
                    tempValue -= 9;
                }
                evenSum += tempValue;
            }
            else// 奇数位置
            {
                oddSum += tempValue;
            }
        }
        else
        {
            if((i % 2) == 1)
            {
                tempValue *= 2;
                if(tempValue >= 10)
                {
                    tempValue -= 9;
                }
                    
                evenSum += tempValue;
            }
            else
            {
                oddSum += tempValue;
            }
        }
    }
    
    allSum = oddSum + evenSum;
    allSum += lastNumber;
    if((allSum % 10) == 0)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

#pragma mark - 混合校验

// 6~16位数字/字母/下划线组成的密码格式校验
+ (BOOL)checkPassword:(NSString *)passwordString
{
    NSString *pattern = @"^[A-Za-z0-9_]{6,16}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    return [predicate evaluateWithObject:passwordString];
}

// 判断字符串是否全为[(数字)、(字母)、(数字|字母)、(汉字)]
+(BOOL)isAllNumber:(NSString *)string
{
    NSString *condition = @"^[0-9]*$";// 是否都是数字
    //NSString *condition = @"^[A-Za-z]+$";//是否都是字母
    //NSString *condition = @"^[A-Za-z0-9]+$";//是否都是字母和数字
    //NSString *condition = @"^[A-Za-z0-9]{6,16}$";//是否都是字母和数字且长度在[6,16]
    //NSString *condition = @"^[\u4e00-\u9fa5]{0,}$";//只能输入汉字
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",condition];
    return [predicate evaluateWithObject:string];
}

// 邮箱格式验证
+(BOOL)isEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

// 判断密码格式是否正确
+ (BOOL)validatePassword:(NSString *)passwordString
{
    NSString *length = @"^\\w{6,20}$";// 长度
    NSString *number = @"^\\w*\\d+\\w*$";// 数字
    NSString *lower = @"^\\w*[a-z]+\\w*$";// 小写字母
    NSString *upper = @"^\\w*[A-Z]+\\w*$";// 大写字母
    
    NSPredicate *lengthPredicate = [NSPredicate predicateWithFormat: @"SELF MATCHES %@", length];
    NSPredicate *numberPredicate = [NSPredicate predicateWithFormat: @"SELF MATCHES %@", number];
    NSPredicate *lowerPredicate = [NSPredicate predicateWithFormat: @"SELF MATCHES %@", lower];
    NSPredicate *upperPredicate = [NSPredicate predicateWithFormat: @"SELF MATCHES %@", upper];
    
    BOOL lengthFlag = [lengthPredicate evaluateWithObject:passwordString];
    BOOL numberFlag = [numberPredicate evaluateWithObject:passwordString];
    BOOL lowerFlag = [lowerPredicate evaluateWithObject:passwordString];
    BOOL upperFlag = [upperPredicate evaluateWithObject:passwordString];
    return (lengthFlag && numberFlag && lowerFlag && upperFlag);
}

#pragma mark - 文字校验

// 昵称
+ (BOOL)validateNickname:(NSString *)nickname
{
    NSString *nicknameRegex = @"^[\u4e00-\u9fa5]{1,8}$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",nicknameRegex];
    return [passWordPredicate evaluateWithObject:nickname];
}

@end

