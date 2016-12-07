//
//  LBB_OrderCommentSectionView.h
//  Textdd
//
//  Created by 美少男 on 16/11/1.
//  Copyright © 2016年 美少男. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LBB_OrderCommentSectionView : UICollectionReusableView

@property(nonatomic,strong) NSMutableDictionary *cellInfo;
@property(nonatomic,weak) UIViewController *parentVC;


@end
