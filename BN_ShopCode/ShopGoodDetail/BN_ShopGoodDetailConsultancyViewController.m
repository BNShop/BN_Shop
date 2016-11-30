//
//  BN_ShopGoodDetailConsultancyViewController.m
//  BN_Shop
//
//  Created by Liya on 2016/11/20.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "BN_ShopGoodDetailConsultancyViewController.h"
#import "PurchaseConsultingViewController.h"

#import "BN_ShopGoodDetailConsultancyViewModel.h"
#import "BN_ShopGoodDetailConsultancyModel.h"

#import "BN_ShopGoodDetailConsultancyCell.h"
#import "BN_ShopGoodDetailConsultancyHeadView.h"

#import "UIView+BlocksKit.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "Base_BaseViewController+ControlCreate.h"

#import "TestObjectHeader.h"

@interface BN_ShopGoodDetailConsultancyViewController ()<PurchaseConsultingViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIView *headView;
@property (strong, nonatomic) BN_ShopGoodDetailConsultancyHeadView *headerView;

@property (strong, nonatomic) BN_ShopGoodDetailConsultancyViewModel *viewModel;

@end

static NSString * const ShopGoodDetailConsultancyCellIdentifier = @"ShopGoodDetailConsultancyCellIdentifier";

@implementation BN_ShopGoodDetailConsultancyViewController

- (instancetype)initWith:(long)goodsId
{
    self = [super init];
    if (self) {
        self.viewModel = [[BN_ShopGoodDetailConsultancyViewModel alloc] init];
        self.viewModel.goodsId = goodsId;
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
    [self.tableView registerNib:[BN_ShopGoodDetailConsultancyCell nib] forCellReuseIdentifier:ShopGoodDetailConsultancyCellIdentifier];
    
    self.headerView = [BN_ShopGoodDetailConsultancyHeadView nib];
    [self.headerView bk_whenTapped:^{
        PurchaseConsultingViewController *ctr = [[PurchaseConsultingViewController alloc] init];
        ctr.delegate = self;
        [self.navigationController pushViewController:ctr animated:YES];
    }];
    
    self.tableView.tableHeaderView = self.headView;
}

- (void)setHeadView:(UIView *)view {
    [self.tableView beginUpdates];
    _headView = view;
    self.tableView.tableHeaderView = view;
    [self.tableView endUpdates];
    
}

- (CGPoint)contentOffset {
    return self.tableView.contentOffset;
}

- (void)setContentOffset:(CGPoint)contentOffset {
    self.tableView.contentOffset = contentOffset;
}

#pragma mark - viewModel
- (void)buildViewModel {
    if (!self.viewModel) {
        self.viewModel = [[BN_ShopGoodDetailConsultancyViewModel alloc] init];
    }
    [self.viewModel.dataSource resetellIdentifier:ShopGoodDetailConsultancyCellIdentifier configureCellBlock:^(id cell, id item) {
        BN_ShopGoodDetailConsultancyModel *obj = (BN_ShopGoodDetailConsultancyModel *)item;
        [(BN_ShopGoodDetailConsultancyCell *)cell updateWith:obj.question answer:obj.answers];
    }];
    
    @weakify(self);
    [self.tableView setHeaderRefreshDatablock:^{
        @strongify(self);
        [self.viewModel getAnswersListClearData:YES];
    } footerRefreshDatablock:^{
        @strongify(self);
        [self.viewModel getAnswersListClearData:NO];
    }];
    
    [self.tableView setTableViewData:self.viewModel.items];
    
    [self.tableView setBn_data:self.viewModel.items];
    
    [self.tableView setRefreshBlock:^{
        @strongify(self);
        [self.viewModel getAnswersListClearData:YES];
    }];
    [self.viewModel.items.loadSupport setDataRefreshblock:^{
        @strongify(self);
        [self.tableView reloadData];
    }];
    [self.viewModel getAnswersListClearData:YES];
    
    self.tableView.dataSource = self.viewModel.dataSource;
    [self.tableView reloadData];
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    @weakify(self);
    CGFloat height = [tableView fd_heightForCellWithIdentifier:ShopGoodDetailConsultancyCellIdentifier configuration:^(id cell) {
        @strongify(self);
        BN_ShopGoodDetailConsultancyModel *model = [self.viewModel.dataSource itemAtIndex:indexPath.row];
        [(BN_ShopGoodDetailConsultancyCell *)cell updateWith:model.question answer:model.answers];
    }];
    return height;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [self.headerView getViewHeight];
}
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    return 100.0f;
//}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.headerView;
}

//- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
//    return [[UIView alloc] init];
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


#pragma mark - PurchaseConsultingViewControllerDelegate
- (void)purchaseConsultingViewControllerWith:(NSString *)text {
    @weakify(self)
    [self.viewModel sendConsultingWith:text failure:^(NSString *errorStr) {
        @strongify(self);
        [self showHudError:errorStr title:TEXT(@"提交咨询失败")];
    }];
}
@end
