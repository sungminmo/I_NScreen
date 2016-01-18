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

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *gradeImageView;
@property (weak, nonatomic) IBOutlet UIImageView *sdhdImageView01;
@property (weak, nonatomic) IBOutlet UIImageView *sdhdImageView02;
@property (weak, nonatomic) IBOutlet UIImageView *hdImageView;
@property (weak, nonatomic) IBOutlet CMProgressView *progressView;
@property (weak, nonatomic) IBOutlet UIImageView *pStateImageView;
@property (weak, nonatomic) IBOutlet UIImageView *pStateImageView2;
@property (nonatomic) int nSelect;

@property (strong, nonatomic) NSDictionary* dataDic;

@end

@implementation EpgSubTableViewCell
@synthesize delegate1;

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.titleLabel.font = [UIFont systemFontOfSize:CNM_DEFAULT_FONT_SIZE];
    self.timeLabel.font = [UIFont systemFontOfSize:CNM_DEFAULT_FONT_SIZE];
    
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
    [self hideBasement:NO];
}

#pragma mark - Pulbics

/**
 *  데이터 및 화면 정보를 갱신한다.
 *
 *  @param data 셀에 표출될 정보
 */
- (void)setData:(NSDictionary*)data WithIndex:(int)nIndex
{
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

    
    NSString *sProgramHD = data[@"programHD"];
    
    if ( [sProgramHD isEqualToString:@"NO"] )
    {
        self.sdhdImageView01.hidden = NO;
        self.sdhdImageView01.image = [UIImage imageNamed:@"sd.png"];
    }
    else
    {
        self.sdhdImageView01.hidden = NO;
        self.sdhdImageView01.image = [UIImage imageNamed:@"hd.png"];
    }
    
    
    
    NSString *sProgramBroadcastingStartTime = [NSString stringWithFormat:@"%@", [data objectForKey:@"programBroadcastingStartTime"]];
    NSString *sProgramBroadcastingEndTime = [NSString stringWithFormat:@"%@", [data objectForKey:@"programBroadcastingEndTime"]];
    
    NSArray *startArr = [sProgramBroadcastingStartTime componentsSeparatedByString:@" "];
    NSArray *startArr2 = [[startArr objectAtIndex:1] componentsSeparatedByString:@":"];
    
    NSArray *endArr = [sProgramBroadcastingEndTime componentsSeparatedByString:@" "];
    NSArray *endArr2 = [[endArr objectAtIndex:1] componentsSeparatedByString:@":"];
    
    NSString *sStart = [NSString stringWithFormat:@"%@:%@", [startArr2 objectAtIndex:0], [startArr2 objectAtIndex:1]];
    
    NSString *sEnd = [NSString stringWithFormat:@"%@:%@", [endArr2 objectAtIndex:0], [endArr2 objectAtIndex:1]];
    
    CGFloat progreeFloat = [[CMAppManager sharedInstance] getProgressViewBufferWithStartTime:sStart WithEndTime:sEnd];
    
    [self.progressView setProgressRatio:progreeFloat animated:NO];
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Seoul"]];
    
    [dateFormatter setDateFormat:@"dd"];
    int nDay = [[dateFormatter stringFromDate:[NSDate date]] intValue];
    
    NSArray *startArr3 = [[startArr objectAtIndex:0] componentsSeparatedByString:@"-"];
    NSString *sStartDD = [NSString stringWithFormat:@"%@", [startArr3 objectAtIndex:2]];
    
    if ( nDay != [sStartDD intValue] )
    {
        progreeFloat = 0;
        [self.progressView setProgressRatio:progreeFloat animated:YES];
    }
    
    if ( progreeFloat <= 0 )
    {
        self.progressView.hidden = YES;
    }
    else
    {
        self.progressView.hidden = NO;
    }
}

- (void)resetImageState:(NSArray*)array {
    
    self.pStateImageView.hidden = YES;
    self.pStateImageView2.hidden = YES;
    
    BOOL isState1 = NO;
    BOOL isState2 = NO;

    for (NSString* sState in array) {

        if ( [sState isEqualToString:@"시청예약"] )
        {
            if (isState1 == YES) {
                self.pStateImageView2.hidden = NO;
                self.pStateImageView2.image = [UIImage imageNamed:@"icon_watchrsv.png"];
                self.pStateImageView2.tag = 10;
                isState2 = YES;
            }
            else {
                self.pStateImageView.hidden = NO;
                self.pStateImageView.image = [UIImage imageNamed:@"icon_watchrsv.png"];
                self.pStateImageView.tag = 10;
                isState1 = YES;
            }
        }
        else if ( [sState isEqualToString:@"녹화예약중"] )
        {
            if (isState1 == YES) {
                self.pStateImageView2.hidden = NO;
                self.pStateImageView2.image = [UIImage imageNamed:@"icon_recrsv.png"];
                self.pStateImageView2.tag = 20;
                isState2 = YES;
            }
            else {
                self.pStateImageView.hidden = NO;
                self.pStateImageView.image = [UIImage imageNamed:@"icon_recrsv.png"];
                self.pStateImageView.tag = 20;
                isState1 = YES;
            }
        }
        
        if ( [sState isEqualToString:@"녹화중"] )
        {
            BOOL isWatch = NO;
            
            if (isState1) {
                if (self.pStateImageView.tag == 10) {
                    isWatch = YES;
                }
            }
            if (isState2) {
                if (self.pStateImageView.tag == 10) {
                    isWatch = YES;
                }
            }
            
            if (isWatch) {
                self.pStateImageView.hidden = NO;
                self.pStateImageView.image = [UIImage imageNamed:@"icon_watchrsv.png"];
                self.pStateImageView.tag = 10;
                self.pStateImageView2.hidden = NO;
                self.pStateImageView2.image = [UIImage imageNamed:@"icon_rec.png"];
                self.pStateImageView2.tag = 30;
            }
            else {
                self.pStateImageView.hidden = NO;
                self.pStateImageView.image = [UIImage imageNamed:@"icon_rec.png"];
                self.pStateImageView.tag = 30;
                
                if (isState2) {
                    self.pStateImageView.hidden = YES;
                }
                
            }
        }
        
    }

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
