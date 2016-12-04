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
    [super buildControls];
    self.tableView.rowHeight = 112.0f;
    [self.tableView registerNib:[BN_ShopOrdersItemCell nib] forCellReuseIdentifier:ShopOrdersConfirmationTableCellIdentifier];
    self.tableView.separatorColor = ColorLine;
    self.tableView.backgroundColor = ColorWhite;
}

- (void)buildViewModel {
    self.orderViewModel.dataSource = [[TableDataSource alloc] initWithItems:self.orderViewModel.detailModel.goodsList cellIdentifier:ShopOrdersConfirmationTableCellIdentifier configureCellBlock:^(BN_ShopOrdersItemCell *cell, id<BN_ShopOrderItemProtocol> item) {
        [cell updateWith:[item pic_url] title:[item goods_name] num:[item goods_num] price:[item real_price] specification:[item standard]];
    }];
    __weak typeof(self) temp = self;
    [self.orderViewModel getShoppingOrderDetail:^{
        [temp.orderViewModel.dataSource resetItems:self.orderViewModel.detailModel.goodsList];
        
        [temp.tableView beginUpdates];
        [temp buildFooterView];
        [temp buildHeaderView];
        [temp.tableView endUpdates];
        
        temp.tableView.dataSource = temp.orderViewModel.dataSource;
        [temp.tableView reloadData];
    } failure:^(NSString *errorDescription) {
        [temp showHudError:errorDescription title:@"获取订单失败"];
//        [temp.navigationController popViewControllerAnimated:YES];
        
        [temp.orderViewModel.dataSource resetItems:self.orderViewModel.detailModel.goodsList];
        
        [temp.tableView beginUpdates];
        [temp buildFooterView];
        [temp buildHeaderView];
        [temp.tableView endUpdates];
        
        temp.tableView.dataSource = temp.orderViewModel.dataSource;
        [temp.tableView reloadData];
    }];
    
}

#pragma mark - ui


- (void)buildFooterView {
    self.footerView = [[UIView alloc] init];
    CGFloat footerHeight = 0;
    CGFloat footerWidth = WIDTH(self.tableView);
    
    BN_ShopOrderBillView *billView = [BN_ShopOrderBillView nib];
    [billView updateWith:[self.orderViewModel shopAcountStr] pointDeduction:[self.orderViewModel shopVailableStr] freight:[self.orderViewModel shopFreightStr]];
    [self.footerView addSubview:billView];
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, footerHeight, footerWidth, 1)];
    lineView.backgroundColor = ColorLine;
    [billView addSubview:lineView];
    [lineView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:billView];
    [lineView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.footerView];
    [lineView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.footerView];
    [lineView autoSetDimension:ALDimensionHeight toSize:1];
    
    [billView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.footerView];
    [billView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.footerView];
    [billView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.footerView];
    [billView autoSetDimension:ALDimensionHeight toSize:billView.getViewHeight];
    footerHeight += billView.getViewHeight;
    
    BN_ShopOrderNumberView *orderPayView = [BN_ShopOrderNumberView nib];
    [orderPayView updateOrderPriceContent];
    [orderPayView updateWith:@"订单总价" content:[self.orderViewModel realNeedPayStr]];
    [self.footerView addSubview:orderPayView];
