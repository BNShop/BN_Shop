//
//  BN_ShopHomeViewController.m
//  BN_Shop
//
//  Created by Liya on 16/11/17.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "BN_ShopHomeViewController.h"
#import "BN_ShoppingcartViewController.h"
#import "BN_ShopSearchViewController.h"
#import "BN_ShopListViewController.h"
#import "BN_ShopSorterViewController.h"
#import "BN_ShopGoodDetailViewController.h"
#import "BN_ShopSpecialSubjectViewController.h"
#import <Base_UITabBarBaseController.h>
#import "BN_ShopFlashSaleListViewController.h"

#import "BN_ShopHomeFlashSaleView.h"
#import "LYFreeTimingPlate.h"
#import "SDCycleScrollView.h"
#import "BN_ShopHomeCategoryView.h"
#import "BN_ShopHomeSouvenirCell.h"
#import "BN_ShopGoodCell.h"
#import "UIImageView+WebCache.h"

#import "Base_BaseViewController+ControlCreate.h"
#import "UIBarButtonItem+BlocksKit.h"
#import "UISearchBar+RAC.h"
#import "PureLayout.h"
#import "NSString+Attributed.h"
#import "NSString+URL.h"
#import "UIView+BlocksKit.h"
#import "BN_ShopHeader.h"

#import "BN_ShopHomeADViewModel.h"
#import "BN_ShopHomeCategoryViewModel.h"
#import "BN_ShopHomeFlashSaleViewModel.h"
#import "BN_ShopHomeSouvenirCellModel.h"
#import "BN_ShopHomeViewModel.h"
#if __has_include("LBB_PoohCycleTransManager.h")
#import "LBB_PoohCycleTransManager.h"
#define HAS_AddressList 1
#endif

@interface BN_ShopHomeViewController ()<BN_ShopHomeSouvenirCellDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *scrollToTopButton;

@property (strong, nonatomic) BN_ShopHomeFlashSaleView *flashSaleView;
@property (strong, nonatomic) SDCycleScrollView *SDScrollViw;
@property (strong, nonatomic) BN_ShopHomeCategoryView *categoryView;
@property (strong, nonatomic) UIView *recommandView;
@property (strong, nonatomic) NSLayoutConstraint *recommandViewHeight;

@property (strong, nonatomic) BN_ShopHomeADViewModel *adViewModel;
@property (strong, nonatomic) BN_ShopHomeCategoryViewModel *categoryViewModel;
@property (strong, nonatomic) BN_ShopHomeFlashSaleViewModel *flashSaleViewModel;
@property (strong, nonatomic) BN_ShopHomeViewModel *viewModel;
@end

static NSString * const ShopHomeCellIdentifier = @"ShopHomeCellIdentifier";
static NSString * const ShopHomeSouvenirCellIdentifier = @"ShopHomeSouvenirCellIdentifier";

@implementation BN_ShopHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.leftBarButtonItems = nil;
    [self buildViewModel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [(Base_UITabBarBaseController*)self.tabBarController setTabBarHidden:NO animated:YES];
}

- (void)buildControls {
    [super buildControls];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.tableView registerNib:[BN_ShopHomeSouvenirCell nib] forCellReuseIdentifier:ShopHomeCellIdentifier];
    
    [self buildADView];
    [self buildCategoryView];
    [self buildRecommandADView];
    [self buildFlashSaleView];
    [self tableHeaderView];
}

