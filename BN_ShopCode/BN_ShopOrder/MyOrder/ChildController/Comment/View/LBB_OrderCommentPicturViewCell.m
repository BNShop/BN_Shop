//
//  LBB_OrderCommentPicturViewCell.m
//  Textdd
//
//  Created by 美少男 on 16/11/1.
//  Copyright © 2016年 美少男. All rights reserved.
//

#import "LBB_OrderCommentPicturViewCell.h"
#import "LBB_OrderHeader.h"


@interface LBB_OrderCommentPicturViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *iconImgView;
@property (weak, nonatomic) IBOutlet UIImageView *defaultImgView;

@end

@implementation LBB_OrderCommentPicturViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.exclusiveTouch = YES;
    
    self.layer.borderColor = ColorLine.CGColor;
    self.layer.borderWidth = 1.0;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    self.iconImgView.image = nil;
    self.defaultImgView.image = nil;
    self.cellInfo = nil;
}

- (void)setCellInfo:(NSDictionary *)cellInfo
{
    _cellInfo = cellInfo;
    UIImage *picture = [_cellInfo objectForKey:PictureKey];
    self.isDefault = [[_cellInfo objectForKey:DefaultKey] boolValue];
    self.iconImgView.image = picture;
    if (self.isDefault) {
        self.iconImgView.image = nil;
        self.defaultImgView.image = picture;
    }else{
       self.defaultImgView.image = nil;
       self.iconImgView.contentMode = UIViewContentModeScaleAspectFill;
    }
}

@end
