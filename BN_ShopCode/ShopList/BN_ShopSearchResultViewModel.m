//
//  BN_ShopSearchResultViewModel.m
//  BN_Shop
//
//  Created by Liya on 2016/12/6.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "BN_ShopSearchResultViewModel.h"
#import "NSArray+BlocksKit.h"

@interface BN_ShopSearchResultViewModel ()<UIScrollViewDelegate>

@end

@implementation BN_ShopSearchResultViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSMutableArray *array = [[NSMutableArray alloc] initFromNet];
        self.resultDataSource = [[TableDataSource alloc] initWithItems:array cellIdentifier:nil configureCellBlock:nil];
    }
    return self;
}

- (void)getSearchResultDataRes:(BOOL)clear keyword:(NSString *)keyword {
    int curPage = clear == YES ? 0 : round(self.resultDataSource.getItemsCount/10.0);
    NSMutableDictionary *paraDic = nil;
    NSString *url = [[NSString stringWithFormat:@"%@/mall/goodsKeyWord?curPage=%d&pageNum=10&word=%@",BASEURL,curPage, keyword] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    __weak typeof(self) temp = self;
    self.resultDataSource.items.loadSupport.loadEvent = NetLoadingEvent;
    
    [[BC_ToolRequest sharedManager] GET:url parameters:paraDic success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSDictionary *dic = responseObject;
        NSNumber *codeNumber = [dic objectForKey:@"code"];
        NSLog(@"url = %@", operation.currentRequest);
        if(codeNumber.intValue == 0)
        {
            NSArray *array = [dic objectForKey:@"rows"];
            NSArray *returnArray = [array bk_map:^id(id obj) {
                return obj[@"name"];
            }];
            
            if (clear == YES)
            {
                [temp.resultDataSource.items removeAllObjects];
            }
            
            [temp.resultDataSource.items addObjectsFromArray:returnArray];
            temp.resultDataSource.items.networkTotal = [dic objectForKey:@"total"];
        }
        else
        {
            NSString *errorStr = [dic objectForKey:@"remark"];
        }
        
        temp.resultDataSource.items.loadSupport.loadEvent = codeNumber.intValue;
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
        temp.resultDataSource.items.loadSupport.loadEvent = NetLoadFailedEvent;
    }];
    
}



#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    NSString *result = [self.resultDataSource itemAtIndexPath:indexPath];
    if (self.collectionSelectBlock) {
        self.collectionSelectBlock (result);
    }
    
}


- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = (WIDTH(collectionView) - 14*2);
    return CGSizeMake(width, 40);
    
}

//cell的最小行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 6.0;
}

//cell的最小列间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 5.0;
}

//内馅
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(6, 14, 6, 14);
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.collectionScrollBlock) {
        self.collectionScrollBlock ();
    }
}

@end
