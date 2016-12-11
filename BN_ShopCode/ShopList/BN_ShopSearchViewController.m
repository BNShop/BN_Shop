//
//  BN_ShopSearchViewController.m
//  BN_Shop
//
//  Created by Liya on 16/11/16.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "BN_ShopSearchViewController.h"
#import "Base_BaseViewController+ControlCreate.h"

#import "BN_ShopSearchViewModel.h"
#import "BN_ShopSearchResultViewModel.h"
#import "UISearchBar+RAC.h"
#import "PureLayout.h"
#import "NSString+TPCategory.h"
#import "BN_ShopHeader.h"

#import "BN_ShopBannerCell.h"
#import "BN_ShopSearchCollectionReusableView.h"
#import "ShopSearchResultCell.h"
#import "UIScrollView+MJRefresh.h"
#import "UIView+LoadCategory.h"

@interface BN_ShopSearchViewController () <BN_ShopSearchViewControllerDelegate>

@property (strong, nonatomic) UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) BN_ShopSearchViewModel *viewModel;
@property (strong, nonatomic) BN_ShopSearchResultViewModel *resultViewModel;

@end

static NSString * const ShopSearchCellIdentifier = @"ShopSearchCellIdentifier";
static NSString * const ShopSearchReminderCellIdentifier = @"ShopSearchReminderCellIdentifier";
static NSString * const ShopSearchSupplementaryIdentifier = @"ShopSearchSupplementaryIdentifier";
static NSString * const ShopSearchResultCellIdentifier = @"ShopSearchResultCellIdentifier";

@implementation BN_ShopSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self buildViewModel];
    [self buildResultDataSource];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)buildControls {
    [super buildControls];
    self.view.backgroundColor = ColorBackground;
    [self.collectionView registerNib:[BN_ShopBannerCell nib] forCellWithReuseIdentifier:ShopSearchCellIdentifier];
    [self.collectionView registerNib:[BN_ShopSearchCollectionReusableView nib] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:ShopSearchSupplementaryIdentifier];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:ShopSearchReminderCellIdentifier];
    [self.collectionView registerNib:[ShopSearchResultCell nib] forCellWithReuseIdentifier:ShopSearchResultCellIdentifier];
}

- (void)loadCustomNavigationButton {
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = nil;
    
    UISearchBar *searchBar = [self getSearchBarWithoutIconWithFrame:CGRectMake(0, 0, WIDTH(self.view), 44) withPlaceholder:TEXT(@"输入关键字搜索")];
    self.navigationItem.titleView = searchBar;
    @weakify(self);
//    [[searchBar rac_searchBarShouldBeginEditingSignal] subscribeNext:^(id x) {
//        @strongify(self);
//        NSString *text = [(UISearchBar *)x text];
//        if (text.length == 0) {
//            [self changeDelegateToSearch];
//        }
//    }];
    
    
    [[searchBar rac_searchBarSearchButtonClickedSignal] subscribeNext:^(id x) {
        @strongify(self);
        [self searchTextDidEnd:[(UISearchBar *)x text]];
        [searchBar resignFirstResponder];
    }];
    
    [[searchBar rac_searchBarCancelButtonClickedSignal] subscribeNext:^(id x) {
        @strongify(self);
        if ([self.delegate respondsToSelector:@selector(searchDismiss)]) {
            [self.delegate searchDismiss];
        }
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }];
    [searchBar becomeFirstResponder];
    self.searchBar = searchBar;
}

- (void)setControlsFrame {
    
}

- (void) searchTextDidEnd:(NSString *)text{
    text = [text Trim];
    [self.resultViewModel.resultDataSource.items removeAllObjects];
    if (text.length > 0) {
        [self.viewModel addSearchToLocalWith:text];
        self.resultViewModel.keyWord = text;
        [self changeDelegateToResult];
    } else {
        [self changeDelegateToSearch];
    }
}

#pragma mark - viewModel
- (void)changeDelegateToSearch {
    @weakify(self);
    
    
    
    [self.collectionView setBn_data:self.viewModel.tags];
    
    self.collectionView.mj_footer = nil;
    self.collectionView.mj_header = nil;
    [self.collectionView setRefreshBlock:^{
        @strongify(self);
        [self.viewModel getHotSearchTagsDataRes];
    }];
    [self.collectionView loadData:nil];
    [self.viewModel.tags.loadSupport setDataRefreshblock:^{
        @strongify(self);
        [self buildViewDataSourceWith:[self.viewModel getRecentlySearchCache] hots:self.viewModel.tags];
        if (self.collectionView.dataSource == self.viewModel.dataSource) {
            [self.collectionView reloadData];
        }
    }];
    self.collectionView.dataSource = self.viewModel.dataSource;
    self.collectionView.delegate = self.viewModel;
    [self.collectionView reloadData];
    
}

