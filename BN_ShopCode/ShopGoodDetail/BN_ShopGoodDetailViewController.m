//
//  BN_ShopGoodDetailViewController.m
//  BN_Shop
//
//  Created by Liya on 2016/11/19.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "BN_ShopGoodDetailViewController.h"
#import "BN_ShoppingcartViewController.h"
#import "BN_ShopGoodSpecificDetailsViewController.h"
#import "BN_ShopGoodDetailConsultancyViewController.h"
#import "BN_ShopGoodDetailCommentViewController.h"
#import "Base_BaseViewController+ControlCreate.h"
#import "BN_ShopGoodDetailBuyViewController.h"

#import "BN_ShopGoodDetailToolBar.h"
#import "BN_ShopGoodDetailSimpleShowView.h"
#import "BN_ShopGoodDetailFriendlyWarning.h"
#import "BN_ShopGoodDetailSellersView.h"
#import "BN_ShopGoodDetaiNormalStateView.h"
#import "BN_ShopGoodDetaiForwardStateView.h"
#import "BN_ShopGoodDetaiPanicStateView.h"
#import "BN_ShopGoodDetailTransitionToolBar.h"
#import "BN_ShopGoodDetailNewArrivalsView.h"
#import "BN_ShopGoodDetailNewArribalsCell.h"

#import "UIBarButtonItem+BlocksKit.h"
#import "UIView+BlocksKit.h"
#import "PureLayout.h"

#import "BN_ShopGoodDetailSimpleShowViewModel.h"
#import "BN_ShopGoodDetaiStateViewModel.h"
#import "BN_ShopGoodDetailNewArrivalsViewModel.h"

#import "TestObjectHeader.h"

@interface BN_ShopGoodDetailViewController ()<BN_ShopGoodDetailBuyViewControllerDelegate>

@property (nonatomic, strong) BN_ShopGoodDetailToolBar *toolBar;
@property (nonatomic, strong) BN_ShopGoodDetailSimpleShowView *simpleShowView;
@property (nonatomic, strong) BN_ShopGoodDetailFriendlyWarning *friendlyWarningView;
@property (nonatomic, strong) BN_ShopGoodDetailSellersView *sellersView;
@property (nonatomic, strong) UIView *stateView;
@property (nonatomic, strong) BN_ShopGoodDetailTransitionToolBar *transitionToolBar;
@property (nonatomic, strong) UIView *headeView;
@property (nonatomic, strong) NSArray *subHeadeViews;
@property (nonatomic, strong) BN_ShopGoodDetailNewArrivalsView *arribalsView;

@property (nonatomic, strong) BN_ShopGoodDetailSimpleShowViewModel *simpleShowViewModel;
@property (nonatomic, strong) BN_ShopGoodDetaiStateViewModel *stateViewModel;
@property (nonatomic, strong) BN_ShopGoodDetailNewArrivalsViewModel *arribalsViewModel;

@property (nonatomic, strong) NSMutableArray *controllers;

@property (nonatomic, weak) UIViewController *curController;

@end

static NSString * const ShopGoodDetailNewArrivalsCellIdentifier = @"ShopGoodDetailNewArrivalsCellIdentifier";

@implementation BN_ShopGoodDetailViewController

- (instancetype)initWith:(long)goodsId
{
    self = [super init];
    if (self) {
        self.simpleShowViewModel = [[BN_ShopGoodDetailSimpleShowViewModel alloc] init];
        self.simpleShowViewModel.goodsId = goodsId;
        self.simpleShowViewModel.type = 4;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self buildSimpleShowViewModel];
    [self bulidStateViewModel];
    [self buildArribalsViewModel];
    
    
    
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
    self.navigationController.navigationBar.translucent = NO;
    [self buildToolBar];
    
    [self buildHeadView];
    [self buildArribalsView];
    
}

//在刷新界面时设置控件位置
- (void)setControlsFrame
{
    
}

- (void)buildHeadView {
    self.headeView = [[UIView alloc] init];
    [self buildSimpleShowView];
    [self buildStateView];
    [self buildFriendWarningView];
    [self buildSellersView];
    [self buildTransitionToolBar];
    
    CGFloat stateHeight = 54.0f;
    CGFloat height = [self.simpleShowView getViewHeight] + stateHeight + [self.friendlyWarningView getViewHeight] + [self.sellersView getViewHeight] + [self.transitionToolBar getViewHeight];
    self.headeView.frame = CGRectMake(0, 0, WIDTH(self.view), height);
    NSMutableArray *tmpArray = [NSMutableArray array];
    for (NSInteger index=0; index<3; index++) {
        [tmpArray addObject:[[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self.view), height)]];
    }
    self.subHeadeViews = tmpArray.copy;
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
    
    [self.headeView addSubview:self.simpleShowView];
    [self.simpleShowView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.headeView];
    [self.simpleShowView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.headeView];
    [self.simpleShowView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.headeView];
    [self.simpleShowView autoSetDimension:ALDimensionHeight toSize:[self.simpleShowView getViewHeight]];
    
}

