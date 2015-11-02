//
//  PvrSubTableViewCell.m
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 10. 19..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import "PvrSubTableViewCell.h"

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
    if ( index != 0 )
    {
        self.pLineImageView01.hidden = YES;
    }
    else
    {
        self.pLineImageView01.hidden = NO;
    }
    
    self.pTitleLbl.text = [NSString stringWithFormat:@"뉴스파이터asdfalskdfjalkj %d", index];

    [self showSeriesMark:false];
}

@end
