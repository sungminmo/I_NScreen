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

- (void)awakeFromNib {
    // Initialization code
}

- (void)setListData:(NSDictionary *)dic WithIndex:(int)index WithPage:(int)nPage
{
    self.nIndex = (index + 1) + (nPage * 4);
    
    self.pAssetIdStr = [NSString stringWithFormat:@"%@", [dic objectForKey:@"primaryAssetId"]];
    NSString *sUrl = [NSString stringWithFormat:@"%@", [dic objectForKey:@"smallImageFileName"]];
    [self.pThumImageView setImageWithURL:[NSURL URLWithString:sUrl]];
    
    self.pTitleLbl.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"title"]];
}

- (IBAction)onBtnClicked:(id)sender
{
    [self.delegate CMContentGroupCollectionViewCellBtnClicked:self.nIndex WithAssetId:self.pAssetIdStr];
}

@end
