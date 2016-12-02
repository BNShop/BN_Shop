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
#import "UISearchBar+RAC.h"
#import "PureLayout.h"

#import "BN_ShopBannerCell.h"
#import "BN_ShopSearchCollectionReusableView.h"

@interface BN_ShopSearchViewController () <UICollectionViewDelegate, BN_ShopSearchViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) BN_ShopSearchViewModel *viewModel;

@end

static NSString * const ShopSearchCellIdentifier = @"ShopSearchCellIdentifier";
static NSString * const ShopSearchReminderCellIdentifier = @"ShopSearchReminderCellIdentifier";
static NSString * const ShopSearchSupplementaryIdentifier = @"ShopSearchSupplementaryIdentifier";

@implementation BN_ShopSearchViewController

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
    self.view.backgroundColor = ColorBackground;
    self.collectionView.delegate = self;
    [self.collectionView registerNib:[BN_ShopBannerCell nib] forCellWithReuseIdentifier:ShopSearchCellIdentifier];
    [self.collectionView registerNib:[BN_ShopSearchCollectionReusableView nib] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:ShopSearchSupplementaryIdentifier];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:ShopSearchReminderCellIdentifier];
}

- (void)loadCustomNavigationButton {
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = nil;
    
    UISearchBar *searchBar = [self getSearchBarWithoutIconWithFrame:CGRectMake(0, 0, WIDTH(self.view), 44) withPlaceholder:TEXT(@"输入关键字搜索")];
    self.navigationItem.titleView = searchBar;
    @weakify(self);
    [[searchBar rac_searchBarSearchButtonClickedSignal] subscribeNext:^(id x) {
        @strongify(self);
        [self searchTextDidEnd:[(UISearchBar *)x text]];
    }];
    
    [[searchBar rac_searchBarCancelButtonClickedSignal] subscribeNext:^(id x) {
        @strongify(self);
        if ([self.delegate respondsToSelector:@selector(searchDismiss)]) {
            [self.delegate searchDismiss];
        }
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }];
    [searchBar becomeFirstResponder];
}

- (void)setControlsFrame {
    
}

- (void) searchTextDidEnd:(NSString *)text{
    [self.viewModel addSearchToLocalWith:text];
    
    if ([self.delegate respondsToSelector:@selector(searchTextDidEndEditing:)]) {
        [self.delegate searchTextDidEndEditing:text];
    }
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - viewModel
- (void)buildViewModel {
    self.viewModel = [[BN_ShopSearchViewModel alloc] init];
    NSArray *recentlys = [self.viewModel getRecentlySearchCache];
    NSArray *hots = [self.viewModel getHotSearchCache];
    [self buildViewDataSourceWith:recentlys hots:hots];
    
    @weakify(self);
//    [self.collectionView setHeaderRefreshDatablock:^{
//        @strongify(self);
//        [self.viewModel getHotSearchTagsDataRes];
//    } footerRefreshDatablock:nil];
    
    [self.collectionView setCollectionViewData:self.viewModel.tags];
    [self.collectionView setBn_data:self.viewModel.tags];
    [self.collectionView setRefreshBlock:^{
        @strongify(self);
        [self.viewModel getHotSearchTagsDataRes];
    }];
    [self.viewModel.tags.loadSupport setDataRefreshblock:^{
        @strongify(self);
        [self buildViewDataSourceWith:[self.viewModel getRecentlySearchCache] hots:self.viewModel.tags];
        [self.collectionView reloadData];
    }];
    [self.collectionView reloadData];
    
    [self.viewModel getHotSearchTagsDataRes];
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

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];

    NSString *search = [self.viewModel validSearch:indexPath];
    if (search) {
        [self searchTextDidEnd:search];
    } else if (indexPath.section == 1) {
    }
    
}


- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    SectionDataSource *section = [self.viewModel.dataSource sectionAtIndex:indexPath.section];
    if (section.tagged && [section getItemsCount] == 1) {
        CGFloat width = (WIDTH(collectionView) - 14*2);
        return CGSizeMake(width, 40);
        
    } else {
        CGFloat width = (WIDTH(collectionView) - 5*2 - 14*2) / 3.0;
        return CGSizeMake(width, 26);
    }
    
}

//cell的最小行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 6.0;
}

//cell的最小列间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 5.0;
}

//内馅
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(6, 14, 6, 14);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(WIDTH(collectionView), 36.0f);
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
