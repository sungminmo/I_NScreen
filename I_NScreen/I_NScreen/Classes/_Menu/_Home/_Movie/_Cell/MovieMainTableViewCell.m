//
//  MovieMainTableViewCell.m
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 11. 2..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import "MovieMainTableViewCell.h"

@implementation MovieMainTableViewCell
@synthesize delegate;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setListData:(NSArray *)arr WithIndex:(int)index WithViewerType:(NSString *)viewerType
{
    int nCount = (int)[arr count];
    
    if ( [viewerType isEqualToString:@"200"] )
    {
        // 인기순위
        for ( int i = 0; i < nCount; i++ )
        {
            switch (i) {
                case 0:
                {
                    self.pTitleLbl01.text = [NSString stringWithFormat:@"%@", [[arr objectAtIndex:i] objectForKey:@"title"]];
                }break;
                case 1:
                {
                    self.pTitleLbl02.text = [NSString stringWithFormat:@"%@", [[arr objectAtIndex:i] objectForKey:@"title"]];
                }break;
                case 2:
                {
                    self.pTitleLbl03.text = [NSString stringWithFormat:@"%@", [[arr objectAtIndex:i] objectForKey:@"title"]];
                }break;
                case 3:
                {
                    self.pTitleLbl04.text = [NSString stringWithFormat:@"%@", [[arr objectAtIndex:i] objectForKey:@"title"]];
                }break;
            }
        }
    }
    
    
}



@end