- (void)loadCustomNavigationButton {
    [super loadCustomNavigationButton];
    
    @weakify(self);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] bk_initWithImage:IMAGE(@"Shop_Home_NavShoppingCart") style:UIBarButtonItemStylePlain handler:^(id sender) {
        BN_ShoppingcartViewController *ctr = [[BN_ShoppingcartViewController alloc] init];
        @strongify(self);
        [self.navigationController pushViewController:ctr animated:YES];
    }];
    self.navigationItem.rightBarButtonItem.tintColor = ColorBlack;
    
    UISearchBar *searchBar = [self getSearchBarWithFrame:CGRectMake(0, 0, WIDTH(self.view), 44) withPlaceholder:TEXT(@"请输入产品名称")];
    self.navigationItem.titleView = searchBar;
    [[searchBar rac_searchBarShouldBeginEditingSignal] subscribeNext:^(id x) {
        [searchBar resignFirstResponder];
        @strongify(self);
        BN_ShopSearchViewController *ctr = [[BN_ShopSearchViewController alloc] init];
        [[ctr rac_searchTextDidEndEditingSignal] subscribeNext:^(id x) {
            @strongify(self);
            BN_ShopListViewController *listCtr = [[BN_ShopListViewController alloc] initWithGoodName:x];
            [self.navigationController pushViewController:listCtr animated:YES];

        }];
        UINavigationController *navCtr = [[UINavigationController alloc]initWithRootViewController:ctr];
        [navCtr setModalPresentationStyle:UIModalPresentationCustom];
        [navCtr setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
        [self presentViewController:navCtr animated:YES completion:nil];
    }];
}

- (void)setControlsFrame {
    [super setControlsFrame];
}

#pragma mark - viewModel
- (void)buildViewModel {
    [self buildADModel];
    [self buildCategoryViewModel];
    [self buildFlashSaleViewModel];
    [self buildSouvenirModel];
}

- (void)buildSouvenirTableDataSource {
    NSMutableArray *array = [NSMutableArray array];
    for (BN_ShopSouvenirModel *model in self.viewModel.souvenirs) {
        TableDataSource *cellSource = [[TableDataSource alloc] initWithItems:model.goodsList cellIdentifier:ShopHomeSouvenirCellIdentifier configureCellBlock:^(id cell, BN_ShopSouvenirGoodModel *item) {
            [(BN_ShopGoodCell *)cell typeFace0];
            [(BN_ShopGoodCell *)cell updateWith:item.pic_url title:item.name front:[item.front_price strikethroughAttribute] real:item.real_price additional:nil];
        }];
        BN_ShopHomeSouvenirCellModel *cellModel = [[BN_ShopHomeSouvenirCellModel alloc] init];
        cellModel.dataSource = cellSource;
        cellModel.souvenirModel = model;
        [array addObject:cellModel];
    }
    @weakify(self);
    self.viewModel.dataSource = [[TableDataSource alloc] initWithItems:array cellIdentifier:ShopHomeCellIdentifier configureCellBlock:^(id cell, id item) {
        @strongify(self);
        [(BN_ShopHomeSouvenirCell *)cell setDelegate:self];
        [[(BN_ShopHomeSouvenirCell *)cell collectionView] registerNib:[BN_ShopGoodCell nib] forCellWithReuseIdentifier:ShopHomeSouvenirCellIdentifier];
        BN_ShopHomeSouvenirCellModel *model = (BN_ShopHomeSouvenirCellModel *)item;
        [(BN_ShopHomeSouvenirCell *)cell collectionView].dataSource = model.dataSource;
        [(BN_ShopHomeSouvenirCell *)cell updateWith:model.title thumbnailUrl:model.thumbnailUrl dataSource:model.dataSource];
        
    }];
    
    self.tableView.dataSource = self.viewModel.dataSource;

}

- (void)buildSouvenirModel {
    self.viewModel = [[BN_ShopHomeViewModel alloc] init];
    @weakify(self);
    [self.viewModel.souvenirs.loadSupport setDataRefreshblock:^{
        @strongify(self);
        [self buildSouvenirTableDataSource];
        [self.tableView reloadData];
    }];
    [self.tableView setBn_data:self.viewModel.souvenirs];
    [self.tableView setTableViewData:self.viewModel.souvenirs];
    [self.tableView setHeaderRefreshDatablock:^{
        @strongify(self);
        [self.adViewModel getADArray];
        [self.viewModel getSouvenirsData];
        [self.flashSaleViewModel getFlashSaleData];
        [self.categoryViewModel getCategoryArray];
    } footerRefreshDatablock:^{}];
    [self.viewModel getSouvenirsData];
    [self.tableView setRefreshBlock:^{
        @strongify(self);
        [self.viewModel getSouvenirsData];
    }];
}

