//
//  BN_ShopGoodDetailViewController.m
//  BN_Shop
//
//  Created by Liya on 2016/11/19.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "BN_ShopGoodDetailViewController.h"
#import "BN_ShoppingcartViewController.h"


#import "BN_ShopGoodDetailToolBar.h"
#import "BN_ShopGoodDetailSimpleShowView.h"
#import "BN_ShopGoodDetailFriendlyWarning.h"
#import "BN_ShopGoodDetailSellersView.h"
#import "BN_ShopGoodDetaiNormalStateView.h"
#import "BN_ShopGoodDetaiForwardStateView.h"
#import "BN_ShopGoodDetaiPanicStateView.h"

#import "UIBarButtonItem+BlocksKit.h"
#import "UIView+BlocksKit.h"
#import "PureLayout.h"

#import "BN_ShopGoodDetailSimpleShowViewModel.h"
#import "BN_ShopGoodDetaiStateViewModel.h"

@interface BN_ShopGoodDetailViewController ()

@property (nonatomic, strong) BN_ShopGoodDetailToolBar *toolBar;
@property (nonatomic, strong) BN_ShopGoodDetailSimpleShowView *simpleShowView;
@property (nonatomic, strong) BN_ShopGoodDetailFriendlyWarning *friendlyWarningView;
@property (nonatomic, strong) BN_ShopGoodDetailSellersView *sellersView;
@property (nonatomic, strong) UIView *stateView;

@property (nonatomic, strong) BN_ShopGoodDetailSimpleShowViewModel *simpleShowViewModel;
@property (nonatomic, strong) BN_ShopGoodDetaiStateViewModel *stateViewModel;

@end

@implementation BN_ShopGoodDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadCustomNavigationButton {
    [super loadCustomNavigationButton];
    
    @weakify(self);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] bk_initWithImage:IMAGE(@"Shop_GoodDetail_NavShare") style:UIBarButtonItemStylePlain handler:^(id sender) {
        @strongify(self);
        [self shareForGood];
    }];
    self.navigationItem.rightBarButtonItem.tintColor = ColorBlack;
}

- (void)buildControls {
    [super buildControls];
    [self buildToolBar];
    [self buildSimpleShowView];
    [self buildFriendWarningView];
    [self buildSellersView];
    
    
}

//在刷新界面时设置控件位置
- (void)setControlsFrame
{
    
}

- (void)buildToolBar {
    self.toolBar = [BN_ShopGoodDetailToolBar nib];
    @weakify(self);
    [[self.toolBar rac_shopGoodDetailToolBarClickSignal] subscribeNext:^(id x) {
        //,0:跳到购物车 1：客服 2:收藏 3:加入购物车
        @strongify(self);
        NSInteger tag = [x integerValue];
        if (tag == 0) [self gotoShopCart];
        else if (tag == 1) [self airLine];
        else if (tag == 2) [self followAction];
        else if (tag == 3) [self addToCart];
    }];
    [self.view addSubview:self.toolBar];
    [self.toolBar autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view];
    [self.toolBar autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view];
    [self.toolBar autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.view];
    [self.toolBar autoSetDimension:ALDimensionHeight toSize:[self.toolBar getViewHeight]];
}

- (void)buildSimpleShowView {
    
    self.simpleShowViewModel = [[BN_ShopGoodDetailSimpleShowViewModel alloc] init];
    self.simpleShowViewModel.shortDescription = @"木材面包口感扎实绵密";
    
    self.simpleShowView = [BN_ShopGoodDetailSimpleShowView nib];
    [self.simpleShowView updateThumbnailWith:self.simpleShowViewModel.thumbnailUrlList];
    [self.simpleShowView updateWith:self.simpleShowViewModel.shortDescription schedule:[self.simpleShowViewModel scheduleWith:0]];
    @weakify(self);
    [[self.simpleShowView rac_thumbnailDidScrollToIndexSignal] subscribeNext:^(id x) {
        NSLog(@"选了了第几张 %@", x);
        @strongify(self);
        [self.simpleShowView updateWith:self.simpleShowViewModel.shortDescription schedule:[self.simpleShowViewModel scheduleWith:([x integerValue]+1)]];
    }];
    [[self.simpleShowView rac_thumbnailDidSelectItemAtIndexSignal] subscribeNext:^(id x) {
        NSLog(@"点击了第几张 %@", x);
    }];
    
    [self.view addSubview:self.simpleShowView];
    [self.simpleShowView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view];
    [self.simpleShowView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view];
    [self.simpleShowView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.view];
    [self.simpleShowView autoSetDimension:ALDimensionHeight toSize:DeviceWidth+31];
    
}

- (void)buildFriendWarningView {
    self.friendlyWarningView = [BN_ShopGoodDetailFriendlyWarning nib];
    [self.view addSubview:self.friendlyWarningView];
    [self.friendlyWarningView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view];
    [self.friendlyWarningView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view];
    [self.friendlyWarningView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.simpleShowView];
    [self.friendlyWarningView autoSetDimension:ALDimensionHeight toSize:[self.friendlyWarningView getViewHeight]];
    [self.friendlyWarningView updateWith:@"满99包邮" point:@"购买可送12积分" deliver:@"第三方发货"];
}

- (void)buildSellersView {
    self.sellersView = [BN_ShopGoodDetailSellersView nib];
    [self.view addSubview:self.sellersView];
    [self.sellersView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view];
    [self.sellersView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view];
    [self.sellersView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.friendlyWarningView];
    [self.sellersView autoSetDimension:ALDimensionHeight toSize:[self.sellersView getViewHeight]];
    [self.sellersView updateWith:@"阿里巴巴" iconUrl:nil];
    
    [self.sellersView bk_whenTapped:^{
#warning 跳转到哪里了呢
    }];
}


- (void)buildStateView {
//    BN_ShopGoodDetaiForwardStateView *test = [BN_ShopGoodDetaiForwardStateView nib];
//    [self.view addSubview:test];
//    [test autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view];
//    [test autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view];
//    [test autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.view withOffset:100];
//    [test autoSetDimension:ALDimensionHeight toSize:test.getViewHeight];
//    [test updateWith:@"¥768" frontPrice:[[NSAttributedString alloc] initWithString:@"¥8970"] tips:@"下午九点 尊师开枪呀" follow:@"9030跟随"];
//    [test updateWith:[NSDate dateWithTimeIntervalSinceNow:3*60*60+90] countdownToLastSeconds:0];
//    [test setNeedsLayout];
}

#pragma mark - action's for nav
- (void)shareForGood {
#warning 导航栏的点击处理-分享
}

#pragma mark - ToolBar
- (void)gotoShopCart {
    BN_ShoppingcartViewController *cartctr = [[BN_ShoppingcartViewController alloc] init];
    [self.navigationController pushViewController:cartctr animated:YES];
}

#warning 工具栏的点击处理
- (void)airLine {
}

- (void)followAction {
}

- (void)addToCart {
}
@end
