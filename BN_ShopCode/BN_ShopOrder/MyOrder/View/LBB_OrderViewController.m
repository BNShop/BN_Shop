//
//  LBB_OrderViewController.m
//  ST_Travel
//
//  Created by 美少男 on 16/12/6.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "LBB_OrderViewController.h"
#import "HMSegmentedControl.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "LBB_OrderFooterView.h"
#import "LBB_OrderHeaderView.h"
#import "LBB_OrderModel.h"
#import "LBB_OrderDetailViewCell.h"
#import "LBB_OrderCommentViewController.h"
#import "LBB_OrderModel.h"
#import "BN_ShopOrderDetailViewController.h"
#import "LBB_ApplyAalesViewController.h"
#import "BN_ShopHeader.h"

@interface LBB_OrderViewController ()
<UITableViewDataSource,
UITableViewDelegate,
LBB_OrderFooterViewDelegate,
LBB_OrderCommentDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) LBB_OrderViewModel *viewModel;

@end

@implementation LBB_OrderViewController


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadViewControllerWithInfo:) name:@"TicketCommentNotification" object:nil];
}

- (void)buildControls
{
    [self initTableview];
    [self initDataSource];
}

- (void)initDataSource
{
    if (!self.viewModel) {
        self.viewModel = [[LBB_OrderViewModel alloc] init];
    }
    __weak typeof (self) weakSelf = self;
    [self.tableView setHeaderRefreshDatablock:^{
        [weakSelf.viewModel getDataArray:weakSelf.baseViewType IsClear:YES];
    } footerRefreshDatablock:^{
        [weakSelf.viewModel getDataArray:weakSelf.baseViewType IsClear:NO];
    }];
    
    //设置绑定数组
    [self.tableView setTableViewData:self.viewModel.dataArray];
    
    
    [self.viewModel.dataArray.loadSupport setDataRefreshblock:^{
        NSLog(@"数据刷新了");
    }];
    
    [self.tableView loadData:self.viewModel.dataArray];
    
    //刷新数据
    
    [self.viewModel getDataArray:self.baseViewType IsClear:YES];
}


#pragma mark - public
- (void)reloadAllData
{
    
}

//初始化数据类型
- (void)initDataSourceWithType:(NSInteger)stateType
{
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

- (void)initTableview
{
    UINib *nib = [UINib nibWithNibName:@"LBB_OrderDetailViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"LBB_OrderDetailViewCell"];
    [self initDataSourceWithType:self.baseViewType];
    self.bottomViewBottomContraint.constant = TabHeight + TopSegmmentControlHeight + 20.f;
}


#pragma mark - tableView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.viewModel.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self numberOfRows:section];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LBB_OrderModelDetail *cellDict = [self getCellInfo:indexPath];
    return orderCellHeight(cellDict);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 110.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"LBB_OrderDetailViewCell";
    LBB_OrderDetailViewCell *cell = nil;
    
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[LBB_OrderDetailViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.accessoryView =  nil;
    
    LBB_OrderModelDetail *cellDict = [self getCellInfo:indexPath];
    if (cellDict) {
        [cell setCellInfo:cellDict];
    }
    
    if (indexPath.row == [self numberOfRows:indexPath.section] - 1 ) {
        cell.lineView.hidden = YES;
    }else {
        cell.lineView.hidden = NO;
    }
    return cell;
}


- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UINib *nib = [UINib nibWithNibName:@"LBB_OrderHeaderView" bundle:nil];
    NSArray *viewArray = [nib instantiateWithOwner:nil options:nil];
    LBB_OrderHeaderView *headView = [viewArray firstObject];
    headView.frame = CGRectMake(0, 0, DeviceWidth, 44.f);
    if (section < self.viewModel.dataArray.count) {
        headView.cellInfo = [self.viewModel.dataArray objectAtIndex:section];
    }
    
    return headView;
    
}
- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UINib *nib = [UINib nibWithNibName:@"LBB_OrderFooterView" bundle:nil];
    NSArray *viewArray = [nib instantiateWithOwner:nil options:nil];
    LBB_OrderFooterView *footView = [viewArray firstObject];
    footView.frame = CGRectMake(0, 0, DeviceWidth, 85.f);
    if(section == self.viewModel.dataArray.count - 1){
        footView.bgView.hidden = YES;
    }
    footView.mDelegate = self;
    if (section < self.viewModel.dataArray.count) {
        footView.cellInfo = [self.viewModel.dataArray objectAtIndex:section];
    }
    return footView;
    
}

#pragma mark - didSelectRowAtIndexPath
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(self.viewModel.dataArray.count > indexPath.row) {
        [self showTicketDetailView:[self.viewModel.dataArray objectAtIndex:indexPath.row]];
    }
}

