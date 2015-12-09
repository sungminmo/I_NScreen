//
//  CMHomeCommonCollectionViewCell.m
//  I_NScreen
//
//  Created by 조백근 on 2015. 11. 8..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import "CMHomeCommonCollectionViewCell.h"
#import "UIImageView+AFNetworking.h"

@interface CMHomeCommonCollectionViewCell ()

@property (nonatomic, weak) IBOutlet UIImageView* posterImageView;
@property (nonatomic, weak) IBOutlet UIImageView* promotionImageView;
@property (nonatomic, weak) IBOutlet UILabel* titleLabel;
@property (nonatomic, weak) IBOutlet UIImageView *pDimImageView;  // 성인 딤 처리 이미지

@property (nonatomic, strong) NSString *sAssetId;
@property (nonatomic) BOOL isAdultCheck;
@property (nonatomic, strong) NSString *sEpisodePeerExistence;  // 1이면 시리즈 나머진 단일
@property (nonatomic, strong) NSString *sContentGroupId;
@property (nonatomic, strong) NSString *sAssetBundle;           // 1이면 묶음 상품
@end

@implementation CMHomeCommonCollectionViewCell
@synthesize delegate;

#pragma mark - Life Cycle

- (void)awakeFromNib {
    
}

#pragma mark - Private

- (void)reset {
    
    self.posterImageView.image = nil;
    self.titleLabel.text = @"";
}

#pragma mark - Public

- (void)setListData:(NSDictionary*)data WithViewerType:(NSString*)type {
    
    self.sAssetId = @"";
    self.sContentGroupId = @"";
    self.sEpisodePeerExistence = @"0";
    self.sAssetBundle = @"0";
    
    NSArray *allKey = [data allKeys];
        
        
    for ( NSString *key in allKey )
    {
        if ( [key isEqualToString:@"assetId"] )
        {
            self.sAssetId = [NSString stringWithFormat:@"%@", [data objectForKey:@"assetId"]];
        }
        
        if ( [key isEqualToString:@"primaryAssetId"] )
        {
            self.sAssetId = [NSString stringWithFormat:@"%@", [data objectForKey:@"primaryAssetId"]];
        }
        
        if ( [key isEqualToString:@"episodePeerExistence"] )
        {
            self.sEpisodePeerExistence = [NSString stringWithFormat:@"%@", [data objectForKey:@"episodePeerExistence"]];
        }
        
        if ( [key isEqualToString:@"contentGroupId"] )
        {
            self.sContentGroupId = [NSString stringWithFormat:@"%@", [data objectForKey:@"contentGroupId"]];
        }
        
        if ( [key isEqualToString:@"assetBundle"] )
        {
            self.sAssetBundle = @"1";
        }
    }
    
    // tv 전용인지 아닌지
    NSArray *keyArr = [data allKeys];
    BOOL isCheck = NO;
    for ( NSString *key in keyArr )
    {
        if ( [key isEqualToString:@"mobilePublicationRight"] )
        {
            isCheck = YES;
        }
    }
    
    if ( isCheck == YES )
    {
        if ( [[data objectForKey:@"mobilePublicationRight"] isEqualToString:@"1"] )
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
        if ( [[data objectForKey:@"publicationRight"] isEqualToString:@"2"] )
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
    
    self.promotionImageView.image = [[CMAppManager sharedInstance] makePromotionImage:data];
    
    NSURL* imageUrl = [NSURL URLWithString:data[@"smallImageFileName"]];
//    [self.posterImageView setImageWithURL:imageUrl];
    UIImage* holderImage = [UIImage imageNamed:@"posterlist_default.png"];
    [self.posterImageView setImageWithURL:imageUrl placeholderImage:holderImage];
    
    self.titleLabel.text = data[@"title"];
    
    NSString *sRating = [NSString stringWithFormat:@"%@", [data objectForKey:@"rating"]];
    
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

- (IBAction)onBtnClicked:(UIButton *)btn
{
    [self.delegate CMHomeCommonCollectionViewDidItemSelectWithAssetId:self.sAssetId WithAdultCheck:self.isAdultCheck WithEpisodePeerExistentce:self.sEpisodePeerExistence WithContentGroupId:self.sContentGroupId WithAssetBundle:self.sAssetBundle];
}

@end
