//
//  BN_ShoppingcartViewController.m
//  BN_Shop
//
//  Created by Liya on 16/11/12.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "BN_ShoppingcartViewController.h"
#import "BN_ShopOrdersConfirmationViewController.h"
#import "BN_ShoppingCartHeardView.h"
#import "BN_ShoppingCartEndView.h"
#import "BN_ShoppingCartCell.h"
#import "BN_ShoppingCartViewModel.h"
#import "UIBarButtonItem+BlocksKit.h"

#import "PureLayout.h"
#import "NSObject+BKBlockObservation.h"

#import "NSArray+BlocksKit.h"


@interface BN_ShoppingcartViewController () <UITableViewDelegate, BN_ShoppingCartEndViewDelegate, BN_ShoppingCartCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) BN_ShoppingCartEndView *endView;
@property (strong, nonatomic) BN_ShoppingCartViewModel *viewModel;


@end

static NSString * const ShoppingCartTableCellIdentifier = @"ShoppingCartTableCellIdentifier";

@implementation BN_ShoppingcartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self buildViewModel];
    
    
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"BN_ShopOrdersConfirmation" object:nil] subscribeNext:^(id x) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self deleteTagger];
        });
    }];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)buildControls {
    [super buildControls];
    
    self.title = TEXT(@"购物车");
    self.endView = [BN_ShoppingCartEndView nib];
    [self.view addSubview:self.endView];
    [self.endView autoSetDimension:ALDimensionHeight toSize:[self.endView getViewHeight]];
    [self.endView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view];
    [self.endView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view];
    [self.endView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.view];
    self.endView.delegate = self;
    
    
    self.tableView.rowHeight = 135.0f;
//    self.tableView.sectionHeaderHeight = 36.0f;
    [self.tableView registerNib:[BN_ShoppingCartCell nib] forCellReuseIdentifier:ShoppingCartTableCellIdentifier];
    self.tableView.backgroundColor = ColorWhite;
}

- (void)loadCustomNavigationButton {
    [super loadCustomNavigationButton];
    
    @weakify(self);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:TEXT(@"编辑") style:UIBarButtonItemStylePlain handler:^(id sender) {
        @strongify(self);
        self.viewModel.edit = !self.viewModel.edit;
    }];
    self.navigationItem.rightBarButtonItem.tintColor = ColorBlack;
}

