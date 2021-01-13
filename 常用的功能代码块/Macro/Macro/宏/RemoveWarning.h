//
//  RemoveWarning.h
//  Macro
//
//  Created by 谢佳培 on 2020/11/25.
//

#ifndef RemoveWarning_h
#define RemoveWarning_h

//消除PerformSelector警告
#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

#endif /* RemoveWarning_h */


