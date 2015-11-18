//
//  CMContentGroupCollectionViewController.m
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 10. 29..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import "CMContentGroupCollectionViewController.h"

@interface CMContentGroupCollectionViewController ()
{
    NSArray *pArr;
    int nPage;
}
@end

@implementation CMContentGroupCollectionViewController

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id)initWithData:(NSArray *)arr WithPage:(int)page
{
    if ( self = [super initWithNibName:@"CMContentGroupCollectionViewController" bundle:nil])
    {
        pArr = arr;
        nPage = page;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UINib *nib = [UINib nibWithNibName:@"CMContentGroupCollectionViewCell" bundle:nil];
    [self.pCollectionView registerNib:nib forCellWithReuseIdentifier:@"CellId"];
}



- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    int nCount = (int)[pArr count];
    
    if ( [pArr isKindOfClass:[NSDictionary class]] )
        return 1;
    else
        return nCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CMContentGroupCollectionViewCell *cell = [self.pCollectionView dequeueReusableCellWithReuseIdentifier:@"CellId" forIndexPath:indexPath];
    
    cell.delegate = self;
    //    STCollectionItem *item = [_items objectAtIndex:indexPath.row];
    //    cell.numberLabel.text = [NSString stringWithFormat:@"%d", item.number];
    //    cell.captionLabel.text = item.caption;
    if ( [pArr isKindOfClass:[NSDictionary class]] )
    {
        [cell setListData:(NSDictionary *)pArr WithIndex:(int)indexPath.row WithPage:nPage];
    }
    else
    {
        [cell setListData:[pArr objectAtIndex:indexPath.row] WithIndex:(int)indexPath.row WithPage:nPage];
    }
    
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size;
    
    if ( [[[CMAppManager sharedInstance] getDeviceCheck] isEqualToString:IPHONE_RESOLUTION_6_PLUS] )
    {
        size.width = 95;
        size.height = 158;
    }
    else if ( [[[CMAppManager sharedInstance] getDeviceCheck] isEqualToString:IPHONE_RESOLUTION_6] )
    {
        size.width = 85;
        size.height = 138;
    }
    else
    {
        size.width = 70;
        size.height = 113;
    }
    
    
    return size;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //    STCollectionItem *item = [_items objectAtIndex:indexPath.row];
    //    NSString *message = [NSString stringWithFormat:@"%d\n%@", item.number, item.caption];
    //
    
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
}

- (void)CMContentGroupCollectionViewCellBtnClicked:(int)nSelect WithAssetId:(NSString *)assetId WithSeriesLink:(NSString *)seriesLint WithAdultCheck:(BOOL)isAdult
{
    [self.delegate CMContentGroupCollectionBtnClicked:nSelect WithAssetId:assetId WithSeriesLink:seriesLint WithAdultCheck:isAdult];
}


@end
