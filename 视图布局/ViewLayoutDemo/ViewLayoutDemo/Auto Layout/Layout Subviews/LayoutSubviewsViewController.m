//
//  LayoutSubviewsViewController.m
//  ViewLayoutDemo
//
//  Created by 谢佳培 on 2020/10/14.
//

#import "LayoutSubviewsViewController.h"
#import <Masonry.h>

@implementation LayoutHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.layer.borderWidth = 2.0;
        self.layer.borderColor = [UIColor redColor].CGColor;
    }
    return self;
}

@end

@implementation LayoutFooterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.layer.borderWidth = 2.0;
        self.layer.borderColor = [UIColor greenColor].CGColor;
    }
    return self;
}

@end

@implementation LayoutBodyView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.layer.borderWidth = 2.0;
        self.layer.borderColor = [UIColor blueColor].CGColor;
        
        self.textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.textLabel.font = [UIFont systemFontOfSize:20.0];
        self.textLabel.numberOfLines = 0;
        self.textLabel.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:self.textLabel];
        
        self.text = @"";
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 根据宽度和字号自动计算Label高度
    CGSize size = [self.text boundingRectWithSize:CGSizeMake(320, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:20.0]} context:nil].size;
    
    self.textLabel.frame = CGRectMake(0, 0, 320, size.height);
}

- (void)setText:(NSString *)text
{
    _text = text;
    self.textLabel.text = text;
    
    // 重新计算Label布局
    [self setNeedsLayout];
}

@end

@interface LayoutSubviewsViewController ()

@property (nonatomic, strong) LayoutHeaderView *headerView;
@property (nonatomic, strong) LayoutBodyView *bodyView;
@property (nonatomic, strong) LayoutFooterView *footerView;
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, assign) BOOL bodyTextChanged;// 文本是否改变

@end

@implementation LayoutSubviewsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"layout";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createSubViews];
}


- (void)createSubViews
{
    self.headerView = [[LayoutHeaderView alloc] initWithFrame:CGRectMake(0, 164, 320, 100)];
    [self.view addSubview:self.headerView];

    self.bodyView = [[LayoutBodyView alloc] initWithFrame:CGRectMake(0, 264, 320, 304)];
    [self.view addSubview:self.bodyView];

    self.footerView = [[LayoutFooterView alloc] initWithFrame:CGRectMake(0, 568, 320, 100)];
    [self.view addSubview:self.footerView];

    self.bodyView.text = @"嗨，你好呀";
    self.bodyTextChanged = YES;

    UIButton *changeBodyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    changeBodyBtn.frame = CGRectMake(0, 164, 200, 44);
    [changeBodyBtn setTitle:@"更改文本" forState:UIControlStateNormal];
    [changeBodyBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [changeBodyBtn addTarget:self action:@selector(changeBody) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:changeBodyBtn];
}

- (void)changeBody
{
    if (self.bodyTextChanged)
    {
        self.bodyView.text = @"一八五六至一八五七年间，法国《巴黎杂志》上连载的一部小说轰动了文坛，同时也在社会上引起了轩然大波。怒不可遏的司法当局对作者提起公诉，指控小说“伤风败俗、亵渎宗教”，并传唤作者到法庭受审。这位作者就是居斯塔夫·福楼拜，这部小说就是他的代表作《包法利夫人》。审判的闹剧最后以“宣判无罪”告结束，而隐居乡野、籍籍无名的作者却从此奠定了自己的文学声誉和在文学史上的地位。";
        self.bodyTextChanged = NO;
    }
    else
    {
        self.bodyView.text = @"但奇怪的是，这个在家人眼中智力如此低下的居斯塔夫，却很早就显露了文学天赋。他还没有学会阅读便在头脑里构思故事，还没有学会写作就开始自编自演戏剧，他十三岁时编了一份手抄的小报，十四五岁已醉心于创作，可是直到三十六岁才开始发表作品。";
        self.bodyTextChanged = YES;
    }

}

@end










