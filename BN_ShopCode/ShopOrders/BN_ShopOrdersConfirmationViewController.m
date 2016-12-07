//
//  BN_ShopOrdersConfirmationViewController.m
//  BN_Shop
//
//  Created by Liya on 16/11/14.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "BN_ShopOrdersConfirmationViewController.h"
#import "Base_BaseViewController+ControlCreate.h"
#import "BN_ShopOrderDetailViewController.h"
#import "LBB_OrderViewController.h"
#import "LBB_OrderModuleViewController.h"

#import "BN_ShopOrderBillView.h"
#import "BN_ShopOrdersToolBar.h"
#import "BN_ShopOrderUserProfileView.h"
#import "BN_ShopOrdersItemCell.h"
#import "BN_ShopOrderNumberView.h"
#import "BN_ShopOrderUsePointView.h"

#import "BN_ShopOrderUserProfileViewModel.h"
#import "BN_ShopOrdersConfirmationViewModel.h"

#import "PureLayout.h"
#import "UIView+BlocksKit.h"

#import "BN_ShopOrderItemProtocol.h"

@interface BN_ShopOrdersConfirmationViewController ()

@property (strong, nonatomic) BN_ShopOrdersConfirmationViewModel *confirmationviewModel;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) BN_ShopOrderUserProfileView *userView;
@property (strong, nonatomic) BN_ShopOrderBillView *billView;
@property (strong, nonatomic) BN_ShopOrderUsePointView *pointView;
@property (strong, nonatomic) BN_ShopOrdersToolBar *toolBar;

@end

static NSString * const ShopOrdersConfirmationTableCellIdentifier = @"ShopOrdersConfirmationTableCellIdentifier";

@implementation BN_ShopOrdersConfirmationViewController

- (instancetype)initWith:(NSArray *)shoppingCartIds numbers:(NSArray *)numbers {
    if (self = [super init]) {
        self.confirmationviewModel = [[BN_ShopOrdersConfirmationViewModel alloc] init];
        
        self.confirmationviewModel.shoppingCartIds = [shoppingCartIds componentsJoinedByString:@","];
        self.confirmationviewModel.numbers = [numbers componentsJoinedByString:@","];
    }
    return self;
}

- (instancetype)initWithSpecial:(long)goodid num:(int)num {
    if (self = [super init]) {
        self.confirmationviewModel = [[BN_ShopOrdersConfirmationViewModel alloc] init];
        self.confirmationviewModel.goodsId = goodid;
        self.confirmationviewModel.num = num;
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
    self.title = TEXT(@"确定订单");
    
    self.tableView.rowHeight = 112.0f;
    [self.tableView registerNib:[BN_ShopOrdersItemCell nib] forCellReuseIdentifier:ShopOrdersConfirmationTableCellIdentifier];
    self.tableView.separatorColor = ColorLine;
    self.tableView.backgroundColor = ColorWhite;
}

#pragma mark - buildViewModel
- (void)buildViewModel {
    __weak typeof(self) temp = self;
    [self.confirmationviewModel getShoppingOrderConfirmationDetail:^{
        for (BN_ShopConfirmOrderItemModel *sectionModel in self.confirmationviewModel.ordreModel.resultMap.rows) {
            SectionDataSource *section = [temp.confirmationviewModel getSectionDataSourceWith:nil items:sectionModel.shoppingCartList cellIdentifier:ShopOrdersConfirmationTableCellIdentifier configureCellBlock:^(BN_ShopOrdersItemCell *cell, BN_ShopOrderCartItemModel *item) {
                [cell updateWith:[item pic_url] title:[item goods_name] num:[item goods_num] price:[item real_price] specification:[item standard]];
            } configureSectionBlock:nil];
            [temp.confirmationviewModel addDataSourceWith:section];
        }
        [temp buildUserView];
        [temp buildToolView];
        
        temp.tableView.dataSource = temp.confirmationviewModel.dataSource;
        [temp.tableView reloadData];
        
        [temp buildTableFooterView];
        
    } failure:^(NSString *errorDescription) {
        [self showHudError:errorDescription title:@"获取订单失败"];
        [self.navigationController popViewControllerAnimated:YES];
    }];
}


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return self.userView;
    } else {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = ColorBackground;
        return view;
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return self.userView.getViewHeight;
    }
    return 5;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (self.confirmationviewModel.submenu) {
        BN_ShopConfirmOrderItemModel *item = [self.confirmationviewModel.ordreModel.resultMap.rows objectAtIndex:section];
        return [self getFooterInSectionView:item];
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (self.confirmationviewModel.submenu) {
        return 90;
    }
    return 0.01f;
}


