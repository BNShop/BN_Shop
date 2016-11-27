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
#import "ST_TabBarController.h"

#import "BN_ShopHomeFlashSaleView.h"
#import "LYFreeTimingPlate.h"
#import "SDCycleScrollView.h"
#import "BN_ShopHomeCategoryView.h"
#import "BN_ShopHomeSouvenirCell.h"
#import "BN_ShopGoodCell.h"

#import "Base_BaseViewController+ControlCreate.h"
#import "UIBarButtonItem+BlocksKit.h"
#import "UISearchBar+RAC.h"
#import "PureLayout.h"
#import "NSString+Attributed.h"

#import "BN_ShopHomeADViewModel.h"
#import "BN_ShopHomeCategoryViewModel.h"
#import "BN_ShopHomeFlashSaleViewModel.h"
#import "BN_ShopHomeSouvenirCellModel.h"
#import "BN_ShopHomeViewModel.h"


#import "TestCartItem.h"

@interface BN_ShopHomeViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *scrollToTopButton;

@property (strong, nonatomic) BN_ShopHomeFlashSaleView *flashSaleView;
@property (strong, nonatomic) SDCycleScrollView *SDScrollViw;
@property (strong, nonatomic) BN_ShopHomeCategoryView *categoryView;

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
    
    [self buildViewModel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [(ST_TabBarController*)self.tabBarController setTabBarHidden:NO animated:YES];
}

- (void)buildControls {
    [super buildControls];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.tableView registerNib:[BN_ShopHomeSouvenirCell nib] forCellReuseIdentifier:ShopHomeCellIdentifier];
    
    [self buildADView];
    [self buildCategoryView];
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
            NSLog(@"=== %@, %@", [x class], x);
            BN_ShopListViewController *listCtr = [[BN_ShopListViewController alloc] init];
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
#warning 初始化列表数据等等
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
            [(BN_ShopGoodCell *)cell updateWith:item.pic_url title:item.name front:item.front_price real:[item.real_price strikethroughAttribute] additional:nil];
        }];
        BN_ShopHomeSouvenirCellModel *cellModel = [[BN_ShopHomeSouvenirCellModel alloc] init];
        cellModel.dataSource = cellSource;
        cellModel.souvenirModel = model;
        [array addObject:cellModel];
    }
    @weakify(self);
    self.viewModel.dataSource = [[TableDataSource alloc] initWithItems:array cellIdentifier:ShopHomeCellIdentifier configureCellBlock:^(id cell, id item) {
        @strongify(self);
        [[(BN_ShopHomeSouvenirCell *)cell collectionView] registerNib:[BN_ShopGoodCell nib] forCellWithReuseIdentifier:ShopHomeSouvenirCellIdentifier];
        [[[(BN_ShopHomeSouvenirCell *)cell rac_shopHomeSouvenirCellSignal] takeLast:1] subscribeNext:^(id x) {
            
            UITableViewCell *cell = [(NSArray *)x firstObject];
            NSIndexPath *indexPath = [(NSArray *)x lastObject];
            @strongify(self);
            NSIndexPath *sectionIndex = [self.tableView indexPathForCell:cell];
            NSLog(@"首页点击 section = %ld, row = %ld", (long)sectionIndex.row, (long)indexPath.row);
            BN_ShopGoodDetailViewController *detailCtr = [[BN_ShopGoodDetailViewController alloc] init];
            [self.navigationController pushViewController:detailCtr animated:YES];
        }];
        [[(BN_ShopHomeSouvenirCell *)cell rac_shopHomeClickTitleSignal] subscribeNext:^(id x) {
            @strongify(self);
            NSIndexPath *sectionIndex = [self.tableView indexPathForCell:(UITableViewCell *)x];
            BN_ShopSouvenirModel *categoryM = [self.viewModel.souvenirs objectAtIndex:sectionIndex.row];
            BN_ShopSorterViewController *ctr = [[BN_ShopSorterViewController alloc] initWith:categoryM.category_id];
            [self.navigationController pushViewController:ctr animated:YES];
        }];
        [[(BN_ShopHomeSouvenirCell *)cell rac_shopHomeClickThumbnailSignal] subscribeNext:^(id x) {
            @strongify(self);
            NSIndexPath *sectionIndex = [self.tableView indexPathForCell:(UITableViewCell *)x];
            NSLog(@"首页点击缩略图 section = %ld", (long)sectionIndex.row);
        }];
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
    self.SDScrollViw = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, WIDTH(self.view), 160) imageURLStringsGroup:self.adViewModel.adUrlList];
    self.SDScrollViw.autoScrollTimeInterval = 5.0f;
    self.SDScrollViw.pageDotImage = IMAGE(@"Shop_Home_Dot");
    self.SDScrollViw.currentPageDotImage = IMAGE(@"Shop_Home_CurrentDot");
    @weakify(self);
    self.SDScrollViw.clickItemOperationBlock = ^(NSInteger currentIndex) {
#warning 点击广告图的跳转
        @strongify(self);
        id adObj = [self.adViewModel adItemWithIndex:currentIndex];
        BN_ShopSpecialSubjectViewController *ctr = [[BN_ShopSpecialSubjectViewController alloc] init];
        [self.navigationController pushViewController:ctr animated:YES];
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
}

