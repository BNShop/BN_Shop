//
//  BN_ShopListViewController.m
//  BN_Shop
//
//  Created by Liya on 16/11/16.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "BN_ShopListViewController.h"
#import "BN_ShopScreeningConditionsViewController.h"
#import "BN_ShopSearchViewController.h"
#import "BN_ShopGoodDetailViewController.h"
#import "Base_BaseViewController+ControlCreate.h"

#import "UIBarButtonItem+BlocksKit.h"
#import "BN_ShopGoodCell.h"
#import "BN_ShopGoodHorizontalCell.h"
#import "BN_ShopListSelectionToolBar.h"

#import "BN_ShopListViewModel.h"
#import "PureLayout.h"
#import "UIView+BlocksKit.h"
#import "UISearchBar+RAC.h"

#import "BN_ShopHeader.h"
#import "NSString+Attributed.h"
#import "UICollectionView+TPCategory.h"

@interface BN_ShopListViewController ()<UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) BN_ShopListSelectionToolBar *toolBar;
@property (strong, nonatomic) BN_ShopListViewModel *listViewModel;

@end

static NSString * const ShopListGridCellIdentifier = @"ShopListGridCellIdentifier";
static NSString * const ShopListHorizontalCellIdentifier = @"ShopListHorizontalCellIdentifier";

@implementation BN_ShopListViewController

- (instancetype)initWithCategoryId:(long)categoryId
{
    self = [super init];
    if (self) {
        self.listViewModel = [[BN_ShopListViewModel alloc] init];
        self.listViewModel.categoryId = categoryId;
    }
    return self;
}

- (instancetype)initWithGoodName:(NSString *)goodName
{
    self = [super init];
    if (self) {
        self.listViewModel = [[BN_ShopListViewModel alloc] init];
        self.listViewModel.goodsName = goodName;;
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
    [self.collectionView registerNib:[BN_ShopGoodHorizontalCell nib] forCellWithReuseIdentifier:ShopListHorizontalCellIdentifier];
    [self.collectionView registerNib:[BN_ShopGoodCell nib] forCellWithReuseIdentifier:ShopListGridCellIdentifier];
    
    self.toolBar = [BN_ShopListSelectionToolBar nib];
    [self.view addSubview:self.toolBar];
    [self.toolBar autoSetDimension:ALDimensionHeight toSize:[self.toolBar getViewHeight]];
    [self.toolBar autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view];
    [self.toolBar autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view];
    [self.toolBar autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.view];
    
    @weakify(self);
    [self.toolBar.rac_radioTagSignal subscribeNext:^(id x) {
        @strongify(self);
        [self.listViewModel setOrderWith:[[(NSArray *)x firstObject] integerValue]];
        [self.toolBar updatePriceButtonWith:[self.listViewModel isDesc]];
        [self.toolBar updateVLineWith:NO];
        [self.listViewModel getGoodsClearData:YES];
    }];
    [self.toolBar.rac_filterSignal subscribeNext:^(id x) {
        @strongify(self);
        [self.toolBar updateVLineWith:YES];
        
        BN_ShopScreeningConditionsViewController *ctr = [[BN_ShopScreeningConditionsViewController alloc] initWithBankTagId:self.listViewModel.brandTagId priceTagId:self.listViewModel.priceTagId suitTagId:self.listViewModel.suitTagId];
        ctr.view.backgroundColor = [UIColor clearColor];
        [ctr setModalPresentationStyle:UIModalPresentationCustom];
        [ctr setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
        [self presentViewController:ctr animated:YES completion:nil];
        @weakify(self);
        [[ctr rac_screeningConditionsSignal] subscribeNext:^(id x) {
            @strongify(self);
            [self.toolBar updateVLineWith:NO];
            NSArray *tmplist = (NSArray *)x;
            self.listViewModel.priceTagId = [tmplist.firstObject longValue];
            self.listViewModel.suitTagId = [[tmplist objectAtIndex:1] longValue];
            self.listViewModel.brandTagId = [tmplist.lastObject longValue];
            [self.listViewModel getGoodsClearData:YES];
        }];
        [[ctr rac_dismissConditionsSignal] subscribeNext:^(id x) {
            @strongify(self);
            [self.toolBar updateVLineWith:NO];
        }];
    }];
    
    
}

- (void)loadCustomNavigationButton {
    [super loadCustomNavigationButton];
    
    @weakify(self);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] bk_initWithImage:nil style:UIBarButtonItemStylePlain handler:^(id sender) {
        @strongify(self);
        self.listViewModel.isHorizontalCell = !self.listViewModel.isHorizontalCell;
        self.navigationItem.rightBarButtonItem.image = (self.listViewModel.isHorizontalCell ? IMAGE(@"Shop_ShopList_NavGrid") : IMAGE(@"Shop_ShopList_NavHorizontal"));
        [self tableViewChangedForCell];
    }];
    self.navigationItem.rightBarButtonItem.image = (self.listViewModel.isHorizontalCell ? IMAGE(@"Shop_ShopList_NavGrid") : IMAGE(@"Shop_ShopList_NavHorizontal"));
    self.navigationItem.rightBarButtonItem.tintColor = ColorBlack;
    
    UISearchBar *searchBar = [self getSearchBarWithFrame:CGRectMake(0, 0, WIDTH(self.view), 44) withPlaceholder:TEXT(@"请输入产品名称")];
    self.navigationItem.titleView = searchBar;
    [[searchBar rac_searchBarShouldBeginEditingSignal] subscribeNext:^(id x) {
        [searchBar resignFirstResponder];
        @strongify(self);
        id ctr = [BN_ShopSearchViewController shopSearchViewController];
        if (ctr) {
            [self.navigationController pushViewController:ctr animated:YES];
        }
//         BN_ShopSearchViewController *ctr = [[BN_ShopSearchViewController alloc] init];
//        [[ctr rac_searchTextDidEndEditingSignal] subscribeNext:^(id x) {
//            @strongify(self);
//            self.listViewModel.goodsName = x;
//            [self.listViewModel getGoodsClearData:YES];
//        }];
//        UINavigationController *navCtr = [[UINavigationController alloc]initWithRootViewController:ctr];
//        [navCtr setModalPresentationStyle:UIModalPresentationCustom];
//        [navCtr setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
//        [self presentViewController:navCtr animated:YES completion:nil];
    }];
    
}

