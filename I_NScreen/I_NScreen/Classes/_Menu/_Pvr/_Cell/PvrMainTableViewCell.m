//
//  PvrMainTableViewCell.m
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 10. 19..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import "PvrMainTableViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "CMProgressView.h"

@interface PvrMainTableViewCell ()

@property (nonatomic, weak) IBOutlet UIImageView *pLineImageView01;     // 윗라인
@property (nonatomic, weak) IBOutlet UIImageView *pLineImageView02;     // 밑 라인
@property (strong, nonatomic) IBOutlet UIImageView *seriesImageView;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UIImageView *logoImageView;
@property (strong, nonatomic) IBOutlet UIImageView *recImageView;
@property (nonatomic, weak) IBOutlet UILabel *pTitleLbl;    //  타이틀
@property (strong, nonatomic) IBOutlet CMProgressView *progressView;


@end

@implementation PvrMainTableViewCell

- (void)awakeFromNib {

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

// 녹화 예약 관리
- (void)setListDataReservation:(NSDictionary *)dic WithIndex:(int)index WithRecordCheck:(BOOL)isRecordCheck
{
    [self layoutSubviews];
    [self layoutIfNeeded];
    
    if ( index != 0 )
    {
        self.pLineImageView01.hidden = YES;
    }
    else
    {
        self.pLineImageView01.hidden = NO;
    }
    
    if ( isRecordCheck == YES )
    {
        // 녹화중
        self.recImageView.hidden = NO;
        self.progressView.hidden = NO;
    }
    else
    {
        self.recImageView.hidden = YES;
        self.progressView.hidden = YES;
    }
    
    NSString *sLogUrl = [NSString stringWithFormat:@"%@", [dic objectForKey:@"Channel_logo_img"]];
    [self.logoImageView setImageWithURL:[NSURL URLWithString:sLogUrl]];
    
    self.pTitleLbl.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"ProgramName"]];
    
    
    
    NSString *sSeriesId = [NSString stringWithFormat:@"%@", [dic objectForKey:@"SeriesId"]];
    if ( [sSeriesId isEqualToString:@"NULL"] )
    {
        // 단편
        self.seriesImageView.hidden = YES;
        self.dateLabel.hidden = NO;
        self.timeLabel.hidden = NO;
    }
    else
    {
        // 시리즈
        self.seriesImageView.hidden = NO;
        self.dateLabel.hidden = YES;
        self.timeLabel.hidden = YES;
    }
    
    CGFloat progressFloat = 0;
    

    NSString *sProgramBroadcastingStartTime = [NSString stringWithFormat:@"%@", [dic objectForKey:@"RecordStartTime"]];
    
    if ( [sProgramBroadcastingStartTime isEqualToString:@"0"] )
    {
        // 녹화끝났음
        self.recImageView.hidden = YES;
        self.progressView.hidden = YES;
        
        self.dateLabel.text = @"";
        
        return;
    }
    
    NSString *sProgramBroadcastingEndTime = [NSString stringWithFormat:@"%@", [dic objectForKey:@"RecordEndTime"]];
    
    NSArray *startArr = [sProgramBroadcastingStartTime componentsSeparatedByString:@" "];
    NSArray *startArr2 = [[startArr objectAtIndex:1] componentsSeparatedByString:@":"];
    
    NSArray *endArr = [sProgramBroadcastingEndTime componentsSeparatedByString:@" "];
    NSArray *endArr2 = [[endArr objectAtIndex:1] componentsSeparatedByString:@":"];
    
    NSString *sStart = [NSString stringWithFormat:@"%@:%@", [startArr2 objectAtIndex:0], [startArr2 objectAtIndex:1]];
    
    NSString *sEnd = [NSString stringWithFormat:@"%@:%@", [endArr2 objectAtIndex:0], [endArr2 objectAtIndex:1]];
    
    progressFloat = [[CMAppManager sharedInstance] getProgressViewBufferWithStartTime:sStart WithEndTime:sEnd];
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Seoul"]];
    
    [dateFormatter setDateFormat:@"dd"];
    int nDay = [[dateFormatter stringFromDate:[NSDate date]] intValue];
    
    NSArray *startArr3 = [[startArr objectAtIndex:0] componentsSeparatedByString:@"-"];
    NSString *sStartDD = [NSString stringWithFormat:@"%@", [startArr3 objectAtIndex:2]];
    
    if ( nDay != [sStartDD intValue] )
    {
        progressFloat = .0;
        [self.progressView setProgressRatio:.0 animated:YES];
    }
    
    if ( progressFloat > 0 )
    {
        // 녹화중
        self.recImageView.hidden = NO;
        self.progressView.hidden = NO;
        
        [self.progressView setProgressRatio:progressFloat animated:YES];
    }
    else
    {
        // 녹화끝났음
        self.recImageView.hidden = YES;
        self.progressView.hidden = YES;
    }
    
    NSString *sPurchasedTime = [NSString stringWithFormat:@"%@", [dic objectForKey:@"RecordStartTime"]];
    NSArray *purchasedTimeArr = [sPurchasedTime componentsSeparatedByString:@" "];
    NSArray *purchasedTimeArr2 = [[purchasedTimeArr objectAtIndex:0] componentsSeparatedByString:@"-"];
    NSArray *purchasedTimeArr3 = [[purchasedTimeArr objectAtIndex:1] componentsSeparatedByString:@":"];
    NSString *sPurchasedTime2 = [NSString stringWithFormat:@"%@%@%@", [purchasedTimeArr2 objectAtIndex:0], [purchasedTimeArr2 objectAtIndex:1], [purchasedTimeArr2 objectAtIndex:2]];
    
    NSString *sWeek = [NSString stringWithFormat:@"%@", [[CMAppManager sharedInstance] GetDayOfWeek:sPurchasedTime2]];
    
    NSString *sMonth = [NSString stringWithFormat:@"%@", [purchasedTimeArr2 objectAtIndex:1]];
    NSString *sDay = [NSString stringWithFormat:@"%@", [purchasedTimeArr2 objectAtIndex:2]];
    
    NSString *sHour = [NSString stringWithFormat:@"%@", [purchasedTimeArr3 objectAtIndex:0]];
    NSString *sMinute = [NSString stringWithFormat:@"%@", [purchasedTimeArr3 objectAtIndex:1]];
    
    self.dateLabel.text = [NSString stringWithFormat:@"%@.%@ (%@)", sMonth, sDay, sWeek];
    self.timeLabel.text = [NSString stringWithFormat:@"%@:%@", sHour, sMinute];
}