//    [orderPayView setFrame:CGRectMake(0, footerHeight, footerWidth, orderPayView.getViewHeight)];
    [orderPayView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:billView];
    [orderPayView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.footerView];
    [orderPayView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.footerView];
    [orderPayView autoSetDimension:ALDimensionHeight toSize:orderPayView.getViewHeight];
    footerHeight += orderPayView.getViewHeight;
    
    UIView *lineView0 = [[UIView alloc] initWithFrame:CGRectMake(0, footerHeight, footerWidth, 5)];
    lineView0.backgroundColor = ColorBackground;
    [self.footerView addSubview:lineView0];
    [lineView0 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:orderPayView];
    [lineView0 autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.footerView];
    [lineView0 autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.footerView];
    [lineView0 autoSetDimension:ALDimensionHeight toSize:5];
    footerHeight += 5;
    
    BN_ShopOrderServiceStateView *serviceView = [BN_ShopOrderServiceStateView nib];
    if (self.orderViewModel.detailModel.saleafter > 0) {
        [serviceView updateServerState:self.orderViewModel.detailModel.saleafter];
    } else {
        [serviceView updateServerHelp];
    }
    [self.footerView addSubview:serviceView];
    [serviceView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:lineView0];
    [serviceView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.footerView];
    [serviceView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.footerView];
    [serviceView autoSetDimension:ALDimensionHeight toSize:serviceView.getViewHeight];
    footerHeight += serviceView.getViewHeight;
    
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, footerHeight, footerWidth, 5)];
    lineView1.backgroundColor = ColorBackground;
    [self.footerView addSubview:lineView1];
    [lineView1 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:serviceView];
    [lineView1 autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.footerView];
    [lineView1 autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.footerView];
    [lineView1 autoSetDimension:ALDimensionHeight toSize:5];
    footerHeight += 5;
    
    if ([self.orderViewModel.detailModel orderState] != BN_ShopOrderState_Pay) {
        BN_ShopOrderNumberView *orderPayView = [BN_ShopOrderNumberView nib];
        [orderPayView updateWith:@"支付方式" content:self.orderViewModel.detailModel.pay_typeName];
        [self.footerView addSubview:orderPayView];
//        [orderPayView setFrame:CGRectMake(0, footerHeight, footerWidth, orderPayView.getViewHeight)];
        [orderPayView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:lineView1];
        [orderPayView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.footerView];
        [orderPayView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.footerView];
        [orderPayView autoSetDimension:ALDimensionHeight toSize:orderPayView.getViewHeight];
        footerHeight += orderPayView.getViewHeight;
    }
    
    BN_ShopOrderNumberView *orderTimeView = [BN_ShopOrderNumberView nib];
    [orderTimeView updateWith:@"订单时间" content:self.orderViewModel.detailModel.create_time];
    [self.footerView addSubview:orderTimeView];
//    [orderTimeView setFrame:CGRectMake(0, footerHeight, footerWidth, orderPayView.getViewHeight)];
    [orderTimeView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.footerView withOffset:footerHeight];
    [orderTimeView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.footerView];
    [orderTimeView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.footerView];
    [orderTimeView autoSetDimension:ALDimensionHeight toSize:orderTimeView.getViewHeight];
    footerHeight += orderTimeView.getViewHeight;
    
    if ([self.orderViewModel.detailModel orderState] == BN_ShopOrderState_Take) {
        BN_ShopOrderNumberView *orderPayView = [BN_ShopOrderNumberView nib];
        [orderPayView updateWith:@"快递单号" content:self.orderViewModel.detailModel.courier_no];
        [self.footerView addSubview:orderPayView];
        [orderPayView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:orderTimeView];
        [orderPayView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.footerView];
        [orderPayView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.footerView];
        [orderPayView autoSetDimension:ALDimensionHeight toSize:orderPayView.getViewHeight];
//        [orderPayView setFrame:CGRectMake(0, footerHeight, footerWidth, orderPayView.getViewHeight)];
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
    [processView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.footerView];
    [processView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.footerView];
    [processView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.footerView];
    [processView autoSetDimension:ALDimensionHeight toSize:processView.getViewHeight];
//    processView.frame = CGRectMake(0, footerHeight, footerWidth, processView.getViewHeight);
    footerHeight += processView.getViewHeight;
    self.footerView.frame = CGRectMake(0, 0, footerWidth, footerHeight);
    
    self.tableView.tableFooterView = self.footerView;
}

- (void)buildHeaderView {
    BN_ShopOrderNumberView *orderIdView = [BN_ShopOrderNumberView nib];
    [orderIdView updateOrderStateContent];
    [orderIdView updateWith:[NSString stringWithFormat:@"订单编号 %@", self.orderViewModel.order_id] content:self.orderViewModel.detailModel.order_state_name];
    
    BN_ShopOrderUserProfileView *userView = [BN_ShopOrderUserProfileView nib];
    [userView updateWith:self.orderViewModel.userProfile.name tel:self.orderViewModel.userProfile.telNum tagged:NO provinces:[self.orderViewModel.userProfile provinceAndCity] street:self.orderViewModel.userProfile.address];
    [userView hidenArrowRView];
    
    
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
