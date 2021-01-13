//
//  Block.h
//  Macro
//
//  Created by 谢佳培 on 2020/11/25.
//

#ifndef Block_h
#define Block_h

// void
typedef void (^VoidBlock)(void);
typedef void (^ClickBlock)(void);
typedef void (^ClickIndexBlock)(NSInteger index);
typedef BOOL (^BoolBlock)(void);
typedef int  (^IntBlock)(void);
typedef id   (^IDBlock)(void);

// int
typedef void (^Void_IntBlock)(int index);
typedef BOOL (^Bool_IntBlock)(int index);
typedef int  (^Int_IntBlock)(int index);
typedef id   (^ID_IntBlock)(int index);

// string
typedef void (^Void_StringBlock)(NSString *str);
typedef BOOL (^Bool_StringBlock)(NSString *str);
typedef int  (^Int_StringBlock)(NSString *str);
typedef id   (^ID_StringBlock)(NSString *str);

// id
typedef void (^Void_IDBlock)(id data);
typedef BOOL (^Bool_IDBlock)(id data);
typedef int  (^Int_IDBlock)(id data);
typedef id   (^ID_IDBlock)(id data);

// bool
typedef void (^VoidBoolBlock)(BOOL flag);

#endif /* Block_h */
