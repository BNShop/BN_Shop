//
//  BN_ShopGoodDetailTransitionToolBar.m
//  BN_Shop
//
//  Created by Liya on 2016/11/24.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "BN_ShopGoodDetailTransitionToolBar.h"
#import "HMSegmentedControl.h"
#import "PureLayout.h"
#import "BN_ShopHeader.h"

@interface BN_ShopGoodDetailTransitionToolBar ()
@property (strong, nonatomic) HMSegmentedControl *segmentedControl;

@property (copy) void(^block)(NSInteger selectedIndex);
@end

@implementation BN_ShopGoodDetailTransitionToolBar

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:@[TEXT(@"商品详情"), TEXT(@"商品评论"), TEXT(@"购买咨询")]];
    self.segmentedControl.selectionIndicatorHeight = 2.0f;  // 线的高度
    self.segmentedControl.selectionIndicatorColor = ColorBlack;//线条的颜色
    self.segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;//线充满整个字
    self.segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;//线的位置
    
    
    self.segmentedControl.titleTextAttributes = @{NSForegroundColorAttributeName : ColorLightGray, NSFontAttributeName : Font12};
    self.segmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : ColorBlack, NSFontAttributeName : Font12};

    [self.segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    
    [self addSubview:self.segmentedControl];
    [self.segmentedControl autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self];
    [self.segmentedControl autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self withOffset:10.0f];
    [self.segmentedControl autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self withOffset:-10.0f];
    [self.segmentedControl autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self withOffset:-2.0f];

}


- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
    NSLog(@"Selected index %ld (via UIControlEventValueChanged)", (long)segmentedControl.selectedSegmentIndex);
    if (self.block) {
        self.block (segmentedControl.selectedSegmentIndex);
    }
}

- (void)updateWith:(NSString *)commentNum segmentedControlChangedValue:(void(^)(NSInteger selectedIndex))block{
    self.segmentedControl.sectionTitles = @[TEXT(@"商品详情"), [NSString stringWithFormat:@"%@(%@)", TEXT(@"商品评论"), commentNum], TEXT(@"购买咨询")];
    self.block = block;
}

- (void)updateWith:(NSString *)commentNum {
    self.segmentedControl.sectionTitles = @[TEXT(@"商品详情"), [NSString stringWithFormat:@"%@(%@)", TEXT(@"商品评论"), commentNum], TEXT(@"购买咨询")];
}

- (CGFloat)getViewHeight {
    return 38.0f;
}

- (void)dealloc {
    self.block = nil;
}
@end
