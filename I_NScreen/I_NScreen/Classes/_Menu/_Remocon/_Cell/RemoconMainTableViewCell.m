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

@property (nonatomic, strong) NSDictionary *pData;
@property (weak, nonatomic) IBOutlet CMProgressView *progressView;
@property (nonatomic) int nIndex;
@end

@implementation RemoconMainTableViewCell
@synthesize delegate;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setListData:(NSDictionary *)dic WithIndex:(int)index WithStar:(BOOL)isStar
{
    if ( index != 0 )
    {
        self.topLineView.hidden = YES;
    }
    else
    {
        self.topLineView.hidden = NO;
    }
    
    self.nIndex = index;
    self.pData = dic;
    
    self.pChannelLbl.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"channelNumber"]];
    self.pTitleLbl.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"channelProgramOnAirTitle"]];
    
    NSString *sUrl = [NSString stringWithFormat:@"%@", [dic objectForKey:@"channelLogoImg"]];
    [self.pChannelLogoImageView setImageWithURL:[NSURL URLWithString:sUrl]];
    
    self.pAllImageView.hidden = index%2 == 0 ? true : false;
    self.pHdImageView.hidden = index%2 == 0 ? true : false;
    
    
    
    
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

    
    [self.progressView setProgressRatio:[[CMAppManager sharedInstance] getProgressViewBufferWithStartTime:sStart WithEndTime:sEnd] animated:YES];
    
    
//    [self.progressView setProgressRatio:.5 animated:YES];
}

- (IBAction)onBtnClicked:(UIButton *)btn
{
    NSString *sChannelId = [NSString stringWithFormat:@"%@", [self.pData objectForKey:@"channelId"]];
    CMDBDataManager *manager = [CMDBDataManager sharedInstance];
    RLMArray *ramArr = [manager getFavorChannel];
    BOOL isCheck = NO;
    
    int nCount = 0;
    for ( CMFavorChannelInfo *info in ramArr )
    {
        if ( [info.pChannelId isEqualToString:sChannelId] )
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
    
    
    NSLog(@"[manager getFavorChannel] = [%@]", [manager getFavorChannel]);
    
    [self.delegate RemoconMainTableViewCellWithTag:self.nIndex];
}

@end
