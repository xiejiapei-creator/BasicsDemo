//
//  CollectionViewController.m
//  FoundationDemo
//
//  Created by 谢佳培 on 2020/10/30.
//

#import "CollectionViewController.h"
#import "HeaderViewController.h"

@interface CollectionViewController ()

@end

@implementation CollectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self performSelector];
}

#pragma mark - 数组

// 创建数组
- (void)createArray
{
    PersonClass *person = [[PersonClass alloc] init];
    
    NSArray *aArray = @[@1, @2, @3];
    NSArray<NSString *> *bArray = @[@"2", @"4", @"3", @"1"];
    NSArray *cArray = [NSArray arrayWithObjects:@1, @"XieJiaPei", person, nil];
    NSArray *dArray = [NSArray arrayWithObjects:@1, @"XieJiaPei", nil, @5, person, nil];
    NSLog(@"原始数组A为：%@",aArray);
    NSLog(@"原始数组B为：%@",bArray);
    NSLog(@"原始数组A为：%@",cArray);
    NSLog(@"原始数组C为：%@",dArray);
}

// 从数组中取值
- (void)getValueFromArray
{
    PersonClass *person = [[PersonClass alloc] init];
    NSArray *cArray = [NSArray arrayWithObjects:@1, @"XieJiaPei", person, nil];
    
    NSString *index1IncArray = [cArray objectAtIndex:1];
    NSNumber *index0IncArray = cArray[0];
    NSLog(@"数组C中下标0的值为：%@，下标1的值为：%@",index0IncArray,index1IncArray);
    
    NSArray *array = @[@"xie",@"jia",@"pei",@"fan",@"yi",@"cheng",@"lin",@"feng",@"mian"];
    NSArray *newArray = [array objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(2, 3)]];
    NSLog(@"获取索引从3~6的元素组成的新集合:%@",newArray);
    
    NSLog(@"获取元素在集合中的位置:%lu",(unsigned long)[array indexOfObject:@"xie"]);
    
    array = [array arrayByAddingObjectsFromArray:newArray];
    NSLog(@"向array数组的最后追加另一个数组的所有元素:%@",array);
    
    array = [array subarrayWithRange:NSMakeRange(5, 3)];
    NSLog(@"索引为6~9处的所有元素:%@",array);
}

// 给数组排序
- (void)sortedArray
{
    NSArray<NSString *> *bArray = @[@"2", @"4", @"3", @"1"];
    
    NSArray *sortedArray = [bArray sortedArrayUsingSelector:@selector(compare:)];
    NSLog(@"集合元素自身的排序方法（compare:），数组B排序后为：%@", sortedArray);
    
    NSArray *sortedArrayByFunction = [bArray sortedArrayUsingFunction:intSort context:nil];
    NSLog(@"通过函数排序，数组B排序后为：%@", sortedArrayByFunction);
    
    NSArray *sortedArrayByBlock = [bArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2)
    {
        if ([obj1 integerValue] > [obj2 integerValue])
        {
            return NSOrderedDescending;
        }
        if ([obj1 intValue] < [obj2 intValue])
        {
            return NSOrderedAscending;
        }
        return NSOrderedSame;
    }];
    NSLog(@"通过代码块排序，数组B排序后为：%@", sortedArrayByBlock);
}

NSInteger intSort(id num1, id num2, void *context)
{
    int v1 = [num1 intValue];
    int v2 = [num2 intValue];
    if (v1 < v2)
        return NSOrderedAscending;
    else if (v1 > v2)
        return NSOrderedDescending;
    else
        return NSOrderedSame;
}

// 让数组过滤数据
- (void)filteredArray
{
    NSArray<NSString *> *bArray = @[@"2", @"4", @"3", @"1"];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", @"[3-9]+"];
    NSArray *filteredArray = [bArray filteredArrayUsingPredicate:predicate];
    NSLog(@"数组B过滤数据(只留下3-9之间的数据）后为：%@", filteredArray);
}

