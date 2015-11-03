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

- (void)setListData:(NSDictionary *)dic WithIndex:(int)index
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
    
    // 일단 녹화 시간으로 적어 놓고 바꿔야 함
//    NSString *sTime = [NSString stringWithFormat:@"%@", [dic objectForKey:@"RecordEndTime"]];
//    NSArray *timeArr = [sTime componentsSeparatedByString:@" "];
//    
//    self.pDayLbl.text = [NSString stringWithFormat:@"%@", [timeArr objectAtIndex:0]];
//    self.pTimeLbl.text = [NSString stringWithFormat:@"%@", [timeArr objectAtIndex:1]];
    
#warning TEST
    
    BOOL series = index%2;  //  시리즈 여부 테스트값
    if (series) {
        
        self.seriesImageView.hidden = false;
        self.dateLabel.hidden = true;
        self.timeLabel.hidden = true;
    } else {
        self.seriesImageView.hidden = true;
        self.dateLabel.hidden = false;
        self.timeLabel.hidden = false;
        
        self.dateLabel.text = @"10.10 (금)";
        self.timeLabel.text = @"11:11";
    }
    
    BOOL rec = index%2; //  녹화 여부 테스트값
    if (rec) {
        self.recImageView.hidden = false;
        self.progressView.hidden = false;
        
        [self.progressView reset];
        [self.progressView setProgressRatio:0.9 animated:YES];
    } else {
        self.recImageView.hidden = true;
        self.progressView.hidden = true;
    }
}

@end
