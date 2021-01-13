//
//  WallView.m
//  UseUIControlFramework
//
//  Created by 谢佳培 on 2020/11/13.
//

#import "WallView.h"

#pragma mark - Model

@implementation WallItemModel

+ (instancetype)modelWithImage:(UIImage *)image text:(NSString *)text
{
    WallItemModel *model = [[WallItemModel alloc] init];
    model.image = image;
    model.text = text;
    return model;
}

@end

#pragma mark - CollectionCell

@implementation WallViewCollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        _imageView = [UIButton buttonWithType:UIButtonTypeCustom];
        _imageView.userInteractionEnabled = YES;
        _imageView.clipsToBounds = NO;
        _imageView.layer.masksToBounds = YES;
        [self addSubview:_imageView];
        
        _textLabel = [[UILabel alloc] init];
        _textLabel.userInteractionEnabled = NO;
        _textLabel.textColor = [UIColor darkGrayColor];
        _textLabel.font = [UIFont systemFontOfSize:12];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.numberOfLines = 0;
        [self addSubview:_textLabel];
    }
    return self;
}

- (void)setModel:(WallItemModel *)model withLayout:(WallViewLayout *)layout appearance:(WallViewAppearance *)appearance
{
    [_imageView setImage:model.image forState:UIControlStateNormal];
    _textLabel.text = model.text;
    
    // appearance
    self.backgroundColor = appearance.itemBackgroundColor;
    _imageView.layer.cornerRadius = appearance.imageViewCornerRadius;
    _imageView.imageView.contentMode = appearance.imageViewContentMode;
    [_imageView setBackgroundImage:[UIImage imageWithColor:appearance.imageViewBackgroundColor] forState:UIControlStateNormal];
    [_imageView setBackgroundImage:[UIImage imageWithColor:appearance.imageViewHighlightedColor] forState:UIControlStateHighlighted];
    _textLabel.backgroundColor = appearance.textLabelBackgroundColor;
    _textLabel.textColor = appearance.textLabelTextColor;
    _textLabel.font = appearance.textLabelFont;
    
    // layout
    _imageView.size = CGSizeMake(layout.imageViewSideLength, layout.imageViewSideLength);
    _imageView.centerX = layout.itemSize.width / 2;
    if (_textLabel.text.length > 0)
    {
        CGFloat h = layout.itemSize.height - layout.imageViewSideLength - layout.itemSubviewsSpacing;
        CGSize size = [_textLabel sizeThatFits:CGSizeMake(layout.itemSize.width, MAXFLOAT)];
        if (size.height > h) size.height = h;
        _textLabel.size = CGSizeMake(layout.itemSize.width, size.height);
        _textLabel.y = _imageView.bottom + layout.itemSubviewsSpacing;
        _textLabel.centerX = layout.itemSize.width / 2;
    }
}

@end

#pragma mark - CollectionView

@implementation WallCollectionView

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
                       layout:(WallViewLayout *)layout
                   appearance:(WallViewAppearance *)appearance
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        _wallLayout = layout;
        _wallAppearance = appearance;
        
        self.backgroundColor = appearance.sectionBackgroundColor;
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.minimumLineSpacing = layout.itemPadding;
        flowLayout.itemSize = layout.itemSize;
        flowLayout.sectionInset = layout.itemEdgeInset;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.alwaysBounceHorizontal = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.bounces = YES;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [self addSubview:_collectionView];
        
        [_collectionView registerClass:[WallViewCollectionCell class]
            forCellWithReuseIdentifier:@"cell"];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _collectionView.frame = self.bounds;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _models.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WallViewCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    if (indexPath.row < _models.count)
    {
        id object = [_models objectAtIndex:indexPath.row];
        [cell setModel:object withLayout:_wallLayout appearance:_wallAppearance];
    }
    cell.imageView.tag = indexPath.row;
    [cell.imageView addTarget:self action:@selector(itemClicked:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)itemClicked:(UIButton *)sender
{
    WallView *wallView = self.wallView;
    if ([wallView.delegate respondsToSelector:@selector(wallView:didSelectItemAtIndexPath:)])
    {
        NSIndexPath *_indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:self.rowIndex];
        [wallView.delegate wallView:wallView didSelectItemAtIndexPath:_indexPath];
    }
}

