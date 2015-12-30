//
//  EpgMainTableViewCell.m
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 9. 11..
//  Copyright (c) 2015년 STVN. All rights reserved.
//

#import "EpgMainTableViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "CMDBDataManager.h"
#import "CMFavorChannelInfo.h"

@implementation EpgMainTableViewCell
@synthesize delegate;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setListData:(NSDictionary *)dic WithIndex:(int)index WithStar:(BOOL)isStar WithWatchCheck:(BOOL)isWatch WithRecordingCheck:(BOOL)isRecording WithReservCheck:(BOOL)isReservCheck
{
    if ( index != 0 )
    {
        self.pLineImageView01.hidden = YES;
    }
    else
    {
        self.pLineImageView01.hidden = NO;
    }
    
    self.nIndex = index;
    
    if (isRecording == YES &&  isWatch == NO)
    {
        self.pStateImageView.hidden = NO;
        self.pStateImageView.image = [UIImage imageNamed:@"icon_rec.png"];
        
        self.pStateImageView2.hidden = YES;
        self.pStateImageView2.image = nil;
    }
    else if (isRecording == YES &&  isWatch == YES)
    {
        self.pStateImageView.hidden = NO;
        self.pStateImageView.image = [UIImage imageNamed:@"icon_rec.png"];
        
        self.pStateImageView2.hidden = NO;
        self.pStateImageView2.image = [UIImage imageNamed:@"icon_watchrsv.png"];
    }
    else if (isRecording == NO &&  isWatch == YES)
    {
        self.pStateImageView.hidden = NO;
        self.pStateImageView.image = [UIImage imageNamed:@"icon_watchrsv.png"];
        
        self.pStateImageView2.hidden = YES;
        self.pStateImageView2.image = nil;
    }
    else if (isRecording == NO &&  isWatch == NO)
    {
        self.pStateImageView.hidden = YES;
        self.pStateImageView.image = nil;
        
        self.pStateImageView2.hidden = YES;
        self.pStateImageView2.image = nil;
    }
    
    self.pData = dic;
    
    NSString *sChannelLog = [NSString stringWithFormat:@"%@", [dic objectForKey:@"channelLogoImg"]];
    NSString *sChannelNumber = [NSString stringWithFormat:@"%@", [dic objectForKey:@"channelNumber"]];
    NSString *sChannelProgramOnAirTitle = [NSString stringWithFormat:@"%@", [dic objectForKey:@"channelProgramOnAirTitle"]];
    NSString *sProgramGrade = [NSString stringWithFormat:@"%@", [dic objectForKey:@"channelProgramGrade"]];
    
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
    else if ( [sProgramGrade isEqualToString:@"12세 이상"] )
    {
        self.pGradeImageView.image = [UIImage imageNamed:@"12.png"];
    }
    else if ( [sProgramGrade isEqualToString:@"7세 이상"] )
    {
        self.pGradeImageView.image = [UIImage imageNamed:@"7.png"];
    }
    else
    {
        self.pGradeImageView.image = [UIImage imageNamed:@""];
    }
    
    NSString *sChannelOnAirHD = dic[@"channelOnAirHD"];
    
    if ( [sChannelOnAirHD isEqualToString:@"YES"] )
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
    
    if ( isStar == YES )
    {
        self.pStarImageView.image = [UIImage imageNamed:@"ch_pick.png"];
    }
    else
    {
        self.pStarImageView.image = [UIImage imageNamed:@"ch_unpick.png"];
    }

    CGFloat prosFloat = [[CMAppManager sharedInstance] getProgressViewBufferWithStartTime:sNStartTime WithEndTime:sNEndTime];
    
    if ( prosFloat <= 0 )
    {
//        self.progressView.hidden = YES;
        self.progressView.hidden = NO;
        [self.progressView setProgressRatio:0 animated:NO];
    }
    else
    {
        self.progressView.hidden = NO;
        [self.progressView setProgressRatio:prosFloat animated:NO];
    }
}

- (IBAction)onBtnClicked:(UIButton *)btn
{
    NSString *channelNumber = [NSString stringWithFormat:@"%@", [self.pData objectForKey:@"channelNumber"]];
    CMDBDataManager *manager = [CMDBDataManager sharedInstance];
    RLMArray *ramArr = [manager getFavorChannel];
    BOOL isCheck = NO;
    
    int nCount = 0;
    for ( CMFavorChannelInfo *info in ramArr )
    {
        if ( [info.pChannelNumber isEqualToString:channelNumber] )
        {
            isCheck = YES;
            [manager removeFavorChannel:nCount];
        }
        nCount++;
    }
    
    if ( isCheck == NO )
    {
        [manager setFavorChannel:self.pData];
    }
    
    [self.delegate EpgMainTableViewWithTag:self.nIndex];
    DDLogDebug(@"[manager getFavorChannel] = [%@]", [manager getFavorChannel]);
    
}

@end
