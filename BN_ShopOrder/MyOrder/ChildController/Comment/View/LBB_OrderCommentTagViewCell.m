//
//  LBB_OrderCommentTagViewCell.m
//  Textdd
//
//  Created by 美少男 on 16/11/1.
//  Copyright © 2016年 美少男. All rights reserved.
//

#import "LBB_OrderCommentTagViewCell.h"
//#import "CommonFunc.h"
#import "LBB_OrderHeader.h"

CGFloat orderCommentTagCellWith(NSString* content,BOOL close)
{
    CGFloat width = 10.f;
    if (close) {
        width = 35.f;
    }
    CGSize size = OrderSizeOfString(content, CGSizeMake(9999, 35.f), Font15);
    width += size.width;
    return width;
}

@interface LBB_OrderCommentTagViewCell()

@property (weak, nonatomic) IBOutlet UILabel *tagNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *bottomLabel;

@end


@implementation LBB_OrderCommentTagViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.exclusiveTouch = YES;
    self.tagNameLabel.textColor = ColorBlack;
    self.tagNameLabel.font = Font15;
    self.layer.borderColor = ColorLine.CGColor;
    self.layer.borderWidth = 1.0f;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    self.tagNameLabel.text = nil;
    self.bottomLabel.text = nil;
}

- (void)setCellInfo:(NSDictionary *)cellInfo
{
    _cellInfo = cellInfo;
    NSString *content = [_cellInfo objectForKey:TicketTagDescKey];
    self.isDefault = [[_cellInfo objectForKey:DefaultKey] boolValue];
    if (self.isDefault) {
        self.bottomLabel.hidden = NO;
        self.bottomLabel.text = content;
        self.tagNameLabel.text = nil;
        self.closeBtn.hidden = YES;
    }else{
        self.bottomLabel.text = nil;
        self.tagNameLabel.text = content;
        self.closeBtn.hidden = NO;
    }
}


- (IBAction)closeBtnClickAction:(id)sender {
    NSLog(@"\n 关闭标签");
}


@end
