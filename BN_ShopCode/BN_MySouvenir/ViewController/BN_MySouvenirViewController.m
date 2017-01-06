//
//  BN_MySouvenirViewController.m
//  BN_Shop
//
//  Created by yuze_huang on 2016/12/30.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "BN_MySouvenirViewController.h"
#import "BN_MSouvenirTableViewCell.h"
#import "BN_MySouvenirModel.h"
#import "BN_ShopToolRequest.h"
#import "BN_ShopGoodDetailViewController.h"

@interface BN_MySouvenirViewController ()<BN_MSouvenirTableViewCellDelegate,UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) BN_MySouvenirModel *model;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

static NSString * const SouvenirCellIdentifier = @"SouvenirCellIdentifier";


@implementation BN_MySouvenirViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray = [NSMutableArray array];
    // Do any additional setup after loading the view from its nib.
    self.title = TEXT(@"伴手礼专题");
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [(Base_UITabBarBaseController*)self.tabBarController setTabBarHidden:NO animated:YES];
}

-(void)buildControls
{
    [super buildControls];
    [self.tableView registerNib:[BN_MSouvenirTableViewCell nib] forCellReuseIdentifier:SouvenirCellIdentifier];
    self.tableView.separatorStyle = NO;
    [self initDataSource];
}

- (void)loadCustomNavigationButton
{
    [super loadCustomNavigationButton];
}

-(void)setControlsFrame
{
    [super setControlsFrame];
    UIView *view = [UIView new];
    self.tableView.tableFooterView = view;
}

#pragma mark - 获取数据
- (void)initDataSource {
    __weak typeof (self) weakSelf = self;
    [self.tableView setHeaderRefreshDatablock:^{
        [weakSelf getDataArrayIsClear:YES];
    } footerRefreshDatablock:^{
        if (weakSelf.dataArray.count) {
            [weakSelf getDataArrayIsClear:NO];
        }else {
            [weakSelf getDataArrayIsClear:YES];
        }
        
    }];
    [self.tableView setTableViewData:self.dataArray];
    [self.dataArray.loadSupport setDataRefreshblock:^{
        
    }];
    [self.tableView loadData:self.dataArray];
    [self getDataArrayIsClear:YES];
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40.0 + WIDTH(tableView) / 1.73;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    BN_MySouvenirModel *model = self.dataArray[indexPath.row];
    if (model.specialId) {
        BN_ShopGoodDetailViewController *ctr = [[BN_ShopGoodDetailViewController alloc] initWith:model.specialId];
        [self.navigationController pushViewController:ctr animated:YES];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BN_MSouvenirTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SouvenirCellIdentifier];
    if (!cell) {
        cell = [[BN_MSouvenirTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SouvenirCellIdentifier];
    }
    cell.accessoryType = UITableViewCellSelectionStyleNone;
    BN_MySouvenirModel *model = _dataArray[indexPath.row];
    [cell updateWith:model.specialName thumbnailUrl:model.coverImg model:model];
    @weakify(self);
    cell.collect = ^(){
        @strongify(self);
        [self CollectClick:model];
    };
    return cell;
}

#pragma mark - 数据
- (void)getDataArrayIsClear:(BOOL)clear {
    int curPage = clear == YES ? 0 : round(self.dataArray.count/10.0);
    NSDictionary *dic = @{@"curPage":@(curPage),@"pageNum":@10,@"type":@14};
    NSString *url = [NSString stringWithFormat:@"%@/mime/myCollect/special/list",BASEURL];
    __weak typeof(self) temp = self;
    self.dataArray.loadSupport.loadEvent = NetLoadingEvent;
    [[BC_ToolRequest sharedManager] GET:url parameters:dic success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSDictionary *dic = responseObject;
        NSNumber *codeNumber = [dic objectForKey:@"code"];
        if(codeNumber.intValue == 0)
        {
            NSArray *array = [dic objectForKey:@"rows"];
            NSArray *returnArray = [BN_MySouvenirModel mj_objectArrayWithKeyValuesArray:array];
            
            if (clear == YES)
            {
                [temp.dataArray removeAllObjects];
            }
            
            [temp.dataArray addObjectsFromArray:returnArray];
            if (returnArray.count < 10) {
                temp.dataArray.networkTotal = @(temp.dataArray.count);
            } else {
                temp.dataArray.networkTotal = [dic objectForKey:@"total"];
            }
        }
        else
        {
            //            NSString *errorStr = [dic objectForKey:@"remark"];
        }
        temp.dataArray.loadSupport.loadEvent = codeNumber.intValue;
        [temp.tableView reloadData];
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        temp.dataArray.loadSupport.loadEvent= NetLoadFailedEvent;
    }];
}

#pragma mark - 收藏点击
- (void)CollectClick:(BN_MySouvenirModel *)model {
    
    if (model.isCollected) {
        NSDictionary *dic = @{@"collectId":@(model.specialId)};
        
        NSString *url = [NSString stringWithFormat:@"%@/mall/deleteCollect",BASEURL];
        @weakify(self);
        [[BC_ToolRequest sharedManager] POST:url parameters:dic success:^(NSURLSessionDataTask *operation, id responseObject) {
            @strongify(self);
            NSDictionary *dic = responseObject;
            NSNumber *codeNumber = [dic objectForKey:@"code"];
            if(codeNumber.intValue == 0) {
                [self getDataArrayIsClear:YES];
            }else {
                NSLog(@"取消收藏失败：%@",responseObject);
            }
        } failure:^(NSURLSessionDataTask *operation, NSError *error) {
            
        }];
    }else {
        @weakify(self);
        [[BN_ShopToolRequest sharedInstance] collecteWith:model.specialId allSpotsType:1 success:^(int collecteState, NSString *collecteMessage) {
            @strongify(self);
            [self getDataArrayIsClear:YES];
        } failure:^(NSString *errorDescription) {
//            @strongify(self);
//                    [self showHudError:errorDescription title:TEXT(@"操作失败")];
            
        }];
    }
    
}

@end