- (void)showTicketDetailView:(LBB_OrderModelData*)ticketInfo
{
    BN_ShopOrderDetailViewController *ctr = [[BN_ShopOrderDetailViewController alloc] initWith:[NSString stringWithFormat:@"%@",ticketInfo.order_id]];
    [self.navigationController pushViewController:ctr animated:YES];
     
}

#pragma mark - private cell Info

- (LBB_OrderModelDetail*)getCellInfo:(NSIndexPath*)indexPath
{
    if (self.viewModel.dataArray.count > indexPath.section) {
        LBB_OrderModelData *modelData = self.viewModel.dataArray[indexPath.section];
        
        if (indexPath.row < modelData.goodsList.count) {
            LBB_OrderModelDetail *data = [modelData.goodsList objectAtIndex:indexPath.row];
            return data;
        }
    }
   
    return nil;
}

- (NSInteger)numberOfRows:(NSInteger)section
{
    if (self.viewModel.dataArray.count > section) {
        LBB_OrderModelData *modelData = self.viewModel.dataArray[section];
         return modelData.goodsList.count;
    }
    
    return 0;
}

#pragma mark - 取消订单 立即支付 立即取票 查看详情
- (void)cellBtnClickDelegate:(LBB_OrderModelData*)cellInfo
             TicketClickType:(OrderClickType)clickType
{
//    LBB_ApplyAalesViewController *vc = [[LBB_ApplyAalesViewController alloc] initWithNibName:@"LBB_ApplyAalesViewController" bundle:nil];
//    [self.navigationController pushViewController:vc animated:YES];
//    return;
    __weak typeof (self) weakSelf = self;
    [cellInfo.loadSupport setDataRefreshblock:^{
        [weakSelf.tableView reloadData];
    }];
    
    [cellInfo.loadSupport setDataRefreshFailBlock:^(NetLoadEvent code,NSString* remak){
        if ([remak length]) {
            [weakSelf showHudPrompt:remak];
        }
    }];
    switch (clickType) {
        case eCancelOrder:
        {
            [cellInfo cancelOrder];
        }
            break;
        
        case eGetOrder:
        {
           [cellInfo confirmReceipt];
        }
            break;
        case eDeleteOrder:
        {
            __weak typeof (LBB_OrderModelData*) weakCellModel = cellInfo;
            [cellInfo.loadSupport setDataRefreshblock:^{
                [weakSelf.viewModel.dataArray removeObject:weakCellModel];
                [weakSelf.tableView reloadData];
            }];
            [cellInfo deleteOrder];
        }
            break;
       
        case eApplyAales:
        {
            LBB_ApplyAalesViewController *vc = [[LBB_ApplyAalesViewController alloc] initWithNibName:@"LBB_ApplyAalesViewController" bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case eCommentOrder:
        {
            LBB_OrderCommentViewController *vc = [[LBB_OrderCommentViewController alloc] initWithNibName:@"LBB_OrderCommentViewController" bundle:nil];
            vc.viewModel = cellInfo;
            vc.delegate = self;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case ePayOrder:
        case eCheckAales:
        case eShowOrderDetail://查看详情
        {
            [self showTicketDetailView:cellInfo];
        }
            break;
     
        default:
            break;
    }
}

#pragma mark - segmentedControlChangedValue
- (void)segmentedControlChangedValue:(HMSegmentedControl*)segmentControll
{
    NSInteger selectIndex = segmentControll.selectedSegmentIndex;
    switch (selectIndex) {
        case 0://查看全部-门票
            [self initDataSourceWithType:eOrderType];
            break;
        case 1: //我的门票_待付款
            [self initDataSourceWithType:eOrderType_WaitPay];
            break;
        case 2: //我的门票_待取票
            [self initDataSourceWithType:eOrderType_WaitGetTicket];
            break;
        case 3: //我的门票_待评价
            [self initDataSourceWithType:eOrderType_WaitComment];
            break;
        case 4: //我的门票_退款;
            [self initDataSourceWithType:eOrderType_AfterAales];
            break;
            
        default:
            break;
    }
    
    [self.tableView reloadData];
}

#pragma mark - 被通知所调用的函数
- (void)loadViewControllerWithInfo:(id)info
{
    //    NSNotification *notification = info;
    [self performSegueWithIdentifier:@"LBB_OrderCommentViewController" sender:nil];
    
}

#pragma mark - LBB_OrderCommentDelegate
- (void)didCommentSuccess:(LBB_OrderModelData*)viewModel
{
    [self.tableView reloadData];
}

@end
