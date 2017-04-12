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
#import "BN_ShopOrderNumberProcessingView.h"
#import "Base_BaseViewController+ControlCreate.h"
#import "BN_ShopPaymentViewController.h"
#import "LBB_OrderCommentViewController.h"
#import "LBB_ApplyAalesViewController.h"
#import "LBB_OrderModuleViewController.h"

#import "BN_ShopOrderUserProfileViewModel.h"
#import "BN_ShopOrderDetailViewModel.h"
#import "BN_ShoppingCartViewModel.h"

#import "PureLayout.h"
#import "UIView+BlocksKit.h"
#import "UIActionSheet+BlocksKit.h"

#import "BN_ShopOrderItemProtocol.h"
#import "BN_ShopHeader.h"
#import "NSArray+BlocksKit.h"

@interface BN_ShopOrderDetailViewController ()<BN_ShopPaymentViewControllerDelegate, LBB_OrderCommentDelegate>

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
    
    [self buildViewModelRes];
}

- (void)buildViewModelRes {
    __weak typeof(self) temp = self;
    [self.orderViewModel getShoppingOrderDetail:^{
        [temp.orderViewModel.dataSource resetItems:self.orderViewModel.detailModel.goodsList];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [temp.tableView beginUpdates];
            [temp buildFooterView];
            [temp buildHeaderView];
            [temp.tableView endUpdates];
            
            temp.tableView.dataSource = temp.orderViewModel.dataSource;
            [temp.tableView reloadData];
        });
    } failure:^(NSString *errorDescription) {
        [temp showHudError:errorDescription title:@"获取订单失败"];
        [temp.navigationController popViewControllerAnimated:YES];
    }];
}

#pragma mark - ui


