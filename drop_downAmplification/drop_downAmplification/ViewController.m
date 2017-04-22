//
//  ViewController.m
//  drop_downAmplification
//
//  Created by BigCat on 2017/4/21.
//  Copyright © 2017年 BigCatBrother. All rights reserved.
//

#import "ViewController.h"
#import <Masonry.h>
#import "UIView+Frame.h"
#import "UIImage+Image.h"

#define kHeadImageViewHeight 200
#define kTABViewHeight 44
#define kIconSize 80
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UIView *TABView; // 选项卡
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UIView *headView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
//
    
   
    
    
   [self setupTableViewStyle];
    [self setupHeadViewStyle];
    [self setupNavigationBar];

    
//    self.headImageView.hidden = YES;
//    self.TABView.hidden = YES;
//    self.tableView.hidden = YES;
}

-(void)setupHeadViewStyle
{
    __weak typeof(self) WeakSelf = self;
    
    self.headView = [UIView new];
    [self.view addSubview:self.headView];
    [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(WeakSelf.view.mas_top);
        make.height.mas_equalTo(kHeadImageViewHeight);
        make.width.equalTo(WeakSelf.view.mas_width);
    }];
    
    [self setupHeadImageViewStyle];
    [self setupTABViewStytle];
    [self setupIconStyle];
}
-(void)setupTableViewStyle
{
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    self.tableView.contentInset = UIEdgeInsetsMake(kHeadImageViewHeight + kTABViewHeight, 0, 0, 0);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.backgroundColor = [UIColor redColor];
}

-(void)setupHeadImageViewStyle
{
    __weak typeof(self) WeakSelf = self;
    
    self.headImageView = [UIImageView new];
    [self.headView addSubview:self.headImageView];
    self.headImageView.image = [UIImage imageNamed:@"mn"];
    self.headImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.headImageView.clipsToBounds = YES;
    
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(WeakSelf.headView.mas_top);
        make.right.equalTo(WeakSelf.headView.mas_right);
        make.left.equalTo(WeakSelf.headView.mas_left);
        make.height.mas_equalTo(kHeadImageViewHeight);
    }];
}

-(void)setupIconStyle
{
    
    __weak typeof(self) WeakSelf = self;
    self.icon = [UIImageView new];
    [self.headView addSubview:self.icon];
    self.icon.image = [UIImage imageNamed:@"ws"];
    
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kIconSize, kIconSize));
        make.centerX.equalTo(WeakSelf.headView.mas_centerX);
        make.bottom.equalTo(WeakSelf.TABView.mas_top).offset(-20);
    }];
}

-(void)setupTABViewStytle
{
    __weak typeof(self) WeakSelf = self;
    
    self.TABView = [UIView new];
    [self.view addSubview:self.TABView];
    self.TABView.backgroundColor = [UIColor purpleColor];
    
    [self.TABView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(WeakSelf.headImageView.mas_bottom);
        make.right.equalTo(WeakSelf.headView.mas_right);
        make.left.equalTo(WeakSelf.headView.mas_left);
        make.height.mas_equalTo(kTABViewHeight);
    }];
}

-(void)setupNavigationBar
{
    // 用一个空UIIimage
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc]init] forBarMetrics:UIBarMetricsDefault];
    // 清空导航条的阴影线
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc]init]];
    
    // 设置导航条标题
    UILabel *label = [[UILabel alloc]init];
    label.text = @"我是标题";
    // 设置文字颜色
    label.textColor = [UIColor colorWithWhite:1 alpha:0];
    
    // 尺寸自适应：自动计算文字大小
    [label sizeToFit];
    
    self.titleLabel = label;
    
    [self.navigationItem setTitleView:label];
}

#pragma mark---UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.backgroundColor = [UIColor greenColor];
    }
    
    cell.textLabel.text = @(indexPath.row).stringValue;
    
    return cell;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    CGFloat originalOffset = kHeadImageViewHeight + kTABViewHeight;
    CGFloat scrollOffsetY =  originalOffset + scrollView.contentOffset.y;
    NSLog(@"%f",scrollOffsetY);
    
    
    [self.headImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo( kHeadImageViewHeight - scrollOffsetY);
    }];
    
    if (scrollOffsetY >= kHeadImageViewHeight - 64) {
     
        [self.headImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(64);
        }];
    }else
    {
        [self.headImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo( kHeadImageViewHeight - scrollOffsetY);
        }];
    }
    
    // 计算透明度
    CGFloat alpha = scrollOffsetY / (kHeadImageViewHeight + kTABViewHeight);
    if (alpha > 1) {
        alpha = 0.99;
    }
    
    // 设置导航条背景图片
    // 根据当前alpha值生成图片
    UIImage *image = [UIImage imageWithColor:[UIColor colorWithWhite:1 alpha:alpha]];
    
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    // 设置导航条标题颜色
    self.titleLabel.textColor = [UIColor colorWithWhite:0 alpha:alpha];
}
@end
