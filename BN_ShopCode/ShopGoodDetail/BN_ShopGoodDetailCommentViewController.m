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

- (instancetype)initWith:(long)goodId type:(int)type
{
    self = [super init];
    if (self) {
        self.viewModel = [[BN_ShopGoodDetailCommentViewModel alloc] init];
        self.viewModel.objId = goodId;
        self.viewModel.type = type;
    }
    return self;
}

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
- (void)setCommentAvgScore:(int)avg_score {
    self.viewModel.avg_score = avg_score;
}

- (void)buildViewModel {
    if (!self.viewModel) {
        self.viewModel = [[BN_ShopGoodDetailCommentViewModel alloc] init];
    }

    [self.viewModel.dataSource resetellIdentifier:ShopGoodDetailCommentCellIdentifier configureCellBlock:^(id cell, BN_ShopGoodCommentsModel *item) {
        [(BN_ShopGoodDetailCommentsCell *)cell updateWith:item.pics];
        [(BN_ShopGoodDetailCommentsCell *)cell updateWith:item.userName dateStr:item.commentDate content:item.remark goodStr:nil icon:item.userPicUrl];
    }];
    
    @weakify(self);
    [self.tableView setHeaderRefreshDatablock:^{
        [self.viewModel getCommentsClearData:YES];
    } footerRefreshDatablock:^{
        @strongify(self);
        [self.viewModel getCommentsClearData:NO];
    }];
    
    [self.tableView setTableViewData:self.viewModel.items];
    
    [self.tableView setBn_data:self.viewModel.items];
    
    [self.tableView setRefreshBlock:^{
        @strongify(self);
        [self.viewModel getCommentsClearData:YES];
    }];
    [self.viewModel.items.loadSupport setDataRefreshblock:^{
        @strongify(self);
        [self.tableView reloadData];
    }];
    [self.viewModel getCommentsClearData:YES];
    
    self.tableView.dataSource = self.viewModel.dataSource;
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
        BN_ShopGoodCommentsModel *item = [self.viewModel.dataSource itemAtIndexPath:indexPath];
        [(BN_ShopGoodDetailCommentsCell *)cell updateWith:item.pics];
        [(BN_ShopGoodDetailCommentsCell *)cell updateWith:item.userName dateStr:item.commentDate content:item.remark goodStr:nil icon:item.userPicUrl];;
    }];
    return height;
}

@end
