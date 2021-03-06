//
//  CMContentGroupCollectionViewCell.m
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 10. 29..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import "CMContentGroupCollectionViewCell.h"
#import "UIImageView+AFNetworking.h"

@interface CMContentGroupCollectionViewCell ()

@property (nonatomic, strong) NSString *sEpisodePeerExistence;
@property (nonatomic, strong) NSString *sContentGroupId;
@property (nonatomic, strong) NSString *sAssetBundle;

@end

@implementation CMContentGroupCollectionViewCell
@synthesize pTitleLbl, pThumImageView;
@synthesize nIndex;
@synthesize delegate;
@synthesize pAssetIdStr;
@synthesize pSeriesLintStr;
@synthesize pOnlyTvImageView;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setListData:(NSDictionary *)dic WithIndex:(int)index WithPage:(int)nPage
{
    self.nIndex = (index + 1) + (nPage * 4);
    
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
        
        if ( [key isEqualToString:@"assetBundle"] )
        {
            self.sAssetBundle = [NSString stringWithFormat:@"%@", [dic objectForKey:@"assetBundle"]];
        }
    }

    
    self.pAssetIdStr = [NSString stringWithFormat:@"%@", [dic objectForKey:@"primaryAssetId"]];
    NSString *sUrl = [NSString stringWithFormat:@"%@", [dic objectForKey:@"smallImageFileName"]];
    self.pSeriesLintStr = [NSString stringWithFormat:@"%@", [dic objectForKey:@"assetSeriesLink"]];
//    [self.pThumImageView setImageWithURL:[NSURL URLWithString:sUrl]];
    UIImage* holderImage = [UIImage imageNamed:@"posterlist_default.png"];
    [self.pThumImageView setImageWithURL:[NSURL URLWithString:sUrl] placeholderImage:holderImage];
    
    self.pTitleLbl.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"title"]];
    
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
        self.pDimImageView.hidden = YES;
        self.isAdultCheck = NO;
    }
}

- (IBAction)onBtnClicked:(id)sender
{
    [self.delegate CMContentGroupCollectionViewCellBtnClicked:self.nIndex WithAssetId:self.pAssetIdStr WithSeriesLink:self.pSeriesLintStr WithAdultCheck:self.isAdultCheck WithEpisodePeerExistence:self.sEpisodePeerExistence WithContentGroupId:self.sContentGroupId WithAssetBundle:self.sAssetBundle];
}

@end
