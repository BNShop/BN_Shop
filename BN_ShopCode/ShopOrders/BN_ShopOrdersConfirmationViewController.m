//
//  BN_ShopOrdersConfirmationViewController.m
//  BN_Shop
//
//  Created by Liya on 16/11/14.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "BN_ShopOrdersConfirmationViewController.h"
#import "BN_ShopOrderBillView.h"
#import "BN_ShopOrdersToolBar.h"
#import "BN_ShopOrderUserProfileView.h"
#import "BN_ShopOrdersItemCell.h"

#import "BN_ShopOrderUserProfileViewModel.h"
#import "BN_ShopOrdersConfirmationViewModel.h"

#import "PureLayout.h"
#import "UIView+BlocksKit.h"

#import "TestCartItem.h"
#import "TestUserProfile.h"

@interface BN_ShopOrdersConfirmationViewController ()

@property (strong, nonatomic) BN_ShopOrderUserProfileViewModel *userViewModel;
@property (strong, nonatomic) BN_ShopOrdersConfirmationViewModel *confirmationviewModel;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) BN_ShopOrderUserProfileView *userView;
@property (strong, nonatomic) BN_ShopOrderBillView *billView;
@property (strong, nonatomic) BN_ShopOrdersToolBar *toolBar;

@end

static NSString * const ShopOrdersConfirmationTableCellIdentifier = @"ShopOrdersConfirmationTableCellIdentifier";

@implementation BN_ShopOrdersConfirmationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.userViewModel = [[BN_ShopOrderUserProfileViewModel alloc] init];
    self.confirmationviewModel = [[BN_ShopOrdersConfirmationViewModel alloc] init];
    
    @weakify(self);
    [self.toolBar placeAnOrderWith:^(id sender) {
#warning 去下单的详细操作
        NSLog(@"下单啦");
    }];
    
//    [self.billView addDeductionedPointForSelectedWithTask:^(BOOL deductioned) {
//        @strongify(self);
//        if (self.confirmationviewModel.deduction != deductioned) {
//            
//            self.confirmationviewModel.deduction = deductioned;
//            [self updateConfirmationView];
//        }
//        
//    }];
    
    [self.userView bk_whenTapped:^{
#warning 去修改收货地址等等操作啦
        NSLog(@"去修改收货地址跳转啦");
    }];
    
    [self testObects];
    [self.tableView reloadData];
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
    
    self.toolBar = [BN_ShopOrdersToolBar nib];
    [self.view addSubview:self.toolBar];
    [self.toolBar autoSetDimension:ALDimensionHeight toSize:[self.toolBar getViewHeight]];
    [self.toolBar autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view];
    [self.toolBar autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view];
    [self.toolBar autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.view];
    
    
    
    self.userView = [BN_ShopOrderUserProfileView nib];
    [self.userView updateWith:@"王久" tel:@"134567890" tagged:YES provinces:@"中国 福建省 厦门市" street:@"思明区 软件园二期 东门"];
    self.userView.frame = RECT_CHANGE_size(self.userView, WIDTH(self.tableView), self.userView.getViewHeight);
    self.billView = [BN_ShopOrderBillView nib];
}


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.userView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return self.userView.getViewHeight;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return self.billView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return self.billView.getViewHeight;
}


#pragma mark - bill and profile view
- (void)updateConfirmationView {
//    [self.billView updateWith:[self.confirmationviewModel integralDeductionTips] retailPrice:[self.confirmationviewModel retailPriceTips] pointDeduction:[self.confirmationviewModel integralpriceTips] freight:[self.confirmationviewModel freightTips] deductioned:[self.confirmationviewModel isDeduction]];
    [self.toolBar updateWith:[self.confirmationviewModel realPrice]];
}

- (void)updateUserView {
    [self.userView updateWith:[self.userViewModel.userProfile contactPersonName] tel:[self.userViewModel telNum] tagged:self.userViewModel.isTagged provinces:[self.userViewModel provinceAndCity] street:[self.userViewModel.userProfile detailedAddr]];
}

#pragma mark - test
- (void)testObects {
    NSMutableArray *array = [NSMutableArray array];
    for (NSInteger j=0; j<3; j++) {
        TestCartItem *item = [[TestCartItem alloc] init];
        item.selected = YES;
        item.front_price = [NSString stringWithFormat:@"%ld", j+1];
        item.real_price = [NSString stringWithFormat:@"%.2f", ((float)j+3)*(random()%30)];
        item.num = j;
        [array addObject:item];
    }
    
    
    self.tableView.dataSource = self.confirmationviewModel.dataSource;
//    [self.endView updateWith:[self.viewModel selectedItemPriceShow] settlementTitle:[self.viewModel settlementCount]];
    [self.tableView reloadData];
    
    TestUserProfile *profile = [[TestUserProfile alloc] init];
    profile.city = @"厦门市";
    profile.province = @"福建省";
    profile.district = @"思明区";
    profile.detailedAddr = @"软件园二期何厝路口";
    profile.contactPersonName = @"王久久";
    profile.contactPersonPhoneNum = @"1234567890";
    self.userViewModel.userProfile = profile;
    [self updateUserView];
    
    self.confirmationviewModel.retailPrice = @"68.90";//商品总额
    self.confirmationviewModel.integral = @"8";//积分
    self.confirmationviewModel.deduction = NO;//是否抵扣积分
    self.confirmationviewModel.freight = @"15.00"; //运费
    [self updateConfirmationView];
}


@end
