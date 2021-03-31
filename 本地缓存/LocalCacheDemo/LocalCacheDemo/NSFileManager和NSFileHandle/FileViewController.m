//
//  FileViewController.m
//  LocalCacheDemo
//
//  Created by 谢佳培 on 2020/10/16.
//

#import "FileViewController.h"

@interface FileViewController ()<NSFileManagerDelegate>

@end

@implementation FileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 获取Document目录
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *directoryPath = [documentPath stringByAppendingPathComponent:@"XieJiaPei"];
    NSString *filePath = [directoryPath stringByAppendingPathComponent:@"/luckcoffee.plist"];
    
    NSLog(@"获取文件的大小：%lld",[self getFileSizeWithPath:filePath]);
    NSLog(@"获取文件的信息：%@",[self getFileInfoWithPath:filePath]);
}

#pragma mark - 创建文件/文件夹

// 方式一：使用URL进行创建目录
- (NSURL *)createDirectory
{
    NSURL *directoryURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] firstObject];
    NSURL *directoryPath = [directoryURL URLByAppendingPathComponent:@"Directory"];
    
    // 目录不存在则创建
    NSError *error = nil;
    if (![[NSFileManager defaultManager] createDirectoryAtURL:directoryPath withIntermediateDirectories:YES attributes:nil error:&error])
    {
        // 处理错误
        return nil;
    }
    
    NSLog(@"创建的目录路径为：%@",directoryPath);
    
    return directoryPath;
}

// 方式二：使用String进行创建目录
- (BOOL)creatDirectoryWithPath:(NSString *)path
{
    if (path.length == 0)
    {
        return NO;
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isSuccess = YES;
    BOOL isExist = [fileManager fileExistsAtPath:path];
    
    if (isExist == NO)
    {
        NSError *error;
        if (![fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error])
        {
            isSuccess = NO;
            NSLog(@"创建目录失败：%@",[error localizedDescription]);
        }
    }
    
    return isSuccess;
}

// 创建文件
- (BOOL)creatFile:(NSString *)filePath
{
    if (filePath.length == 0)// 文件路径为空
    {
        return NO;
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:filePath])// 文件已经存在
    {
        return YES;
    }
    
    NSError *error;
    NSString *directoryPath = [filePath stringByDeletingLastPathComponent];// 目录路径
    // 创建目录
    BOOL isSuccess = [fileManager createDirectoryAtPath:directoryPath withIntermediateDirectories:YES attributes:nil error:&error];
    if (!isSuccess)
    {
        NSLog(@"创建文件夹失败：%@",[error localizedDescription]);
        return NO;
    }

    // 创建文件
    isSuccess = [fileManager createFileAtPath:filePath contents:nil attributes:nil];
    return isSuccess;
}

#pragma mark - 写入/读取

// 向文件写入数据
- (BOOL)writeToFile:(NSString *)filePath contents:(NSData *)data
{
    if (filePath.length == 0)
    {
        return NO;
    }
    
    // 文件路径不存在则创建
    BOOL result = [self creatFile:filePath];
    if (result)
    {
        result = [data writeToFile:filePath atomically:YES];
        // 写入数据
        if (result)
        {
            NSLog(@"写入成功");
        }
        else
        {
            NSLog(@"写入失败");
        }
    }
    else
    {
        NSLog(@"写入失败");
    }
    return result;
}

// 读取文件中的数据
- (void)readFileWithPath:(NSString *)path
{
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSString *receiveString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSData *datas = [receiveString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:datas options:NSJSONReadingMutableLeaves error:nil];
    
    NSLog(@"文件读取成功，内容为: %@",jsonDict);
}



#pragma mark - 浏览

