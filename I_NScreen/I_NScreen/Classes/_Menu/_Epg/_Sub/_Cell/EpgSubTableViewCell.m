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
@property (strong, nonatomic) IBOutlet UIImageView *hdImageView;
@property (strong, nonatomic) IBOutlet CMProgressView *progressView;


@property (strong, nonatomic) NSDictionary* dataDic;

@end

@implementation EpgSubTableViewCell

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
    
    self.timeLabel.text = @"";
    self.titleLabel.text = @"";
    self.gradeImageView.image = nil;
    self.hdImageView.hidden = true;
}

#pragma mark - Pulbics

/**
 *  데이터 및 화면 정보를 갱신한다.
 *
 *  @param data 셀에 표출될 정보
 */
- (void)setData:(NSDictionary*)data {
    
    [self resetData];
    
    self.dataDic = data;
    
    self.timeLabel.text = data[@"time"];
    self.titleLabel.text = data[@"title"];
    
    NSString* grade = data[@"grade"];
    if ([grade hasPrefix:@"19"]) {
        self.gradeImageView.image = [UIImage imageNamed:@"19.png"];
    } else if ([grade hasPrefix:@"15"]) {
        self.gradeImageView.image = [UIImage imageNamed:@"15.png"];
    } else {
        self.gradeImageView.image = [UIImage imageNamed:@"all.png"];
    }
    
    if ([data[@"hd"] isEqualToString:@"Y"]) {
        self.hdImageView.hidden = FALSE;
    } else {
        self.hdImageView.hidden = YES;
    }
    
    [self.progressView setProgressRatio:.9 animated:YES];
}

#pragma mark - Event

- (void)userPressedMoreButton:(id)sender
{
    [self.delegate EpgSubTableViewDeleteBtn:0];
}

- (void)userPressedDeleteButton:(id)sender
{
    [self.delegate EpgSubTableViewDeleteBtn:1];
}

@end
