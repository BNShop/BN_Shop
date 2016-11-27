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
#import "Base_BaseViewController+ControlCreate.h"

#import "UIBarButtonItem+BlocksKit.h"
#import "BN_ShopGoodCell.h"
#import "BN_ShopGoodHorizontalCell.h"
#import "BN_ShopListSelectionToolBar.h"

#import "BN_ShopListViewModel.h"
#import "PureLayout.h"
#import "UIView+BlocksKit.h"
#import "UISearchBar+RAC.h"

#import "NSString+Attributed.h"
#import "TestCartItem.h"


@interface BN_ShopListViewController ()<UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) BN_ShopListSelectionToolBar *toolBar;
@property (strong, nonatomic) BN_ShopListViewModel *listViewModel;

@end

static NSString * const ShopListGridCellIdentifier = @"ShopListGridCellIdentifier";
static NSString * const ShopListHorizontalCellIdentifier = @"ShopListHorizontalCellIdentifier";

@implementation BN_ShopListViewController

- (instancetype)initWithCategoryId:(long)CategoryId
{
    self = [super init];
    if (self) {
        
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
#warning 进行数据请求并且对collectiveview刷新
    }];
    [self.toolBar.rac_filterSignal subscribeNext:^(id x) {
        @strongify(self);
        [self.toolBar updateVLineWith:YES];
        
        BN_ShopScreeningConditionsViewController *ctr = [[BN_ShopScreeningConditionsViewController alloc] init];
        ctr.view.backgroundColor = [UIColor clearColor];
        [ctr setModalPresentationStyle:UIModalPresentationCustom];
        [ctr setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
        [self presentViewController:ctr animated:YES completion:nil];
        @weakify(self);
        [[ctr rac_screeningConditionsSignal] subscribeNext:^(id x) {
            
            @strongify(self);
            [self.toolBar updateVLineWith:NO];
#warning 去刷新数据进行数据请求并且对collectiveview刷新
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
         BN_ShopSearchViewController *ctr = [[BN_ShopSearchViewController alloc] init];
        [[ctr rac_searchTextDidEndEditingSignal] subscribeNext:^(id x) {
            @strongify(self);
            NSLog(@"=== %@, %@", [x class], x);
#warning 去刷新数据进行数据请求并且对collectiveview刷新
        }];
        UINavigationController *navCtr = [[UINavigationController alloc]initWithRootViewController:ctr];
        [navCtr setModalPresentationStyle:UIModalPresentationCustom];
        [navCtr setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
        [self presentViewController:navCtr animated:YES completion:nil];
    }];
    
}

#pragma mark - viewModel
- (void)buildViewModel {
    self.listViewModel = [[BN_ShopListViewModel alloc] init];
    [self testObects];
#warning 初始化列表数据等等
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
#warning 跳转到商品详情页
    
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


#pragma mark - data source test

- (void)testObects {
    NSMutableArray *array = [NSMutableArray array];
    for (NSInteger j=0; j<13; j++) {
        TestCartItem *item = [[TestCartItem alloc] init];
        item.front_price = [NSString stringWithFormat:@"%ld", j+1];
        item.real_price = [NSString stringWithFormat:@"%.2f", ((float)j+3)*(random()%30)];
        [array addObject:item];
    }
    
    if (self.listViewModel.isHorizontalCell) {
//        [self.listViewModel getSectionDataSourceWith:array cellIdentifier:ShopListHorizontalCellIdentifier configureCellBlock:^(id cell, TestCartItem *item) {
//            [(BN_ShopGoodHorizontalCell *)cell updateWith:@"http://2f.zol-img.com.cn/product/100/939/ceiLvj7vpOz0Y.jpg" title:[@"全面深化改革走过了三年的历程。三年虽短，但在以习近平同志为核心的党中央领导下,中国大地上却有数不清的改变在发生，亿万人的力量在汇聚，延展为中国现代化进程中精华荟萃的特殊单元" substringToIndex:random()%40] front:item.front_price real:[item.real_price strikethroughAttribute] additional:@"9090条评论"];
//        }];
    } else {
        
//        [self.listViewModel getSectionDataSourceWith:array cellIdentifier:ShopListGridCellIdentifier configureCellBlock:^(id cell, TestCartItem *item) {
//            [(BN_ShopGoodCell *)cell updateWith:@"http://2f.zol-img.com.cn/product/100/939/ceiLvj7vpOz0Y.jpg" title:[@"全面深化改革走过了三年的历程。三年虽短，但在以习近平同志为核心的党中央领导下,中国大地上却有数不清的改变在发生，亿万人的力量在汇聚，延展为中国现代化进程中精华荟萃的特殊单元" substringToIndex:random()%30] front:item.front_price real:[item.real_price strikethroughAttribute] additional:@"9090条评论"];
//        }];
    }
    self.collectionView.dataSource = self.listViewModel.dataSource;
    [self.collectionView reloadData];
}


@end
