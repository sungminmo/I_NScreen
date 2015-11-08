//
//  AdultMainCollectionViewCell.m
//  I_NScreen
//
//  Created by kimts on 2015. 11. 8..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import "AdultMainCollectionViewCell.h"
#import "UIImageView+AFNetworking.h"

@interface AdultMainCollectionViewCell ()

@property (nonatomic, strong) IBOutlet UIImageView* posterImageView;
@property (nonatomic, strong) IBOutlet UILabel* titleLabel;

@end

@implementation AdultMainCollectionViewCell

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

    if ( [type isEqualToString:@"200"] ) {
        
        NSURL* imageUrl = [NSURL URLWithString:data[@"smallImageFileName"]];
        [self.posterImageView setImageWithURL:imageUrl];
        
        self.titleLabel.text = data[@"title"];
    }
}

@end
