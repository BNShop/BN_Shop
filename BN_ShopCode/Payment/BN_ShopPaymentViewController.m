//
//  BN_ShopPaymentViewController.m
//  BN_Shop
//
//  Created by Liya on 2016/12/5.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "BN_ShopPaymentViewController.h"

#import "TableDataSource.h"
#import "BN_ShopPayMentChannelModel.h"
#import "BN_ShopPaymentViewModel.h"
#import "BN_ShopPayment.h"
#import "BN_ShopToolRequest.h"

#import "BN_ShopPaymentCell.h"
#import "BN_ShopOrderNumberView.h"


@interface BN_ShopPaymentViewController ()<UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) BN_ShopPaymentViewModel *viewModel;


@end

static NSString * const ShopPaymentCellIdentifier = @"ShopPaymentCellIdentifier";

@implementation BN_ShopPaymentViewController

- (instancetype)init:(BN_ShopPaymentViewModel *)viewModel
{
    self = [super init];
    if (self) {
        self.viewModel = viewModel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)buildControls {
    [super buildControls];
    self.title = TEXT(@"确定支付");
    [self.viewModel.dataSource resetellIdentifier:ShopPaymentCellIdentifier configureCellBlock:^(BN_ShopPaymentCell *cell, BN_ShopPayMentChannelModel *item) {
        [cell updateWith:item.payIconName title:item.payName subTitle:item.payExplain];
    }];
    [self.tableView registerNib:[BN_ShopPaymentCell nib] forCellReuseIdentifier:ShopPaymentCellIdentifier];
    self.tableView.delegate = self;
    self.tableView.dataSource = self.viewModel.dataSource;
    self.tableView.rowHeight = 45.0f;
    self.tableView.sectionHeaderHeight = 45.0f;
    self.tableView.separatorColor = ColorLine;
}

#pragma mark - wx
- (void)wxPay {
    @weakify(self);
    [[BN_ShopToolRequest sharedInstance] webchatPrePayWith:self.viewModel.orderIds success:^(PayReq *payReq) {
        @strongify(self);
        [BN_ShopPayment sharedInstance].wxPaymentHandler =  ^(NSString *returnKey, int errCode) {
            if (errCode == 0) { //成功
                if ([self.delegate respondsToSelector:@selector(paymentViewModelWith:type:needPay:)]) {
                    [self.delegate paymentViewControllerWithSucess:self.viewModel.orderIds type:self.viewModel.paymentType payAccount:self.viewModel.needPay];
                }
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                [self showHudPrompt:returnKey];
            }
        };
        [[BN_ShopPayment sharedInstance] sendReq:payReq];
    } failure:^(NSString *errorDescription) {
        @strongify(self);
        [self showHudPrompt:errorDescription];
    }];
}

#pragma mark - 支付宝
#warning 进行支付
- (void)alipay {
    
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 45.0f;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(tableView), 55)];
    BN_ShopOrderNumberView *number = [BN_ShopOrderNumberView nib];
    number.frame = CGRectMake(0, 0, WIDTH(tableView), 45.0f);
    [number updateWith:TEXT(@"支付金额") content:[NSString stringWithFormat:@"¥%@", self.viewModel.needPay]];
    [number updateOrderPriceContent];
    [view addSubview:number];
    view.backgroundColor = ColorBackground;
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    BN_ShopPayMentChannelModel *item = [self.viewModel.dataSource itemAtIndexPath:indexPath];
    if (item.payType == BN_ShopPaymentType_WX) {
        [self wxPay];
    } else if (item.payType == BN_ShopPaymentType_Alipay) {
        [self alipay];
    }
}


@end
