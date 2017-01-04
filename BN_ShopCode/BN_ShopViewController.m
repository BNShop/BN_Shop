//
//  BN_ShopViewController.m
//  BN_Shop
//
//  Created by newman on 16/11/11.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "BN_ShopViewController.h"
#import <Base_UITabBarBaseController.h>
#import "LBB_OrderModuleViewController.h"
#import "BN_ShopHeader.h"
#import "BN_MySouvenirViewController.h"
#import "BN_MyCollectionViewController.h"
#import "BN_MyLimitBuyViewController.h"

@interface BN_ShopViewController ()

@end

@implementation BN_ShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self setNavigationBarHidden:YES];
    [(Base_UITabBarBaseController*)self.tabBarController setTabBarHidden:NO animated:YES];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(50, 100, 100, 50)];
    [btn setTitle:@"我的订单" forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor blueColor]];
    [btn addTarget:self action:@selector(btnCLickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    UIButton *btna = [[UIButton alloc] initWithFrame:CGRectMake(200, 100, 100, 50)];
    [btna setTitle:@"我的收藏" forState:UIControlStateNormal];
    [btna setBackgroundColor:[UIColor blueColor]];
    [btna addTarget:self action:@selector(myCollection) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btna];
    
    UIButton *btnb = [[UIButton alloc] initWithFrame:CGRectMake(50, 300, 100, 50)];
    [btnb setTitle:@"限时抢购" forState:UIControlStateNormal];
    [btnb setBackgroundColor:[UIColor blueColor]];
    [btnb addTarget:self action:@selector(myLimitbuy) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnb];
    
    UIButton *btnc = [[UIButton alloc] initWithFrame:CGRectMake(200, 300, 100, 50)];
    [btnc setTitle:@"伴手礼" forState:UIControlStateNormal];
    [btnc setBackgroundColor:[UIColor blueColor]];
    [btnc addTarget:self action:@selector(mySouvenir) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnc];
}

- (void)myCollection {
    BN_MyCollectionViewController *vc = [[BN_MyCollectionViewController alloc] initWithNibName:@"BN_MyCollectionViewController" bundle:[NSBundle mainBundle]];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)myLimitbuy {
    BN_MyLimitBuyViewController *vc = [[BN_MyLimitBuyViewController alloc] initWithNibName:@"BN_MyLimitBuyViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)mySouvenir {
    BN_MySouvenirViewController *vc = [[BN_MySouvenirViewController alloc] initWithNibName:@"BN_MySouvenirViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)btnCLickAction:(id)sender
{
    LBB_OrderModuleViewController *vc = [[LBB_OrderModuleViewController alloc] init];
    vc.baseViewType = eOrderType;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
