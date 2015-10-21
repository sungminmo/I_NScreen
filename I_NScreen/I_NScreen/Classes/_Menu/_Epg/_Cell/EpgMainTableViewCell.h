//
//  EpgMainTableViewCell.h
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 9. 11..
//  Copyright (c) 2015년 STVN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EpgMainTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView *pLineImageView01;     // 윗라인
@property (nonatomic, weak) IBOutlet UIImageView *pLineImageView02;     // 밑 라인
@property (nonatomic, weak) IBOutlet UIImageView *pHeartImgView;        // 하트
@property (nonatomic, weak) IBOutlet UIImageView *pLogoImageView;       // 방송로그
@property (nonatomic, weak) IBOutlet UIImageView *pFullStreamImageView; // 총 방송 steam
@property (nonatomic, weak) IBOutlet UIImageView *pSeeStreamImageView;  // 본 시간 steam
@property (nonatomic, weak) IBOutlet UIImageView *pGradeImageView;      // 시청등급
@property (nonatomic, weak) IBOutlet UIImageView *pChannelInfoImageView;    // HD 인지 SD 인지
@property (nonatomic, weak) IBOutlet UILabel     *pChannelTitleLbl;     // 체널 타이틀
@property (nonatomic, weak) IBOutlet UILabel     *pChannelTimeLbl;       // 체널 시간
@property (nonatomic, weak) IBOutlet UILabel     *pChannelLbl;           // 체널 

- (void)setListData:(NSDictionary *)dic WithIndex:(int)index;

@end
