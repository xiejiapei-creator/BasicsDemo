//
//  TopicViewController.m
//  NetworkRequestDemo
//
//  Created by 谢佳培 on 2020/10/21.
//  Copyright © 2020 xiejiapei. All rights reserved.
//

#import "TopicViewController.h"
#import <Masonry/Masonry.h>

const CGFloat TopicCellDetailFontSize = 14.0;

@implementation TopicCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self createSubViews];
        [self createSubViewsConstraints];
    }
    return self;
}

// 添加子视图
- (void)createSubViews
{
    self.memberAvatarImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:self.memberAvatarImageView];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.titleLabel.numberOfLines = 0;
    [self.contentView addSubview:self.titleLabel];
    
    self.nodeNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:self.nodeNameLabel];
    
    self.memberNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.memberNameLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.memberNameLabel];
    
    self.replyCountLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.replyCountLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.replyCountLabel];
}

// 添加约束
- (void)createSubViewsConstraints
{
    [self.memberAvatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.height.equalTo(@50);
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.width.equalTo(@50);
    }];
    
    [self.replyCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.height.equalTo(@30);
        make.left.equalTo(self.contentView.mas_left).offset(70);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
    }];
    
    [self.nodeNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-5);
        make.height.equalTo(@30);
        make.left.equalTo(self.contentView.mas_left).offset(70);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
    }];
    
    [self.memberNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-5);
        make.height.equalTo(@30);
        make.left.equalTo(self.contentView.mas_left).offset(70);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-40);
        make.left.equalTo(self.contentView.mas_left).offset(70);
        make.right.equalTo(self.contentView.mas_right).offset(-40);
    }];
}

@end

@implementation NodeModel

@end

@implementation MemberModel

@end

@implementation TopicModel

@end

NSString * const TopicCellReuseIdentifier = @"cell";

@interface TopicViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSURLSession *URLSession;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray<TopicModel *> *topicArray;
@property (nonatomic, strong) NSMutableDictionary *imageCacheDict;

@end

@implementation TopicViewController

#pragma mark - Life Circle

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.topicURLString = @"https://www.v2ex.com/api/topics/latest.json";
        self.URLSession = [NSURLSession sharedSession];
        self.imageCacheDict = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureNavigationbar];
    [self createSubViews];
    [self createSubViewsConstraints];
    [self fetchData];
}

// 配置导航栏
- (void)configureNavigationbar
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Get" style:UIBarButtonItemStylePlain target:self action:@selector(httpGet)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Post" style:UIBarButtonItemStylePlain target:self action:@selector(httpPost)];
}

// 添加子视图
- (void)createSubViews
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.tableView registerClass:[TopicCell class] forCellReuseIdentifier:TopicCellReuseIdentifier];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

// 添加约束
- (void)createSubViewsConstraints {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
    }];
}

#pragma mark - NSURLSession

- (void)httpGet
{
    NSURL *getURL = [NSURL URLWithString:@"https://www.v2ex.com/api/topics/hot.json"];
    
    // 下载数据
    NSURLSessionDataTask *getTask = [self.URLSession dataTaskWithURL:getURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (!error)
        {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"Get方式获取到的数据为：%@", dict);
        }
        else
        {
            NSLog(@"Get方式获取数据出错了：%@", error);
        }
    }];
    [getTask resume];
}

- (void)httpPost
{
    NSDictionary *dict = @{@"home": @"post"};
    NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    NSURL *postURL = [NSURL URLWithString:@"https://www.v2ex.com/api/topics/hot.json"];
    
    NSMutableURLRequest *postRequest = [NSMutableURLRequest requestWithURL:postURL];
    postRequest.HTTPMethod = @"POST";
    postRequest.HTTPBody = data;
    [postRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    // 上传数据
    NSURLSessionDataTask *postTask = [self.URLSession uploadTaskWithRequest:postRequest fromData:data completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (!error)
        {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"Post方式上传获取到服务端返回到结果为：%@", dict);
        }
        else
        {
            NSLog(@"Post方式上传出错了：%@", error);
        }
    }];
    [postTask resume];
}

- (void)fetchData
{
    if (self.topicURLString.length < 1)
    {
        NSLog(@"用于获取数据的URL不能为空");
        return;
    }
    NSURL *topicURL = [NSURL URLWithString:self.topicURLString];
    
    NSURLSessionDataTask *topicTask = [self.URLSession dataTaskWithURL:topicURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (!error)
        {
            NSArray *topicList = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            [self parseTopics:topicList];
        }
        else
        {
            NSLog(@"获取数据出错了：%@", error);
        }
    }];
    [topicTask resume];
}

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.topicArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TopicCell *cell = [tableView dequeueReusableCellWithIdentifier:TopicCellReuseIdentifier forIndexPath:indexPath];
    
    TopicModel *topicModel = self.topicArray[indexPath.row];
    cell.titleLabel.text = topicModel.title;
    cell.nodeNameLabel.text = topicModel.node.name;
    cell.memberNameLabel.text = topicModel.member.username;
    cell.replyCountLabel.text = @(topicModel.replies).stringValue;
    
    NSString *imageURL = topicModel.member.avatar_normal;
    NSURL *cachedImageURL = self.imageCacheDict[imageURL];
    if (cachedImageURL)// 图片有被缓存过
    {
        
        cell.memberAvatarImageView.image = [self imageForURL:cachedImageURL];
    }
    else// 未缓存则下载
    {
        [self downloadImage:imageURL forCell:cell];
    }
    
    return cell;
}