- (void)setModels:(NSArray<WallItemModel *> *)models
{
    _models = models;
    [_collectionView reloadData];
}

@end

#pragma mark - WallView

@interface WallView () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIVisualEffectView *blurView;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation WallView

#pragma mark - Life Circle

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
        _blurView = [[UIVisualEffectView alloc] initWithEffect:effect];
        [self addSubview:_blurView];
        
        _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.bounces = NO;
        _tableView.delaysContentTouches = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = [UIColor clearColor];
        // 不调整滚动视图
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        [self addSubview:_tableView];
        
        _wallHeaderLabel = [self labelWithTextColor:[UIColor darkGrayColor] font:[UIFont systemFontOfSize:12] action:@selector(headerClicked)];
        _tableView.tableHeaderView = _wallHeaderLabel;
        
        _wallFooterLabel = [self labelWithTextColor:[UIColor blackColor] font:[UIFont systemFontOfSize:17] action:@selector(footerClicked)];
        _wallFooterLabel.backgroundColor = [UIColor whiteColor];
        _tableView.tableFooterView = _wallFooterLabel;
    }
    return self;
}

- (UILabel *)labelWithTextColor:(UIColor *)textColor font:(UIFont *)font action:(SEL)action
{
    UILabel *label = [[UILabel alloc] init];
    label.textAlignment = NSTextAlignmentCenter;
    label.userInteractionEnabled = YES;
    label.text = @"zhWallView";
    label.textColor = textColor;
    label.font = font;
    [label addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:action]];
    return label;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _blurView.frame = self.bounds;
    _tableView.frame = self.bounds;
}

#pragma mark - UITableViewDataSource / UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.layout.itemEdgeInset.top + self.layout.itemEdgeInset.bottom + self.layout.itemSize.height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WallCollectionView *cell = [tableView dequeueReusableCellWithIdentifier:@"WallCollectionView"];
    if (!cell)
    {
        cell = [[WallCollectionView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"WallCollectionView" layout:[self layout] appearance:[self appearance]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.wallView = self;
    cell.rowIndex = indexPath.row;
    id object = [_models objectAtIndex:indexPath.row];
    if ([object isKindOfClass:[NSArray class]])
    {
        cell.models = (NSArray *)object;
    }
    return cell;
}

#pragma mark - Gesture block

- (void)headerClicked
{
    if (self.didClickHeader) self.didClickHeader(self);
}

- (void)footerClicked
{
    if (nil != self.didClickFooter) self.didClickFooter(self);
}

#pragma mark - WallViewDelegateConfig

- (WallViewLayout *)layout
{
    id <WallViewDelegateConfig> config = (id <WallViewDelegateConfig>)self.delegate;
    
    if ([config respondsToSelector:@selector(layoutOfItemInWallView:)])
    {
        return [config layoutOfItemInWallView:self];
    }
    return [[WallViewLayout alloc] init];
}

- (WallViewAppearance *)appearance
{
    id <WallViewDelegateConfig> config = (id <WallViewDelegateConfig> )self.delegate;
    
    if ([config respondsToSelector:@selector(appearanceOfItemInWallView:)])
    {
        return [config appearanceOfItemInWallView:self];
    }
    return [[WallViewAppearance alloc] init];
}

#pragma mark - Setter

- (void)setModels:(NSArray<NSArray<WallItemModel *> *> *)models
{
    _models = models;
    
    [self reloadTableViewHeaderAndFooterHeight];
    [_tableView reloadData];
}

- (void)reloadTableViewHeaderAndFooterHeight
{
    _tableView.tableHeaderView.size = CGSizeMake(self.width, self.layout.wallHeaderHeight);
    _tableView.tableFooterView.size = CGSizeMake(self.width, self.layout.wallFooterHeight + 34);
}

- (CGSize)sizeThatFits:(CGSize)size
{
    CGFloat sectionHeight = self.layout.itemEdgeInset.top + self.layout.itemEdgeInset.bottom + self.layout.itemSize.height;
    CGFloat totalHeight = sectionHeight * _models.count;
    totalHeight +=_tableView.tableHeaderView.size.height;
    totalHeight += _tableView.tableFooterView.size.height;
    return CGSizeMake(size.width, totalHeight);
}
 
@end

