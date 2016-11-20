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
#import "BN_ShoppingCartItemProtocol.h"

#import "TestCartItem.h"


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
    self.viewModel = [[BN_ShoppingCartViewModel alloc] init];
    
    @weakify(self);
    [self.viewModel bk_addObserverForKeyPath:@"edit" options:NSKeyValueObservingOptionNew task:^(id obj, NSDictionary *change) {
        @strongify(self);
        BOOL isEdit = [[change objectForKey:@"new"] boolValue];
        self.endView.edit = isEdit;
        self.navigationItem.rightBarButtonItem.title = isEdit ? TEXT(@"完成") : TEXT(@"编辑");
    }];
    [self testObects];
    
    
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
    self.tableView.sectionHeaderHeight = 36.0f;
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

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    BN_ShoppingCartHeardView *heardView = [BN_ShoppingCartHeardView nib];
    SectionDataSource *sectionDataSource = [self.viewModel.dataSource sectionAtIndex:section];
    [heardView updateWith:sectionDataSource.Title roundUpTitle:sectionDataSource.tagged roundUpBlock:^(id obj) {
//        NSLog(@"section = %d", section);
    }];
    return heardView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 36.0f;//通过这个方法设置高度，要不第一个heaerview不现实
}
#pragma mark - BN_ShoppingCartEndViewDelegate
- (void)selectAll:(BOOL)isSelect {
    [self.viewModel selectAll:!isSelect];
    [self.endView updateWith:[self.viewModel selectedItemPriceShow] settlementTitle:[self.viewModel settlementCount]];
    [self.tableView reloadData];
}

- (void)deleteTagger {
    [self.viewModel clearSelectedItems];
    self.viewModel.edit = NO;
    [self.endView updateWith:[self.viewModel selectedItemPriceShow] settlementTitle:[self.viewModel settlementCount]];
    [self.tableView reloadData];
}

- (void)settlementTagger {
    NSArray *array = [self.viewModel settlementSelectedItems];
    if ([array count] > 0) {
#warning 跳转到确定订单页面并传值
        BN_ShopOrdersConfirmationViewController *ctr = [[BN_ShopOrdersConfirmationViewController alloc] init];
        [self.navigationController pushViewController:ctr animated:YES];
    }

}

#pragma mark - BN_ShoppingCartCellDelegate
- (void)selectActionWith:(UITableViewCell *)cell selected:(BOOL)selected {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    id<BN_ShoppingCartItemProtocol> object = [self.viewModel.dataSource itemAtIndexPath:indexPath];
    [object setSelected:selected];
    
    [self.endView updateWith:[self.viewModel selectedItemPriceShow] settlementTitle:[self.viewModel settlementCount]];
    
}

- (void)valueChangedWith:(UITableViewCell *)cell count:(float)count {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    id<BN_ShoppingCartItemProtocol> object = [self.viewModel.dataSource itemAtIndexPath:indexPath];
    [object setNum:count];
    if ([object isSelected]) {
        [self.endView updateWith:[self.viewModel selectedItemPriceShow] settlementTitle:[self.viewModel settlementCount]];
    }
}


#pragma mark - test
- (void)testObects {
    for (NSInteger i=0; i<3; i++) {
        NSMutableArray *array = [NSMutableArray array];
        for (NSInteger j=0; j<i+3; j++) {
            TestCartItem *item = [[TestCartItem alloc] init];
            item.selected = YES;
            item.front_price = [NSString stringWithFormat:@"%ld", i+j];
            item.real_price = [NSString stringWithFormat:@"%ld", (long)j];
            item.num = j;
            [array addObject:item];
        }
        
        SectionDataSource *section = [self.viewModel getSectionDataSourceWith:[NSString stringWithFormat:@"上海标题:%ld", (long)i] items:array cellIdentifier:ShoppingCartTableCellIdentifier configureCellBlock:^(id cell, id<BN_ShoppingCartItemProtocol> item) {
            [(BN_ShoppingCartCell *)cell updateWith:[item isSelected] thumbnailUrl:@"http://2f.zol-img.com.cn/product/100/939/ceiLvj7vpOz0Y.jpg" title:[@"全面深化改革走过了三年的历程。三年虽短，但在以习近平同志为核心的党中央领导下,中国大地上却有数不清的改变在发生，亿万人的力量在汇聚，延展为中国现代化进程中精华荟萃的特殊单元" substringToIndex:random()%30] num:[item num] price:[item real_price]];
            [(BN_ShoppingCartCell *)cell setDelegate:self];
        } configureSectionBlock:^(UIView *view, id sectionDataSource, NSString *kind, NSIndexPath *indexPath) {
            NSLog(@"section = %ld", (long)indexPath.section);
        }];
        [self.viewModel addDataSourceWith:section];
    }
    self.tableView.dataSource = self.viewModel.dataSource;
    [self.endView updateWith:[self.viewModel selectedItemPriceShow] settlementTitle:[self.viewModel settlementCount]];
    [self.tableView reloadData];
}

@end
