//
//  MyCMMainTableViewCell.m
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 9. 16..
//  Copyright (c) 2015년 STVN. All rights reserved.
//

#import "MyCMMainTableViewCell.h"

@implementation MyCMMainTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setListData:(NSDictionary *)dic WithIndex:(int)index
{
    if ( index != 0 )
    {
        self.pLineImageView01.hidden = YES;
    }
    else
    {
        self.pLineImageView01.hidden = NO;
    }
    
    self.pTitleLbl.text = [NSString stringWithFormat:@"뉴스파이터 %d", index];
}

@end
