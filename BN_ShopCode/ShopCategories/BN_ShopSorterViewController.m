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

#import "BN_ShopSorterTitleCell.h"
#import "BN_ShopSorterContantCell.h"
#import "BN_ShopSorterViewModel.h"

#import "Base_BaseViewController+ControlCreate.h"
#import "UIBarButtonItem+BlocksKit.h"
#import "UISearchBar+RAC.h"


@interface BN_ShopSorterViewController ()<UITableViewDelegate, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UITableView *titleTableView;
@property (weak, nonatomic) IBOutlet UICollectionView *contentCollectionView;

@property (strong, nonatomic) BN_ShopSorterViewModel *viewModel;

@end

static NSString * const ShopSorterTableCellIdentifier = @"ShopSorterTableCellIdentifier";
static NSString * const ShopSorterCollectCellIdentifier = @"ShopSorterCollectCellIdentifier";

@implementation BN_ShopSorterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.viewModel = [[BN_ShopSorterViewModel alloc] init];
    [self.viewModel getTitleDataSourceWith:[NSArray arrayWithObjects:@"台湾伴手礼", @"厦门伴手礼", @"福建伴手礼", nil] cellIdentifier:ShopSorterTableCellIdentifier configureCellBlock:^(id cell, id item) {
        [(BN_ShopSorterTitleCell *)cell updateWith:item selected:[(BN_ShopSorterTitleCell *)cell isSelected]];
    }];
    
    [self.viewModel getSectionDataSourceWith:[NSArray arrayWithObjects:@"木材面包1", @"唱片面包1", @"肉松面包1", @"木材面包2", @"唱片面包2", @"肉松面包2", @"木材面包3", @"唱片面包3", nil] cellIdentifier:ShopSorterCollectCellIdentifier configureCellBlock:^(id cell, id item) {
        [(BN_ShopSorterContantCell *)cell updateWith:item iconUrl:@""];
    }];

    
    self.titleTableView.dataSource = self.viewModel.titleDataSource;
    self.contentCollectionView.dataSource = self.viewModel.selectionDataSource;
    
    [self.titleTableView reloadData];
    [self.contentCollectionView reloadData];
    [self.titleTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
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
            BN_ShopListViewController *listCtr = [[BN_ShopListViewController alloc] init];
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



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 47.0f;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.viewModel setSelectionIndex:indexPath.row];
    [self.contentCollectionView reloadData];
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
#warning 进行页面跳转
    
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
