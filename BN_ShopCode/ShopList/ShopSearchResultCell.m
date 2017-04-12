//
//  ShopSearchResultCell.m
//  BN_Shop
//
//  Created by Liya on 2016/12/6.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "ShopSearchResultCell.h"
#import "BN_ShopHeader.h"

@interface ShopSearchResultCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomLine;


@end

@implementation ShopSearchResultCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.titleLabel.text = nil;
    self.titleLabel.font = Font12;
    self.titleLabel.textColor = ColorLightGray;
    self.bottomLine.backgroundColor = ColorLine;
}


- (void)updateWith:(NSString *)title {
    self.titleLabel.text = title;
}
@end
