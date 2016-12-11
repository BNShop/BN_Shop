//
//  LBB_OrderDetailViewCell.h
//  adf
//
//  Created by 美少男 on 16/12/6.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBB_OrderModel.h"
#import "LBB_OrderHeader.h"

CGFloat orderCellHeight(LBB_OrderModelDetail* cellInfo);

@interface LBB_OrderDetailViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *monneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageWidthContraint;

@property(nonatomic,strong) LBB_OrderModelDetail* cellInfo;


@end