#pragma mark - viewModel
- (void)buildViewModel {
    self.viewModel = [[BN_ShoppingCartViewModel alloc] init];
    
    @weakify(self);
    [self.viewModel bk_addObserverForKeyPath:@"edit" options:NSKeyValueObservingOptionNew task:^(id obj, NSDictionary *change) {
        @strongify(self);
        BOOL isEdit = [[change objectForKey:@"new"] boolValue];
        self.endView.edit = isEdit;
        self.navigationItem.rightBarButtonItem.title = isEdit ? TEXT(@"完成") : TEXT(@"编辑");
    }];
    
    self.viewModel.dataSource = [[MultipleSectionTableArraySource alloc] init];
    
    [self.tableView setBn_data:self.viewModel.shoppingCartList];
    [self.tableView loadData:self.viewModel.shoppingCartList];
    [self.tableView setHeaderRefreshDatablock:^{
        @strongify(self);
        [self.viewModel getShoppingCartListData:YES];
    } footerRefreshDatablock:^{
        @strongify(self);
        [self.viewModel getShoppingCartListData:NO];
    }];
    [self.tableView setRefreshBlock:^{
        @strongify(self);
        [self.viewModel getShoppingCartListData:YES];
    }];
    [self.viewModel.shoppingCartList.loadSupport setDataRefreshblock:^{
        @strongify(self);
        
        for (BN_ShoppingCartItemModel *item in self.viewModel.shoppingCartList) {
            SectionDataSource *section =  [self.viewModel getSectionDataSourceWith:nil items:@[item] cellIdentifier:ShoppingCartTableCellIdentifier configureCellBlock:^(id cell, BN_ShoppingCartItemModel *item) {
                [(BN_ShoppingCartCell *)cell updateWith:[item isSelected] thumbnailUrl:item.pic_url title:item.name num:[item num] price:[item real_price]];
                [(BN_ShoppingCartCell *)cell setDelegate:self];
            } configureSectionBlock:nil];
            
            [self.viewModel addDataSourceWith:section];
        }
        self.tableView.dataSource = self.viewModel.dataSource;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.endView updateWith:[self.viewModel selectedItemPriceShow] settlementTitle:[self.viewModel settlementCount]];
            [self.tableView reloadData];
        });
    }];
    [self.viewModel getShoppingCartListData:YES];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    SectionDataSource *sectionDataSource = [self.viewModel.dataSource sectionAtIndex:section];
    if (!sectionDataSource.Title) {
        return nil;
    }
    BN_ShoppingCartHeardView *heardView = [BN_ShoppingCartHeardView nib];
    [heardView updateWith:sectionDataSource.Title roundUpTitle:sectionDataSource.tagged roundUpBlock:^(id obj) {
//        NSLog(@"section = %d", section);
    }];
    return heardView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    SectionDataSource *sectionDataSource = [self.viewModel.dataSource sectionAtIndex:section];
    if (!sectionDataSource.Title) {
        return 0.01;
    }
    return 36.0f;//通过这个方法设置高度，要不第一个heaerview不现实
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 135.0f;
}
#pragma mark - BN_ShoppingCartEndViewDelegate
- (void)selectAll:(BOOL)isSelect {
    [self.viewModel selectAll:!isSelect];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.endView updateWith:[self.viewModel selectedItemPriceShow] settlementTitle:[self.viewModel settlementCount]];
        [self.tableView reloadData];
    });
}

- (void)deleteTagger {
    NSArray *ids = [[self.viewModel settlementSelectedItems] bk_map:^id(BN_ShoppingCartItemModel *obj) {
        return @(obj.shopping_cart_id);
    }];
    if (ids.count == 0) {
        return;
    }
    @weakify(self);
    [self.viewModel deleteShoppingCart:ids success:^{
        @strongify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            self.viewModel.edit = NO;
            [self.endView updateWith:[self.viewModel selectedItemPriceShow] settlementTitle:[self.viewModel settlementCount]];
            [self.tableView reloadData];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"BN_ShopOrdersConfirmation" object:nil];
        });
    } failure:^(NSString *errorDescription) {
        [self showHudPrompt:errorDescription];
    }];
    
}

- (void)settlementTagger {
    NSArray *array = [self.viewModel settlementSelectedItems];
    NSMutableArray *shopIds = [NSMutableArray array];
    NSMutableArray *nums = [NSMutableArray array];
    
    [array bk_each:^(BN_ShoppingCartItemModel *obj) {
        
        [shopIds addObject:@(obj.shopping_cart_id)];
        [nums addObject:@(obj.num)];
    }];
    
    if ([shopIds count] > 0 && [nums count] > 0) {
        BN_ShopOrdersConfirmationViewController *ctr = [[BN_ShopOrdersConfirmationViewController alloc] initWith:shopIds numbers:nums];
        [self.navigationController pushViewController:ctr animated:YES];
    }

}

#pragma mark - BN_ShoppingCartCellDelegate
- (void)selectActionWith:(UITableViewCell *)cell selected:(BOOL)selected {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    id object = [self.viewModel.dataSource itemAtIndexPath:indexPath];
    [object setSelected:selected];
    
    [self.endView updateWith:[self.viewModel selectedItemPriceShow] settlementTitle:[self.viewModel settlementCount]];
    
}

- (void)valueChangedWith:(UITableViewCell *)cell count:(float)count {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    id object = [self.viewModel.dataSource itemAtIndexPath:indexPath];
    [object setNum:count];
    if ([object isSelected]) {
        [self.endView updateWith:[self.viewModel selectedItemPriceShow] settlementTitle:[self.viewModel settlementCount]];
    }
}

@end