#pragma mark - viewModel
- (void)buildViewModel {
    if (!self.listViewModel) {
        self.listViewModel = [[BN_ShopListViewModel alloc] init];
    }
    if (self.listViewModel.isHorizontalCell) {
        [self.listViewModel getDataSourceWith:ShopListHorizontalCellIdentifier configureCellBlock:^(id cell, BN_ShopGoodModel *item) {
            [(BN_ShopGoodHorizontalCell *)cell updateWith:item.pic_url title:item.name front:[item.front_price strikethroughAttribute] real:item.real_price additional:[self.listViewModel total_commentStr:item.total_comment]];
        }];
    } else {
        [self.listViewModel getDataSourceWith:ShopListGridCellIdentifier configureCellBlock:^(id cell, BN_ShopGoodModel *item) {
            [(BN_ShopGoodCell *)cell updateWith:item.pic_url title:item.name front:[item.front_price strikethroughAttribute]  real:item.real_price additional:[self.listViewModel total_commentStr:item.total_comment]];
        }];
    }
    
    
    @weakify(self);
    [self.collectionView setHeaderRefreshDatablock:^{
        @strongify(self);
        [self.listViewModel getGoodsClearData:YES];
    } footerRefreshDatablock:^{
        @strongify(self);
        [self.listViewModel getGoodsClearData:NO];
    }];
    
    [self.collectionView setCollectionViewData:self.listViewModel.goods];
    
    [self.collectionView setBn_data:self.listViewModel.goods];
    [self.collectionView loadData:self.listViewModel.goods];
    [self.collectionView setRefreshBlock:^{
        @strongify(self);
        [self.listViewModel getGoodsClearData:YES];
    }];
    [self.listViewModel.goods.loadSupport setDataRefreshblock:^{
        @strongify(self);
        [self.collectionView reloadData];
    }];
    [self.listViewModel getGoodsClearData:YES];
    
    self.collectionView.dataSource = self.listViewModel.dataSource;
    [self.collectionView reloadData];
    
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    BN_ShopGoodModel *good = [self.listViewModel.dataSource itemAtIndexPath:indexPath];
    BN_ShopGoodDetailViewController *ctr = [[BN_ShopGoodDetailViewController alloc] initWith:good.goods_id];
    [self.navigationController pushViewController:ctr animated:YES];
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.listViewModel.isHorizontalCell) {
        CGFloat width = (WIDTH(collectionView) - 22);
        return CGSizeMake(width, 120);
    } else {
        CGFloat width = (WIDTH(collectionView) - 12 - 17*2) / 2.0;
        return CGSizeMake(width, width+37);
    }
    
}

//cell的最小行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    if (self.listViewModel.isHorizontalCell) {
        return 6.0;
    } else {
        return 12.0;
    }
}

//cell的最小列间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    if (self.listViewModel.isHorizontalCell) {
        return 0.0;
    } else {
        return 12.0;
    }
}

//内馅
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (self.listViewModel.isHorizontalCell) {
        return UIEdgeInsetsMake(6, 12, 6, 10);
    } else {
        return UIEdgeInsetsMake(12, 17, 12, 17);
    }
}

#pragma mark - UI
- (void)tableViewChangedForCell {
    if (self.listViewModel.isHorizontalCell) {
        [self.listViewModel.dataSource resetellIdentifier:ShopListHorizontalCellIdentifier];
    } else {
        [self.listViewModel.dataSource resetellIdentifier:ShopListGridCellIdentifier];
    }
    [self.collectionView reloadData];
}


@end
