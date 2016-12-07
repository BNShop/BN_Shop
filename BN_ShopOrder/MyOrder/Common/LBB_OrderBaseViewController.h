//
//  LBB_OrderBaseViewController.h
//  ST_Travel
//
//  Created by 美少男 on 16/12/6.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBB_OrderHeader.h"

@interface LBB_OrderBaseViewController : Base_BaseViewController

@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewBottomContraint;

@property (assign,nonatomic) OrderViewType baseViewType;

@end