- (void)buildFriendWarningView {
    self.friendlyWarningView = [BN_ShopGoodDetailFriendlyWarning nib];
    [self.headeView addSubview:self.friendlyWarningView];
    [self.friendlyWarningView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.headeView];
    [self.friendlyWarningView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.headeView];
    [self.friendlyWarningView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.stateView];
    [self.friendlyWarningView autoSetDimension:ALDimensionHeight toSize:[self.friendlyWarningView getViewHeight]];
    
}

- (void)buildSellersView {
    self.sellersView = [BN_ShopGoodDetailSellersView nib];
    [self.headeView addSubview:self.sellersView];
    [self.sellersView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.headeView];
    [self.sellersView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.headeView];
    [self.sellersView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.friendlyWarningView];
    [self.sellersView autoSetDimension:ALDimensionHeight toSize:[self.sellersView getViewHeight]];
    
    [self.sellersView bk_whenTapped:^{
#warning 跳转到哪里了呢
    }];
}

#pragma mark - buildViewModel

- (void)buildSimpleShowViewModel {
    if (!self.simpleShowViewModel) {
        self.simpleShowViewModel = [[BN_ShopGoodDetailSimpleShowViewModel alloc] init];
    }
    [self.simpleShowView setBn_data:self.simpleShowViewModel.photoList];
    @weakify(self);
    [self.simpleShowView setRefreshBlock:^{
        @strongify(self);
        [self.simpleShowViewModel getPicsData];
    }];
    [self.simpleShowViewModel.photoList.loadSupport setDataRefreshblock:^{
        @strongify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.simpleShowView updateThumbnailWith:self.simpleShowViewModel.thumbnailUrlList];
            [self.simpleShowView updateWith:self.simpleShowViewModel.shortDescription schedule:[self.simpleShowViewModel scheduleWith:0]];
        });
    }];
    [self.simpleShowViewModel getPicsData];
}

- (void)bulidStateViewModel {
    self.stateViewModel = [[BN_ShopGoodDetaiStateViewModel alloc] init];
    [self.view setBn_data:self.stateViewModel];
    @weakify(self);
    [self.view setRefreshBlock:^{
        @strongify(self);
        [self.stateViewModel getSimpleDetailDataWith:self.simpleShowViewModel.goodsId];
    }];
    [self.stateViewModel.loadSupport setDataRefreshblock:^{
        @strongify(self);
        self.simpleShowViewModel.shortDescription = self.stateViewModel.simpleDetailModel.name;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self buildStateView];
            [self buildTransitionControllers];
            [self.simpleShowView updateWith:self.simpleShowViewModel.shortDescription schedule:[self.simpleShowViewModel scheduleWith:0]];
            [self.sellersView updateWith:self.stateViewModel.simpleDetailModel.shop_name iconUrl:self.stateViewModel.simpleDetailModel.shop_logo];
            [self.transitionToolBar updateWith:self.stateViewModel.commentNumStr];
            [self.friendlyWarningView updateWith:self.stateViewModel.freeShippingStatus point:self.stateViewModel.pointStr deliver:@"第三方发货"];
        });
       
    }];
    [self.stateViewModel getSimpleDetailDataWith:self.simpleShowViewModel.goodsId];
}

