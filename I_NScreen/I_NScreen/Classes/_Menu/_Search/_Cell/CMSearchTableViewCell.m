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
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

#pragma mark - Privates

- (void)resetData {
    
    self.channelLabel.text = @"";
    self.logoImageView.image = nil;
    self.timeLabel.text = @"";
    self.titleLabel.text = @"";
    self.gradeImageView.image = nil;
    self.hmImageView.hidden = NO;
}

#pragma mark - Publics

/*
 <channelId>1438</channelId>
 <channelNumber>107</channelNumber>
 <channelName>팬트하우스_HD</channelName>
 <channelInfo>HD</channelInfo>
 <channelLogoImg>http://58.141.255.69:8080/logo/1438.png</channelLogoImg>
 <channelProgramID>S319072039</channelProgramID>
 <channelProgramTime>2015-11-03 01:35:00</channelProgramTime>
 <channelProgramTitle>(일) 이웃집 아가씨 몰래 찍은 동영상</channelProgramTitle>
 <channelProgramSeq>319072039</channelProgramSeq>
 <channelProgramGrade>19세 이상</channelProgramGrade>
 <channelProgramHD>YES</channelProgramHD>
 */
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
    
    self.logoImageView.image = nil;
    [self.logoImageView setImageWithURL:[NSURL URLWithString:data[@"channelLogoImg"]]];
    
    self.timeLabel.text = data[@"channelProgramTime"];
    self.titleLabel.text = data[@"channelProgramTitle"];
    
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

    NSString* sChannelInfo = data[@"channelInfo"];
    
    if ( [sChannelInfo isEqualToString:@"HD"] )
    {
        // HD
        
        self.hmImageView.image = [UIImage imageNamed:@"hd.png"];
    }
    else
    {
        // SD
        self.hmImageView.image = [UIImage imageNamed:@"sd.png"];
    }
    
//    NSString* hd = data[@"channelProgramHD"];
//    
//    if ([hd isEqualToString:@"YES"]) {
//        self.hmImageView.hidden = NO;
//    } else {
//        self.hmImageView.hidden = YES;
//    }
}

- (IBAction)onBtnClicked:(UIButton *)btn
{
//    NSString *sChannelId = self.pDataDic[@"channelId"];
//    CMDBDataManager *manager = [CMDBDataManager sharedInstance];
//    RLMArray *ramArr = [manager getFavorChannel];
//    BOOL isCheck = NO;
//    
//    int nCount = 0;
//    for ( CMFavorChannelInfo *info in ramArr )
//    {
//        if ( [info.pChannelId isEqualToString:sChannelId] )
//        {
//            isCheck = YES;
//            [manager removeFavorChannel:nCount];
//        }
//        nCount++;
//    }
//    
//    if ( isCheck == NO )
//    {
//        [manager setFavorChannel:self.pDataDic];
//    }
//    
//    [self.delegate EpgMainTableViewWithTag:self.nIndex];
//    NSLog(@"[manager getFavorChannel] = [%@]", [manager getFavorChannel]);
    
    
//    [self.delegate2 CMSearchTableViewCellTag:self.nIndex];
}

@end
