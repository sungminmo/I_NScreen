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
        
        NSURL* imageUrl = [NSURL URLWithString:data[@"smallImageFileName"]];
        [self.posterImageView setImageWithURL:imageUrl];
        
        self.titleLabel.text = data[@"title"];
    }
}

- (IBAction)onBtnClicked:(UIButton *)btn
{
    [self.delegate CMHomeCommonCollectionViewDidItemSelectWithAssetId:self.sAssetId];
}

@end
