//
//  KVOPrincipleModel.h
//  KVO_KVC_Demo
//
//  Created by 谢佳培 on 2021/2/22.
//

#import <Foundation/Foundation.h>

@interface PrinciplePerson : NSObject
{
    @public
    NSString *name;
}

@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *bookName;

- (void)hello;
- (void)read;

@end

@interface PrincipleStudent : PrinciplePerson

@end
