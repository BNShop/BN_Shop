//
//  LBB_OrderBaseViewController.m
//  ST_Travel
//
//  Created by 美少男 on 16/12/6.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "LBB_OrderBaseViewController.h"
#import "BN_ShopHeader.h"

@interface LBB_OrderBaseViewController ()

@end

@implementation LBB_OrderBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
        [self loadCustomNavigationButton];
    self.automaticallyAdjustsScrollViewInsets = NO;//对策scroll View自动向下移动20像素问题
    
//    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
//    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"我的登录_顶部返回"] style:UIBarButtonItemStylePlain target:self action:@selector(backAction:)];
//    self.navigationItem.leftBarButtonItem = backBarButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setNavigationBarHidden:NO];
}



#pragma mark -  UI Action
- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