- (void)buildFooterView {
    self.footerView = [[UIView alloc] init];
    CGFloat footerHeight = 0;
    CGFloat footerWidth = WIDTH(self.tableView);
    
    @weakify(self);
//    if ([self.orderViewModel.detailModel orderState] == BN_ShopOrderState_Take) {
//        BN_ShopOrderNumberProcessingView *processView = [BN_ShopOrderNumberProcessingView nib];
//        [processView updateWith:@"" content:@""];
//        [processView updateWith:ColorWhite q_color:ColorBtnYellow titleColor:ColorBtnYellow title:TEXT(@"退款")];
//        [processView addEventHandler:^(id sender) {
//#warning 退款跳转
//        }];
//        [self.footerView addSubview:processView];
//        [processView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.footerView];
//        [processView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.footerView];
//        [processView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.footerView];
//        [processView autoSetDimension:ALDimensionHeight toSize:processView.getViewHeight];
//        footerHeight += processView.getViewHeight;
//    }
    
    BN_ShopOrderBillView *billView = [BN_ShopOrderBillView nib];
    [billView updateWith:[self.orderViewModel shopAcountStr] pointDeduction:[self.orderViewModel shopVailableStr] freight:[self.orderViewModel shopFreightStr]];
    [self.footerView addSubview:billView];
    [billView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.footerView withOffset:footerHeight];
    [billView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.footerView];
    [billView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.footerView];
    [billView autoSetDimension:ALDimensionHeight toSize:billView.getViewHeight];
    footerHeight += billView.getViewHeight;
    
    BN_ShopOrderNumberView *orderPayView = [BN_ShopOrderNumberView nib];
    [orderPayView updateOrderPriceContent];
    [orderPayView updateWith:@"订单总价" content:[self.orderViewModel realNeedPayStr]];
    [self.footerView addSubview:orderPayView];
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
    if (self.orderViewModel.detailModel.saleafter_state == BN_ShopOrderSaleafterState_Ing) {
        [serviceView updateServerStateIng];
    } else if (self.orderViewModel.detailModel.saleafter_state == BN_ShopOrderSaleafterState_Finish) {
        [serviceView updateServerStateFinish];
    } else {
        [serviceView updateServerHelp];
        [serviceView bk_whenTapped:^{
#warning 订单详情页的联系客服的操作
            @strongify(self);
            if ([BC_ToolRequest sharedManager].token.length == 0) {
                [self showHudError:TEXT(@"没有权限联系客服") title:TEXT(@"请先登录")];
                return;
            }
            
            Class LBB_ShopChatViewController = NSClassFromString(@"LBB_ShopChatViewController");
            if (LBB_ShopChatViewController) {
                id newobj = [[LBB_ShopChatViewController alloc] init];
                [newobj performSelector:NSSelectorFromString(@"setupChatID:") withObject:@"鹭爸爸888"];
                [self.navigationController pushViewController:newobj animated:YES];
            }
        }];
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
        [orderPayView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:lineView1];
        [orderPayView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.footerView];
        [orderPayView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.footerView];
        [orderPayView autoSetDimension:ALDimensionHeight toSize:orderPayView.getViewHeight];
        footerHeight += orderPayView.getViewHeight;
    }
    
    BN_ShopOrderNumberView *orderTimeView = [BN_ShopOrderNumberView nib];
    [orderTimeView updateWith:@"订单时间" content:self.orderViewModel.detailModel.create_time];
    [self.footerView addSubview:orderTimeView];
    [orderTimeView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.footerView withOffset:footerHeight];
    [orderTimeView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.footerView];
    [orderTimeView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.footerView];
    [orderTimeView autoSetDimension:ALDimensionHeight toSize:orderTimeView.getViewHeight];
    footerHeight += orderTimeView.getViewHeight;
    if ([self.orderViewModel.detailModel orderState] == BN_ShopOrderState_Take) {
        BN_ShopOrderNumberProcessingView *orderPayView = [BN_ShopOrderNumberProcessingView nib];
        [orderPayView updateWith:@"快递单号" content:self.orderViewModel.detailModel.courier_no];
        [orderPayView updateWith:ColorBtnYellow q_color:nil titleColor:ColorWhite title:TEXT(@"复制")];
        [orderPayView addEventHandler:^(id sender) {
            @strongify(self);
            UIPasteboard*pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = self.orderViewModel.detailModel.courier_no;
            [self showHudSucess:@"复制到剪贴板了"];
        }];
        [self.footerView addSubview:orderPayView];
        [orderPayView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:orderTimeView];
        [orderPayView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.footerView];
        [orderPayView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.footerView];
        [orderPayView autoSetDimension:ALDimensionHeight toSize:orderPayView.getViewHeight];
        footerHeight += orderPayView.getViewHeight;
    }
    
    BN_ShopOrderProcessingView *processView = [BN_ShopOrderProcessingView nib];
    if ([self.orderViewModel.detailModel orderState] == BN_ShopOrderState_Pay) {
        [processView updateWith:@"取消订单" rightTitle:@"立即支付"];
        [processView addLeftEventHandler:^(id sender) {
            @strongify(self);
            [self.orderViewModel cancelOrderId:^{
                [self showHudSucess:TEXT(@"取消订单成功")];
                [self.navigationController popViewControllerAnimated:YES];
            } failure:^(NSString *errorDescription) {
                [self showHudError:errorDescription title:TEXT(@"取消订单失败")];
            }];
        }];
        [processView addRightEventHandler:^(id sender) {
            @strongify(self);
            [self payment];
        }];
    } else if ([self.orderViewModel.detailModel orderState] == BN_ShopOrderState_Take) {
        [processView updateWith:nil rightTitle:@"确认收货"];
        [processView addLeftEventHandler:nil];
        [processView addRightEventHandler:^(id sender) {
            @strongify(self);
            [self.orderViewModel confirmReceiptOrderId:^{
                [self showHudSucess:TEXT(@"确认收货成功")];
                [self buildViewModelRes];
            } failure:^(NSString *errorDescription) {
                [self showHudError:errorDescription title:TEXT(@"确认收货失败")];
            }];
        }];
    } else if ([self.orderViewModel.detailModel orderState] == BN_ShopOrderState_Recommend) {
        if (self.orderViewModel.detailModel.if_saleafter == 1) {
            [processView updateWith:@"申请售后" rightTitle:@"立即评价"];
        } else {
            [processView updateWith:nil rightTitle:@"立即评价"];
        }
        
        if (self.orderViewModel.detailModel.if_saleafter == 1) {
            [processView addLeftEventHandler:^(id sender) {
                LBB_ApplyAalesViewController *vc = [[LBB_ApplyAalesViewController alloc] initWithNibName:@"LBB_ApplyAalesViewController" bundle:nil];
                vc.orderViewModel = [self getLBB_OrderModelData];
                @weakify(self);
                vc.completeBlock = ^(BOOL resulut){
                    @strongify(self);
                    if (resulut) {
                        [self buildViewModelRes];
                    }
                };
                [self.navigationController pushViewController:vc animated:YES];
            }];
        }
        
        [processView addRightEventHandler:^(id sender) {
            LBB_OrderCommentViewController *vc = [[LBB_OrderCommentViewController alloc] initWithNibName:@"LBB_OrderCommentViewController" bundle:nil];
            vc.viewModel = [self getLBB_OrderModelData];
            vc.delegate = self;
            [self.navigationController pushViewController:vc animated:YES];
        }];
    }
    else {
        [processView updateWith:nil rightTitle:nil];
        [processView addLeftEventHandler:nil];
        [processView addRightEventHandler:nil];
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


- (LBB_OrderModelData *)getLBB_OrderModelData {
    BN_ShopOrderDetailModel *detailModel = self.orderViewModel.detailModel;
    NSArray *rrderModelDetailS = [detailModel.goodsList bk_map:^id(BN_ShopOrderItemModel *obj) {
        LBB_OrderModelDetail *detail = [LBB_OrderModelDetail new];
        detail.front_price = obj.front_price;
        detail.goods_id = [@(obj.goods_id) stringValue];
        detail.goods_num = obj.goods_num;
        detail.order_id = [@(obj.order_id) stringValue];
        detail.order_no = obj.order_no;
        detail.order_state_name = obj.order_state_name;
        detail.pic_url = obj.pic_url;
        detail.real_price = obj.real_price;
        detail.standard = obj.standard;
        detail.goods_name = obj.goods_name;
        return detail;
    }];
    LBB_OrderModelData *orderData = [LBB_OrderModelData new];
    orderData.goodsList = rrderModelDetailS.mutableCopy;
    orderData.integral_amount = detailModel.integral_amount;
    orderData.goods_amount = detailModel.goods_amount;
    orderData.freight_amount = detailModel.freight_amount;
    orderData.pay_type = detailModel.pay_type;
    orderData.order_id = detailModel.order_id;
    orderData.order_state = detailModel.order_state;
    orderData.order_state_name = detailModel.order_state_name;
    orderData.comment_state_name = detailModel.comment_state_name;
    orderData.saleafter_state_name = detailModel.saleafter_state_name;
    orderData.saleafter_state = detailModel.saleafter_state;
    return orderData;
}

#pragma mark - 支付处理
- (void)payment {
    BN_ShopPaymentViewModel *viewModel = [BN_ShopPaymentViewModel paymentViewModelWith:@[self.orderViewModel.detailModel.order_id] type:self.orderViewModel.detailModel.pay_type needPay:self.orderViewModel.detailModel.pay_amount];
    BN_ShopPaymentViewController *ctr = [[BN_ShopPaymentViewController alloc] init:viewModel];
    ctr.delegate = self;
    [self.navigationController pushViewController:ctr animated:YES];
}

#pragma mark - BN_ShopPaymentViewControllerDelegate
- (void)paymentViewControllerWithSucess:(NSArray *)orderIds type:(BN_ShopPaymentType)type payAccount:(NSString *)payAccount {
//    [self buildViewModelRes];
    UINavigationController *nav = self.navigationController;
    LBB_OrderModuleViewController *vc = [nav.viewControllers bk_match:^BOOL(id obj) {
        if ([obj isKindOfClass:[LBB_OrderModuleViewController class]]) {
            return YES;
        }
        return NO;
    }];
    if (vc) {
        [vc refreshBlock];
        [nav popToViewController:vc animated:YES];
    } else {
        [self.navigationController popToRootViewControllerAnimated:NO];
        
        vc = [[LBB_OrderModuleViewController alloc] init];
        vc.baseViewType = eOrderType;
        [nav pushViewController:vc animated:YES];
    }
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - LBB_OrderCommentDelegate
- (void)didCommentSuccess:(LBB_OrderModelData*)viewModel
{
    [self buildViewModelRes];
}

@end
