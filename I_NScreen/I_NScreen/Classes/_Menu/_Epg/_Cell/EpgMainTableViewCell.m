//
//  EpgMainTableViewCell.m
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 9. 11..
//  Copyright (c) 2015년 STVN. All rights reserved.
//

#import "EpgMainTableViewCell.h"
#import "UIImageView+AFNetworking.h"

@implementation EpgMainTableViewCell

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
    
//    self.pChannelLbl.text = [NSString stringWithFormat:@"%d", index];
//    self.pChannelTitleLbl.text = [NSString stringWithFormat:@"뉴스파이터 %d", index];
    
    ////
    
    
    NSString *sChannelLog = [NSString stringWithFormat:@"%@", [dic objectForKey:@"channelLogoImg"]];
    NSString *sChannelNumber = [NSString stringWithFormat:@"%@", [dic objectForKey:@"channelNumber"]];
    NSString *sChannelProgramOnAirTitle = [NSString stringWithFormat:@"%@", [dic objectForKey:@"channelName"]];
    NSString *sProgramGrade = [NSString stringWithFormat:@"%@", [dic objectForKey:@"channelProgramGrade"]];
    NSString *sChannelInfo = [NSString stringWithFormat:@"%@", [dic objectForKey:@"channelInfo"]];
    
    [self.pLogoImageView setImageWithURL:[NSURL URLWithString:sChannelLog]];
    self.pChannelLbl.text = sChannelNumber;
    self.pChannelTitleLbl.text = sChannelProgramOnAirTitle;
    
    if ( [sProgramGrade isEqualToString:@"모두 시청"] )
    {
        self.pGradeImageView.image = [UIImage imageNamed:@"all.png"];
    }
    else if ( [sProgramGrade isEqualToString:@"19세 이상"] )
    {
        self.pGradeImageView.image = [UIImage imageNamed:@"19.png"];
    }
    else if ( [sProgramGrade isEqualToString:@"15세 이상"] )
    {
        self.pGradeImageView.image = [UIImage imageNamed:@"15.png"];
    }
    else
    {
        self.pGradeImageView.image = [UIImage imageNamed:@""];
    }
    
    
    if ( [sChannelInfo isEqualToString:@"HD"] )
    {
        // HD
        self.pChannelInfoImageView.image = [UIImage imageNamed:@"hd.png"];
    }
    else
    {
        // SD
        self.pChannelInfoImageView.image = [UIImage imageNamed:@"sd.png"];
    }
    
    // 체널 시간
//    pChannelTimeLbl
    
    NSString *sStartTime = [NSString stringWithFormat:@"%@", [dic objectForKey:@"channelProgramOnAirStartTime"]];
    NSString *sEndTime = [NSString stringWithFormat:@"%@", [dic objectForKey:@"channelProgramOnAirEndTime"]];
    
    NSArray *startTimeArr = [sStartTime componentsSeparatedByString:@" "];
    NSArray *endTimeArr = [sEndTime componentsSeparatedByString:@" "];
    
    if ( [startTimeArr count] < 2 )
        return;
    if ( [endTimeArr count] < 2 )
        return;
    
    NSString *sStartTime2 = [NSString stringWithFormat:@"%@", [startTimeArr objectAtIndex:1]];
    NSString *sEndTime2 = [NSString stringWithFormat:@"%@", [endTimeArr objectAtIndex:1]];
    
    NSArray *startTimeArr2 = [sStartTime2 componentsSeparatedByString:@":"];
    NSArray *endTimeArr2 = [sEndTime2 componentsSeparatedByString:@":"];
    
    NSString *sNStartTime = [NSString stringWithFormat:@"%@:%@", [startTimeArr2 objectAtIndex:0], [startTimeArr2 objectAtIndex:1]];
    NSString *sNEndTime = [NSString stringWithFormat:@"%@:%@", [endTimeArr2 objectAtIndex:0], [endTimeArr2 objectAtIndex:1]];
    
    self.pChannelTimeLbl.text = [NSString stringWithFormat:@"%@~%@", sNStartTime, sNEndTime];

    [self.progressView setProgressRatio:[[CMAppManager sharedInstance] getProgressViewBufferWithStartTime:sNStartTime WithEndTime:sNEndTime] animated:YES];

}

@end