- (void)buildViewModel {
    self.viewModel = [[BN_ShopSearchViewModel alloc] init];
    NSArray *recentlys = [self.viewModel getRecentlySearchCache];
    NSArray *hots = [self.viewModel getHotSearchCache];
    [self buildViewDataSourceWith:recentlys hots:hots];
    
    @weakify(self);
    self.viewModel.collectionSelectBlock = ^(NSString *search){
        @strongify(self);
        self.searchBar.text = search;
        [self searchTextDidEnd:search];
    };
    self.viewModel.collectionScrollBlock = ^{
        @strongify(self);
        [self.collectionView.noDataView removeFromSuperview];
        [self.collectionView.netLoadView removeFromSuperview];
        if (self.collectionView.dataSource != self.viewModel.dataSource) {
            [self changeDelegateToSearch];
        }
        [self.searchBar resignFirstResponder];
    };
    [self changeDelegateToSearch];
    
    [self.viewModel getHotSearchTagsDataRes];
}


- (void)changeDelegateToResult {
    @weakify(self);
    [self.collectionView setCollectionViewData:self.resultViewModel.resultDataSource.items];
    [self.collectionView setBn_data:self.resultViewModel.resultDataSource.items];
    [self.collectionView setHeaderRefreshDatablock:^{
        @strongify(self);
        [self.resultViewModel getSearchResultDataRes:YES keyword:self.resultViewModel.keyWord];
    } footerRefreshDatablock:^{
        @strongify(self);
        [self.resultViewModel getSearchResultDataRes:NO keyword:self.resultViewModel.keyWord];
    }];
    [self.collectionView setRefreshBlock:^{
        @strongify(self);
        [self.resultViewModel getSearchResultDataRes:YES keyword:self.resultViewModel.keyWord];
    }];
    [self.collectionView loadData:self.resultViewModel.resultDataSource.items];
    [self.resultViewModel.resultDataSource.items.loadSupport setDataRefreshblock:^{
        @strongify(self);
        if (self.collectionView.dataSource == self.resultViewModel.resultDataSource) {
            [self.collectionView reloadData];
        }
    }];
    self.collectionView.dataSource = self.resultViewModel.resultDataSource;
    self.collectionView.delegate = self.resultViewModel;
    [self.collectionView reloadData];
    [self.resultViewModel getSearchResultDataRes:YES keyword:self.resultViewModel.keyWord];
    
}

- (void)buildResultDataSource {
    self.resultViewModel = [[BN_ShopSearchResultViewModel alloc] init];
    [self.resultViewModel.resultDataSource resetellIdentifier:ShopSearchResultCellIdentifier configureCellBlock:^(ShopSearchResultCell *cell, id item) {
        [cell updateWith:item];
    }];
    @weakify(self);
    self.resultViewModel.collectionSelectBlock = ^(NSString *result) {
        @strongify(self);
        if ([self.delegate respondsToSelector:@selector(searchTextDidEndEditing:)]) {
            [self.delegate searchTextDidEndEditing:result];
        }
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    };
    self.resultViewModel.collectionScrollBlock = ^{
        @strongify(self);
        [self.searchBar resignFirstResponder];
        if (self.resultViewModel.resultDataSource.getItemsCount == 0) {
            if (self.collectionView.dataSource != self.viewModel.dataSource) {
                [self changeDelegateToSearch];
            }
        }
    };
}

