//
//  CMSearchCollectionViewCell.m
//  I_NScreen
//
//  Created by 조백근 on 2015. 9. 20..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import "CMSearchCollectionViewCell.h"
#import "UIImageView+AFNetworking.h"

@interface CMSearchCollectionViewCell()

@property (nonatomic, weak) IBOutlet UIImageView* posterImageView;
@property (nonatomic, weak) IBOutlet UILabel* titleLabel;
@property (nonatomic, weak) IBOutlet UIImageView *pAdultImageView;
@property (nonatomic, weak) IBOutlet UIImageView *pTvOnlyImageView;
@property (nonatomic, weak) IBOutlet UIImageView *promotionImageView;
@end

@implementation CMSearchCollectionViewCell

- (void)awakeFromNib {

    self.titleLabel.font = [UIFont systemFontOfSize:CNM_DEFAULT_FONT_SIZE];
}

- (void)setImageUrl:(NSString*)imageUrl title:(NSString*)title rating:(NSString *)rating WithTyOnly:(BOOL)isTyOnly data:(NSDictionary*)data{
 
    if ( [rating isEqualToString:@"19"] )
    {
        if ( [[CMAppManager sharedInstance] getKeychainAdultCertification] == YES )
        {
            // 성인 인증을 받았으면 딤 해제
            self.pAdultImageView.hidden = YES;
        }
        else
        {
            self.pAdultImageView.hidden = NO;
        }
    }
    else
    {
        self.pAdultImageView.hidden = YES;
    }

    self.posterImageView.image = nil;
//    [self.posterImageView setImageWithURL:[NSURL URLWithString:imageUrl]];
    UIImage* holderImage = [UIImage imageNamed:@"posterlist_default.png"];
    [self.posterImageView setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:holderImage];
    
    self.titleLabel.text = title;
    
    UIImage* promotionImage = [[CMAppManager sharedInstance] makePromotionImage:data];
    self.promotionImageView.image = promotionImage;
}

@end
