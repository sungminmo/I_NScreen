//
//  CMPageCollectionViewCell.m
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 10. 16..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import "CMPageCollectionViewCell.h"
#import "UIImageView+AFNetworking.h"

@interface CMPageCollectionViewCell ()
@property (nonatomic, strong) NSString *sEpisodePeerExistence;
@property (nonatomic, strong) NSString *sContentGroupId;
@property (nonatomic, strong) NSString *sAssetBundle;

@end

@implementation CMPageCollectionViewCell
@synthesize pTitleLbl, pThumImageView;
@synthesize nIndex;
@synthesize delegate;
@synthesize pAssetIdStr;
@synthesize isAdultCheck;

- (void)awakeFromNib {

    self.pTitleLbl.font = [UIFont systemFontOfSize:CNM_DEFAULT_FONT_SIZE];
}


- (void)setListData:(NSDictionary *)dic WithIndex:(int)index WithPage:(int)nPage
{
    self.nIndex = (index + 1) + (nPage * 8);
    
    self.sEpisodePeerExistence = @"0";
    self.sContentGroupId = @"";
    self.sAssetBundle = @"0";
    // tv 전용인지 아닌지
     NSArray *keyArr = [dic allKeys];
    
    BOOL isCheck = NO;
    for ( NSString *key in keyArr )
    {
        if ( [key isEqualToString:@"mobilePublicationRight"] )
        {
            isCheck = YES;
        }
        
        if ( [key isEqualToString:@"episodePeerExistence"] )
        {
            self.sEpisodePeerExistence = [NSString stringWithFormat:@"%@", [dic objectForKey:@"episodePeerExistence"]];
        }
        
        if ( [key isEqualToString:@"contentGroupId"] )
        {
            self.sContentGroupId = [NSString stringWithFormat:@"%@", [dic objectForKey:@"contentGroupId"]];
        }
        
        if ( [key isEqualToString:@""] )
        {
            self.sAssetBundle = [NSString stringWithFormat:@"%@", [dic objectForKey:@"assetBundle"]];
        }
    }
    
    if ( isCheck == YES )
    {
        self.pRankingView.hidden = YES;
        if ( [[dic objectForKey:@"mobilePublicationRight"] isEqualToString:@"1"] )
        {
            // 모바일
            self.pOnlyTvImageView.hidden = YES;
        }
        else
        {
            // tv
            self.pOnlyTvImageView.hidden = NO;
        }
    }
    else
    {
        self.pRankingView.hidden = NO;
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
    }
    
    self.pAssetIdStr = [NSString stringWithFormat:@"%@", [dic objectForKey:@"assetId"]];
    
    NSString *sImageFileName = [NSString stringWithFormat:@"%@", [dic objectForKey:@"smallImageFileName"]];
    self.pTitleLbl.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"title"]];
    
//    [self.pThumImageView setImageWithURL:[NSURL URLWithString:sImageFileName]];
    UIImage* holderImage = [UIImage imageNamed:@"posterlist_default.png"];
    [self.pThumImageView setImageWithURL:[NSURL URLWithString:sImageFileName] placeholderImage:holderImage];
    
    
    self.pRankingLbl.text = [NSString stringWithFormat:@"%d", self.nIndex];
    
//    if ( [[[CMAppManager sharedInstance] getDeviceCheck] isEqualToString:IPHONE_RESOLUTION_6_PLUS] )
//    {
//        [self.pTitleLbl setFont:[UIFont systemFontOfSize:15.0f]];
//    }
//    else if ( [[[CMAppManager sharedInstance] getDeviceCheck] isEqualToString:IPHONE_RESOLUTION_6] )
//    {
//        [self.pTitleLbl setFont:[UIFont systemFontOfSize:14.0f]];
//    }
//    else
//    {
//        [self.pTitleLbl setFont:[UIFont systemFontOfSize:12.0f]];
//    }
    
    // isNew > promotionSticker > hot 우선순위
    self.pStickerImageView.image = [[CMAppManager sharedInstance] makePromotionImage:dic];
    
    // 19금 딤 처리
    NSString *sRating = [NSString stringWithFormat:@"%@", [dic objectForKey:@"rating"]];
    
    if ( [sRating isEqualToString:@"19"] )
    {
        
        if ( [[CMAppManager sharedInstance] getKeychainAdultCertification] == YES )
        {
            // 성인 인증을 받았으면 딤 해제
            self.isAdultCheck = NO;
            self.pDimImageView.hidden = YES;
        }
        else
        {
            self.isAdultCheck = YES;
            self.pDimImageView.hidden = NO;
        }
        
    }
    else
    {
        self.isAdultCheck = NO;
        self.pDimImageView.hidden = YES;
    }
}

- (IBAction)onBtnClicked:(id)sender
{
    [self.delegate CMPageCollectionCellBtnClicked:self.nIndex WithAssetId:self.pAssetIdStr WithAdultCheck:self.isAdultCheck WithEpisodePeerExistence:self.sEpisodePeerExistence WithContentGroupId:self.sContentGroupId WithAssetBundle:self.sAssetBundle];
}

@end
