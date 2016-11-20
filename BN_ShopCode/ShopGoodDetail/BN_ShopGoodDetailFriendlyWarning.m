//
//  BN_ShopGoodDetailFriendlyWarning.m
//  BN_Shop
//
//  Created by Liya on 2016/11/20.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "BN_ShopGoodDetailFriendlyWarning.h"

@interface BN_ShopGoodDetailFriendlyWarning ()

@property (weak, nonatomic) IBOutlet UILabel *friendlyLabel0;
@property (weak, nonatomic) IBOutlet UILabel *friendlyLabel1;
@property (weak, nonatomic) IBOutlet UIView *lineView0;
@property (weak, nonatomic) IBOutlet UIView *lineView1;

@property (weak, nonatomic) IBOutlet UILabel *pledgeLabel;
@property (weak, nonatomic) IBOutlet UILabel *pledgeLabel1;
@property (weak, nonatomic) IBOutlet UILabel *pledgeLabel2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *spaceWidthC;

@end

@implementation BN_ShopGoodDetailFriendlyWarning

- (void)awakeFromNib {
    [super awakeFromNib];
    self.friendlyLabel0.text = TEXT(@"");
    self.friendlyLabel0.font = Font10;
    self.friendlyLabel0.textColor = ColorLightGray;
    self.friendlyLabel1.text = TEXT(@"");
    self.friendlyLabel1.font = Font10;
    self.friendlyLabel1.textColor = ColorLightGray;
    
    self.lineView0.backgroundColor = ColorLine;
    self.lineView1.backgroundColor = ColorLine;
    
    self.pledgeLabel.text = TEXT(@"100%正品保证");
    self.pledgeLabel.textColor = ColorLightGray;
    self.pledgeLabel.font = Font8;
    [self.pledgeLabel sizeToFit];
    
    self.pledgeLabel1.text = TEXT(@"七天无理由退换货");
    self.pledgeLabel1.textColor = ColorLightGray;
    self.pledgeLabel1.font = Font8;
    [self.pledgeLabel1 sizeToFit];
    
    self.pledgeLabel2.text = TEXT(@"第三方发货");
    self.pledgeLabel2.textColor = ColorLightGray;
    self.pledgeLabel2.font = Font8;
    [self.pledgeLabel2 sizeToFit];
}

- (void)updateWith:(NSString *)postage point:(NSString *)point deliver:(NSString *)deliver {
    self.friendlyLabel0.text = postage;
    self.friendlyLabel1.text = point;
    self.pledgeLabel2.text = deliver;
    [self.pledgeLabel2 sizeToFit];
    
    self.spaceWidthC.constant = (WIDTH(self) - WIDTH(self.pledgeLabel2) - WIDTH(self.pledgeLabel) - WIDTH(self.pledgeLabel2) - 15 - 30)/4.0;
    [self setNeedsLayout];
}

- (CGFloat)getViewHeight {
    return 50.0f;
}

@end
