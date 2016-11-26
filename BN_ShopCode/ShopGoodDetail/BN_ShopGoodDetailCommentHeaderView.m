//
//  BN_ShopGoodDetailCommentHeaderView.m
//  BN_Shop
//
//  Created by Liya on 2016/11/20.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "BN_ShopGoodDetailCommentHeaderView.h"

@interface BN_ShopGoodDetailCommentHeaderView ()

@property (weak, nonatomic) IBOutlet UILabel *avgortLabel;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *starImgs;

@end

@implementation BN_ShopGoodDetailCommentHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.avgortLabel.textColor = ColorLightGray;
    self.avgortLabel.font = Font12;
    [self.avgortLabel sizeToFit];
    
    for (UIImageView *img in self.starImgs) {
        [img setImage:IMAGE(@"Shop_GoodDetail_UnStar")];
    }
}

- (void)updateWith:(NSString *)avgort {
    self.avgortLabel.text = [NSString stringWithFormat:@"%@: %@", TEXT(@"综合评价"), avgort];
    NSInteger num = [avgort integerValue];
    [self.starImgs enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx+1 <= num) {
            [(UIImageView *)obj setImage:IMAGE(@"Shop_GoodDetail_Star")];
        } else {
            [(UIImageView *)obj setImage:IMAGE(@"Shop_GoodDetail_UnStar")];
        }
    }];
}

- (CGFloat)getViewHeight {
    return 32.0f;
}

@end
