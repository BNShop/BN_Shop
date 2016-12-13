//
//  LBB_OrderAalesCollectionViewCell.h
//  BN_Shop
//
//  Created by 美少男 on 16/12/8.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LBB_OrderAalesCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@property (weak, nonatomic) IBOutlet UIImageView *rightImgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightImagWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightHeightContraint;


@end
