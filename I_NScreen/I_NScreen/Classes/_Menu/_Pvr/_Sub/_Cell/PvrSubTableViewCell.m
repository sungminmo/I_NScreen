//
//  PvrSubTableViewCell.m
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 10. 19..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import "PvrSubTableViewCell.h"
#import "UIImageView+AFNetworking.h"

@interface PvrSubTableViewCell ()

@property (nonatomic, weak) IBOutlet UIImageView *pLineImageView01;     // 윗라인
@property (nonatomic, weak) IBOutlet UIImageView *pLineImageView02;     // 밑 라인
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UIImageView *seriesImageView;
@property (strong, nonatomic) IBOutlet UIImageView *logoImageView;
@property (nonatomic, weak) IBOutlet UILabel *pTitleLbl;


@end

@implementation PvrSubTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Private
/**
 *  '시리즈'이미지를 표출한다.
 *
 *  @param isShow '시리즈'이미지 표출 여부
 */
- (void)showSeriesMark:(BOOL)isShow {
    
    if (isShow) {
        self.dateLabel.hidden = true;
        self.timeLabel.hidden = true;
        self.seriesImageView.hidden = false;
    } else {
        self.seriesImageView.hidden = true;
    }
}

#pragma mark - Public

- (void)setListData:(NSDictionary *)dic WithIndex:(int)index
{
    
    NSString *sUrl = [NSString stringWithFormat:@"%@", [dic objectForKey:@"Channel_logo_img"]];
    [self.logoImageView setImageWithURL:[NSURL URLWithString:sUrl]];
    self.pTitleLbl.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"ProgramName"]];
    
    if ( [[dic objectForKey:@"RecordStartTime"] isEqualToString:@"0"] )
        return;
    
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
