//
//  RemoconMainTableViewCell.m
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 10. 19..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import "RemoconMainTableViewCell.h"
#import "CMProgressView.h"
#import "UIImageView+AFNetworking.h"
#import "CMDBDataManager.h"

@interface RemoconMainTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *topLineView;
@property (nonatomic, weak) IBOutlet UIImageView *pStarImageView; // 별표
@property (nonatomic, weak) IBOutlet UIImageView *pChannelLogoImageView;  // 체널 로그 이미지 뷰
@property (nonatomic, weak) IBOutlet UIImageView *pAllImageView;
@property (nonatomic, weak) IBOutlet UIImageView *pHdImageView;

@property (nonatomic, weak) IBOutlet UILabel *pChannelLbl;
@property (nonatomic, weak) IBOutlet UILabel *pTitleLbl;
@property (nonatomic, weak) IBOutlet UILabel *pTimeLbl;
@property (nonatomic, weak) IBOutlet UIImageView *pStateImageView;

@property (nonatomic, strong) NSDictionary *pData;
@property (weak, nonatomic) IBOutlet CMProgressView *progressView;
@property (nonatomic) int nIndex;
@end

@implementation RemoconMainTableViewCell
@synthesize delegate;

- (void)awakeFromNib {
    // Initialization code
    
    self.pTitleLbl.font = [UIFont systemFontOfSize:CNM_DEFAULT_FONT_SIZE];
    self.pTimeLbl.font = [UIFont systemFontOfSize:CNM_DEFAULT_FONT_SIZE];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setListData:(NSDictionary *)dic WithIndex:(int)index WithStar:(BOOL)isStar WithWatchCheck:(BOOL)isWatch WithRecordingCheck:(BOOL)isRecording WithReservCheck:(BOOL)isReservCheck
{
    if ( index != 0 )
    {
        self.topLineView.hidden = YES;
    }
    else
    {
        self.topLineView.hidden = NO;
    }
    
    if ( isWatch == YES )
    {
        // 시청예약중
        self.pStateImageView.hidden = NO;
        self.pStateImageView.image = [UIImage imageNamed:@"icon_watchrsv.png"];
    }
    
    if ( isRecording == YES )
    {
        // 녹화중
        self.pStateImageView.hidden = NO;
        self.pStateImageView.image = [UIImage imageNamed:@"icon_rec.png"];
    }
    
    if ( isReservCheck == YES )
    {
        // 녹화예약중
        self.pStateImageView.hidden = NO;
        self.pStateImageView.image = [UIImage imageNamed:@"icon_recrsv"];
    }
    
    self.nIndex = index;
    self.pData = dic;
    
    self.pChannelLbl.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"channelNumber"]];
    self.pTitleLbl.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"channelProgramOnAirTitle"]];
    
    NSString *sUrl = [NSString stringWithFormat:@"%@", [dic objectForKey:@"channelLogoImg"]];
    [self.pChannelLogoImageView setImageWithURL:[NSURL URLWithString:sUrl]];
    
    NSString *sProgramGrade = [NSString stringWithFormat:@"%@", [dic objectForKey:@"channelProgramGrade"]];
    if ( [sProgramGrade isEqualToString:@"모두 시청"] )
    {
        self.pAllImageView.image = [UIImage imageNamed:@"all.png"];
    }
    else if ( [sProgramGrade isEqualToString:@"19세 이상"] )
    {
        self.pAllImageView.image = [UIImage imageNamed:@"19.png"];
    }
    else if ( [sProgramGrade isEqualToString:@"15세 이상"] )
    {
        self.pAllImageView.image = [UIImage imageNamed:@"15.png"];
    }
    else if ( [sProgramGrade isEqualToString:@"12세 이상"] )
    {
        self.pAllImageView.image = [UIImage imageNamed:@"12.png"];
    }
    else if ( [sProgramGrade isEqualToString:@"7세 이상"] )
    {
        self.pAllImageView.image = [UIImage imageNamed:@"7.png"];
    }
    else
    {
        self.pAllImageView.image = [UIImage imageNamed:@""];
    }
    
    NSString *sChannelOnAirHD = dic[@"channelOnAirHD"];
    if ( [sChannelOnAirHD isEqualToString:@"YES"] )
    {
        // HD
        self.pHdImageView.image = [UIImage imageNamed:@"hd.png"];
    }
    else
    {
        // SD
        self.pHdImageView.image = [UIImage imageNamed:@"sd.png"];
    }
    
    
    
    NSString *sChannelProgramOnAirStartTime = [NSString stringWithFormat:@"%@", [dic objectForKey:@"channelProgramOnAirStartTime"]];
    NSString *sChannelProgramOnAirEndTime = [NSString stringWithFormat:@"%@", [dic objectForKey:@"channelProgramOnAirEndTime"]];
    
    self.pTimeLbl.text = [NSString stringWithFormat:@"%@~%@", [[CMAppManager sharedInstance] getSplitTimeWithDateStr:sChannelProgramOnAirStartTime], [[CMAppManager sharedInstance] getSplitTimeWithDateStr:sChannelProgramOnAirEndTime]];
    
    
    NSArray *startArr = [sChannelProgramOnAirStartTime componentsSeparatedByString:@" "];
    NSArray *startArr2 = [[startArr objectAtIndex:1] componentsSeparatedByString:@":"];
    
    NSArray *endArr = [sChannelProgramOnAirEndTime componentsSeparatedByString:@" "];
    NSArray *endArr2 = [[endArr objectAtIndex:1] componentsSeparatedByString:@":"];
    
    NSString *sStart = [NSString stringWithFormat:@"%@:%@", [startArr2 objectAtIndex:0], [startArr2 objectAtIndex:1]];
    
    NSString *sEnd = [NSString stringWithFormat:@"%@:%@", [endArr2 objectAtIndex:0], [endArr2 objectAtIndex:1]];
    
    if ( isStar == YES )
    {
        self.pStarImageView.image = [UIImage imageNamed:@"ch_pick.png"];
    }
    else
    {
        self.pStarImageView.image = [UIImage imageNamed:@"ch_unpick.png"];
    }

    CGFloat progressFloat = [[CMAppManager sharedInstance] getProgressViewBufferWithStartTime:sStart WithEndTime:sEnd];
    
    if ( progressFloat <= 0 )
    {
        self.progressView.hidden = YES;
    }
    else
    {
        self.progressView.hidden = NO;
        [self.progressView setProgressRatio:progressFloat animated:YES];
    }
    
//    [self.progressView setProgressRatio:.5 animated:YES];
}

- (IBAction)onBtnClicked:(UIButton *)btn
{
    NSString *channelNumber = self.pData[@"channelNumber"];
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
    
    
    DDLogDebug(@"[manager getFavorChannel] = [%@]", [manager getFavorChannel]);
    
    [self.delegate RemoconMainTableViewCellWithTag:self.nIndex];
}

@end
