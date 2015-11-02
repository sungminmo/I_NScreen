//
//  PvrMainTableViewCell.m
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 10. 19..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import "PvrMainTableViewCell.h"
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
    
    NSString* series = dic[@"series"];
    
    if ([series isEqualToString:@"Y"]) {
        
        self.seriesImageView.hidden = false;
        self.dateLabel.hidden = true;
        self.timeLabel.hidden = true;
    } else {
        self.seriesImageView.hidden = true;
        self.dateLabel.hidden = false;
        self.timeLabel.hidden = false;
        
        self.dateLabel.text = dic[@"date"];
        self.timeLabel.text = dic[@"time"];
    }
    
    NSString* rec = dic[@"rec"];
    if ([rec isEqualToString:@"Y"]) {
        self.recImageView.hidden = false;
        self.progressView.hidden = false;
        
        [self.progressView reset];
        [self.progressView setProgressRatio:[dic[@"rate"] floatValue] animated:YES];
    } else {
        self.recImageView.hidden = true;
        self.progressView.hidden = true;
    }
    
    self.pTitleLbl.text = dic[@"title"];
}

@end
