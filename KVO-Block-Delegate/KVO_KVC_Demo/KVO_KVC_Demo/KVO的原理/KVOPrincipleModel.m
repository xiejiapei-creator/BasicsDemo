//
//  KVOPrincipleModel.m
//  KVO_KVC_Demo
//
//  Created by 谢佳培 on 2021/2/22.
//

#import "KVOPrincipleModel.h"

@implementation PrinciplePerson

- (void)setNickName:(NSString *)nickName
{
    _nickName = nickName;
}

- (void)setBookName:(NSString *)bookName
{
    _bookName = bookName;
}

- (void)hello
{
    
}

- (void)read
{
    
}

@end

@implementation PrincipleStudent

- (void)read
{
    NSLog(@"读书");
}

@end
