//
//  LBB_OrderCommentTagViewCell.h
//  Textdd
//
//  Created by 美少男 on 16/11/1.
//  Copyright © 2016年 美少男. All rights reserved.
//

#import <UIKit/UIKit.h>

CGFloat orderCommentTagCellWith(NSString* content,BOOL close);

@interface LBB_OrderCommentTagViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property(nonatomic,strong) NSDictionary *cellInfo;
@property(nonatomic,assign) BOOL isDefault;


@end
