//
//  BN_MyLimitBuyViewController.m
//  BN_Shop
//
//  Created by yuze_huang on 2017/1/1.
//  Copyright © 2017年 GL_RunMan. All rights reserved.
//

#import "BN_MyLimitBuyViewController.h"
#import "BN_MyCollectionToolBar.h"
#import "BN_ShopHeader.h"
#import "UIBarButtonItem+BlocksKit.h"
#import "BN_MyLimitBuyViewModel.h"
#import "NSArray+BlocksKit.h"
#import "PureLayout.h"
#import "NSObject+BKBlockObservation.h"
#import "BN_MyLimitBuyCell.h"
#import "BN_ShopToolRequest.h"
#import "BN_ShopGoodDetailViewController.h"

@interface BN_MyLimitBuyViewController ()<BN_MyLimitBuyCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) BN_MyCollectionToolBar *toolBar;
@property (strong, nonatomic) BN_MyLimitBuyViewModel *viewModel;
@end

static NSString * const cellIdenifier = @"BN_MyLimitBuyCellIdentifier";

@implementation BN_MyLimitBuyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.tableView.separatorStyle = NO;
    [self buildViewModel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)buildControls
{
    [super buildControls];
    self.title = TEXT(@"限时抢购");
    
    [self.tableView registerNib:[BN_MyLimitBuyCell nib] forCellReuseIdentifier:cellIdenifier];
    self.tableView.backgroundColor = ColorWhite;
    //    UIView *view = [[UIView alloc] init];
    //    self.tableView.tableFooterView = view;
    self.toolBar = [[BN_MyCollectionToolBar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 52, self.view.frame.size.width, 52)];
    self.toolBar.hidden = YES;
    @weakify(self);
    self.toolBar.selectAll = ^(BOOL isSelect) {
        @strongify(self);
        [self selectClick:isSelect];
    };
    self.toolBar.deleteClick = ^(){
        @strongify(self);
        [self deleteTagger];
    };
    [self.view addSubview:self.toolBar];
}

- (void)loadCustomNavigationButton {
    [super loadCustomNavigationButton];
    @weakify(self);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:TEXT(@"编辑") style:UIBarButtonItemStylePlain handler:^(id sender) {
        @strongify(self);
        self.viewModel.edit = !self.viewModel.edit;
//        self.viewModel. = !self.viewModel.edit;
        [self.viewModel isEditCell:self.viewModel.edit];
        self.toolBar.hidden = !self.viewModel.edit;
        [self.tableView reloadData];
    }];
    self.navigationItem.rightBarButtonItem.tintColor = ColorBlack;
}

#pragma mark - 创建viewModel
- (void)buildViewModel {
    self.viewModel = [[BN_MyLimitBuyViewModel alloc] init];
    @weakify(self);
    [self.viewModel bk_addObserverForKeyPath:@"edit" options:NSKeyValueObservingOptionNew task:^(id obj, NSDictionary *change) {
        @strongify(self);
        BOOL isEdit = [[change objectForKey:@"new"] boolValue];
        self.toolBar.edit = isEdit;
        self.navigationItem.rightBarButtonItem.title = isEdit ? TEXT(@"完成") : TEXT(@"编辑");
    }];
    
    
    self.viewModel.dataSource = [[MultipleSectionTableArraySource alloc] init];
    
    [self.tableView setBn_data:self.viewModel.collectionList];
    [self.tableView loadData:self.viewModel.collectionList];
    [self.tableView setHeaderRefreshDatablock:^{
        @strongify(self);
        [self.viewModel getCollectionListData:YES];
    } footerRefreshDatablock:^{
        @strongify(self);
        [self.viewModel getCollectionListData:NO];
    }];
    [self.tableView setRefreshBlock:^{
        @strongify(self);
        [self.viewModel getCollectionListData:YES];
    }];
    [self.viewModel.collectionList.loadSupport setDataRefreshblock:^{
        @strongify(self);
        
        for (BN_MycollectionModel *item in self.viewModel.collectionList) {
            SectionDataSource *section =  [self.viewModel getSectionDataSourceWith:nil items:@[item] cellIdentifier:cellIdenifier configureCellBlock:^(id cell, BN_MycollectionModel *item) {
                [(BN_MyLimitBuyCell *)cell updateViewWithModel:item];
                [(BN_MyLimitBuyCell *)cell setDelegate:self];
                if (item.buying_state == 1) {
                    [(BN_MyLimitBuyCell *)cell updateAdditionalFrenzied:item.date];
                    [(BN_MyLimitBuyCell *)cell addManageButtonEvent:^(id sender) {
                    
                    }];
                }else if (item.buying_state == 0) {
                    [(BN_MyLimitBuyCell *)cell updateAdditionalForward:item.date state:(int)item.warn_id];
                    [cell addManageButtonEvent:^(id sender) {
                        @strongify(self);
                        
                        [[BN_ShopToolRequest sharedInstance] warnORCancelRes:(item.warn_id <= 0) goodsId:(item.warn_id>0 ? item.warn_id : item.goodsId) success:^(long warn_id) {
                            item.warn_id = warn_id;
                            NSIndexPath *indexPath = [self.tableView indexPathForCell:(BN_MyLimitBuyCell *)cell];
                            if (indexPath) {
                                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                            }
                            
                        } failure:^(NSString *errorDescription) {
                            
                        }];
                    }];
                }
            } configureSectionBlock:nil];
            
            [self.viewModel addDataSourceWith:section];
        }
        self.tableView.dataSource = self.viewModel.dataSource;
        dispatch_async(dispatch_get_main_queue(), ^{
            //            [self.endView updateWith:[self.viewModel selectedItemPriceShow] settlementTitle:[self.viewModel settlementCount]];
            [self.tableView reloadData];
        });
    }];
    
    [self.viewModel getCollectionListData:YES];
}
#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 135.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BN_MycollectionModel *model = [self.viewModel.dataSource itemAtIndexPath:indexPath];
    if (model.goodsId) {
        BN_ShopGoodDetailViewController *ctr = [[BN_ShopGoodDetailViewController alloc] initWith:model.goodsId];
        [self.navigationController pushViewController:ctr animated:YES];
    }
}

#pragma mark - BN_MyLimitBuyCellDelegate
- (void)selectActionWith:(UITableViewCell *)cell selected:(BOOL)selected
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    id object = [self.viewModel.dataSource itemAtIndexPath:indexPath];
    [object setSelected:selected];
}

- (void)valueChangedWith:(UITableViewCell *)cell count:(float)count
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    id object = [self.viewModel.dataSource itemAtIndexPath:indexPath];
    if ([object isSelected]) {
//        [self.toolBar updateWith:[self.viewModel selectedItemPriceShow] settlementTitle:[self.viewModel settlementCount]];
    }
}

#pragma mark - 工具栏删除
- (void)selectClick:(BOOL)isSelect {
    [self.viewModel selectAll:!isSelect];
    [self.tableView reloadData];
}

- (void)deleteTagger {
    NSArray *ids = [[self.viewModel settlementSelectedItems] bk_map:^id(BN_MycollectionModel *obj) {
        return @(obj.collect_id);
    }];
    if (ids.count == 0) {
        return;
    }
    @weakify(self);
    [self.viewModel deletecollection:ids success:^{
        @strongify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            self.viewModel.edit = NO;
            [self.tableView reloadData];
        });
    } failure:^(NSString *errorDescription) {
        [self showHudPrompt:errorDescription];
    }];
}


@end
