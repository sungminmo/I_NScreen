//
//  CMContentGroupCollectionViewCell.m
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 10. 29..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import "CMContentGroupCollectionViewCell.h"
#import "UIImageView+AFNetworking.h"

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
    
    self.pAssetIdStr = [NSString stringWithFormat:@"%@", [dic objectForKey:@"primaryAssetId"]];
    NSString *sUrl = [NSString stringWithFormat:@"%@", [dic objectForKey:@"smallImageFileName"]];
    self.pSeriesLintStr = [NSString stringWithFormat:@"%@", [dic objectForKey:@"assetSeriesLink"]];
    [self.pThumImageView setImageWithURL:[NSURL URLWithString:sUrl]];
    
    self.pTitleLbl.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"title"]];
}

- (IBAction)onBtnClicked:(id)sender
{
    [self.delegate CMContentGroupCollectionViewCellBtnClicked:self.nIndex WithAssetId:self.pAssetIdStr WithSeriesLink:self.pSeriesLintStr];
}

@end
