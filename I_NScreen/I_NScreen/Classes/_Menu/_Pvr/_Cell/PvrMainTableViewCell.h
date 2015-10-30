//
//  PvrMainTableViewCell.h
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 10. 19..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PvrMainTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView *pLineImageView01;     // 윗라인
@property (nonatomic, weak) IBOutlet UIImageView *pLineImageView02;     // 밑 라인
@property (nonatomic, weak) IBOutlet UILabel *pTitleLbl;
@property (nonatomic, weak) IBOutlet UIImageView *pChannelLogImageView;
@property (nonatomic, weak) IBOutlet UILabel *pDayLbl;      // 날짜
@property (nonatomic, weak) IBOutlet UILabel *pTimeLbl;         // 시간

- (void)setListData:(NSDictionary *)dic WithIndex:(int)index;

@end
