//
//  EpgSubTableViewCell.m
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 9. 14..
//  Copyright (c) 2015년 STVN. All rights reserved.
//

#import "EpgSubTableViewCell.h"
#import "CMProgressView.h"

@interface EpgSubTableViewCell ()

@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIImageView *gradeImageView;
@property (strong, nonatomic) IBOutlet UIImageView *sdhdImageView01;
@property (strong, nonatomic) IBOutlet UIImageView *sdhdImageView02;
@property (strong, nonatomic) IBOutlet UIImageView *hdImageView;
@property (strong, nonatomic) IBOutlet CMProgressView *progressView;
@property (nonatomic) int nSelect;

@property (strong, nonatomic) NSDictionary* dataDic;

@end

@implementation EpgSubTableViewCell
@synthesize delegate1;

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    [self resetData];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
}

#pragma mark - Privates

/**
 *  데이터 및 화면을 초기화 한다.
 */
- (void)resetData {

    self.dataDic = nil;
    self.nSelect = 0;
    self.timeLabel.text = @"";
    self.titleLabel.text = @"";
    self.gradeImageView.image = nil;
    self.sdhdImageView01.hidden = true;
    self.sdhdImageView02.hidden = true;
}

#pragma mark - Pulbics

/**
 *  데이터 및 화면 정보를 갱신한다.
 *
 *  @param data 셀에 표출될 정보
 */
- (void)setData:(NSDictionary*)data WithIndex:(int)nIndex {
    
    [self resetData];
    
    self.dataDic = data;
    self.nSelect = nIndex;
    
    NSString *sStartTime = [NSString stringWithFormat:@"%@", [data objectForKey:@"programBroadcastingStartTime"]];
    NSString *sEndTime = [NSString stringWithFormat:@"%@", [data objectForKey:@"programBroadcastingEndTime"]];
    
    self.timeLabel.text = [NSString stringWithFormat:@"%@~%@", [[CMAppManager sharedInstance] getSplitTimeWithDateStr:sStartTime], [[CMAppManager sharedInstance] getSplitTimeWithDateStr:sEndTime]];
    
    self.titleLabel.text = data[@"programTitle"];
    
    NSString* grade = data[@"programGrade"];
    
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
    else
    {
        self.gradeImageView.image = [UIImage imageNamed:@""];
    }
//    
//    NSString* channelInfo = data[@"channelInfo"];
//    NSArray *channelInfoArr = [channelInfo componentsSeparatedByString:@","];
//    
//
//    
//    if ( [channelInfoArr count] == 2 )
//    {
//        self.sdhdImageView01.hidden = NO;
//        self.sdhdImageView02.hidden = NO;
//        
//        self.sdhdImageView01.image = [UIImage imageNamed:@"sd.png"];
//        self.sdhdImageView02.image = [UIImage imageNamed:@"hd.png"];
//    }
//    else if ( [channelInfoArr count] == 1 )
//    {
//        if ( [[channelInfoArr objectAtIndex:0] isEqualToString:@"SD"] )
//        {
//            self.sdhdImageView01.hidden = NO;
//            self.sdhdImageView01.image = [UIImage imageNamed:@"sd.png"];
//        }
//        else
//        {
//            self.sdhdImageView01.hidden = NO;
//            self.sdhdImageView01.image = [UIImage imageNamed:@"hd.png"];
//        }
//    }
//    
    NSString *sProgramHD = data[@"programHD"];
    
    if ( [sProgramHD isEqualToString:@"YES"] )
    {
        self.hdImageView.hidden = NO;
        self.hdImageView.image = [UIImage imageNamed:@"hd.png"];
    }
    else
    {
        self.hdImageView.hidden = YES;
    }
    
    [self.progressView setProgressRatio:.9 animated:YES];
}

#pragma mark - Event

- (void)userPressedMoreButton:(id)sender
{
    [self.delegate1 EpgSubTableViewMoreBtn:self.nSelect];
}

- (void)userPressedDeleteButton:(id)sender
{
    [self.delegate1 EpgSubTableViewDeleteBtn:self.nSelect];
}

@end
