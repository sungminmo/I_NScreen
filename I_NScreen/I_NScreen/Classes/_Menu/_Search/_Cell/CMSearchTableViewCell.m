//
//  CMSearchTableViewCell.m
//  I_NScreen
//
//  Created by 조백근 on 2015. 10. 1..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import "CMSearchTableViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "CMDBDataManager.h"

@interface CMSearchTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *bookmarkImageView;
@property (weak, nonatomic) IBOutlet UILabel *channelLabel;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *gradeImageView;
@property (weak, nonatomic) IBOutlet UIImageView *hmImageView;
@property (nonatomic, weak) IBOutlet UIView* lineView;
@property (nonatomic) int nIndex;
@property (nonatomic, strong) NSDictionary *pDataDic;

- (IBAction)onBtnClicked:(UIButton *)btn;

@end

@implementation CMSearchTableViewCell
@synthesize delegate2;

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.titleLabel.font = [UIFont systemFontOfSize:CNM_DEFAULT_FONT_SIZE];
    self.titleLabel.font = [UIFont systemFontOfSize:CNM_DEFAULT_FONT_SIZE];
    self.stateLabel.font = [UIFont systemFontOfSize:CNM_DEFAULT_FONT_SIZE];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

#pragma mark - Privates

- (void)resetData {
    
    self.channelLabel.text = @"";
    self.logoImageView.image = nil;
    self.timeLabel.text = @"";
    self.stateLabel.text = @"";
    self.titleLabel.text = @"";
    self.gradeImageView.image = nil;
    self.hmImageView.hidden = NO;
}

#pragma mark - Publics
- (void)setData:(NSDictionary*)data WithIndex:(int)nIndex WithStar:(BOOL)isStar WithWatchCheck:(BOOL)isWatch WithRecordingCheck:(BOOL)isRecording WithReservCheck:(BOOL)isReservCheck{

    [self resetData];
    
    self.pDataDic = data;
    
    self.nIndex = nIndex;
    
    if ( isStar == YES )
    {
        self.bookmarkImageView.image = [UIImage imageNamed:@"ch_pick.png"];
    }
    else
    {
        self.bookmarkImageView.image = [UIImage imageNamed:@"ch_unpick.png"];
    }
    
    self.channelLabel.text = data[@"channelNumber"];
    
    self.titleLabel.text = data[@"channelProgramTitle"];
    
    self.logoImageView.image = nil;
    [self.logoImageView setImageWithURL:[NSURL URLWithString:data[@"channelLogoImg"]]];

    self.timeLabel.text = [[CMAppManager sharedInstance] getSplitTimeWithDateStr:data[@"channelProgramTime"]];
    
    double interval = [[CMAppManager sharedInstance] getLicenseRemainMinuteWithLicenseDate:data[@"channelProgramTime"] compareDate:[NSDate date]];
    
    if (interval > 0)
    {
        self.stateLabel.text = [NSString stringWithFormat:@"%@ 방송예정", [[CMAppManager sharedInstance] replaceDashToDot:data[@"channelProgramTime"]]];
    }
    else
    {
        self.stateLabel.text = @"현재 방송 중";
    }

    NSString* grade = data[@"channelProgramGrade"];
    
    if ( [grade isEqualToString:@"모두 시청"] )
    {
        self.gradeImageView.image = [UIImage imageNamed:@"all.png"];
    }
    else if ( [grade isEqualToString:@"19세 이상"] )
    {
        self.gradeImageView.image = [UIImage imageNamed:@"19.png"];
    }
    else if ( [grade isEqualToString:@"15세 이상"] )
    {
        self.gradeImageView.image = [UIImage imageNamed:@"15.png"];
    }
    else if ( [grade isEqualToString:@"12세 이상"] )
    {
        self.gradeImageView.image = [UIImage imageNamed:@"12.png"];
    }
    else if ( [grade isEqualToString:@"7세 이상"] )
    {
        self.gradeImageView.image = [UIImage imageNamed:@"7.png"];
    }
    else
    {
        self.gradeImageView.image = [UIImage imageNamed:@""];
    }
    
    NSString *channelInfo = data[@"channelInfo"];
    
    if ( [channelInfo isEqualToString:@"HD"] )
    {
        // HD
        self.hmImageView.image = [UIImage imageNamed:@"hd.png"];
    }
    else if ([channelInfo isEqualToString:@"SD"])
    {
        // SD
        self.hmImageView.image = [UIImage imageNamed:@"sd.png"];
    }
}

- (IBAction)onBtnClicked:(UIButton *)btn
{

}

#pragma mark - Event

- (void)userPressedMoreButton:(id)sender
{
    [self.delegate2 CMSearchTableViewMoreBtn:self.nIndex];
}

- (void)userPressedDeleteButton:(id)sender
{
    [self.delegate2 CMSearchTableViewDeleteBtn:self.nIndex];
}


@end