- (void)buildADModel {
    self.adViewModel = [[BN_ShopHomeADViewModel alloc] init];
    @weakify(self);
    [self.adViewModel.adList.loadSupport setDataRefreshblock:^{
        @strongify(self);
        self.SDScrollViw.imageURLStringsGroup = self.adViewModel.adUrlList;
    }];
    [self.SDScrollViw setBn_data:self.adViewModel.adList];
    [self.adViewModel getADArray];
    [self.SDScrollViw setRefreshBlock:^{
        @strongify(self);
        [self.adViewModel getADArray];
    }];
    
    [self.adViewModel getRecommendAdListArray];
    [self.adViewModel.recommendAdList.loadSupport setDataRefreshblock:^{
        @strongify(self);
        CGFloat height = WIDTH(self.recommandView)/1.73;
        for (NSInteger index=0; index<self.adViewModel.recommendAdList.count; index++) {
            BN_ADModel *model = self.adViewModel.recommendAdList[index];
            UIImageView *imgView = [[UIImageView alloc] init];
            [imgView sd_setImageWithURL:[model.picUrl URL] placeholderImage:nil];
            [self.recommandView addSubview:imgView];
            [imgView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.recommandView withOffset:index*(20+height)];
            [imgView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.recommandView];
            [imgView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.recommandView];
            [imgView autoSetDimension:ALDimensionHeight toSize:height];
            imgView.tag = index;
            
            [imgView bk_whenTapped:^{
#if HAS_AddressList
                @strongify(self);
                [[LBB_PoohCycleTransManager sharedInstance] transmission:self.adViewModel.recommendAdList[imgView.tag] viewController:self];
#endif
            }];
        }
        self.recommandViewHeight.constant = (20+height)*self.adViewModel.recommendAdList.count;
        UIView *recommandADView = self.tableView.tableHeaderView;
        height = HEIGHT(self.SDScrollViw) + HEIGHT(self.categoryView) + HEIGHT(self.flashSaleView) + self.recommandViewHeight.constant;
        recommandADView.frame = RECT_CHANGE_height(recommandADView, height);
        [recommandADView setNeedsLayout];
        self.tableView.tableHeaderView = recommandADView;
    }];
}

- (void)buildCategoryViewModel {
    self.categoryViewModel = [[BN_ShopHomeCategoryViewModel alloc] init];
    @weakify(self);
    [self.categoryViewModel.categorys.loadSupport setDataRefreshblock:^{
        @strongify(self);
        [self updateCategoryView];
    }];
    [self.categoryViewModel getCategoryArray];
    [self.categoryView setBn_data:self.categoryViewModel.categorys];
    [self.categoryView setRefreshBlock:^{
        @strongify(self);
        [self.categoryViewModel getCategoryArray];
    }];
    
}

- (void)buildFlashSaleViewModel {
    self.flashSaleViewModel = [[BN_ShopHomeFlashSaleViewModel alloc] init];
    @weakify(self);
    [self.flashSaleViewModel.flashSaleModel.loadSupport setDataRefreshblock:^{
        @strongify(self);
        [self updateFlashSaleView];
    }];
    [self.flashSaleViewModel getFlashSaleData];
    [self.flashSaleView setBn_data:self.flashSaleViewModel.flashSaleModel];
    [self.flashSaleView setRefreshBlock:^{
        @strongify(self);
        [self.flashSaleViewModel getFlashSaleData];
    }];
    
}

