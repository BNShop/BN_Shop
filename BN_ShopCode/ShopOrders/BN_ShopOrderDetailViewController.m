//
//  BN_ShopOrderDetailViewController.m
//  BN_Shop
//
//  Created by Liya on 2016/12/3.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "BN_ShopOrderDetailViewController.h"
#import "BN_ShopOrderBillView.h"
#import "BN_ShopOrdersToolBar.h"
#import "BN_ShopOrderUserProfileView.h"
#import "BN_ShopOrdersItemCell.h"
#import "BN_ShopOrderServiceStateView.h"
#import "BN_ShopOrderNumberView.h"
#import "BN_ShopOrderProcessingView.h"
#import "Base_BaseViewController+ControlCreate.h"

#import "BN_ShopOrderUserProfileViewModel.h"
#import "BN_ShopOrderDetailViewModel.h"

#import "PureLayout.h"
#import "UIView+BlocksKit.h"

#import "BN_ShopOrderItemProtocol.h"

@interface BN_ShopOrderDetailViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIView *headerView;
@property (strong, nonatomic) UIView *footerView;


@property (strong, nonatomic) BN_ShopOrderUserProfileViewModel *userViewModel;
@property (strong, nonatomic) BN_ShopOrderDetailViewModel *orderViewModel;

@end

static NSString * const ShopOrdersConfirmationTableCellIdentifier = @"ShopOrdersConfirmationTableCellIdentifier";

@implementation BN_ShopOrderDetailViewController