// 可变数组
- (void)mutableArray
{
    NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:@[@"xie",@"jia",@"pei"]];
    
    // 向集合最后添加一个元素
    [mutableArray addObject:@"liu"];
    // 向集合尾部添加多个元素
    [mutableArray addObjectsFromArray:@[@"ying",@"chi"]];
    NSLog(@"向集合最后位置添加元素后数组为：%@",mutableArray);
    
    // 指定位置插入一个元素
    [mutableArray insertObject:@"GuanYu" atIndex:1];
    // 指定位置插入多个元素
    [mutableArray insertObjects:@[@"ZhangFei",@"ZhaoYun"] atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(1, 2)]];
    NSLog(@"指定位置插入元素后数组为：%@",mutableArray);
    
    // 删除最后一个元素
    [mutableArray removeLastObject];
    // 删除指定索引处的元素
    [mutableArray removeObjectAtIndex:5];
    // 删除2~5处元素
    [mutableArray removeObjectsInRange:NSMakeRange(2, 3)];
    NSLog(@"删除元素后数组为：%@",mutableArray);
    
    // 替换索引为2处的元素
    [mutableArray replaceObjectAtIndex:2 withObject:@"MaChao"];
    NSLog(@"替换可变数组中的数据后为：%@",mutableArray);
}

// 数组的拷贝
- (void)copyArray
{
    NSArray<NSString *> *bArray = @[@"2", @"4", @"3", @"1"];
    
    NSArray *shallowCopyArray = [bArray copy];
    NSLog(@"原数组为不可变数组——使用copy——结果数组为不可变数组，比较是否相等的结果为：%@", shallowCopyArray == bArray ? @"相等" : @"不相等");
    NSLog(@"原数组为不可变数组——使用copy——结果数组为不可变数组，比较元素是否相等的结果为：%@", shallowCopyArray[3] == bArray[3] ? @"相等" : @"不相等");
    
    NSMutableArray *mutableCopyArray = [bArray mutableCopy];
    NSLog(@"原数组为不可变数组——使用mutableCopy——结果数组为可变数组，比较是否相等的结果为：%@", mutableCopyArray == bArray ? @"相等" : @"不相等");
    
    NSArray *copyArray = [mutableCopyArray copy];
    NSLog(@"原数组为可变数组——使用copy——结果数组为不可变数组，比较是否相等的结果为：%@", copyArray == mutableCopyArray ? @"相等" : @"不相等");
    
    NSMutableArray *anotherMutableCopyArray = [mutableCopyArray mutableCopy];
    NSLog(@"原数组为可变数组——使用mutableCopy——结果数组为可变数组，比较是否相等的结果为：%@", anotherMutableCopyArray == mutableCopyArray ? @"相等" : @"不相等");
}

// 遍历数组
- (void)enumeratorArray
{
    NSArray<NSString *> *bArray = @[@"2", @"4", @"3", @"1"];
    
    for (NSString *string in bArray)
    {
        NSLog(@"使用快速遍历，字符串为：%@",string);
    }
    
    NSEnumerator *enumerator = [bArray objectEnumerator];
    id object;
    while (object = [enumerator nextObject])
    {
        NSLog(@"使用顺序枚举器，数值为：%@",object);
    }
    
    NSEnumerator *reverseEnumerator = [bArray reverseObjectEnumerator];
    while (object = [reverseEnumerator nextObject])
    {
        NSLog(@"使用逆序枚举器，数值为：%@" , object);
    }
}

// 写入文件
- (void)arrayWriteToFile
{
    NSArray<NSString *> *bArray = @[@"2", @"4", @"3", @"1"];
    
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [documentPath stringByAppendingFormat:@"/%@",@"xie.plist"];
    if ( [bArray writeToFile:filePath atomically:YES] )
    {
        NSLog(@"成功写入文件，路径为：%@",filePath);
    }
    
    NSArray *arrayFromFile = [NSArray arrayWithContentsOfFile:filePath];
    NSLog(@"从文件中读取到的数组为：%@",arrayFromFile);
}

