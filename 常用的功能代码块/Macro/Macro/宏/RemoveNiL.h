//
//  RemoveNiL.h
//  Macro
//
//  Created by 谢佳培 on 2020/11/25.
//
#import "NSString+Custom.h"

#ifndef RemoveNiL_h
#define RemoveNiL_h

#define StrRemoveNiL(v)  ([NSString removeNil:v])
#define StrNilToValue(k,v)  ([NSString removeNilToValue:k value:v])
#define StrNilToConnect(v)  ([NSString removeNilToConnect:v])
#define IntToStr(v)  ([NSString intToStr:v])

#endif /* RemoveNiL_h */
