//
//  BookMarkViewController.m
//  LocalCacheDemo
//
//  Created by 谢佳培 on 2020/10/19.
//

#import "BookMarkViewController.h"

@interface BookMarkViewController ()

@end

@implementation BookMarkViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

// 创建BookMark
- (NSData *)bookmarkForURL:(NSURL *)url
{
    NSError *error = nil;
    
    // 创建创建一个 NSURL 对象对应的 bookmark
    NSData *bookmark = [url bookmarkDataWithOptions:NSURLBookmarkCreationSuitableForBookmarkFile includingResourceValuesForKeys:nil relativeToURL:nil error:&error];
    
    if (error || (bookmark == nil))
    {
        // 处理错误
        NSLog(@"发生了错误");
        return nil;
    }
    
    return bookmark;
}

// 保存BookMark
- (void)writeBookMark:(NSData *)bookmark
{
    NSError *error = nil;
    
    // 指定一个 alias file 的路径，将 NSData 类型的 bookmark 持久化保存在其中，可以将这个 alias file 理解为一个 symbolic link
    BOOL isSuccess = [NSURL writeBookmarkData:bookmark toURL:[NSURL URLWithString:@""] options:NSURLBookmarkCreationSuitableForBookmarkFile error:&error];
    
    if (isSuccess)
    {
        NSLog(@"bookmark 成功持久化保存在alias file");
    }
}

// BookMark转为URL
- (NSURL *)urlForBookmark:(NSData *)bookmark
{
    BOOL bookmarkIsStale = NO;
    NSError *error = nil;
    
    // 通过解析 bookmark 转换成一个 NSURL 对象
    NSURL* bookmarkURL = [NSURL URLByResolvingBookmarkData:bookmark options:NSURLBookmarkResolutionWithoutUI relativeToURL:nil bookmarkDataIsStale:&bookmarkIsStale error:&error];
    
    if (bookmarkIsStale || (error != nil))
    {
        NSLog(@"发生了错误");
        return nil;
    }
    
    return bookmarkURL;
}

@end
