//
//  UITableViewCell+NIB.h
//  CTAS
//
//  Created by Liya on 16/1/4.
//  Copyright © 2016年 Liya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableViewCell (NIB)
+ (UINib *)nib;

+ (id)loadCellOfType: (Class)tp fromNib: (NSString*)nibName withId: (NSString*)reuseId;
+ (id)loadFromNibWith:(NSString*)reuseId;

@end


@interface UICollectionViewCell (NIB)
+ (UINib *)nib;

@end

@interface UICollectionReusableView (NIB)
+ (UINib *)nib;
@end
