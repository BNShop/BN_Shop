//
//  BN_ShopViewController.m
//  BN_Shop
//
//  Created by newman on 16/11/11.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "BN_ShopViewController.h"
#import "ST_TabBarController.h"

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
    [(ST_TabBarController*)self.tabBarController setTabBarHidden:NO animated:YES];
    
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
