//
//  EpgMainTableViewCell.h
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 9. 11..
//  Copyright (c) 2015년 STVN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMProgressView.h"

@protocol EpgMainTableViewDelegate;

@interface EpgMainTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView *pLineImageView01;     // 윗라인
@property (nonatomic, weak) IBOutlet UIImageView *pLineImageView02;     // 밑 라인
@property (nonatomic, weak) IBOutlet UIImageView *pStarImageView;        // 별
@property (nonatomic, weak) IBOutlet UIImageView *pLogoImageView;       // 방송로그
@property (nonatomic, weak) IBOutlet UIImageView *pGradeImageView;      // 시청등급
@property (nonatomic, weak) IBOutlet UIImageView *pChannelInfoImageView;    // HD 인지 SD 인지
@property (nonatomic, weak) IBOutlet UILabel     *pChannelTitleLbl;     // 체널 타이틀
@property (nonatomic, weak) IBOutlet UILabel     *pChannelTimeLbl;       // 체널 시간
@property (nonatomic, weak) IBOutlet UILabel     *pChannelLbl;           // 체널
@property (nonatomic, weak) IBOutlet UIButton    *pStarBtn;
@property (nonatomic, weak) IBOutlet UIImageView *pStateImageView;  // 시청예약인지, 녹화중인지, 녹화예약인지
@property (nonatomic) int nIndex;

@property (nonatomic, strong) NSDictionary *pData;

@property (strong, nonatomic) IBOutlet CMProgressView *progressView;

@property (nonatomic, weak) id <EpgMainTableViewDelegate>delegate;

- (void)setListData:(NSDictionary *)dic WithIndex:(int)index WithStar:(BOOL)isStar WithWatchCheck:(BOOL)isWatch WithRecordingCheck:(BOOL)isRecording WithReservCheck:(BOOL)isReservCheck;

- (IBAction)onBtnClicked:(UIButton *)btn;

@end

@protocol EpgMainTableViewDelegate <NSObject>

@optional
- (void)EpgMainTableViewWithTag:(int)nTag;

@end