#pragma mark - bill and profile view
- (UIView *)getFooterInSectionView:(BN_ShopConfirmOrderItemModel *)item {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self.view), 90.0f)];

    
    BN_ShopOrderNumberView *freightView = [BN_ShopOrderNumberView nib];
    if (item.freight_price) {
        [freightView updateWith:@"运费" content:[item freightPriceStr]];
    } else {
        [freightView updateWith:@"运费" content:@"免运费"];
    }
    freightView.frame = CGRectMake(0, 0, WIDTH(self.tableView), 45.0);
    
    BN_ShopOrderNumberView *priceView = [BN_ShopOrderNumberView nib];
    [priceView udatewithContentAttr:[item totalPriceAttributed]];
    priceView.frame = CGRectMake(0, 45.0, WIDTH(self.tableView), 45.0);
    
    [view addSubview:freightView];
    [view addSubview:priceView];
    
    
    return view;
}

- (void)buildToolView {
    self.toolBar = [BN_ShopOrdersToolBar nib];
    [self.view addSubview:self.toolBar];
    self.toolBar.frame = CGRectMake(0, HEIGHT(self.view)-self.toolBar.getViewHeight, WIDTH(self.view), self.toolBar.getViewHeight);
    @weakify(self);
    [self.toolBar placeAnOrderWith:^(id sender) {
        @strongify(self);
        [self.confirmationviewModel getShoppingOrderDetail:^(NSArray *orderIds) {
            //下单成功的处理
            UINavigationController *nav = self.navigationController;
            [self.navigationController popViewControllerAnimated:NO];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"BN_ShopOrdersConfirmation" object:nil];
            if (orderIds.count > 1) {
//                LBB_OrderViewController *ctr = [[LBB_OrderViewController alloc] initWithNibName:@"LBB_OrderViewController" bundle:nil];
//                ctr.baseViewType  = eOrderType_WaitPay;
                LBB_OrderModuleViewController *ctr = [[LBB_OrderModuleViewController alloc] init];
                [nav pushViewController:ctr animated:YES];
            } else {
                long orderid = [[orderIds firstObject] longValue];
                BN_ShopOrderDetailViewController *ctr = [[BN_ShopOrderDetailViewController alloc] initWith:[NSString stringWithFormat:@"%ld", orderid]];
                [nav pushViewController:ctr animated:YES];
            }
            
            
        } failure:^(NSString *errorDescription) {
            [self showHudError:errorDescription title:@"下单失败"];
        }];

    }];
    [self.toolBar updateWith:[self.confirmationviewModel realNeedPayStr]];
}

- (void)buildUserView {
    self.userView = [BN_ShopOrderUserProfileView nib];
    [self.userView updateWith:self.confirmationviewModel.ordreModel.userAddress.name tel:self.confirmationviewModel.ordreModel.userAddress.telNum tagged:NO provinces:[self.confirmationviewModel.ordreModel.userAddress provinceAndCity] street:self.confirmationviewModel.ordreModel.userAddress.address];
    self.userView.frame = CGRectMake(0, 0, WIDTH(self.view), self.userView.getViewHeight);
    [self.userView bk_whenTapped:^{
#warning 跳转去改变地址
//        把地址ID给self.confirmationviewModel.ordreModel.userAddress.address_id （long）
    }];

}

- (void)buildBillView {
    self.billView = [BN_ShopOrderBillView nib];
    [self.billView updateWith:[self.confirmationviewModel shopAcountStr] pointDeduction:[self.confirmationviewModel shopVailableStr] freight:[self.confirmationviewModel shopFreightStr]];
}

- (void)buildPointView {
    self.pointView = [BN_ShopOrderUsePointView nib];
    [self.pointView updateWith:[self.confirmationviewModel.ordreModel vailableUseStr] deductioned:NO];
    @weakify(self);
    [self.pointView addDeductionedPointForSelectedWithTask:^(BOOL deductioned) {
        @strongify(self);
        if (self.confirmationviewModel.userVailable != deductioned) {
            
            self.confirmationviewModel.userVailable = deductioned;
            [self.billView updateWith:[self.confirmationviewModel shopAcountStr] pointDeduction:[self.confirmationviewModel shopVailableStr] freight:[self.confirmationviewModel shopFreightStr]];
            [self.toolBar updateWith:[self.confirmationviewModel realNeedPayStr]];
        }
    }];
}


- (void)buildTableFooterView {
    [self buildBillView];
    [self buildPointView];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self.tableView), self.billView.getViewHeight+self.pointView.getViewHeight+5)];
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self.view), 5)];
    lineView.backgroundColor = ColorBackground;
    [view addSubview:lineView];
    [view addSubview:self.billView];
    [view addSubview:self.pointView];
    self.billView.frame = CGRectMake(0, self.pointView.getViewHeight+5, WIDTH(self.tableView), self.billView.getViewHeight);
    self.pointView.frame = CGRectMake(0, 5, WIDTH(self.tableView), self.pointView.getViewHeight);
    [self.tableView beginUpdates];
    self.tableView.tableFooterView = view;
    [self.tableView endUpdates];
    
}

@end