- (void)buildViewDataSourceWith:(NSArray *)recentlys hots:(NSArray *)hots {
    
    [self.viewModel.dataSource resetSections:nil];
    
    NSArray *titles = @[TEXT(@"最近搜索"), TEXT(@"热门搜索")];
    NSArray *images = @[@"Shop_Screen_Brand", @"Shop_Screen_Tag"];
    NSArray *warnings = @[TEXT(@"暂无最近搜索"), TEXT(@"暂无热门搜索")];
    NSArray *searchs = @[recentlys, hots];
    
    @weakify(self);
    for (NSInteger index = 0; index < [searchs count]; index++) {
        SectionDataSource *section = nil;
        
        NSString *title = [titles objectAtIndex:index];
        NSArray *array = [searchs objectAtIndex:index];
        
        if ([array count] == 0) {
            section = [self.viewModel getSectionDataSourceWith:title tagged:[warnings objectAtIndex:index] items:@[[warnings objectAtIndex:index]] cellIdentifier:ShopSearchReminderCellIdentifier sectionIdentifier:ShopSearchSupplementaryIdentifier configureCellBlock:^(id cell, id item) {
                UILabel *label = [(UICollectionViewCell *)cell viewWithTag:-1];
                if (!label) {
                    label = [[UILabel alloc] init];
                    label.font = Font12;
                    label.textColor = ColorLine;
                    label.textAlignment = NSTextAlignmentCenter;
                    [[(UICollectionViewCell *)cell contentView] addSubview:label];
                    [label autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:[(UICollectionViewCell *)cell contentView]];
                    [label autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:[(UICollectionViewCell *)cell contentView]];
                    [label autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:[(UICollectionViewCell *)cell contentView]];
                    [label autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:[(UICollectionViewCell *)cell contentView]];
                }
                label.text = item;
            } configureSectionBlock:^(UIView *view, id sectionDataSource, NSString *kind, NSIndexPath *indexPath) {
                
                [(BN_ShopSearchCollectionReusableView *)view updateWith:[(SectionDataSource *)sectionDataSource Icon] title:[(SectionDataSource *)sectionDataSource Title]];
                if (indexPath.section == 0) {
                    [(BN_ShopSearchCollectionReusableView *)view addOkEventHandler:^(id sender) {
                        @strongify(self);
                        [self.viewModel delSearchLocal];
                        [self.collectionView reloadData];
                    }];
                } else {
                    [(BN_ShopSearchCollectionReusableView *)view addOkEventHandler:nil];
                }
            }];
        } else {
            section = [self.viewModel getSectionDataSourceWith:title tagged:nil items:array cellIdentifier:ShopSearchCellIdentifier sectionIdentifier:ShopSearchSupplementaryIdentifier configureCellBlock:^(id cell, id item) {
                [(BN_ShopBannerCell *)cell updateWith:item];
            } configureSectionBlock:^(UIView *view, id sectionDataSource, NSString *kind, NSIndexPath *indexPath) {
                [(BN_ShopSearchCollectionReusableView *)view updateWith:[(SectionDataSource *)sectionDataSource Icon] title:[(SectionDataSource *)sectionDataSource Title]];
                if (indexPath.section == 0) {
                    [(BN_ShopSearchCollectionReusableView *)view addOkEventHandler:^(id sender) {
                        @strongify(self);
                        [self.viewModel delSearchLocal];
                        [self buildViewModel];
                    }];
                } else {
                    [(BN_ShopSearchCollectionReusableView *)view addOkEventHandler:nil];
                }
            }];
        }
        
        [self.viewModel addDataSourceWith:section];
        section.Icon = [images objectAtIndex:index];
    }
    
    self.collectionView.dataSource = self.viewModel.dataSource;
    [self.collectionView reloadData];
}

@end

@implementation BN_ShopSearchViewController (RAC)
- (RACSignal *)rac_searchTextDidEndEditingSignal
{
    self.delegate = self;
    RACSignal *signal = objc_getAssociatedObject(self, _cmd);
    if (signal != nil) {
        return signal;
    }
    
    signal = [[self rac_signalForSelector:@selector(searchTextDidEndEditing:) fromProtocol:@protocol(BN_ShopSearchViewControllerDelegate)] map:^id(RACTuple *tuple) {
        return tuple.first;
    }];
    
    objc_setAssociatedObject(self, _cmd, signal, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return signal;
}

- (RACSignal *)rac_searchDismissSignal
{
    self.delegate = self;
    RACSignal *signal = objc_getAssociatedObject(self, _cmd);
    if (signal != nil) {
        return signal;
    }
    
    signal = [[self rac_signalForSelector:@selector(searchDismiss) fromProtocol:@protocol(BN_ShopSearchViewControllerDelegate)] map:^id(RACTuple *tuple) {
        return tuple;
    }];
    
    objc_setAssociatedObject(self, _cmd, signal, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return signal;
}

@end