- (void)buildStateView {
    CGFloat height = 54.0f;
    self.stateView.hidden = YES;
    self.stateView = nil;
    switch (self.stateViewModel.state) {
        case GoodDetaiState_Forward:
        {
            BN_ShopGoodDetaiForwardStateView *stateView = [BN_ShopGoodDetaiForwardStateView nib];
            [stateView updateWith:self.stateViewModel.date countdownToLastSeconds:0];
            [stateView updateWith:self.stateViewModel.realPriceStr frontPrice:self.stateViewModel.frontPriceAttrStr tips:self.stateViewModel.tips follow:self.stateViewModel.followNumStr];
            self.stateView = stateView;
            height = [stateView getViewHeight];
        }
            break;
        case GoodDetaiState_Panic:
        {
            BN_ShopGoodDetaiPanicStateView *stateView = [BN_ShopGoodDetaiPanicStateView nib];
            [stateView updateWith:self.stateViewModel.date countdownToLastSeconds:0];
            [stateView updateWith:self.stateViewModel.realPriceStr frontPrice:self.stateViewModel.frontPriceAttrStr saleNum:self.stateViewModel.saleNumStr residue:self.stateViewModel.residueNumStr];
            self.stateView = stateView;
            height = [stateView getViewHeight];
        }
            break;
            
        default:
        {
            BN_ShopGoodDetaiNormalStateView *stateView = [BN_ShopGoodDetaiNormalStateView nib];
            [stateView updateWith:self.stateViewModel.realPriceStr frontPrice:self.stateViewModel.frontPriceAttrStr];
            self.stateView = stateView;
            height = [stateView getViewHeight];
        }
            break;
    }
    [self.headeView addSubview:self.stateView];
    [self.stateView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.headeView];
    [self.stateView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.headeView];
    [self.stateView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.simpleShowView];
    [self.stateView autoSetDimension:ALDimensionHeight toSize:height];
    
}

- (void)buildArribalsViewModel {
    self.arribalsViewModel = [[BN_ShopGoodDetailNewArrivalsViewModel alloc] init];
    [self.arribalsViewModel.dataSource resetellIdentifier:ShopGoodDetailNewArrivalsCellIdentifier configureCellBlock:^(id cell, BN_ShopGoodDetailNewArrivalsModel *item) {
        [(BN_ShopGoodDetailNewArribalsCell *)cell updateWith:item.pic_url];
    }];
    
    @weakify(self);
    [self.arribalsView.collectionView setHeaderRefreshDatablock:^{
        @strongify(self);
        [self.arribalsViewModel getNewArrivalsClearData:YES goodsId:self.simpleShowViewModel.goodsId];
    } footerRefreshDatablock:^{
        @strongify(self);
        [self.arribalsViewModel getNewArrivalsClearData:NO goodsId:self.simpleShowViewModel.goodsId];
    }];
    
    [self.arribalsView.collectionView setCollectionViewData:self.arribalsViewModel.arrivals];
    [self.arribalsView.collectionView setBn_data:self.arribalsViewModel.arrivals];
    
    [self.arribalsView.collectionView setRefreshBlock:^{
        @strongify(self);
         [self.arribalsViewModel getNewArrivalsClearData:YES goodsId:self.simpleShowViewModel.goodsId];
    }];
    [self.arribalsViewModel.arrivals.loadSupport setDataRefreshblock:^{
        @strongify(self);
        [self.arribalsView.collectionView reloadData];
    }];
    [self.arribalsViewModel getNewArrivalsClearData:YES goodsId:self.simpleShowViewModel.goodsId];
    
    self.arribalsView.collectionView.dataSource = self.arribalsViewModel.dataSource;
    [self.arribalsView.collectionView reloadData];
}

- (void)buildArribalsView {
    self.arribalsView = [[BN_ShopGoodDetailNewArrivalsView alloc] init];
    [self.arribalsView updateWith:ShopGoodDetailNewArrivalsCellIdentifier registerNib:[BN_ShopGoodDetailNewArribalsCell nib]];
    [self.arribalsView updateWith:self.arribalsViewModel.dataSource];
    [self.arribalsView updateWith:self.arribalsViewModel.title subTitle:self.arribalsViewModel.subTitle];
    [[self.arribalsView rac_collectionViewDidSelectItemSignal] subscribeNext:^(id x) {
//        x为NSIndexPath
#warning -----点击新推荐的图片跳转
    }];
}

