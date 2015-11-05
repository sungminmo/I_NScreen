//
//  CMPageCollectionViewCell.m
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 10. 16..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import "CMPageCollectionViewCell.h"
#import "UIImageView+AFNetworking.h"

@implementation CMPageCollectionViewCell
@synthesize pTitleLbl, pThumImageView;
@synthesize nIndex;
@synthesize delegate;
@synthesize pAssetIdStr;

- (void)awakeFromNib {
    // Initialization code
}


- (void)setListData:(NSDictionary *)dic WithIndex:(int)index WithPage:(int)nPage
{
    self.nIndex = (index + 1) + (nPage * 8);
    
    self.pAssetIdStr = [NSString stringWithFormat:@"%@", [dic objectForKey:@"assetId"]];
    
    NSString *sImageFileName = [NSString stringWithFormat:@"%@", [dic objectForKey:@"smallImageFileName"]];
    self.pTitleLbl.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"title"]];
    [self.pThumImageView setImageWithURL:[NSURL URLWithString:sImageFileName]];
    self.pRankingLbl.text = [NSString stringWithFormat:@"%d", self.nIndex];
    
    if ( [[[CMAppManager sharedInstance] getDeviceCheck] isEqualToString:IPHONE_RESOLUTION_6_PLUS] )
    {
        [self.pTitleLbl setFont:[UIFont systemFontOfSize:15.0f]];
    }
    else if ( [[[CMAppManager sharedInstance] getDeviceCheck] isEqualToString:IPHONE_RESOLUTION_6] )
    {
        [self.pTitleLbl setFont:[UIFont systemFontOfSize:14.0f]];
    }
    else
    {
        [self.pTitleLbl setFont:[UIFont systemFontOfSize:12.0f]];
    }
    
    
    if ( [[dic objectForKey:@"isNew"] isEqualToString:@"1"] )
    {
        // new 스티커
        self.pStickerImageView.image = [UIImage imageNamed:@"icon_promotion_01.png"];
    }
    else
    {
        if ( [[dic objectForKey:@"hot"] isEqualToString:@"1"] )
        {
            // hot 스티커
            self.pStickerImageView.image = [UIImage imageNamed:@"icon_promotion_02.png"];
        }
    }
    
    if ( [[dic objectForKey:@"assetNew"] isEqualToString:@"1"] ||
        [[dic objectForKey:@"assetNew"] isEqualToString:@"2"] )
    {
        // new 스티커
        self.pStickerImageView.image = [UIImage imageNamed:@"icon_promotion_01.png"];
    }
    else
    {
        if ( [[dic objectForKey:@"assetHot"] isEqualToString:@"1"] ||
            [dic objectForKey:@"2"] )
        {
            // hot 스티커
            self.pStickerImageView.image = [UIImage imageNamed:@"icon_promotion_02.png"];
        }
    }
    
    if ( [[dic objectForKey:@"promotionSticker"] isEqualToString:@"11"] )
    {
        // 반값
        self.pStickerImageView.image = [UIImage imageNamed:@""];
    }
    else if ( [[dic objectForKey:@"promotionSticker"] isEqualToString:@"12"] )
    {
        // 추천
        self.pStickerImageView.image = [UIImage imageNamed:@""];
    }
    else if ( [[dic objectForKey:@"promotionSticker"] isEqualToString:@"13"] )
    {
        // 이벤트
        self.pStickerImageView.image = [UIImage imageNamed:@"icon_promotion_03.png"];
    }
    else if ( [[dic objectForKey:@"promotionSticker"] isEqualToString:@"14"] )
    {
        // 극장동시
        self.pStickerImageView.image = [UIImage imageNamed:@""];
    }
    else if ( [[dic objectForKey:@"promotionSticker"] isEqualToString:@"15"] )
    {
        // 할인
        self.pStickerImageView.image = [UIImage imageNamed:@""];
    }
    else if ( [[dic objectForKey:@"promotionSticker"] isEqualToString:@"16"] )
    {
        // HOT
        self.pStickerImageView.image = [UIImage imageNamed:@"icon_promotion_02.png"];
    }
    else if ( [[dic objectForKey:@"promotionSticker"] isEqualToString:@"17"] )
    {
        // 선물 팡팡
        self.pStickerImageView.image = [UIImage imageNamed:@""];
    }
    else if ( [[dic objectForKey:@"promotionSticker"] isEqualToString:@"18"] )
    {
        // 쿠폰 할인
        self.pStickerImageView.image = [UIImage imageNamed:@""];
    }

    
  
}

- (IBAction)onBtnClicked:(id)sender
{
    [self.delegate CMPageCollectionCellBtnClicked:self.nIndex WithAssetId:self.pAssetIdStr];
}

@end