// 获取文件夹下所有的文件列表
- (NSArray *)getFileListWithPath:(NSString *)path
{
    if (path.length == 0)
    {
        return nil;
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *fileList = [fileManager contentsOfDirectoryAtPath:path error:&error];
    if (error)
    {
        NSLog(@"获取文件列表失败：%@",[error localizedDescription]);
    }
    return fileList;
}

// 获取文件夹下所有的文件列表
- (NSArray *)getAllFileListWithPath:(NSString *)path
{
    if (path.length==0)
    {
        return nil;
    }
    
    NSArray *fileArray = [self getFileListWithPath:path];
    NSMutableArray *newFileArray = [NSMutableArray array];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    for (NSString *filePath in fileArray)
    {
        NSString * fullPath = [path stringByAppendingPathComponent:filePath];
        BOOL isDirectory = NO;
        if ([fileManager fileExistsAtPath:fullPath isDirectory:&isDirectory])
        {
            if (isDirectory)
            {
                // 如果是目录进行递归
                [newFileArray addObjectsFromArray:[self getAllFileListWithPath:fullPath]];
            }
            else
            {
                [newFileArray addObject:fullPath];
            }
        }
    }
    return newFileArray;
}

// 遍历
- (void)enumeratorAtURL
{
    NSURL *directoryURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] firstObject];
    
    NSLog(@"目录为：%@",directoryURL);
    
    // 遍历下级的所有文件和文件夹
    NSDirectoryEnumerator *enumerator = [[NSFileManager defaultManager] enumeratorAtURL:directoryURL includingPropertiesForKeys:@[NSURLIsPackageKey] options:NSDirectoryEnumerationSkipsHiddenFiles errorHandler:^(NSURL *url, NSError *error) {// 处理错误
        
        // 如果错误后应继续，则返回YES
        return YES;
    }];
    
    // 每一个Item的url
    for (NSURL *url in enumerator)
    {
        // Item的名称
        NSString *localizedName = nil;
        [url getResourceValue:&localizedName forKey:NSURLLocalizedNameKey error:NULL];
        NSLog(@"Item的名称：%@", localizedName);
        
        // Item是否是目录
        NSNumber *isDirectory = nil;
        [url getResourceValue:&isDirectory forKey:NSURLIsDirectoryKey error:NULL];
        
        if ([isDirectory boolValue])
        {
            // Item是否是一个包
            NSNumber *isPackage = nil;
            [url getResourceValue:&isPackage forKey:NSURLIsPackageKey error:NULL];
            
            if ([isPackage boolValue])
            {
                NSLog(@"这个包在：%@", localizedName);
            }
            else
            {
                NSLog(@"这个目录在：%@", localizedName);
            }
        }
    }
}

// 目录内容
- (void)contentsOfDirectoryAtURL
{
    NSURL *directoryURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] firstObject];
    NSError *error = nil;
    NSArray *properties = [NSArray arrayWithObjects: NSURLLocalizedNameKey,nil];// 本地化文件名
    
    // 获取目录下的所有文件和文件夹
    NSArray *array = [[NSFileManager defaultManager] contentsOfDirectoryAtURL:directoryURL includingPropertiesForKeys:properties options:(NSDirectoryEnumerationSkipsHiddenFiles) error:&error];
    if (array == nil)
    {
        NSLog(@"处理错误");
    }
    
    // 获取该文件夹或者文件的创建日期
    NSDate *date = nil;
    [array[0] getResourceValue:&date forKey:NSURLCreationDateKey error:nil];// 创建日期
    if (date)
    {
        NSLog(@"该文件夹或者文件的创建日期为：%@",date);
    }
}

#pragma mark - 移动文件

// 移动文件
- (void)copyItem
{
    NSURL *directoryURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] firstObject];
    NSURL *backupDirectory = [directoryURL URLByAppendingPathComponent:@"backupDirectory"];// 最终存储目录
    NSURL *appDataDirectory = [directoryURL URLByAppendingPathComponent:@"tmp.data"];// 临时目录
    
    // 异步拷贝
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 为移动/复制操作alloc/init文件管理器是一个好习惯，以防您以后决定添加一个委托
        NSFileManager *fileManager = [[NSFileManager alloc] init];
        fileManager.delegate = self;
        
        NSError *error;
        // 尝试移动文件
        if (![fileManager copyItemAtURL:appDataDirectory toURL:backupDirectory error:&error])// 如果发生错误，可能是因为以前的备份目录已经存在
        {
            // 删除旧目录并重试
            if ([fileManager removeItemAtURL:backupDirectory error:&error])
            {
                // 如果操作再次失败，则实际中止
                if (![fileManager copyItemAtURL:appDataDirectory toURL:backupDirectory error:&error])
                {
                    // 报告错误
                    NSLog(@"移动文件失败");
                }
                else
                {
                    NSLog(@"移动文件成功");
                }
            }
        }
        else
        {
            NSLog(@"移动文件成功");
        }
    });
}

// 移动文件
- (BOOL)moveFileFromPath:(NSString *)fromPath toPath:(NSString *)toPath toPathIsDirectory:(BOOL)isDirectory
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    // 判断原始路径
    if (![fileManager fileExistsAtPath:fromPath])
    {
        NSLog(@"错误: 原始路径不存在");
        return NO;
    }
    
    // 判断目标路径是否存在
    BOOL toPathIsDirectory = NO;
    BOOL isExist = [fileManager fileExistsAtPath:toPath isDirectory:&toPathIsDirectory];
    if (isExist)// 存在
    {
        if (toPathIsDirectory)
        {
            // 创建目标目录，已经存在则会直接跳过
            if ([self creatDirectoryWithPath:toPath])
            {
                // 在目录下添加文件
                NSString *fileName = fromPath.lastPathComponent;
                toPath = [toPath stringByAppendingPathComponent:fileName];
                // 移动文件
                return [self moveItemAtPath:fromPath toPath:toPath];
            }
        }
        else
        {
            // 移除目标路径的重复文件
            [self removeFileWithPath:toPath];
            // 移动文件
            return [self moveItemAtPath:fromPath toPath:toPath];
        }
    }
    else// 不存在
    {
        if (isDirectory)
        {
            // 创建目标目录，已经存在则会直接跳过
            if ([self creatDirectoryWithPath:toPath])
            {
                // 在目录下添加文件
                NSString *fileName = fromPath.lastPathComponent;
                toPath = [toPath stringByAppendingPathComponent:fileName];
                // 移动文件
                return [self moveItemAtPath:fromPath toPath:toPath];
            }
        }
        else
        {
            // 移动文件
            return [self moveItemAtPath:fromPath toPath:toPath];
        }
    }
    return NO;
}

