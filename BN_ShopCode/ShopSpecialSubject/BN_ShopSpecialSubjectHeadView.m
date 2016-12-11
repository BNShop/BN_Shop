//
//  BN_ShopSpecialSubjectHeadView.m
//  BN_Shop
//
//  Created by Liya on 2016/11/22.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "BN_ShopSpecialSubjectHeadView.h"
#import "UIControl+BlocksKit.h"
#import "UIImageView+WebCache.h"
#import "NSString+URL.h"
#import "BN_ShopHeader.h"

@interface BN_ShopSpecialSubjectHeadView () <UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UILabel *followLabel;
@property (weak, nonatomic) IBOutlet UILabel *likeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeight;

@end

@implementation BN_ShopSpecialSubjectHeadView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.commentLabel.textColor = ColorGray;
    self.commentLabel.font = Font8;
    self.followLabel.textColor = ColorGray;
    self.followLabel.font = Font8;
    self.likeLabel.textColor = ColorGray;
    self.likeLabel.font = Font8;
    [self.likeLabel sizeToFit];
    [self.followLabel sizeToFit];
    [self.contentLabel sizeToFit];
    
    self.contentLabel.textColor = ColorGray;
    self.contentLabel.font = Font12;
    [self.contentLabel sizeToFit];
    
    self.collectionView.delegate = self;
    
}

- (void)updateWith:(NSString *)imgUrl comment:(NSString *)comment follow:(NSString *)follow like:(NSString *)like content:(NSString *)content {
    [self.imgView sd_setImageWithURL:[imgUrl URL] placeholderImage:nil];
    [self.commentLabel setText:comment];
    [self.followLabel setText:follow];
    [self.likeLabel setText:like];
    [self.contentLabel setText:content];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.commentLabel sizeToFit];
        [self.followLabel sizeToFit];
        [self.likeLabel sizeToFit];
        [self.contentLabel sizeToFit];
        self.contentHeight.constant = [self.contentLabel sizeThatFits:CGSizeMake(WIDTH(self)-50, 0)].height;
    });
    
}

- (void)collectionViewRegisterNib:(UINib *)nib forCellWithReuseIdentifier:(NSString *)identifier {
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:identifier];
}

- (void)updateWith:(id<UICollectionViewDataSource>)dataSource {
    [self.collectionView setDataSource:dataSource];
    [self.collectionView reloadData];
    if ([dataSource respondsToSelector:@selector(collectionView:numberOfItemsInSection:)]) {
        NSInteger num = ([dataSource collectionView:self.collectionView numberOfItemsInSection:0]+2)/3;
        self.collectionHeight.constant = MAX(0.1, num*24.0f+(num-1)*7);
    }
}


- (CGFloat)getViewHeight {
    CGFloat h = HEIGHT(self.imgView) + self.collectionHeight.constant + self.contentHeight.constant + 40 + 60;
    return h;
}


#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = (WIDTH(collectionView) - 52 - 10*2) / 3.0;
    return CGSizeMake(width, 24);
    
}

//cell的最小行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 7.0f;
}

//cell的最小列间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10.0f;
}

//内馅
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 26, 0, 26);
}


@end
