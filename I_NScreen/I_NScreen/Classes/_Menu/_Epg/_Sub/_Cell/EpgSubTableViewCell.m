//
//  EpgSubTableViewCell.m
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 9. 14..
//  Copyright (c) 2015년 STVN. All rights reserved.
//

#import "EpgSubTableViewCell.h"

@interface EpgSubTableViewCell ()

@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIImageView *gradeImageView;
@property (strong, nonatomic) IBOutlet UIImageView *hdImageView;
@property (strong, nonatomic) IBOutlet UIView *progressBackgroundView;
@property (strong, nonatomic) IBOutlet UIView *progressView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *progressWidth;

@property (strong, nonatomic) NSDictionary* dataDic;

@end

@implementation EpgSubTableViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.progressView.backgroundColor = [CMColor colorHighlightedFontColor];
    
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
    self.progressWidth.constant = 0;
}

/**
 *  진행바 너비를 셋팅한다.
 *  progressBackgroundView의 너비가 확정된 이후에 제대로된 너비를 세팅할수 있기때문에
 *  layoutSubviews 함수 안에서 호출한다.
 *
 *  @param ratio 진행바 너비 비율 (0 ~ 1)
 */
- (void)setProgressRatio:(CGFloat)ratio {
    
    self.progressWidth.constant = self.progressBackgroundView.bounds.size.width * ratio;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    [self layoutIfNeeded];
    
    [self setProgressRatio:[self.dataDic[@"progress"] floatValue]];
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