// 整体调用方法
- (void)performSelector
{
    PersonClass *person = [[PersonClass alloc] init];
    NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:@[person,person,person,person]];
    
    // 对集合元素整体调用方法
    [mutableArray makeObjectsPerformSelector:@selector(printPetPhrase:) withObject:@"锤子"];
    
    // 迭代集合内指定范围内元素，并使用该元素来执行代码块
    [mutableArray enumerateObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(1, 2)] options:NSEnumerationReverse usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
         NSLog(@"正在处理第%ld个元素：%@" , idx , obj);
    }];
}

#pragma mark - 字典

// 创建字典并取值
- (void)createDictionary
{
    PersonClass *person = [[PersonClass alloc] init];
    
    // 通过语法糖创建字典
    NSDictionary *dict = @{@"name": @"XieJiaPei", @"age": @22, @4: @5, person: @"FanYiCheng"};
    NSLog(@"原始字典为：%@",dict);
    
    // 从字典中取值
    NSLog(@"字典中的姓名为：%@，年龄为：%@，倘若没有Key值为：%@",dict[@"name"],[dict objectForKey:@"age"],dict[@"noKey"]);
    
    // 通过初始化方法创建字典
    NSDictionary *dictionary = [[NSDictionary alloc] initWithObjectsAndKeys: @"XieJiaPei",@"name",@22,@"age",person,@"FanYiCheng",nil];
    NSLog(@"key-value对数量: %lu",(unsigned long)[dictionary count]);
    NSLog(@"allKey: %@",[dictionary allKeys]);
    NSLog(@"allValues: %@",[dictionary allValues]);
    NSLog(@"key不同，值相同，这种情况的所有key为: %@",[dictionary allKeysForObject:@"XieJiaPei"]);
}

// 遍历字典
- (void)enumerateDictionary
{
    PersonClass *person = [[PersonClass alloc] init];
    NSDictionary *dict = @{@"name": @"XieJiaPei", @"age": @22, @4: @5, person: @"FanYiCheng"};
    
    // 使用指定代码块来迭代执行该集合中所有key-value对
    [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop)
    {
        NSLog(@"key的值为：%@，value的值：%@", key, obj);
    }];
}

// 写入文件
- (void)dictionaryWriteToFile
{
    // 我发现要写入plist文件，key必须为string类型
    NSDictionary *dict = @{@"name": @"XieJiaPei", @"age": @22, @"4": @5};
    
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [documentPath stringByAppendingPathComponent:@"jia.plist"];
    
    // 将路径转换为本地url形式
    NSURL *fileUrl = [NSURL fileURLWithPath:filePath];

    // writeToURL 的好处是，既可以写入本地url也可以写入远程url，苹果推荐使用此方法写入plist文件
    if ( [dict writeToURL:fileUrl atomically:YES] )
    {
        NSLog(@"成功写入文件，路径为：%@",filePath);
    }
    
    NSDictionary *dictionaryFromFile = [NSDictionary dictionaryWithContentsOfFile:filePath];
    NSLog(@"从文件中读取到的字典为：%@",dictionaryFromFile);
}

// 字典排序
- (void)compareDictionary
{
    NSDictionary *numberDict = @{@"Xie": @22, @"Liu": @18, @"Zou": @19};
    
    // compare:
    NSArray *newKeys = [numberDict keysSortedByValueUsingSelector:@selector(compare:)];
    NSLog(@"集合元素自身的排序方法（compare:），字典通过比较值将key排序后为：%@", newKeys);
    
    // block:
    NSDictionary *stringDict = @{@"Xie": @"apple", @"Liu": @"Banana", @"Zou": @"watermelon"};
    newKeys = [stringDict keysSortedByValueUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2)
    {
        if ([obj1 length] > [obj2 length])
        {
            return NSOrderedDescending;
        }
        if ([obj1 length] < [obj2 length])
        {
            return NSOrderedAscending;
        }
        return NSOrderedSame;
    }];
    NSLog(@"通过代码块排序，定义比较大小的标准：字符串越长越大，排序后key为：%@", newKeys);
}

