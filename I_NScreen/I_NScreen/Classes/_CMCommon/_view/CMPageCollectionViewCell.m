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
@synthesize isAdultCheck;

- (void)awakeFromNib {
    // Initialization code
}


- (void)setListData:(NSDictionary *)dic WithIndex:(int)index WithPage:(int)nPage
{
    self.nIndex = (index + 1) + (nPage * 8);
    
    // tv 전용인지 아닌지
    if ( [[dic objectForKey:@"publicationRight"] isEqualToString:@"2"] )
    {
        // tv모바일
        self.pOnlyTvImageView.hidden = YES;
    }
    else
    {
        // tv
        self.pOnlyTvImageView.hidden = NO;
    }
    
    
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
    
    // promotionSticker > isNew > hot 우선순위
    NSString *sPromotionSticker = [NSString stringWithFormat:@"%@", [dic objectForKey:@"promotionSticker"]];
    NSString *sIsNew = [NSString stringWithFormat:@"%@", [dic objectForKey:@"isNew"]];
    NSString *sHot = [NSString stringWithFormat:@"%@", [dic objectForKey:@"hot"]];
    
    [self.pStickerImageView setImage:[UIImage imageNamed:@""]];
    
//    if ( [sPromotionSticker isEqualToString:@"0"] )
//    {
//        // new
//        [self.pStickerImageView setImage:[UIImage imageNamed:@"icon_promotion_01.png"]];
//    }
//    if ( [sPromotionSticker isEqualToString:@"11"] )
//    {
        // 반값
//        [self.pStickerImageView setImage:[UIImage imageNamed:@"icon_promotion_01.png"]];    //
//    }
    if ( [sPromotionSticker isEqualToString:@"12"] )
    {
        // 추천
        [self.pStickerImageView setImage:[UIImage imageNamed:@"icon_promotion_06.png"]];
    }
    else if ( [sPromotionSticker isEqualToString:@"13"] )
    {
        // 이벤트
        [self.pStickerImageView setImage:[UIImage imageNamed:@"icon_promotion_03.png"]];
    }
    else if ( [sPromotionSticker isEqualToString:@"14"] )
    {
        // 극장 동시
        [self.pStickerImageView setImage:[UIImage imageNamed:@"icon_promotion_07.png"]];
    }
    else if ( [sPromotionSticker isEqualToString:@"15"] )
    {
        // 할인
        [self.pStickerImageView setImage:[UIImage imageNamed:@"icon_promotion_09.png"]];    //
    }
    else if ( [sPromotionSticker isEqualToString:@"16"] )
    {
        // HOT
        [self.pStickerImageView setImage:[UIImage imageNamed:@"icon_promotion_02.png"]];
    }
    else if ( [sPromotionSticker isEqualToString:@"17"] )
    {
        // 쿠폰 증정
        [self.pStickerImageView setImage:[UIImage imageNamed:@"icon_promotion_04.png"]];
    }
    else if ( [sPromotionSticker isEqualToString:@"18"] )
    {
        // 랭킹1위
        [self.pStickerImageView setImage:[UIImage imageNamed:@"icon_promotion_05.png"]];
    }
    else
    {
        if ( [sIsNew isEqualToString:@"1"] )
        {
            // new
            [self.pStickerImageView setImage:[UIImage imageNamed:@"icon_promotion_01.png"]];
        }
        else
        {
            //
            if ( [sHot isEqualToString:@"1"] )
            {
                // hot
                [self.pStickerImageView setImage:[UIImage imageNamed:@"icon_promotion_02.png"]];
            }
        }
    }
    
    // 19금 딤 처리
    NSString *sRating = [NSString stringWithFormat:@"%@", [dic objectForKey:@"rating"]];
    
    if ( [sRating isEqualToString:@"19"] )
    {
        self.isAdultCheck = YES;
        self.pDimImageView.hidden = NO;
    }
    else
    {
        self.isAdultCheck = NO;
        self.pDimImageView.hidden = YES;
    }
}

- (IBAction)onBtnClicked:(id)sender
{
    [self.delegate CMPageCollectionCellBtnClicked:self.nIndex WithAssetId:self.pAssetIdStr WithAdultCheck:self.isAdultCheck];
}

@end