#pragma mark - 图片缓存

// 根据URL获取图片
- (UIImage *)imageForURL:(NSURL *)imageURL
{
    NSData *data = [NSData dataWithContentsOfURL:imageURL];
    UIImage *image = [UIImage imageWithData:data];
    return image;
}

- (NSURL *)writeImageToCacheFromLocation:(NSURL *)location forDownloadURL:(NSURL *)downloadURL
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *applicationSupportURL = [[fileManager URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask] lastObject];
    
    // 图片目录路径
    NSString *imageDirPath = [applicationSupportURL.path stringByAppendingPathComponent:@"image"];
    if (![fileManager fileExistsAtPath:imageDirPath])
    {
        [fileManager createDirectoryAtPath:imageDirPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    // 图片路径
    NSString *fileName = [downloadURL.path lastPathComponent];
    NSString *imagePath = [imageDirPath stringByAppendingPathComponent:fileName];
    NSURL *imageURL = [NSURL fileURLWithPath:imagePath];
    
    // 移动图片
    [fileManager copyItemAtURL:location toURL:imageURL error:nil];
    return imageURL;
}

#pragma mark - 图片下载

- (void)downloadImage:(NSString *)imageURL forCell:(TopicCell *)cell
{
    NSURL *downloadURL = [NSURL URLWithString:imageURL];
    
    NSURLSessionDownloadTask *task = [self.URLSession downloadTaskWithURL:downloadURL completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        // 将图片写入缓存
        NSURL *cachedImageURL = [self writeImageToCacheFromLocation:location forDownloadURL:downloadURL];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imageCacheDict[imageURL] = cachedImageURL;
            cell.memberAvatarImageView.image = [self imageForURL:cachedImageURL];
        });
    }];
    [task resume];
}

#pragma mark - Convert Model

- (void)parseTopics:(NSArray<NSDictionary *> *)topics
{
    NSMutableArray *topicArray = [NSMutableArray array];
    
    [topics enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        TopicModel *topicModel = [[TopicModel alloc] init];
        topicModel.node = [self nodeModelOfTopic:obj];
        topicModel.member = [self memberModelOfTopic:obj];
        
        topicModel.last_reply_by = obj[@"last_reply_by"];
        topicModel.last_touched = [obj[@"last_touched"] integerValue];
        topicModel.title = obj[@"title"];
        topicModel.url = obj[@"url"];
        topicModel.created = [obj[@"created"] integerValue];
        topicModel.content = obj[@"content"];
        topicModel.content_rendered = obj[@"content_rendered"];
        topicModel.last_modified = [obj[@"last_modified"] integerValue];
        topicModel.replies = [obj[@"replies"] integerValue];
        topicModel.topicID = [obj[@"id"] integerValue];
        
        [topicArray addObject:topicModel];
    }];
    self.topicArray = topicArray;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

- (NodeModel *)nodeModelOfTopic:(NSDictionary *)topic
{
    NSDictionary *node = topic[@"node"];
    NodeModel *nodeModel = [[NodeModel alloc] init];
    
    nodeModel.avatar_large = node[@"avatar_large"];
    nodeModel.name = node[@"name"];
    nodeModel.avatar_normal = node[@"avatar_normal"];
    nodeModel.title = node[@"title"];
    nodeModel.url = node[@"url"];
    nodeModel.topics = [node[@"topics"] integerValue];
    nodeModel.footer = node[@"footer"];
    nodeModel.header = node[@"header"];
    nodeModel.title_alternative = node[@"title_alternative"];
    nodeModel.avatar_mini = node[@"avatar_mini"];
    nodeModel.stars = [node[@"stars"] integerValue];
    nodeModel.root = [node[@"root"] boolValue];
    nodeModel.nodeID = [node[@"id"] integerValue];
    nodeModel.parent_node_name = node[@"parent_node_name"];
    
    return nodeModel;
}

- (MemberModel *)memberModelOfTopic:(NSDictionary *)topic
{
    NSDictionary *member = topic[@"member"];
    MemberModel *memberModel = [[MemberModel alloc] init];
    
    memberModel.username = member[@"username"];
    memberModel.website = member[@"website"];
    memberModel.github = member[@"github"];
    memberModel.psn = member[@"psn"];
    memberModel.avatar_normal = member[@"avatar_normal"];
    memberModel.bio = member[@"bio"];
    memberModel.url = member[@"url"];
    memberModel.tagline = member[@"tagline"];
    memberModel.twitter = member[@"twitter"];
    memberModel.created = [member[@"created"] integerValue];
    memberModel.avatar_large = member[@"avatar_large"];
    memberModel.avatar_mini = member[@"avatar_mini"];
    memberModel.location = member[@"location"];
    memberModel.btc = member[@"btc"];
    memberModel.memberID = [member[@"id"] integerValue];
    
    return memberModel;
}


@end
