//
//  CollectionViewController.m
//  UIKitGrammarDemo
//
//  Created by 谢佳培 on 2020/10/30.
//

#import "CollectionViewController.h"
#import "TableViewController.h"
#import <Masonry/Masonry.h>

@interface PersonCollectionViewCell ()

@property (nonatomic, strong, readwrite) UILabel *nameLabel;
@property (nonatomic, strong, readwrite) UILabel *namePinyinLabel;
@property (nonatomic, strong, readwrite) UILabel *mobileLabel;
@property (nonatomic, strong, readwrite) UILabel *introductionLabel;

@end

@implementation PersonCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
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
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.nameLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:self.nameLabel];
    
    self.namePinyinLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.namePinyinLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.namePinyinLabel];
    
    self.mobileLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:self.mobileLabel];
    
    self.introductionLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.introductionLabel.numberOfLines = 0;// 可多行显示
    self.introductionLabel.font = [UIFont systemFontOfSize:15.0];
    [self.contentView addSubview:self.introductionLabel];
    
    // 给Cell添加红色边框
    self.contentView.layer.borderColor = [UIColor redColor].CGColor;
    self.contentView.layer.borderWidth = 1.0;
}

// 添加约束
- (void)createSubViewsConstraints
{
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.height.equalTo(@30);
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
    }];
    
    [self.namePinyinLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(10);
        make.height.equalTo(@30);
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
    }];
    
    [self.mobileLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.namePinyinLabel.mas_bottom).offset(10);
        make.height.equalTo(@30);
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
    }];
    
    [self.introductionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mobileLabel.mas_bottom).offset(10);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
    }];
}

@end

NSString * const CollectionCellReuseIdentifier = @"cell";

@interface CollectionViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

// UICollectionView
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *personArray;// 数据源

@end

@implementation CollectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self createCollectionView];
    [self readPersonData];
}
 
// 添加子视图
- (void)createCollectionView
{
    // 创建集合视图的布局
    CGSize viewSize = self.view.bounds.size;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(viewSize.width/2 - 10, viewSize.height);
    layout.minimumLineSpacing = 10;// Item之间的上下间距
    layout.minimumInteritemSpacing = 10;// Item之间的左右间距
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;// 滚动方向
    
    // 创建集合视图
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor whiteColor];// 默认没有颜色，会渲染成黑色
    [self.collectionView registerClass:[PersonCollectionViewCell class] forCellWithReuseIdentifier:CollectionCellReuseIdentifier];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
    }];
}

// 数据源
- (void)readPersonData
{
    NSURL *fileURL = [[NSBundle mainBundle] URLForResource:@"person" withExtension:@"json"];
    NSData *fileData = [NSData dataWithContentsOfURL:fileURL options:NSDataReadingMappedIfSafe error:nil];
    NSArray<NSDictionary *> *persons = [NSJSONSerialization JSONObjectWithData:fileData options:NSJSONReadingMutableContainers error:nil];
    
    // json to model
    NSMutableArray<PersonModel *> *personArray = [NSMutableArray array];
    [persons enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        PersonModel *personModel = [[PersonModel alloc] init];
        personModel.name = obj[@"name"];
        personModel.namePinyin = obj[@"pinyin"];
        personModel.nameFirstLetter = obj[@"first_letter"];
        personModel.mobile = obj[@"mobile"];
        personModel.introduction = obj[@"introduction"];
        
        [personArray addObject:personModel];
    }];
    
    // 按照字母顺序进行排序
    [personArray sortUsingComparator:^NSComparisonResult(PersonModel *obj1, PersonModel *obj2) {
        return [obj1.namePinyin compare:obj2.namePinyin];
    }];
    
    // 重新加载页面
    self.personArray = personArray;
    [self.collectionView reloadData];
}

// Item数目
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.personArray.count;
}

// Item内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PersonCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CollectionCellReuseIdentifier forIndexPath:indexPath];
    
    PersonModel *personModel = self.personArray[indexPath.item];
    cell.nameLabel.text = personModel.name;
    cell.namePinyinLabel.text = personModel.namePinyin;
    cell.mobileLabel.text = personModel.mobile;
    cell.introductionLabel.text = personModel.introduction;
    
    return cell;
}

// 选中Item
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"选中了Item");
}

// Item尺寸大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 页面宽度一半 - 10 作为Item宽度
    CGSize viewSize = self.view.bounds.size;
    CGFloat width = viewSize.width/2 - 10;
    
    // 根据字号、宽度、内容来估计introduction的高度
    PersonModel *personModel = self.personArray[indexPath.row];
    CGSize size = [personModel.introduction boundingRectWithSize:CGSizeMake(width - 24, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15.0]} context:nil].size;
    
    // 返回Item尺寸大小
    return CGSizeMake(width, size.height + 160);
}

@end
