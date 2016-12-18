//
//  SJR_TabBarController.m
//  ShiJuRen
//
//  Created by newman on 15/8/16.
//  Copyright (c) 2015年 qijuntonglian. All rights reserved.
//

#import "ST_TabBarController.h"
#import "BN_ShopViewController.h"
#import "BN_ShopHomeViewController.h"

#if __has_include("ReceiptAddressViewController.h")
#import "ReceiptAddressViewController.h"
#define HAS_AddressList 1
#endif

@interface ST_TabBarController ()<UITabBarControllerDelegate>
{
    UINavigationController *navigationControllerHome;
    UINavigationController *navigationControllerMy;
    UINavigationController *navigationControllerSquare;
    UINavigationController *navigationControllerMall;
    
    UIButton *centerBtn;
}
@end

@implementation ST_TabBarController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self loadTabBarViewControllers];
        });
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        [self loadTabBarViewControllers];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    centerBtn = [[UIButton alloc]initWithFrame:CGRectMake((DeviceWidth/2) - 22.5, DeviceHeight - 49 + 2, 45, 45)];
    [centerBtn setBackgroundImage:IMAGE(@"SJR_TabMiddleBtn") forState:UIControlStateNormal];
    [centerBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:centerBtn];
  
#if HAS_AddressList
    UIStoryboard *main = [UIStoryboard storyboardWithName:@"MineStoryboard" bundle:nil];
    ReceiptAddressViewController *addRessVC = [main instantiateViewControllerWithIdentifier:@"ReceiptAddressViewController"];
    addRessVC.selectBlock = ^(LBB_AddressModel *addressModel){
        long addressId = addressModel.addressId;//地址主键
        NSString *name = addressModel.name;//收货人
        NSString *phone = addressModel.phone;//收货手机号
        BOOL isDefault = addressModel.isDefault;//是否默认
        NSString *provinceName = addressModel.provinceName;//省份名
        long provinceId = addressModel.provinceId;//省份ID
        NSString *cityName = addressModel.cityName;//城市名
        long cityId = addressModel.cityId;//城市ID
        NSString *districtName = addressModel.districtName;//县、区名称
        long  districtId = addressModel.districtId;//县、区ID
        NSString  *address = addressModel.address;//地址名称
        NSString  *zipcode = addressModel.zipcode;//邮件编码
    };
#endif
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadTabBarViewControllers
{
    Base_BaseViewController *viewController1        = [[BN_ShopViewController alloc]init];
    Base_BaseViewController *viewController2        = [[BN_ShopViewController alloc]init];
    Base_BaseViewController *viewController3        = [[BN_ShopHomeViewController alloc]init];

    Base_BaseViewController *viewController4  = [[BN_ShopViewController alloc]init];
    UIViewController *viewController5        = [[UIViewController alloc]init];

    navigationControllerHome          = [[UINavigationController alloc]initWithRootViewController:viewController1];
    navigationControllerHome.title    = @"首页";
    navigationControllerSquare            = [[UINavigationController alloc]initWithRootViewController:viewController2];
    navigationControllerSquare.title      = @"广场";
    navigationControllerMall       = [[UINavigationController alloc]initWithRootViewController:viewController3];
    navigationControllerMall.title = @"商城";
    navigationControllerMy         = [[UINavigationController alloc]initWithRootViewController:viewController4];
    navigationControllerMy.title   = @"我的";
    
    [navigationControllerHome setNavigationBarHidden:YES animated:NO];
    [navigationControllerMy setNavigationBarHidden:YES animated:NO];
    [navigationControllerSquare setNavigationBarHidden:YES animated:NO];
    [navigationControllerMall setNavigationBarHidden:YES animated:NO];
    
    viewController1.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"首页"
                                                              image:IMAGEOriginal(@"ST_TabImage1")
                                                      selectedImage:IMAGEOriginal(@"ST_TabImage1d")];
    
    viewController2.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"广场"
                                                              image:IMAGEOriginal(@"ST_TabImage2")
                                                      selectedImage:IMAGEOriginal(@"ST_TabImage2d")];
    
    viewController3.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"商城"
                                                              image:IMAGEOriginal(@"ST_TabImage3")
                                                      selectedImage:IMAGEOriginal(@"ST_TabImage3d")];
    
    viewController4.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"我的"
                                                              image:IMAGEOriginal(@"ST_TabImage4")
                                                      selectedImage:IMAGEOriginal(@"ST_TabImage4d")];
    
    viewController1.tabBarItem.imageInsets   = UIEdgeInsetsMake(0, -0, -0, 0);
    viewController2.tabBarItem.imageInsets   = UIEdgeInsetsMake(0, -0, -0, 0);
    viewController3.tabBarItem.imageInsets   = UIEdgeInsetsMake(0,0, -0, -0);
    viewController4.tabBarItem.imageInsets   = UIEdgeInsetsMake(0, 0, -0, -0);

    self.viewControllers = @[navigationControllerHome,navigationControllerSquare,viewController5,navigationControllerMall,navigationControllerMy];
    
    self.delegate = self;
}


- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    NSLog(@"切换到页面%@",viewController.title);
    return YES;
}

-(void)buttonAction:(UIButton*)button
{
    
}

- (void)setTabBarHidden:(BOOL)hidden animated:(BOOL)animated
{
    [super setTabBarHidden:hidden animated:animated];
    CGFloat height = hidden == YES ? DeviceHeight + 2 + 6 : DeviceHeight - 49 + 2;
    if(animated == YES)
    {
        [UIView animateWithDuration:.3 animations:^{
            [centerBtn setFrame:CGRectMake((DeviceWidth/2) - 22.5, height, 45, 45)];
        }];
    }
    else
    {
        [centerBtn setFrame:CGRectMake((DeviceWidth/2) - 22.5, height, 45, 45)];
    }
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