- (void)setListDataList:(NSDictionary *)dic WithIndex:(int)index
{
    [self layoutSubviews];
    [self layoutIfNeeded];
    
    if ( index != 0 )
    {
        self.pLineImageView01.hidden = YES;
    }
    else
    {
        self.pLineImageView01.hidden = NO;
    }
    
    NSString *sLogUrl = [NSString stringWithFormat:@"%@", [dic objectForKey:@"Channel_logo_img"]];
    [self.logoImageView setImageWithURL:[NSURL URLWithString:sLogUrl]];
    
    self.pTitleLbl.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"ProgramName"]];
    
    
    
    NSString *sSeriesId = [NSString stringWithFormat:@"%@", [dic objectForKey:@"SeriesId"]];
    if ( [sSeriesId isEqualToString:@"NULL"] )
    {
        // 단편
        self.seriesImageView.hidden = YES;
        self.dateLabel.hidden = NO;
        self.timeLabel.hidden = NO;
    }
    else
    {
        // 시리즈
        self.seriesImageView.hidden = NO;
        self.dateLabel.hidden = YES;
        self.timeLabel.hidden = YES;
    }
    
    
    NSString *sProgramBroadcastingStartTime = [NSString stringWithFormat:@"%@", [dic objectForKey:@"RecordStartTime"]];
    NSString *sProgramBroadcastingEndTime = [NSString stringWithFormat:@"%@", [dic objectForKey:@"RecordEndTime"]];
    
    NSArray *startArr = [sProgramBroadcastingStartTime componentsSeparatedByString:@" "];
    NSArray *startArr2 = [[startArr objectAtIndex:1] componentsSeparatedByString:@":"];
    
    NSArray *endArr = [sProgramBroadcastingEndTime componentsSeparatedByString:@" "];
    NSArray *endArr2 = [[endArr objectAtIndex:1] componentsSeparatedByString:@":"];
    
    NSString *sStart = [NSString stringWithFormat:@"%@:%@", [startArr2 objectAtIndex:0], [startArr2 objectAtIndex:1]];
    
    NSString *sEnd = [NSString stringWithFormat:@"%@:%@", [endArr2 objectAtIndex:0], [endArr2 objectAtIndex:1]];
    
    CGFloat progressFloat = [[CMAppManager sharedInstance] getProgressViewBufferWithStartTime:sStart WithEndTime:sEnd];
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Seoul"]];
    
    [dateFormatter setDateFormat:@"dd"];
    int nDay = [[dateFormatter stringFromDate:[NSDate date]] intValue];
    
    NSArray *startArr3 = [[startArr objectAtIndex:0] componentsSeparatedByString:@"-"];
    NSString *sStartDD = [NSString stringWithFormat:@"%@", [startArr3 objectAtIndex:2]];
    
    if ( nDay != [sStartDD intValue] )
    {
        progressFloat = .0;
        [self.progressView setProgressRatio:.0 animated:YES];
    }
    
    if ( progressFloat > 0 )
    {
        // 녹화중
        self.recImageView.hidden = NO;
        self.progressView.hidden = NO;
        
        [self.progressView setProgressRatio:progressFloat animated:YES];
    }
    else
    {
        // 녹화끝났음
        self.recImageView.hidden = YES;
        self.progressView.hidden = YES;
    }
    
    
    NSString *sPurchasedTime = [NSString stringWithFormat:@"%@", [dic objectForKey:@"RecordStartTime"]];
    NSArray *purchasedTimeArr = [sPurchasedTime componentsSeparatedByString:@" "];
    NSArray *purchasedTimeArr2 = [[purchasedTimeArr objectAtIndex:0] componentsSeparatedByString:@"-"];
    NSArray *purchasedTimeArr3 = [[purchasedTimeArr objectAtIndex:1] componentsSeparatedByString:@":"];
    NSString *sPurchasedTime2 = [NSString stringWithFormat:@"%@%@%@", [purchasedTimeArr2 objectAtIndex:0], [purchasedTimeArr2 objectAtIndex:1], [purchasedTimeArr2 objectAtIndex:2]];
    
    NSString *sWeek = [NSString stringWithFormat:@"%@", [[CMAppManager sharedInstance] GetDayOfWeek:sPurchasedTime2]];
    
    NSString *sMonth = [NSString stringWithFormat:@"%@", [purchasedTimeArr2 objectAtIndex:1]];
    NSString *sDay = [NSString stringWithFormat:@"%@", [purchasedTimeArr2 objectAtIndex:2]];
    
    NSString *sHour = [NSString stringWithFormat:@"%@", [purchasedTimeArr3 objectAtIndex:0]];
    NSString *sMinute = [NSString stringWithFormat:@"%@", [purchasedTimeArr3 objectAtIndex:1]];
    
    self.dateLabel.text = [NSString stringWithFormat:@"%@.%@ (%@)", sMonth, sDay, sWeek];
    self.timeLabel.text = [NSString stringWithFormat:@"%@:%@", sHour, sMinute];
}


@end
