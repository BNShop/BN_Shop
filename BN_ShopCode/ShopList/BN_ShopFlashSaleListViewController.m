//
//  BN_ShopFlashSaleListViewController.m
//  BN_Shop
//
//  Created by Liya on 2016/11/29.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "BN_ShopFlashSaleListViewController.h"
#import "BN_ShopGoodDetailViewController.h"

#import "BN_ShopGoodHorizontalCell.h"
#import "BN_ShopFlashSaleListViewModel.h"

#import "NSString+Attributed.h"
#import "NSArray+BlocksKit.h"

@interface BN_ShopFlashSaleListViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) BN_ShopFlashSaleListViewModel *viewModel;
@end

static NSString * const ShopListHorizontalCellIdentifier = @"ShopListHorizontalCellIdentifier";
@implementation BN_ShopFlashSaleListViewController

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
    self.navigationItem.title = TEXT(@"限时抢购");
    [self.collectionView registerNib:[BN_ShopGoodHorizontalCell nib] forCellWithReuseIdentifier:ShopListHorizontalCellIdentifier];
}

-(void)leftButtonClick{
    [self.viewModel cancelTimer];
    NSArray *cells = [self.collectionView visibleCells];
    [cells bk_each:^(id obj) {
        if ([obj respondsToSelector:@selector(cancelTimer)]) {
            [obj performSelector:@selector(cancelTimer)];
        }
    }];
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - vm

- (void)buildViewModel {
    self.viewModel = [[BN_ShopFlashSaleListViewModel alloc] init];
    [self.viewModel.dataSource resetellIdentifier:ShopListHorizontalCellIdentifier configureCellBlock:^(id cell, BN_ShopGoodModel *item) {
        [(BN_ShopGoodHorizontalCell *)cell updateWith:item.pic_url title:item.name front:[item.front_price strikethroughAttribute] real:item.real_price additional:nil];
        [(BN_ShopGoodHorizontalCell *)cell buildTimePlate];
        if (item.buying_state == 1) {
            [(BN_ShopGoodHorizontalCell *)cell updateAdditionalFrenzied:item.date];
            [(BN_ShopGoodHorizontalCell *)cell addManageButtonEvent:^(id sender) {
#warning 去抢购
            }];
        } else if (item.buying_state == 0) {
            [(BN_ShopGoodHorizontalCell *)cell updateAdditionalForward:item.date state:(int)item.warn_id];
            if (item.warn_id == -1) {
                [(BN_ShopGoodHorizontalCell *)cell addManageButtonEvent:^(id sender) {
#warning 去定提醒
                }];
            } else {
                [(BN_ShopGoodHorizontalCell *)cell addManageButtonEvent:^(id sender) {
#warning 去取消提醒
                }];
            }
        }
    }];
    
    @weakify(self);
    [self.collectionView setHeaderRefreshDatablock:^{
        @strongify(self);
        [self.viewModel getLimiteGoodsClearData:YES];
    } footerRefreshDatablock:^{
        @strongify(self);
        [self.viewModel getLimiteGoodsClearData:NO];
    }];
    
    [self.collectionView setCollectionViewData:self.viewModel.goods];
    
    [self.collectionView setBn_data:self.viewModel.goods];
    
    [self.collectionView setRefreshBlock:^{
        @strongify(self);
        [self.viewModel getLimiteGoodsClearData:YES];
    }];
    [self.viewModel.goods.loadSupport setDataRefreshblock:^{
        @strongify(self);
        [self.collectionView reloadData];
    }];
    [self.viewModel getLimiteGoodsClearData:YES];
    
    self.collectionView.dataSource = self.viewModel.dataSource;
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    BN_ShopGoodModel *obj = [self.viewModel.dataSource itemAtIndexPath:indexPath];
    if (obj.goods_id) {
        BN_ShopGoodDetailViewController *ctr = [[BN_ShopGoodDetailViewController alloc] initWith:obj.goods_id];
        [self.navigationController pushViewController:ctr animated:YES];
    }
    
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = (WIDTH(collectionView) - 22);
    return CGSizeMake(width, 120);
}

//cell的最小行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 6.0;
}

//cell的最小列间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}

//内馅
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(6, 12, 6, 10);
}
@end