- (void)tableHeaderView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self.tableView), 0)];
    [self.SDScrollViw removeFromSuperview];
    if (self.SDScrollViw) {
        [view addSubview:self.SDScrollViw];
        [self.SDScrollViw autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:view];
        [self.SDScrollViw autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:view];
        [self.SDScrollViw autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:view];
        [self.SDScrollViw autoSetDimension:ALDimensionHeight toSize:160.0f];
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
    
    
    
    [self.flashSaleView removeFromSuperview];
    if (self.flashSaleView) {
        [self updateFlashSaleView];
        [view addSubview:self.flashSaleView];
        [self.flashSaleView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.categoryView withOffset:0.0f];
        [self.flashSaleView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:view];
        [self.flashSaleView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:view];
        [self.flashSaleView autoSetDimension:ALDimensionHeight toSize:self.flashSaleView.getViewHeight];
    }
    
    self.tableView.tableHeaderView = view;
    
    [view setNeedsLayout];
    [view layoutIfNeeded];
    CGFloat height = HEIGHT(self.SDScrollViw) + HEIGHT(self.categoryView) + HEIGHT(self.flashSaleView);
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
        return 400.0-170.0;
    }
    return 400.0f;
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

#pragma mark - data source test

- (void)testObects {
    
    NSMutableArray *array = [NSMutableArray array];
    
    for (NSInteger index = 0; index < 4; index++) {
        NSMutableArray *items = [NSMutableArray array];
        for (NSInteger j = 0; j < index+2; j++) {
            TestCartItem *item = [[TestCartItem alloc] init];
            item.front_price = [NSString stringWithFormat:@"%ld", (j+4)*(random()%15)];
            item.real_price = [NSString stringWithFormat:@"%.2f", ((float)j+6)*(random()%30)];
            [items addObject:item];
        }
        TableDataSource *source = [[TableDataSource alloc] initWithItems:items cellIdentifier:ShopHomeSouvenirCellIdentifier configureCellBlock:^(id cell, TestCartItem *item) {
            [(BN_ShopGoodCell *)cell typeFace0];
             [(BN_ShopGoodCell *)cell updateWith:@"http://2f.zol-img.com.cn/product/100/939/ceiLvj7vpOz0Y.jpg" title:[@"全面深化改革走过了三年的历程。三年虽短，但在以习近平同志为核心的党中央领导下,中国大地上却有数不清的改变在发生，亿万人的力量在汇聚，延展为中国现代化进程中精华荟萃的特殊单元" substringToIndex:random()%30] front:item.front_price real:[item.real_price strikethroughAttribute] additional:nil];
        }];
        BN_ShopHomeSouvenirCellModel *model = [[BN_ShopHomeSouvenirCellModel alloc] init];
        model.dataSource = source;
        [array addObject:model];
    }

    @weakify(self);
    self.viewModel.dataSource = [[TableDataSource alloc] initWithItems:array cellIdentifier:ShopHomeCellIdentifier configureCellBlock:^(id cell, id item) {
        @strongify(self);
        [[(BN_ShopHomeSouvenirCell *)cell collectionView] registerNib:[BN_ShopGoodCell nib] forCellWithReuseIdentifier:ShopHomeSouvenirCellIdentifier];
        [[(BN_ShopHomeSouvenirCell *)cell rac_shopHomeSouvenirCellSignal] subscribeNext:^(id x) {
            
            UITableViewCell *cell = [(NSArray *)x firstObject];
            NSIndexPath *indexPath = [(NSArray *)x lastObject];
            @strongify(self);
            NSIndexPath *sectionIndex = [self.tableView indexPathForCell:cell];
            NSLog(@"首页点击 section = %ld, row = %ld", (long)sectionIndex.row, (long)indexPath.row);
            BN_ShopGoodDetailViewController *detailCtr = [[BN_ShopGoodDetailViewController alloc] init];
            [self.navigationController pushViewController:detailCtr animated:YES];
        }];
        [[(BN_ShopHomeSouvenirCell *)cell rac_shopHomeClickTitleSignal] subscribeNext:^(id x) {
            @strongify(self);
            NSIndexPath *sectionIndex = [self.tableView indexPathForCell:(UITableViewCell *)x];
            NSLog(@"首页点击Title section = %ld", (long)sectionIndex.row);
        }];
        [[(BN_ShopHomeSouvenirCell *)cell rac_shopHomeClickThumbnailSignal] subscribeNext:^(id x) {
            @strongify(self);
            NSIndexPath *sectionIndex = [self.tableView indexPathForCell:(UITableViewCell *)x];
            NSLog(@"首页点击缩略图 section = %ld", (long)sectionIndex.row);
        }];
        BN_ShopHomeSouvenirCellModel *model = (BN_ShopHomeSouvenirCellModel *)item;
        [(BN_ShopHomeSouvenirCell *)cell collectionView].dataSource = model.dataSource;
        [(BN_ShopHomeSouvenirCell *)cell updateWith:model.title thumbnailUrl:model.thumbnailUrl dataSource:model.dataSource];
        
    }];
    
    self.tableView.dataSource = self.viewModel.dataSource;
}
@end
