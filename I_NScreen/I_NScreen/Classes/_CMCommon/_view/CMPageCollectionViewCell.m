//
//  CMPageCollectionViewCell.m
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 10. 16..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import "CMPageCollectionViewCell.h"
#import "UIImageView+AFNetworking.h"

@implementation CMPageCollectionViewCell
@synthesize pTitleLbl, pThumImageView;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setListData:(NSDictionary *)dic WithIndex:(int)index
{
    NSString *sImageFileName = [NSString stringWithFormat:@"%@", [dic objectForKey:@"imageFileName"]];
    self.pTitleLbl.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"title"]];
    [self.pThumImageView setImageWithURL:[NSURL URLWithString:sImageFileName]];
    
    
    if ( [[[CMAppManager sharedInstance] getDeviceCheck] isEqualToString:IPHONE_RESOLUTION_6_PLUS] )
    {
        [self.pTitleLbl setFont:[UIFont systemFontOfSize:15.0f]];
    }
    else if ( [[[CMAppManager sharedInstance] getDeviceCheck] isEqualToString:IPHONE_RESOLUTION_6] )
    {
        [self.pTitleLbl setFont:[UIFont systemFontOfSize:14.0f]];
    }
    else
    {
        [self.pTitleLbl setFont:[UIFont systemFontOfSize:12.0f]];
    }
}

@end