- (void)buildTransitionToolBar {
    self.transitionToolBar = [BN_ShopGoodDetailTransitionToolBar nib];
    @weakify(self);
    [self.transitionToolBar updateWith:@"" segmentedControlChangedValue:^(NSInteger selectedIndex) {
        @strongify(self);
        UIViewController *newController = self.curController;
        if (selectedIndex >= 0 && selectedIndex < self.controllers.count) {
            newController = [self.controllers objectAtIndex:selectedIndex];
        }
        if (newController != self.curController) {
            if ([self.curController respondsToSelector:@selector(setHeadView:)]) {
                [self.curController performSelectorOnMainThread:@selector(setHeadView:) withObject:[self.subHeadeViews objectAtIndex:selectedIndex] waitUntilDone:NO];
            }
            if ([newController respondsToSelector:@selector(setHeadView:)]) {
                [newController performSelectorOnMainThread:@selector(setHeadView:) withObject:self.headeView waitUntilDone:NO];
            }
        }
        [self replaceController:self.curController newController:newController];
    }];
    
    [self.headeView addSubview:self.transitionToolBar];
    [self.transitionToolBar autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.headeView];
    [self.transitionToolBar autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.headeView];
    [self.transitionToolBar autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.sellersView];
    [self.transitionToolBar autoSetDimension:ALDimensionHeight toSize:[self.transitionToolBar getViewHeight]];
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
    
    
    BN_ShopGoodDetailBuyViewController *ctr = [[BN_ShopGoodDetailBuyViewController alloc] initWith:self.stateViewModel.simpleDetailModel.pic_url standards:self.stateViewModel.simpleDetailModel.name price:self.stateViewModel.simpleDetailModel.real_price];
    ctr.view.backgroundColor = [ColorBlack colorWithAlphaComponent:0.17];
    [ctr setModalPresentationStyle:UIModalPresentationCustom];
    [ctr setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    ctr.delegate = self;
    [self presentViewController:ctr animated:YES completion:nil];
}

#pragma mark - 页面跳转
- (void)buildTransitionControllers {
    self.controllers = [NSMutableArray array];
//    NSString *readmePath = [[NSBundle mainBundle] pathForResource:@"Image.html" ofType:nil];
//    self.stateViewModel.simpleDetailModel.goodDescription = [NSString stringWithContentsOfFile:readmePath encoding:NSUTF8StringEncoding error:NULL];
    BN_ShopGoodSpecificDetailsViewController *detailCtr = [[BN_ShopGoodSpecificDetailsViewController alloc] initWithHtml:self.stateViewModel.simpleDetailModel.goodDescription];
    BN_ShopGoodDetailCommentViewController *commetnCtr = [[BN_ShopGoodDetailCommentViewController alloc] initWith:self.simpleShowViewModel.goodsId type:self.simpleShowViewModel.type];
    BN_ShopGoodDetailConsultancyViewController *consultancCtr = [[BN_ShopGoodDetailConsultancyViewController alloc] initWith:self.simpleShowViewModel.goodsId];

    detailCtr.automaticallyAdjustsScrollViewInsets = NO;
    commetnCtr.automaticallyAdjustsScrollViewInsets = NO;
    consultancCtr.automaticallyAdjustsScrollViewInsets = NO;
    [detailCtr setHeadView:[self.subHeadeViews objectAtIndex:0]];
    [commetnCtr setHeadView:[self.subHeadeViews objectAtIndex:1]];
    [consultancCtr setHeadView:[self.subHeadeViews objectAtIndex:2]];
    [self.controllers addObject:detailCtr];
    [self addChildViewController:detailCtr];
    [self.controllers addObject:commetnCtr];
    [self addChildViewController:commetnCtr];
    [self.controllers addObject:consultancCtr];
    [self addChildViewController:consultancCtr];
    
    
    [detailCtr setHeadView:self.headeView];
    [self.view addSubview:detailCtr.view];
    self.curController = detailCtr;
    
    [self.view bringSubviewToFront:self.toolBar];

}

- (void)replaceController:(UIViewController *)oldController newController:(UIViewController *)newController
{
    if (oldController == newController) {
        return;
    }
    
    
    [self addChildViewController:newController];
    [self transitionFromViewController:oldController toViewController:newController duration:0.0 options:UIViewAnimationOptionTransitionNone animations:nil completion:^(BOOL finished) {
        
        if (finished) {
            
            [oldController didMoveToParentViewController:nil];
            [oldController removeFromParentViewController];
            [newController didMoveToParentViewController:self];
            self.curController = newController;
            
            [self.view bringSubviewToFront:self.toolBar];
        }else{
            self.curController = oldController;
        }
        
    }];
}


#pragma mark - BN_ShopGoodDetailBuyViewControllerDelegate
- (void)goodDetailBuyCountWith:(int)cout {
    @weakify(self);
    [self.stateViewModel addShoppingCartWith:self.simpleShowViewModel.goodsId num:cout success:^{
        @strongify(self);
        [self showHudSucess:TEXT(@"加入购物车")];
    } failure:^(NSString *errorDescription) {
        @strongify(self);
        [self showHudError:TEXT(@"加入购物车失败") title:errorDescription];
    }];
}
@end
