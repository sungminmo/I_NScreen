//
//  CMSearchTableViewCell.m
//  I_NScreen
//
//  Created by 조백근 on 2015. 10. 1..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import "CMSearchTableViewCell.h"
#import "UIImageView+AFNetworking.h"

@interface CMSearchTableViewCell ()

@property (strong, nonatomic) IBOutlet UIImageView *bookmarkImageView;
@property (strong, nonatomic) IBOutlet UILabel *channelLabel;
@property (strong, nonatomic) IBOutlet UIImageView *logoImageView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UIImageView *gradeImageView;
@property (strong, nonatomic) IBOutlet UIImageView *hmImageView;
@property (nonatomic, strong) IBOutlet UIView* lineView;

@end

@implementation CMSearchTableViewCell

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
    self.hmImageView.hidden = YES;
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
- (void)setData:(NSDictionary*)data {

    [self resetData];
    
    self.channelLabel.text = data[@"channelNumber"];
    
    self.logoImageView.image = nil;
    [self.logoImageView setImageWithURL:[NSURL URLWithString:data[@"channelLogoImg"]]];
    
    self.timeLabel.text = data[@"channelProgramTime"];
    self.titleLabel.text = data[@"channelProgramTitle"];
    
    NSString* grade = data[@"channelProgramGrade"];
    
    if ([grade hasPrefix:@"19"]) {
        self.gradeImageView.image = [UIImage imageNamed:@"19.png"];
    } else if ([grade hasPrefix:@"15"]) {
        self.gradeImageView.image = [UIImage imageNamed:@"15.png"];
    } else {
        self.gradeImageView.image = [UIImage imageNamed:@"all.png"];
    }
    
    NSString* hd = data[@"channelProgramHD"];
    
    if ([hd isEqualToString:@"YES"]) {
        self.hmImageView.hidden = NO;
    } else {
        self.hmImageView.hidden = YES;
    }
}

@end
