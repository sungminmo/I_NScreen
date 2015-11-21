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

@property (nonatomic, strong) IBOutlet UIImageView* posterImageView;
@property (nonatomic, strong) IBOutlet UILabel* titleLabel;
@property (nonatomic, strong) NSString *sAssetId;
@property (nonatomic, strong) IBOutlet UIImageView *pDimImageView;  // 성인 딤 처리 이미지
@property (nonatomic) BOOL isAdultCheck;
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
    if ( [type isEqualToString:@"200"] ) {
    
        self.sAssetId = [NSString stringWithFormat:@"%@", [data objectForKey:@"assetId"]];
        
        NSString *sPublicationRight = [NSString stringWithFormat:@"%@", [data objectForKey:@"publicationRight"]];
        
        // tv 전용인지 아닌지
        if ( [sPublicationRight isEqualToString:@"2"] )
        {
            // tv모바일
            self.pOnlyTvImageView.hidden = YES;
        }
        else
        {
            // tv
            self.pOnlyTvImageView.hidden = NO;
        }
        
        
        NSURL* imageUrl = [NSURL URLWithString:data[@"smallImageFileName"]];
        [self.posterImageView setImageWithURL:imageUrl];
        
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
}

- (IBAction)onBtnClicked:(UIButton *)btn
{
    [self.delegate CMHomeCommonCollectionViewDidItemSelectWithAssetId:self.sAssetId WithAdultCheck:self.isAdultCheck];
}

@end
