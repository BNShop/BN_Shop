//
//  BN_ShopHomeCategoryView.m
//  BN_Shop
//
//  Created by Liya on 16/11/17.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "BN_ShopHomeCategoryView.h"
#import "BN_ShopHeader.h"

@interface BN_ShopHomeCategoryView ()
@property (weak, nonatomic) IBOutlet UILabel *categoryTitleLabel0;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *categoryTitleLabels;
@property (weak, nonatomic) IBOutlet UIView *bottomLineView;

@end

@implementation BN_ShopHomeCategoryView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.bottomLineView.backgroundColor = ColorLine;
    
//    self.categoryTitleLabel0.text = TEXT(@"分类");
    self.categoryTitleLabel0.font = Font10;
    self.categoryTitleLabel0.textColor = ColorGray;
    for (UILabel *label in self.categoryTitleLabels) {
        label.font = Font10;
        label.textColor = ColorGray;
    }
    
}

- (void)updateWith:(NSArray *)titles {
    NSInteger count = MIN(titles.count, self.categoryTitleLabels.count);
    for (NSInteger index = 0; index < count; index++) {
        UILabel *label = [self.categoryTitleLabels objectAtIndex:index];
        label.text = [titles objectAtIndex:index];
    }
    self.categoryTitleLabel0.text = TEXT(@"分类");
}

- (IBAction)clickedTypeButton:(id)sender {
    if ([self.delegate respondsToSelector:@selector(shopHomeCategoryWith:)]) {
        [self.delegate shopHomeCategoryWith:[(UIButton *)sender tag]];
    }
}


- (CGFloat)getViewHeight {
    return 96.0f;
}

@end

@implementation BN_ShopHomeCategoryView (RAC)

- (RACSignal *)rac_shopHomeCategorySignal
{
    self.delegate = self;
    RACSignal *signal = objc_getAssociatedObject(self, _cmd);
    if (signal != nil) {
        return signal;
    }
    
    signal = [[self rac_signalForSelector:@selector(shopHomeCategoryWith:) fromProtocol:@protocol(BN_ShopHomeCategoryViewDelegate)] map:^id(RACTuple *tuple) {
        return tuple.first;
    }];
    
    objc_setAssociatedObject(self, _cmd, signal, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return signal;
}


@end
