//
//  BN_ShopGoodDetailNewArrivalsView.m
//  BN_Shop
//
//  Created by Liya on 2016/11/21.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "BN_ShopGoodDetailNewArrivalsView.h"
#import "BN_ShopHeader.h"

@interface BN_ShopGoodDetailNewArrivalsView () <UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomLineView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation BN_ShopGoodDetailNewArrivalsView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.titleLabel.textColor = ColorBlack;
    self.titleLabel.font = Font10;
    [self.titleLabel sizeToFit];
    self.subTitleLabel.textColor = ColorLightGray;
    self.subTitleLabel.font = Font10;
    self.collectionView.delegate = self;
    
    self.bottomLineView.backgroundColor = ColorLine;
}

- (void)updateWith:(NSString *)title subTitle:(NSString *)subTitle {
    self.titleLabel.text = title;
    self.subTitleLabel.text = subTitle;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.titleLabel sizeToFit];
        [self.subTitleLabel sizeToFit];
    });
}

- (void)updateWith:(NSString *)cellReuseIdentifier registerNib:(UINib *)nib {
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:cellReuseIdentifier];
}

- (void)updateWith:(id<UICollectionViewDataSource>)dataSource {
    
    self.collectionView.dataSource = dataSource;
    self.collectionView.delegate = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.collectionView reloadData];
    });
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    if ([self.delegate respondsToSelector:@selector(collectionWith:didSelectItemAtIndexPath:)]) {
        [self.delegate collectionWith:collectionView didSelectItemAtIndexPath:indexPath];
    }
    
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = HEIGHT(collectionView) - 10 - 5;
    return CGSizeMake(height*240/306, height);
}

//cell的最小列间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10.0;
}

//内馅
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 12, 5, 10);
}


@end

@implementation BN_ShopGoodDetailNewArrivalsView (RAC)

- (RACSignal *)rac_collectionViewDidSelectItemSignal
{
    self.delegate = self;
    RACSignal *signal = objc_getAssociatedObject(self, _cmd);
    if (signal != nil) {
        return signal;
    }
    
    signal = [[self rac_signalForSelector:@selector(collectionWith:didSelectItemAtIndexPath:) fromProtocol:@protocol(BN_ShopGoodDetailNewArrivalsViewDelegate)] map:^id(RACTuple *tuple) {
        return tuple.second;
    }];
    
    objc_setAssociatedObject(self, _cmd, signal, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return signal;
}

@end
