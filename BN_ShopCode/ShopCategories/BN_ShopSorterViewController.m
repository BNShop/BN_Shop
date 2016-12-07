//
//  BN_ShopSorterViewController.m
//  BN_Shop
//
//  Created by Liya on 16/11/13.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "BN_ShopSorterViewController.h"
#import "BN_ShopListViewController.h"
#import "BN_ShopSearchViewController.h"
#import "BN_ShopListViewController.h"

#import "BN_ShopSorterTitleCell.h"
#import "BN_ShopSorterContantCell.h"
#import "BN_ShopSorterViewModel.h"

#import "Base_BaseViewController+ControlCreate.h"
#import "UIBarButtonItem+BlocksKit.h"
#import "UISearchBar+RAC.h"
#import "NSArray+BlocksKit.h"


@interface BN_ShopSorterViewController ()<UITableViewDelegate, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UITableView *titleTableView;
@property (weak, nonatomic) IBOutlet UICollectionView *contentCollectionView;

@property (strong, nonatomic) BN_ShopSorterViewModel *viewModel;

@end

static NSString * const ShopSorterTableCellIdentifier = @"ShopSorterTableCellIdentifier";
static NSString * const ShopSorterCollectCellIdentifier = @"ShopSorterCollectCellIdentifier";

@implementation BN_ShopSorterViewController

- (instancetype)initWith:(long)initialCategoryId
{
    self = [super init];
    if (self) {
        self.viewModel = [[BN_ShopSorterViewModel alloc] init];
        self.viewModel.curCategoryId = initialCategoryId;
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

-(void)loadCustomNavigationButton {
    [super loadCustomNavigationButton];
    @weakify(self);
    UISearchBar *searchBar = [self getSearchBarWithFrame:CGRectMake(0, 0, WIDTH(self.view), 44) withPlaceholder:TEXT(@"请输入产品名称")];
    self.navigationItem.titleView = searchBar;
    [[searchBar rac_searchBarShouldBeginEditingSignal] subscribeNext:^(id x) {
        [searchBar resignFirstResponder];
        @strongify(self);
        BN_ShopSearchViewController *ctr = [[BN_ShopSearchViewController alloc] init];
        [[ctr rac_searchTextDidEndEditingSignal] subscribeNext:^(id x) {
            @strongify(self);
            NSLog(@"=== %@, %@", [x class], x);
            BN_ShopListViewController *listCtr = [[BN_ShopListViewController alloc] initWithGoodName:x];
            [self.navigationController pushViewController:listCtr animated:YES];
            
        }];
        UINavigationController *navCtr = [[UINavigationController alloc]initWithRootViewController:ctr];
        [navCtr setModalPresentationStyle:UIModalPresentationCustom];
        [navCtr setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
        [self presentViewController:navCtr animated:YES completion:nil];
    }];
}

- (void)buildControls {
    self.titleTableView.backgroundColor = ColorWhite;
    self.titleTableView.rowHeight = 48.0f;
    [self.titleTableView registerNib:[BN_ShopSorterTitleCell nib] forCellReuseIdentifier:ShopSorterTableCellIdentifier];
     
    self.contentCollectionView.backgroundColor = ColorBackground;
    [self.contentCollectionView registerNib:[BN_ShopSorterContantCell nib] forCellWithReuseIdentifier:ShopSorterCollectCellIdentifier];
}



#pragma mark - buildViewModel
- (void)buildViewModel {
    if (!self.viewModel) {
        self.viewModel = [[BN_ShopSorterViewModel alloc] init];
    }
    @weakify(self);
    [self.viewModel.categories.loadSupport setDataRefreshblock:^{
        @strongify(self);
        [self.viewModel getTitleDataSourceWith:self.viewModel.categories cellIdentifier:ShopSorterTableCellIdentifier configureCellBlock:^(id cell, BN_ShopCategoryModel *item) {
            [(BN_ShopSorterTitleCell *)cell updateWith:item.name selected:[(BN_ShopSorterTitleCell *)cell isSelected]];
        }];
        [self.viewModel getSecondDataSourceWith:nil cellIdentifier:ShopSorterCollectCellIdentifier configureCellBlock:^(id cell, BN_ShopSecondCategoryModel *item) {
            [(BN_ShopSorterContantCell *)cell updateWith:item.name iconUrl:item.pic_horizontal_url];
        }];

        self.titleTableView.dataSource = self.viewModel.titleDataSource;
        self.contentCollectionView.dataSource = self.viewModel.secondCategoryDataSource;
        NSInteger tableCellIndex = 0;
        BN_ShopCategoryModel *categoryM = [self.viewModel.categories bk_match:^BOOL(id obj) {
            return [(BN_ShopCategoryModel*)obj category_id] == self.viewModel.curCategoryId;
        }];
        if (categoryM) {
            tableCellIndex = [self.viewModel.categories indexOfObject:categoryM];
        } else {
            categoryM = self.viewModel.categories.firstObject;
            self.viewModel.curCategoryId = [(BN_ShopCategoryModel *)self.viewModel.categories.firstObject category_id];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.titleTableView reloadData];
            [self.contentCollectionView reloadData];
            [self.titleTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:tableCellIndex inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
        });
        
        
        [self buildSecondDataSource:categoryM];
        
    }];
    [self.titleTableView setTableViewData:self.viewModel.categories];
    [self.titleTableView setBn_data:self.viewModel.categories];
    [self.titleTableView loadData:self.viewModel.categories];
    [self.titleTableView setRefreshBlock:^{
        @strongify(self);
        [self.viewModel getCategories];
    }];
    [self.viewModel getCategories];
}


- (void)buildSecondDataSource:(BN_ShopCategoryModel *)model {
    if (model.secondCategories.count) {
        [self.viewModel getSecondDataSourceWith:model.secondCategories];
        [self.contentCollectionView reloadData];
        return;
    }
    @weakify(self);
    @weakify(model);
    [model.secondCategories.loadSupport setDataRefreshblock:^{
        @strongify(self);
        @strongify(model);
        if (model.category_id == self.viewModel.curCategoryId) {
            [self.viewModel getSecondDataSourceWith:model.secondCategories];
            [self.contentCollectionView reloadData];
        }
    }];
    [self.contentCollectionView setBn_data:model.secondCategories];
    [self.contentCollectionView setCollectionViewData:model.secondCategories];
    [self.contentCollectionView loadData:model.secondCategories];
    [self.contentCollectionView setRefreshBlock:^{
        @strongify(self);
        [self.viewModel getSecondCategories:model];
    }];
    [self.viewModel getSecondCategories:model];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 47.0f;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BN_ShopCategoryModel *model = [self.viewModel.titleDataSource itemAtIndexPath:indexPath];
    if (model) {
        self.viewModel.curCategoryId = model.category_id;
        [self buildSecondDataSource:model];
    }
    [self.contentCollectionView reloadData];
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    
    BN_ShopSecondCategoryModel *model = [self.viewModel.secondCategoryDataSource itemAtIndexPath:indexPath];
    BN_ShopListViewController *ctr = [[BN_ShopListViewController alloc] initWithCategoryId:model.category_id];
    [self.navigationController pushViewController:ctr animated:YES];
    
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = WIDTH(collectionView) / 2.0;
    return CGSizeMake(width, width+30);
}

//cell的最小行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}

//cell的最小列间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 20, 0);
}
@end
