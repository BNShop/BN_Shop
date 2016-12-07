//
//  BN_ShopFlashSaleListViewController.m
//  BN_Shop
//
//  Created by Liya on 2016/11/29.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "BN_ShopFlashSaleListViewController.h"
#import "BN_ShopGoodDetailViewController.h"
#import "Base_BaseViewController+ControlCreate.h"
#import "BN_ShopGoodDetailViewController.h"
#import "BN_ShopGoodDetailBuyViewController.h"
#import "BN_ShopOrdersConfirmationViewController.h"

#import "BN_ShopGoodHorizontalCell.h"
#import "BN_ShopFlashSaleListViewModel.h"

#import "NSString+Attributed.h"
#import "NSArray+BlocksKit.h"
#import "BN_ShopToolRequest.h"

@interface BN_ShopFlashSaleListViewController ()<BN_ShopGoodDetailBuyViewControllerDelegate>
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
    @weakify(self);
    [self.viewModel.dataSource resetellIdentifier:ShopListHorizontalCellIdentifier configureCellBlock:^(BN_ShopGoodHorizontalCell *cell, BN_ShopGoodModel *item) {
        @weakify(cell);
        [cell updateWith:item.pic_url title:item.name front:[item.front_price strikethroughAttribute] real:item.real_price additional:nil];
        [cell buildTimePlate];
        if (item.buying_state == 1) {
            [cell updateAdditionalFrenzied:item.date];
            [cell addManageButtonEvent:^(id sender) {
                @strongify(self);
                [self addToCart:item];
            }];
        } else if (item.buying_state == 0) {
            [cell updateAdditionalForward:item.date state:(int)item.warn_id];
            [cell addManageButtonEvent:^(id sender) {
                @strongify(self);
                
                [[BN_ShopToolRequest sharedInstance] warnORCancelRes:(item.warn_id <= 0) goodsId:(item.warn_id>0 ? item.warn_id : item.goods_id) success:^(long warn_id) {
                    item.warn_id = warn_id;
                    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell_weak_];
                    if (indexPath) {
                        [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
                    }
                    
                } failure:^(NSString *errorDescription) {
                    [self showHudError:nil title:errorDescription];
                }];
            }];
        } else {
            [cell updateAdditionalFinish];
        }
    }];

    [self.collectionView setHeaderRefreshDatablock:^{
        @strongify(self);
        [self.viewModel getLimiteGoodsClearData:YES];
    } footerRefreshDatablock:^{
        @strongify(self);
        [self.viewModel getLimiteGoodsClearData:NO];
    }];
    
    [self.collectionView setCollectionViewData:self.viewModel.goods];
    [self.collectionView loadData:self.viewModel.goods];
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

- (void)addToCart:(BN_ShopGoodModel *)good {
    BN_ShopGoodDetailBuyViewController *ctr = [[BN_ShopGoodDetailBuyViewController alloc] initWith:good.pic_url standards:good.name price:good.real_price];
    ctr.view.backgroundColor = [ColorBlack colorWithAlphaComponent:0.17];
    [ctr setModalPresentationStyle:UIModalPresentationCustom];
    [ctr setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    ctr.delegate = self;
    ctr.goodId = good.goods_id;
    [self presentViewController:ctr animated:YES completion:nil];
}


#pragma mark - BN_ShopGoodDetailBuyViewControllerDelegate
- (void)goodDetailBuyCountWith:(int)cout goodId:(long)goodId{
    if (goodId > 0 && cout > 0) {
        BN_ShopOrdersConfirmationViewController *ctr = [[BN_ShopOrdersConfirmationViewController alloc] initWithSpecial:goodId num:cout];
        [self.navigationController pushViewController:ctr animated:YES];
    }
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
