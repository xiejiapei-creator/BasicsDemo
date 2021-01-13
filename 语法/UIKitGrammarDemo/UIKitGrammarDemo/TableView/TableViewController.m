//
//  TableViewController.m
//  UIKitGrammarDemo
//
//  Created by 谢佳培 on 2020/10/30.
//

#import "TableViewController.h"
#import <Masonry/Masonry.h>

@implementation PersonModel

@end

@interface PersonTableViewCell ()

@property (nonatomic, strong, readwrite) UILabel *nameLabel;
@property (nonatomic, strong, readwrite) UILabel *namePinyinLabel;
@property (nonatomic, strong, readwrite) UILabel *mobileLabel;
@property (nonatomic, strong, readwrite) UILabel *introductionLabel;

@end

@implementation PersonTableViewCell

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
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.nameLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:self.nameLabel];
    
    self.namePinyinLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.namePinyinLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.namePinyinLabel];
    
    self.mobileLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:self.mobileLabel];
    
    self.introductionLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.introductionLabel.numberOfLines = 0;
    [self.contentView addSubview:self.introductionLabel];
}

// 添加约束
- (void)createSubViewsConstraints {
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.height.equalTo(@30);
        make.left.equalTo(self.contentView.mas_left).offset(20);
        make.right.equalTo(self.contentView.mas_right).offset(-20);
    }];
    
    [self.namePinyinLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_top);
        make.bottom.equalTo(self.nameLabel.mas_bottom);
        make.left.equalTo(self.contentView.mas_left).offset(20);
        make.right.equalTo(self.contentView.mas_right).offset(-20);
    }];
    
    [self.mobileLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(10);
        make.height.equalTo(@30);
        make.left.equalTo(self.contentView.mas_left).offset(20);
        make.right.equalTo(self.contentView.mas_right).offset(-20);
    }];
    
    [self.introductionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mobileLabel.mas_bottom).offset(10);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
        make.left.equalTo(self.contentView.mas_left).offset(20);
        make.right.equalTo(self.contentView.mas_right).offset(-20);
    }];
}

@end

NSString * const TableCellReuseIdentifier = @"cell";

@interface TableViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<NSMutableArray<PersonModel *> *> * personTableArray;// 数据源[section[row]]
@property (nonatomic, strong) NSMutableArray<NSString *> *sectionIndexTitles;// 索引
@property (nonatomic, assign, getter=isEditFinished) BOOL editFinished;// 是否编辑完成

@end

@implementation TableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configureNavigationbar];
    [self createTableView];
    [self readTablePersonData];
}

// 编辑 TableView
- (void)configureNavigationbar
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editTable)];
    
    self.editFinished = YES;
}

- (void)editTable
{
    if (self.isEditFinished)
    {
        self.editFinished = NO;
        self.navigationItem.rightBarButtonItem.title = @"完成";
        self.tableView.editing = YES;// 正在编辑
    }
    else
    {
        self.editFinished = YES;
        self.navigationItem.rightBarButtonItem.title = @"编辑";
        self.tableView.editing = NO;// 非编辑状态
    }
}

// 创建 TableView
- (void)createTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.tableView registerClass:[PersonTableViewCell class] forCellReuseIdentifier:TableCellReuseIdentifier];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    // 不显示右侧滑块
    self.tableView.showsVerticalScrollIndicator = NO;
    // 分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    // 表头表尾高度
    self.tableView.sectionHeaderHeight = 20;
    self.tableView.sectionFooterHeight = 20;
    // 弹动
    self.tableView.bounces = NO;
    
    // 多选模式
//    self.tableView.allowsSelection = YES;
//    self.tableView.allowsSelectionDuringEditing = YES;
//    self.tableView.allowsMultipleSelection = YES;
//    self.tableView.allowsMultipleSelectionDuringEditing = YES;
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
    }];
}

// UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView// section 数量
{
    return self.personTableArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section// cell 数量
{
    return self.personTableArray[section].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath// cell 样式
{
    PersonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TableCellReuseIdentifier forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;// 选中风格
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;// 右指示器
    //cell.accessoryView = imageBtn;// cell可以设置装饰图
    
    // cell自带imageView属性、text属性、detailTextLabel属性
    cell.detailTextLabel.text = @"更多";
    
    PersonModel *personModel = self.personTableArray[indexPath.section][indexPath.row];
    cell.nameLabel.text = personModel.name;
    cell.namePinyinLabel.text = personModel.namePinyin;
    cell.mobileLabel.text = personModel.mobile;
    cell.introductionLabel.text = personModel.introduction;
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section// SectionHeader 标题
{
    return self.sectionIndexTitles[section];// 索引数组
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath// 能否编辑 cell
{
    return (indexPath.section > 0);// 除第一节外都可编辑
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath// 能否移动 cell
{
    return (indexPath.section == 1);// 第二节可以移动cell
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView// TableView的右边索引列的标题
{
    return self.sectionIndexTitles;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index// TableView的右边索引列的位置，好像没什么用
{
    return index;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath// 支持插入和删除 cell
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        // 从数据源里移除当前cell的数据
        NSMutableArray *personArray = self.personTableArray[indexPath.section];
        [personArray removeObjectAtIndex:indexPath.row];

        // 移除完后当前Section不再拥有cell了
        if (personArray.count == 0)
        {
            // 移除当前Section的数据和索引标题
            [self.personTableArray removeObjectAtIndex:indexPath.section];
            [self.sectionIndexTitles removeObjectAtIndex:indexPath.section];
        }

        // 从视图中移除当前cell
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath// 支持移动 cell
{
    // 从数据源中移除初始cell的数据
    NSMutableArray *sourcePersonArray = self.personTableArray[sourceIndexPath.section];
    PersonModel *sourcePersonModel = sourcePersonArray[sourceIndexPath.row];
    [sourcePersonArray removeObjectAtIndex:sourceIndexPath.row];
    self.personTableArray[sourceIndexPath.section] = sourcePersonArray;

    // 从数据源中向目的cell添加数据
    NSMutableArray *destinationPersonArray = self.personTableArray[destinationIndexPath.section];
    [destinationPersonArray insertObject:sourcePersonModel atIndex:destinationIndexPath.row];
    self.personTableArray[destinationIndexPath.section] = destinationPersonArray;
}

// UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath// 选中 cell
{
    NSLog(@"didSelectRowAtIndexPath %@", indexPath);
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath// 编辑风格
{
    return UITableViewCellEditingStyleDelete;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath// 删除确认按钮的标题
{
    return @"删除";
}

// 数据源
- (void)readTablePersonData
{
    NSURL *fileURL = [[NSBundle mainBundle] URLForResource:@"person" withExtension:@"json"];
    NSData *fileData = [NSData dataWithContentsOfURL:fileURL options:NSDataReadingMappedIfSafe error:nil];
    NSArray<NSDictionary *> *persons = [NSJSONSerialization JSONObjectWithData:fileData options:NSJSONReadingMutableContainers error:nil];
    
    // json to model
    NSMutableArray<PersonModel *> *personModelArray = [NSMutableArray array];
    [persons enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        PersonModel *personModel = [[PersonModel alloc] init];
        personModel.name = obj[@"name"];
        personModel.namePinyin = obj[@"pinyin"];
        personModel.nameFirstLetter = obj[@"first_letter"];
        personModel.mobile = obj[@"mobile"];
        personModel.introduction = obj[@"introduction"];
        
        [personModelArray addObject:personModel];
    }];
    
    // 按照字母顺序进行排序
    [personModelArray sortUsingComparator:^NSComparisonResult(PersonModel *obj1, PersonModel *obj2) {
        return [obj1.namePinyin compare:obj2.namePinyin];
    }];
    
    // 按拼音首字母拆分，顺序遍历
    NSMutableArray<NSMutableArray<PersonModel *> *> *personDataArray = [NSMutableArray array];
    NSMutableArray<NSString *> *sectionIndexArray = [NSMutableArray array];
    NSMutableArray<PersonModel *> *personArray = [NSMutableArray array];
    
    NSInteger count = personModelArray.count;
    for (int i=0; i<count; i++)
    {
        PersonModel *personModel = personModelArray[i];
        if (![sectionIndexArray containsObject:personModel.nameFirstLetter])// 不包含的首字母则需要新的array容纳
        {
            // 将该首字母添加到索引数组
            [sectionIndexArray addObject:personModel.nameFirstLetter];
            if (personArray.count > 0)// array代表的上一个section存在model
            {
                // personDataArray代表[Section[row]]
                [personDataArray addObject:[personArray mutableCopy]];
                // 清空旧的model，成为新array
                [personArray removeAllObjects];
            }
        }
        // 首字母已经被包含，说明是该model处于同一个section，则添加到array即可
        [personArray addObject:personModel];
    }
    // 添加最后一个personArray
    [personDataArray addObject:[personArray copy]];
    
    // 重新加载table
    self.personTableArray = personDataArray;
    self.sectionIndexTitles = sectionIndexArray;
    [self.tableView reloadData];
}


@end
