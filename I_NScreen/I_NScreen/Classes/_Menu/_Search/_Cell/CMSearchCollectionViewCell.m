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

@end

@implementation CMSearchCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setImageUrl:(NSString*)imageUrl title:(NSString*)title rating:(NSString *)rating{
 
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
    [self.posterImageView setImageWithURL:[NSURL URLWithString:imageUrl]];
    self.titleLabel.text = title;
}

@end