- (instancetype)initWith:(NSString *)orderId {
    if (self = [super init]) {
        self.orderViewModel = [[BN_ShopOrderDetailViewModel alloc] init];
        self.orderViewModel.order_id = orderId;
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
    
}

- (void)buildViewModel {
    self.orderViewModel.dataSource = [[TableDataSource alloc] initWithItems:self.orderViewModel.detailModel.goodsList cellIdentifier:ShopOrdersConfirmationTableCellIdentifier configureCellBlock:^(BN_ShopOrdersItemCell *cell, id<BN_ShopOrderItemProtocol> item) {
        [cell updateWith:[item pic_url] title:[item goods_name] num:[item goods_num] price:[item real_price] specification:[item standard]];
    }];
    __weak typeof(self) temp = self;
    [self.orderViewModel getShoppingOrderDetail:^{
        [temp.orderViewModel.dataSource resetItems:self.orderViewModel.detailModel.goodsList];
        [temp buildFooterView];
        [temp buildHeaderView];
        temp.tableView.dataSource = temp.orderViewModel.dataSource;
        [temp.tableView reloadData];
    } failure:^(NSString *errorDescription) {
        [self showHudError:errorDescription title:@"获取订单失败"];
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
}

#pragma mark - ui


- (void)buildFooterView {
    self.footerView = [[UIView alloc] init];
    CGFloat footerHeight = 0;
    CGFloat footerWidth = WIDTH(self.tableView);
    
    BN_ShopOrderBillView *billView = [BN_ShopOrderBillView nib];
    [billView updateWith:self.orderViewModel.detailModel.goods_amount pointDeduction:self.orderViewModel.detailModel.integral_amount freight:self.orderViewModel.detailModel.freight_amount];
    [self.footerView addSubview:billView];
    [billView setFrame:CGRectMake(0, 0, footerWidth, billView.getViewHeight)];
    footerHeight += billView.getViewHeight;
    
    BN_ShopOrderNumberView *orderPayView = [BN_ShopOrderNumberView nib];
    [orderPayView updateOrderPriceContent];
    [orderPayView updateWith:@"订单总价" content:self.orderViewModel.detailModel.pay_amount];
    [self.footerView addSubview:orderPayView];
    [orderPayView setFrame:CGRectMake(0, footerHeight, footerWidth, orderPayView.getViewHeight)];
    footerHeight += orderPayView.getViewHeight;
    
    UIView *lineView0 = [[UIView alloc] initWithFrame:CGRectMake(0, footerHeight, footerWidth, 5)];
    [self.footerView addSubview:lineView0];
    footerHeight += 5;
    
    BN_ShopOrderServiceStateView *serviceView = [BN_ShopOrderServiceStateView nib];
    if (self.orderViewModel.detailModel.saleafter > 0) {
        [serviceView updateServerState:self.orderViewModel.detailModel.saleafter];
    } else {
        [serviceView updateServerHelp];
    }
    [self.footerView addSubview:serviceView];
    [serviceView setFrame:CGRectMake(0, footerHeight, footerWidth, serviceView.getViewHeight)];
    footerHeight += serviceView.getViewHeight;
    
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, footerHeight, footerWidth, 5)];
    [self.footerView addSubview:lineView1];
    footerHeight += 5;
    
    if ([self.orderViewModel.detailModel orderState] != BN_ShopOrderState_Pay) {
        BN_ShopOrderNumberView *orderPayView = [BN_ShopOrderNumberView nib];
        [orderPayView updateWith:@"支付方式" content:self.orderViewModel.detailModel.pay_typeName];
        [self.footerView addSubview:orderPayView];
        [orderPayView setFrame:CGRectMake(0, footerHeight, footerWidth, orderPayView.getViewHeight)];
        footerHeight += orderPayView.getViewHeight;
    }
    
    BN_ShopOrderNumberView *orderTimeView = [BN_ShopOrderNumberView nib];
    [orderTimeView updateWith:@"订单时间" content:self.orderViewModel.detailModel.create_time];
    [self.footerView addSubview:orderTimeView];
    [orderTimeView setFrame:CGRectMake(0, footerHeight, footerWidth, orderPayView.getViewHeight)];
    footerHeight += orderTimeView.getViewHeight;
    
    if ([self.orderViewModel.detailModel orderState] != BN_ShopOrderState_Take) {
        BN_ShopOrderNumberView *orderPayView = [BN_ShopOrderNumberView nib];
        [orderPayView updateWith:@"快递单号" content:self.orderViewModel.detailModel.courier_no];
        [self.footerView addSubview:orderPayView];
        [orderPayView setFrame:CGRectMake(0, footerHeight, footerWidth, orderPayView.getViewHeight)];
        footerHeight += orderPayView.getViewHeight;
    }
    
    BN_ShopOrderProcessingView *processView = [BN_ShopOrderProcessingView nib];
    if ([self.orderViewModel.detailModel orderState] == BN_ShopOrderState_Pay) {
        [processView updateWith:@"取消订单" rightTitle:@"立即支付"];
        [processView addLeftEventHandler:^(id sender) {
            
        }];
        [processView addRightEventHandler:^(id sender) {
            
        }];
    } else if ([self.orderViewModel.detailModel orderState] == BN_ShopOrderState_Take) {
        [processView updateWith:nil rightTitle:@"确认收货"];
        [processView addLeftEventHandler:nil];
        [processView addRightEventHandler:^(id sender) {
            
        }];
    } else if ([self.orderViewModel.detailModel orderState] == BN_ShopOrderState_Recommend) {
        [processView updateWith:@"申请售后" rightTitle:@"立即评价"];
        [processView addLeftEventHandler:^(id sender) {
            
        }];
        [processView addRightEventHandler:^(id sender) {
            
        }];
    } else if ([self.orderViewModel.detailModel orderState] == BN_ShopOrderState_Finish) {
        [processView updateWith:nil rightTitle:@"确认完成"];
        [processView addLeftEventHandler:nil];
        [processView addRightEventHandler:^(id sender) {
            
        }];
    }
    [self.footerView addSubview:processView];
    processView.frame = CGRectMake(0, footerHeight, footerWidth, processView.getViewHeight);
    footerHeight += processView.getViewHeight;
    
    self.footerView.frame = CGRectMake(0, 0, footerWidth, footerHeight);
    
    self.tableView.tableFooterView = self.footerView;
}

- (void)buildHeaderView {
    BN_ShopOrderNumberView *orderIdView = [BN_ShopOrderNumberView nib];
    [orderIdView updateOrderStateContent];
    [orderIdView updateWith:self.orderViewModel.order_id content:self.orderViewModel.detailModel.order_state_name];
    BN_ShopOrderUserProfileView *userView = [BN_ShopOrderUserProfileView nib];
    [userView updateWith:self.orderViewModel.userProfile.name tel:self.orderViewModel.userProfile.telNum tagged:NO provinces:[self.orderViewModel.userProfile provinceAndCity] street:self.orderViewModel.userProfile.address];
    
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self.tableView), orderIdView.getViewHeight+userView.getViewHeight)];
    [self.headerView addSubview:orderIdView];
    [self.headerView addSubview:userView];
    orderIdView.frame = CGRectMake(0, 0, WIDTH(self.headerView), orderIdView.getViewHeight);
    userView.frame = CGRectMake(0, orderIdView.getViewHeight, WIDTH(self.headerView), userView.getViewHeight);
    
    self.tableView.tableHeaderView = self.headerView;
    
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end
