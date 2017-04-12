//
//  UITableViewCell+NIB.m
//  CTAS
//
//  Created by Liya on 16/1/4.
//  Copyright © 2016年 Liya. All rights reserved.
//

#import "UITableViewCell+NIB.h"

@implementation UITableViewCell (NIB)
+ (UINib *)nib
{
    return [UINib nibWithNibName:NSStringFromClass([self class]) bundle:nil];
}


+ (id)loadCellOfType:(Class)tp fromNib:(NSString*)nibName withId:(NSString*)reuseId {
    
    @try{
        NSArray* objects = [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil];
        for (id object in objects) {
            if ([object isKindOfClass:tp]) {
                UITableViewCell *cell = object;
                [cell setValue:reuseId forKey:@"_reuseIdentifier"];
                return cell;
            }
        }
    }
    @catch(NSException *exception) {
        NSLog(@"exception:%@", exception);
    }
    
    
    [NSException raise:@"WrongNibFormat" format:@"Nib for '%@' must contain one TableViewCell, and its class must be '%@'", nibName, tp];
    
    return nil;
}

+ (id)loadFromNibWith:(NSString*)reuseId
{
    return [self loadCellOfType:self fromNib:NSStringFromClass([self class]) withId:reuseId];
}

@end

@implementation UICollectionViewCell (NIB)
+ (UINib *)nib
{
    return [UINib nibWithNibName:NSStringFromClass([self class]) bundle:nil];
}
@end

@implementation UICollectionReusableView (NIB)
+ (UINib *)nib
{
    return [UINib nibWithNibName:NSStringFromClass([self class]) bundle:nil];
}
@end