#pragma mark - 
- (IBAction)scrollToTop:(id)sender {
    [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
    self.scrollToTopButton.hidden = YES;
}


#pragma mark - tableHeaderView

- (void)buildADView {
    self.SDScrollViw = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, WIDTH(self.view), WIDTH(self.view)/1.73) imageURLStringsGroup:self.adViewModel.adUrlList];
    self.SDScrollViw.autoScrollTimeInterval = 5.0f;
    self.SDScrollViw.pageDotImage = IMAGE(@"Shop_Home_Dot");
    self.SDScrollViw.currentPageDotImage = IMAGE(@"Shop_Home_CurrentDot");
    @weakify(self);
    self.SDScrollViw.clickItemOperationBlock = ^(NSInteger currentIndex) {
        @strongify(self);
        BN_ADModel *adObj = [self.adViewModel adItemWithIndex:currentIndex];
        if (adObj.type == 14) {
            //去专题页面
            BN_ShopSpecialSubjectViewController *ctr = [[BN_ShopSpecialSubjectViewController alloc] initWith:adObj.objId];
            [self.navigationController pushViewController:ctr animated:YES];
            
        } else if (adObj.type == 4) {
            
            BN_ShopGoodDetailViewController *ctr = [[BN_ShopGoodDetailViewController alloc] initWith:adObj.objId];
            [self.navigationController pushViewController:ctr animated:YES];
            
        } else if (adObj.hrefUrl) {
#warning 点击广告图的跳转 外部链接
            
        }
    };
}

- (void)buildCategoryView {
    self.categoryView = [BN_ShopHomeCategoryView nib];
    @weakify(self);
    [[self.categoryView rac_shopHomeCategorySignal] subscribeNext:^(id x) {
        NSInteger tag = [x integerValue];
        @strongify(self);
        BN_ShopCategoryModel *categoryM = nil;
        if (tag-1 > 0 && tag-1 < self.categoryViewModel.categorys.count) {
            categoryM = [self.categoryViewModel.categorys objectAtIndex:tag-1];
        }
        BN_ShopSorterViewController *ctr = [[BN_ShopSorterViewController alloc] initWith:categoryM.category_id];
        [self.navigationController pushViewController:ctr animated:YES];
    }];
}

- (void)buildFlashSaleView {
    self.flashSaleView = [BN_ShopHomeFlashSaleView nib];
    @weakify(self);
    
    [self.flashSaleView bk_whenTapped:^{
        @strongify(self);
        BN_ShopFlashSaleListViewController *ctr = [[BN_ShopFlashSaleListViewController alloc] init];
        [self.navigationController pushViewController:ctr animated:YES];
    }];
    [self.flashSaleView tappedThumbnailImg:^{
        @strongify(self);
        if (self.flashSaleViewModel.flashSaleModel.goodsId) {
            BN_ShopGoodDetailViewController *ctr = [[BN_ShopGoodDetailViewController alloc] initWith:self.flashSaleViewModel.flashSaleModel.goodsId];
            [self.navigationController pushViewController:ctr animated:YES];
        }
    }];
    
}

- (void)buildRecommandADView {
    self.recommandView = [[UIView alloc] init];
}

- (void)tableHeaderView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self.tableView), 0)];
    [self.SDScrollViw removeFromSuperview];
    if (self.SDScrollViw) {
        [view addSubview:self.SDScrollViw];
        [self.SDScrollViw autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:view];
        [self.SDScrollViw autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:view];
        [self.SDScrollViw autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:view];
        [self.SDScrollViw autoSetDimension:ALDimensionHeight toSize:WIDTH(self.tableView)/1.73];
    }
    
    [self.categoryView removeFromSuperview];
    if (self.categoryView) {
        [view addSubview:self.categoryView];
        if (self.SDScrollViw) {
            [self.categoryView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.SDScrollViw withOffset:0.0f];
        } else {
            [self.categoryView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:view withOffset:0.0f];
        }
        [self.categoryView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:view];
        [self.categoryView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:view];
        [self.categoryView autoSetDimension:ALDimensionHeight toSize:self.categoryView.getViewHeight];
    }
    
    [self.recommandView removeAllSubviews];
    if (self.recommandView) {
        [view addSubview:self.recommandView];
        [self.recommandView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.categoryView];
        [self.recommandView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:view];
        [self.recommandView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:view];
        self.recommandViewHeight = [self.recommandView autoSetDimension:ALDimensionHeight toSize:0.1];
    }
    
    
    [self.flashSaleView removeFromSuperview];
    if (self.flashSaleView) {
        [self updateFlashSaleView];
        [view addSubview:self.flashSaleView];
        [self.flashSaleView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.recommandView withOffset:0.0f];
        [self.flashSaleView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:view];
        [self.flashSaleView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:view];
        [self.flashSaleView autoSetDimension:ALDimensionHeight toSize:self.flashSaleView.getViewHeight];
    }
    
    self.tableView.tableHeaderView = view;
    
    [view setNeedsLayout];
    [view layoutIfNeeded];
    CGFloat height = HEIGHT(self.SDScrollViw) + HEIGHT(self.categoryView) + HEIGHT(self.flashSaleView) + HEIGHT(self.recommandView);
    view.frame = RECT_CHANGE_height(view, height);
    self.tableView.tableHeaderView = view;
}

