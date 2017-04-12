//
//  LBB_OrderModuleViewController.m
//  ST_Travel
//
//  Created by 美少男 on 16/11/17.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "LBB_OrderModuleViewController.h"
#import "LBB_OrderViewController.h"
#import "HMSegmentedControl.h"
#import "BN_ShopHeader.h"


#define  ViewNum 5

@interface LBB_OrderModuleViewController ()
<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *contentScrollView;
@property(nonatomic,strong) LBB_OrderViewController *vc0;
@property(nonatomic,strong) LBB_OrderViewController *vc1;
@property(nonatomic,strong) LBB_OrderViewController *vc2;
@property(nonatomic,strong) LBB_OrderViewController *vc3;
@property(nonatomic,strong) LBB_OrderViewController *vc4;

@property(nonatomic,strong) HMSegmentedControl *segmentedControl;


@end

@implementation LBB_OrderModuleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"我的订单", nil);
    self.view.backgroundColor = ColorBackground;
    //加载ViewController
    [self addChildViewController];
    //加载ScrollView
    [self setContentScrollView];
    //加载Segment
    [self setSegment];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES]; 
    [self.navigationController.navigationBar setBackgroundImage:[UIImage createImageWithColor:[UIColor clearColor]] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage createImageWithColor:[UIColor clearColor]]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setSegment {
    
    _segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"全部",@"待付款",@"待收货",@"待评价",@"售后"]];
    _segmentedControl.selectionIndicatorHeight = 2.0f;  // 线的高度
    _segmentedControl.titleTextAttributes = @{NSFontAttributeName:Font15,
                                              NSForegroundColorAttributeName:ColorLightGray};
    _segmentedControl.selectedTitleTextAttributes = @{NSFontAttributeName:Font15,
                                                      NSForegroundColorAttributeName:ColorBtnYellow};
    _segmentedControl.selectionIndicatorColor = ColorBtnYellow;
    _segmentedControl.verticalDividerWidth = 1.0;
    _segmentedControl.verticalDividerColor = ColorLightGray;
    _segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    _segmentedControl.layer.borderColor = [ColorLine CGColor];
    _segmentedControl.layer.borderWidth = 1.0;
    _segmentedControl.frame = CGRectMake(0, 0, DeviceWidth, TopSegmmentControlHeight);
    
    [_segmentedControl addTarget:self
                          action:@selector(segmentedControlChangedValue:)
                forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:_segmentedControl];
    
    [self selectIndex];
}
 
- (void)selectIndex
{
    switch (self.baseViewType) {
        case eOrderType://我的订单
            [_segmentedControl setSelectedSegmentIndex:0];
            [self scrollToPage:0];
            break;
        case eOrderType_WaitPay: //我的订单_待付款
            [_segmentedControl setSelectedSegmentIndex:1];
            [self scrollToPage:1];
            break;
        case eOrderType_WaitGetTicket: //我的订单_待取票
            [_segmentedControl setSelectedSegmentIndex:2];
            [self scrollToPage:2];
            break;
        case eOrderType_WaitComment: //我的订单_待评价
            [_segmentedControl setSelectedSegmentIndex:3];
            [self scrollToPage:3];
            break;
        case eOrderType_AfterAales: //我的订单_售后
            [_segmentedControl setSelectedSegmentIndex:4];
            [self scrollToPage:4];
            break;
            
        default:
            break;
    }
}

//加载ScrollView
-(void)setContentScrollView {
    
    UIScrollView *sv = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 40, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:sv];
    sv.bounces = NO;
    sv.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    sv.contentOffset = CGPointMake(0, 0);
    sv.pagingEnabled = YES;
    sv.showsHorizontalScrollIndicator = NO;
    sv.scrollEnabled = NO;
    sv.userInteractionEnabled = YES;
    sv.delegate = self;
    
    for (int i=0; i<self.childViewControllers.count; i++) {
        UIViewController * vc = self.childViewControllers[i];
        vc.view.frame = CGRectMake(i * DeviceWidth, 0, DeviceWidth, self.view.frame.size.height);
        [sv addSubview:vc.view];
    }
    
    sv.contentSize = CGSizeMake(ViewNum * DeviceWidth, 0);
    self.contentScrollView = sv;
}

//加载3个ViewController
-(void)addChildViewController{
    
    self.vc0 = [self getLBB_OrderViewController];
    self.vc0.baseViewType  = eOrderType;
    [self addChildViewController:self.vc0];
    
    self.vc1 = [self getLBB_OrderViewController];
    self.vc1.baseViewType  = eOrderType_WaitPay;
    [self addChildViewController:self.vc1];
    
    self.vc2 = [self getLBB_OrderViewController];
    self.vc2.baseViewType  = eOrderType_WaitGetTicket;
    [self addChildViewController:self.vc2];
    
    self.vc3 = [self getLBB_OrderViewController];
    self.vc3.baseViewType  = eOrderType_WaitComment;
    [self addChildViewController:self.vc3];
    
    self.vc4 = [self getLBB_OrderViewController];
    self.vc4.baseViewType  = eOrderType_AfterAales;
    [self addChildViewController:self.vc4];
}

- (LBB_OrderViewController *)getLBB_OrderViewController
{
    LBB_OrderViewController *vc = [[LBB_OrderViewController alloc] initWithNibName:@"LBB_OrderViewController" bundle:nil]; 
    
    return vc ;
}

#pragma mark - UIScrollViewDelegate

- (void)segmentedControlChangedValue:(HMSegmentedControl*)segmentControll
{
    int selectIndex = (int)segmentControll.selectedSegmentIndex;
    [self scrollToPage:selectIndex];
}

// 只要滚动UIScrollView就会调用
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //计算当前index
    int  pageIndex = (int)(scrollView.contentOffset.x / DeviceWidth);
    NSLog(@"%d",(int)(scrollView.contentOffset.x / DeviceWidth));
    [self scrollToPage:pageIndex];//修复页面自动滚动偏差
}

//实现LGSegment代理方法
-(void)scrollToPage:(int)Page {
    CGPoint offset = self.contentScrollView.contentOffset;
    offset.x = self.view.frame.size.width * Page;
    [UIView animateWithDuration:0.3 animations:^{
        self.contentScrollView.contentOffset = offset;
    }];
    NSLog(@"Page = %d",Page);
}

@end
