//
//  BN_ShopHomeSouvenirCell.m
//  BN_Shop
//
//  Created by Liya on 16/11/17.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "BN_ShopHomeSouvenirCell.h"
#import "UIImageView+WebCache.h"
#import "NSString+URL.h"
#import "UIView+BlocksKit.h"


@interface BN_ShopHomeSouvenirCell () <UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UIImageView *adImgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *midLineView0;
@property (weak, nonatomic) IBOutlet UIView *midLineView1;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIView *bottomLineView;

@end

@implementation BN_ShopHomeSouvenirCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.titleLabel.textColor = ColorBlack;
    self.titleLabel.font = Font15;
    
    self.midLineView0.backgroundColor = ColorLine;
    self.midLineView1.backgroundColor = ColorLine;
    self.bottomLineView.backgroundColor = ColorLine;
    
    self.collectionView.delegate = self;
    
    self.adImgView.userInteractionEnabled = YES;
    self.titleLabel.userInteractionEnabled = YES;
    @weakify(self);
    [self.adImgView bk_whenTapped:^{
        @strongify(self);
        if ([self.delegate respondsToSelector:@selector(clickThumbnailWith:)]) {
            [self.delegate clickThumbnailWith:self];
        }
    }];

    [self.titleLabel bk_whenTapped:^{
        @strongify(self);
        if ([self.delegate respondsToSelector:@selector(clickTitleWith:)]) {
            [self.delegate clickTitleWith:self];
        }
    }];
    
//    self.adImgView.q_BorderColor = ColorLine;
//    self.adImgView.q_BorderWidth = 2.0f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateWith:(NSString *)title thumbnailUrl:(NSString *)thumbnailUrl dataSource:(id <UICollectionViewDataSource>)dataSource {
    self.titleLabel.text = title;
    [self.adImgView sd_setImageWithURL:[thumbnailUrl URL] placeholderImage:IMAGE(@"")];
    self.collectionView.dataSource = dataSource;
    if ([dataSource collectionView:self.collectionView numberOfItemsInSection:0] == 0) {
        self.midLineView1.hidden = YES;
        self.collectionView.hidden = YES;
    } else {
        self.midLineView1.hidden = NO;
        self.collectionView.hidden = NO;
    }
}


#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    if ([self.delegate respondsToSelector:@selector(tableViewWith:collectionViewDidSelectItemAtIndexPath:)]) {
        [self.delegate tableViewWith:self collectionViewDidSelectItemAtIndexPath:indexPath];
    }
    
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = HEIGHT(collectionView) - 10 - 20;
    return CGSizeMake(height-37, height);
}

//cell的最小列间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 5.0;
}

//内馅
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 12, 20, 10);
}


@end

@implementation BN_ShopHomeSouvenirCell (RAC)

- (RACSignal *)rac_shopHomeSouvenirCellSignal
{
    self.delegate = self;
    RACSignal *signal = objc_getAssociatedObject(self, _cmd);
    if (signal != nil) {
        return signal;
    }
    
    signal = [[self rac_signalForSelector:@selector(tableViewWith:collectionViewDidSelectItemAtIndexPath:) fromProtocol:@protocol(BN_ShopHomeSouvenirCellDelegate)] map:^id(RACTuple *tuple) {
        return tuple.allObjects;
    }];
    
    objc_setAssociatedObject(self, _cmd, signal, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return signal;
}

- (RACSignal *)rac_shopHomeClickTitleSignal
{
    self.delegate = self;
    RACSignal *signal = objc_getAssociatedObject(self, _cmd);
    if (signal != nil) {
        return signal;
    }
    
    signal = [[self rac_signalForSelector:@selector(clickTitleWith:) fromProtocol:@protocol(BN_ShopHomeSouvenirCellDelegate)] map:^id(RACTuple *tuple) {
        return tuple.first;
    }];
    
    objc_setAssociatedObject(self, _cmd, signal, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return signal;
}

- (RACSignal *)rac_shopHomeClickThumbnailSignal
{
    self.delegate = self;
    RACSignal *signal = objc_getAssociatedObject(self, _cmd);
    if (signal != nil) {
        return signal;
    }
    
    signal = [[self rac_signalForSelector:@selector(clickThumbnailWith:) fromProtocol:@protocol(BN_ShopHomeSouvenirCellDelegate)] map:^id(RACTuple *tuple) {
        return tuple.first;
    }];
    
    objc_setAssociatedObject(self, _cmd, signal, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return signal;
}

@end