- (void) updateFlashSaleView {
    [self.flashSaleView updateWith:self.flashSaleViewModel.flashSaleModel.pic_url title:self.flashSaleViewModel.flashSaleModel.name instruction:nil price:self.flashSaleViewModel.priceAttri];
    [self.flashSaleView updateWith:self.flashSaleViewModel.date title:self.flashSaleViewModel.timeTitle countdownToLastSeconds:0 timeColor:self.flashSaleViewModel.timeColor];
}

- (void) updateCategoryView {
    [self.categoryView updateWith:self.categoryViewModel.categoryTitles];
}

#pragma mark - BN_ShopHomeSouvenirCellDelegate
- (void)tableViewWith:(UITableViewCell *)cell collectionViewDidSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSIndexPath *sectionIndex = [self.tableView indexPathForCell:cell];
    NSLog(@"首页点击 section = %ld, row = %ld", (long)sectionIndex.row, (long)indexPath.row);
    
    BN_ShopHomeSouvenirCellModel *cellModel = [self.viewModel.dataSource itemAtIndex:sectionIndex.row];
    BN_ShopSouvenirGoodModel *good = [cellModel.dataSource itemAtIndex:indexPath.row];
    
    BN_ShopGoodDetailViewController *detailCtr = [[BN_ShopGoodDetailViewController alloc] initWith:good.goods_id];
    [self.navigationController pushViewController:detailCtr animated:YES];

}

- (void)clickTitleWith:(UITableViewCell *)cell {
    NSIndexPath *sectionIndex = [self.tableView indexPathForCell:cell];
    BN_ShopSouvenirModel *categoryM = [self.viewModel.souvenirs objectAtIndex:sectionIndex.row];
    BN_ShopSorterViewController *ctr = [[BN_ShopSorterViewController alloc] initWith:categoryM.category_id];
    [self.navigationController pushViewController:ctr animated:YES];
}

- (void)clickThumbnailWith:(UITableViewCell *)cell{
    NSIndexPath *sectionIndex = [self.tableView indexPathForCell:cell];
    NSLog(@"首页点击缩略图 section = %ld", (long)sectionIndex.row);
    BN_ShopSouvenirModel *model = [self.viewModel.souvenirs objectAtIndex:sectionIndex.section];
    BN_ShopGoodDetailViewController *ctr = [[BN_ShopGoodDetailViewController alloc] initWith:model.obj_id];
    [self.navigationController pushViewController:ctr animated:YES];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.scrollToTopButton.hidden = scrollView.contentOffset.y < HEIGHT(self.view);
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        self.scrollToTopButton.hidden = scrollView.contentOffset.y < HEIGHT(self.view);
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    BN_ShopHomeSouvenirCellModel *model = [self.viewModel.dataSource itemAtIndexPath:indexPath];
    if (model.souvenirModel.goodsList.count == 0) {
        return 40.0+WIDTH(tableView)/1.73;
    }
    return 216.0+WIDTH(tableView)/1.73;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 5.0f;
}


- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(tableView), 5)];
    view.backgroundColor = ColorBackground;
    return view;
}

@end
