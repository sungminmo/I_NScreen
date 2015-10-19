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

@property (nonatomic, strong) IBOutlet UIImageView* posterImageView;
@property (nonatomic, strong) IBOutlet UILabel* titleLabel;

@end

@implementation CMSearchCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setImageUrl:(NSString*)imageUrl title:(NSString*)title {
    
    [self.posterImageView setImageWithURL:[NSURL URLWithString:imageUrl]];
    self.titleLabel.text = title;
}

@end
