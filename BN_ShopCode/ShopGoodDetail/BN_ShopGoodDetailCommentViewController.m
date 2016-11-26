//
//  BN_ShopGoodDetailCommentViewController.m
//  BN_Shop
//
//  Created by Liya on 2016/11/20.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "BN_ShopGoodDetailCommentViewController.h"
#import "BN_ShopGoodDetailCommentHeaderView.h"
#import "BN_ShopGoodDetailCommentsCell.h"

#import "BN_ShopGoodDetailCommentViewModel.h"
#import "BN_ShopGoodDetailCommentsCellModel.h"
#import "TableDataSource.h"

#import <UITableView+FDTemplateLayoutCell.h>

@interface BN_ShopGoodDetailCommentViewController ()<UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIView *headView;
@property (strong, nonatomic) BN_ShopGoodDetailCommentHeaderView *headerView;

@property (strong, nonatomic) BN_ShopGoodDetailCommentViewModel *viewModel;

@end

static NSString * const ShopGoodDetailCommentCellIdentifier = @"ShopGoodDetailCommentCellIdentifier";

@implementation BN_ShopGoodDetailCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // Do any additional setup after loading the view from its nib.
    [self buildViewModel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)buildControls {
    [super buildControls];
    self.tableView.tableHeaderView = self.headView;
    [self.tableView registerNib:[BN_ShopGoodDetailCommentsCell nib] forCellReuseIdentifier:ShopGoodDetailCommentCellIdentifier];
    
    self.headerView = [BN_ShopGoodDetailCommentHeaderView nib];
    [self.headerView updateWith:self.viewModel.avgort];
    
    self.tableView.tableHeaderView = self.headView;
}

- (void)setHeadView:(UIView *)view {
    [self.tableView beginUpdates];
    _headView = view;
    self.tableView.tableHeaderView = view;
    [self.tableView endUpdates];
//    [self.tableView setContentOffset:CGPointMake(0.0, 0.0)];
}

- (CGPoint)contentOffset {
    return self.tableView.contentOffset;
}

- (void)setContentOffset:(CGPoint)contentOffset {
    self.tableView.contentOffset = contentOffset;
}

#pragma mark - viewModel
- (void)buildViewModel {
    self.viewModel = [[BN_ShopGoodDetailCommentViewModel alloc] init];
    [self testObects];
#warning 初始化列表数据等等
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return self.headerView.getViewHeight;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    @weakify(self);
    CGFloat height = [tableView fd_heightForCellWithIdentifier:ShopGoodDetailCommentCellIdentifier configuration:^(id cell) {
        @strongify(self);
        BN_ShopGoodDetailCommentsCellModel *obj = [self.viewModel.dataSource itemAtIndexPath:indexPath];
        [(BN_ShopGoodDetailCommentsCell *)cell updateWith:obj.imgUrls];
        [(BN_ShopGoodDetailCommentsCell *)cell updateWith:obj.name dateStr:obj.date content:obj.content goodStr:obj.good icon:obj.iconUrl];
    }];
    return height;
}

#pragma mark - testObject
- (void)testObects {
    NSMutableArray *array = [NSMutableArray array];
    for (NSInteger index = 0; index < 10; index++) {
        BN_ShopGoodDetailCommentsCellModel *model = [[BN_ShopGoodDetailCommentsCellModel alloc] init];
        model.name = [@"深耕母婴行业12年，四个维度构建公司差异" substringToIndex:random()%14];
        model.date = @"11月30号";
        model.content = [@"全面深化改革走过了三年的历程。三年虽短，但在以习近平同志为核心的党中央领导下,中国大地上却有数不清的改变在发生，亿万人的力量在汇聚，延展为中国现代化进程中精华荟萃的特殊单元" substringToIndex:random()%80];
        model.good = [@"白色 M 黑色 S 中小型" substringToIndex:random()%8];
        model.iconUrl = @"";
        if (random() % 2 == 0) {
            model.imgUrls = @[];
        } else {
            model.imgUrls = @[@"http://2f.zol-img.com.cn/product/100/939/ceiLvj7vpOz0Y.jpg", @"http://2f.zol-img.com.cn/product/100/939/ceiLvj7vpOz0Y.jpg", @"http://2f.zol-img.com.cn/product/100/939/ceiLvj7vpOz0Y.jpg"];
        }
        [array addObject:model];
    }
    
    self.viewModel.dataSource = [[TableDataSource alloc] initWithItems:array cellIdentifier:ShopGoodDetailCommentCellIdentifier configureCellBlock:^(id cell, id item) {
        BN_ShopGoodDetailCommentsCellModel *obj = (BN_ShopGoodDetailCommentsCellModel *)item;
        [(BN_ShopGoodDetailCommentsCell *)cell updateWith:obj.imgUrls];
        [(BN_ShopGoodDetailCommentsCell *)cell updateWith:obj.name dateStr:obj.date content:obj.content goodStr:obj.good icon:obj.iconUrl];
    }];
    self.tableView.dataSource = self.viewModel.dataSource;
    self.viewModel.avgort = @"3.0";
    [self.headerView updateWith:self.viewModel.avgort];
}


@end
