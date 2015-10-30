//
//  PvrMainTableViewCell.m
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 10. 19..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import "PvrMainTableViewCell.h"
#import "UIImageView+AFNetworking.h"

@implementation PvrMainTableViewCell

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
    
    NSString *sLogUrl = [NSString stringWithFormat:@"%@", [dic objectForKey:@"Channel_logo_img"]];
    [self.pChannelLogImageView setImageWithURL:[NSURL URLWithString:sLogUrl]];
    
    self.pTitleLbl.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"ProgramName"]];
    
    // 일단 녹화 시간으로 적어 놓고 바꿔야 함
//    NSString *sTime = [NSString stringWithFormat:@"%@", [dic objectForKey:@"RecordEndTime"]];
//    NSArray *timeArr = [sTime componentsSeparatedByString:@" "];
//    
//    self.pDayLbl.text = [NSString stringWithFormat:@"%@", [timeArr objectAtIndex:0]];
//    self.pTimeLbl.text = [NSString stringWithFormat:@"%@", [timeArr objectAtIndex:1]];
}

@end
