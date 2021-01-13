//
//  ArchiveViewController.m
//  LocalCacheDemo
//
//  Created by 谢佳培 on 2020/10/16.
//

#import "ArchiveViewController.h"

@implementation ArchivePerson

// 归档
- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeInt:self.age forKey:@"age"];
    [encoder encodeFloat:self.height forKey:@"height"];
}

// 解档
- (id)initWithCoder:(NSCoder *)decoder
{
    self.name = [decoder decodeObjectForKey:@"name"];
    self.age = [decoder decodeIntForKey:@"age"];
    self.height = [decoder decodeFloatForKey:@"height"];
    
    return self;
}

// 跟requiringSecureCoding属性有关，这个需要返回YES，否则归档是失败的，返回的data为空
+ (BOOL)supportsSecureCoding
{
    return YES;
}

@end

@interface ArchiveViewController ()

@end

@implementation ArchiveViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self archiveArray];
    [self decodeArray];
}

#pragma mark - archive

// 归档数组
- (void)archiveArray
{
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) firstObject];
    NSString *archivePath = [documentPath stringByAppendingPathComponent:@"Array.archive"];
    
    NSLog(@"归档路径为：%@",archivePath);
    
    NSArray *arrayArchive = @[@"1997",@"2008",@"2020"];
    NSError *error;
    NSData *archiveData = [NSKeyedArchiver archivedDataWithRootObject:arrayArchive requiringSecureCoding:YES error:&error];
    [archiveData writeToFile:archivePath atomically:YES];
}

// 解档数组
- (void)decodeArray
{
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) firstObject];
    NSString *archivePath = [documentPath stringByAppendingPathComponent:@"Array.archive"];
    
    NSData *decodeData = [NSData dataWithContentsOfFile:archivePath];
    NSError *error;
    NSArray *arrayDecode = [NSKeyedUnarchiver unarchivedObjectOfClass:[NSArray class] fromData:decodeData error:&error];
    NSLog(@"解档后数据为：%@",arrayDecode);
}

// 归档对象
- (void)archivePerson
{
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) firstObject];
    NSString *archivePath = [documentPath stringByAppendingPathComponent:@"Person.archive"];
    
    NSLog(@"归档路径为：%@",archivePath);
    
    ArchivePerson *person = [[ArchivePerson alloc] init];
    person.name = @"谢佳培";
    person.age = 22;
    person.height = 1.71f;
    
    NSError *error;
    NSData *archiveData = [NSKeyedArchiver archivedDataWithRootObject:person requiringSecureCoding:YES error:&error];
    [archiveData writeToFile:archivePath atomically:YES];
}

// 解档对象
- (void)decodePerson
{
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) firstObject];
    NSString *archivePath = [documentPath stringByAppendingPathComponent:@"Person.archive"];
    
    NSData *personArchive = [NSData dataWithContentsOfFile:archivePath];
    NSError *error;
    ArchivePerson *personDecode = (ArchivePerson *)[NSKeyedUnarchiver unarchivedObjectOfClass:[ArchivePerson class] fromData:personArchive error:&error];
    NSLog(@"解档后人物名称为：%@",personDecode.name);
}

@end