// 移动文件
- (BOOL)moveItemAtPath:(NSString *)fromPath toPath:(NSString *)toPath
{
    BOOL result = NO;
    NSError * error = nil;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    result = [fileManager moveItemAtPath:fromPath toPath:toPath error:&error];
    
    if (error)
    {
        NSLog(@"移动文件失败：%@",[error localizedDescription]);
    }
    return result;
}

#pragma mark - 删除文件

// 移除文件
- (BOOL)removeFileWithPath:(NSString *)filePath
{
    BOOL isSuccess = NO;
    NSError *error;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    // 移除文件
    isSuccess = [fileManager removeItemAtPath:filePath error:&error];
    
    if (error)
    {
        NSLog(@"移除文件失败：%@",[error localizedDescription]);
    }
    else
    {
        NSLog(@"移除文件成功");
    }
    return isSuccess;
}

// 根据后缀名移除一堆文件
- (void)removeFileSuffixList:(NSArray<NSString *> *)suffixList filePath:(NSString *)path deep:(BOOL)deep
{
    // 找到路径下的所有文件
    NSArray *fileArray = nil;
    if (deep)// 是否深度遍历
    {
        fileArray = [self getAllFileListWithPath:path];
    }
    else
    {
        fileArray = [self getFileListWithPath:path];
        
        NSMutableArray *fileArrayTmp = [NSMutableArray array];
        for (NSString *fileName in fileArray)
        {
            NSString* fullPath = [path stringByAppendingPathComponent:fileName];
            [fileArrayTmp addObject:fullPath];
        }
        
        fileArray = fileArrayTmp;
    }
    
    // 根据后缀名移除文件
    for (NSString *filePath in fileArray)
    {
        for (NSString *suffix in suffixList)
        {
            if ([filePath hasSuffix:suffix])
            {
                [self removeFileWithPath:filePath];
            }
        }
    }
}

#pragma mark - 文件信息

// 获取文件大小
- (long long)getFileSizeWithPath:(NSString*)path
{
    unsigned long long fileLength = 0;
    NSNumber *fileSize;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSDictionary *fileAttributes = [fileManager attributesOfItemAtPath:path error:nil];
    if ((fileSize = [fileAttributes objectForKey:NSFileSize]))
    {
        fileLength = [fileSize unsignedLongLongValue]; //单位是 B
    }
    return fileLength;
}

// 获取文件信息
- (NSDictionary*)getFileInfoWithPath:(NSString*)path
{
    NSError *error;
    NSDictionary *reslut =  [[NSFileManager defaultManager] attributesOfItemAtPath:path error:&error];
    if (error)
    {
        NSLog(@"：%@",[error localizedDescription]);
    }
    return reslut;
}

#pragma mark - File Handle

// 追加写入数据
- (BOOL)appendData:(NSData *)data withPath:(NSString *)filePath
{
    if (filePath.length == 0)
    {
        return NO;
    }
    
    // 文件路径不存在则创建
    BOOL result = [self creatFile:filePath];
    if (result)
    {
        NSFileHandle *handle = [NSFileHandle fileHandleForWritingAtPath:filePath];
        [handle seekToEndOfFile];// 追加到文件内容末尾
        [handle writeData:data];// 写入数据
        [handle synchronizeFile];// 同步
        [handle closeFile];// 关闭文件
    }
    else
    {
        NSLog(@"追加数据失败");
    }
    return result;
}

// 读取文件中的数据
- (void)useFileHandlerReadFileWithPath:(NSString *)path
{
    NSFileHandle *handle = [NSFileHandle fileHandleForReadingAtPath:path];
    NSData *fileData = [handle readDataToEndOfFile];
    [handle closeFile];
    
    NSString *receiveString = [[NSString alloc] initWithData:fileData encoding:NSUTF8StringEncoding];
    NSData *datas = [receiveString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:datas options:NSJSONReadingMutableLeaves error:nil];
    
    NSLog(@"文件读取成功，内容为: %@",jsonDict);
}

@end