// 字典过滤
- (void)filteredDictionary
{
    NSDictionary *numberDict = @{@"Xie": @22, @"Liu": @18, @"Zou": @19};
    
    NSSet *keySet = [numberDict keysOfEntriesPassingTest:^BOOL(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop)
    {
        return ([obj intValue] < 20);
    }];
    NSLog(@"真羡慕，你俩都好小呀：%@",keySet);
}

// 可变字典
- (void)mutableDictionary
{
    NSDictionary *numberDict = @{@"Xie": @22, @"Liu": @18, @"Zou": @19};
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionaryWithDictionary:numberDict];
    
    mutableDict[@"Xie"] = @"love Liu";
    NSLog(@"覆盖值后，字典为：%@",mutableDict);
    
    mutableDict[@"marray"] = @"baby";
    NSLog(@"添加新元素后，字典为：%@",mutableDict);
    
    [mutableDict addEntriesFromDictionary:@{@"Lin":@21}];
    NSLog(@"添加另外一个字典后，字典为：%@",mutableDict);
    
    [mutableDict removeObjectForKey:@"Xie"];
    NSLog(@"删除元素后，字典为：%@",mutableDict);
}

#pragma mark - 集合

- (void)set
{
    NSSet *set = [NSSet setWithObjects:@"xie",@"jia",@"pei", nil];
    NSSet *newSet = [NSSet setWithSet:set];
    NSSet *differenceSet = [NSSet setWithObjects:@"xie",@"liu",@"ying", nil];
    NSSet *deepCopySet = [[NSSet alloc] initWithSet:set copyItems:YES];
    NSLog(@"如果是深拷贝，所有元素必须符合NSCoping协议，拷贝后集合为：%@",deepCopySet);
    
    NSLog(@"集合中元素个数：%lu",(unsigned long)[set count]);
    
    set = [set setByAddingObject:@"love"];
    NSLog(@"将添加单个元素后生成的新集合赋给set：%@",set);
    
    set = [set setByAddingObjectsFromSet:newSet];
    NSLog(@"添加多个元素，相当于并集：%@",set);
    
    if ([set intersectsSet:differenceSet])
    {
        NSLog(@"有交集");
    }

    if ([set isSubsetOfSet:differenceSet])
    {
        NSLog(@"有子集");
    }

    if ([set containsObject:@"xie"])
    {
        NSLog(@"集合中包含元素xie");
    }

    NSLog(@"随取元素：%@",[set anyObject]);
    
    NSSet *filteredSet = [set objectsPassingTest:^BOOL(id  _Nonnull obj, BOOL * _Nonnull stop){
        return ([obj isEqualToString:@"xie"]);
    }];
    NSLog(@"过滤集合：%@",filteredSet);
}

- (void)mutableSet
{
    // 添加
    NSArray *array = @[@"xie",@"jia",@"pei"];
    NSMutableSet *set = [NSMutableSet setWithCapacity:10];
    [set addObjectsFromArray:array];
    NSSet *newSet = [NSSet setWithSet:set];
    
    // 删除
    [set removeObject:@"xie"];
    NSLog(@"删除元素后，新set为：%@",set);
    
    // 并集
    [set unionSet:newSet];
    NSLog(@"set取并集为：%@",set);
    
    // 交集
    [set intersectsSet:newSet];
    NSLog(@"set取交集为：%@",set);
    
    // 差集
    [set minusSet:newSet];
    NSLog(@"set取差集为：%@",set);
}

- (void)countedSet
{
    NSCountedSet *set = [NSCountedSet setWithObjects:@"xie",@"jia", nil];
    [set addObject:@"xie"];
    [set addObject:@"pei"];
    NSLog(@"带有重复次数的set为：%@",set);
    NSLog(@"xie这个字符串出现的次数为：%lu",(unsigned long)[set countForObject:@"xie"]);
}

@end




