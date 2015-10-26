//
//  EpgSubTableViewCell.h
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 9. 14..
//  Copyright (c) 2015년 STVN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BMXSwipableCell/BMXSwipableCell.h>

@protocol EpgSubTableViewDelegate;

@interface EpgSubTableViewCell : BMXSwipableCell

//@property (nonatomic, weak) IBOutlet UIImageView *pLineImageView01;     // 윗라인
//@property (nonatomic, weak) IBOutlet UIImageView *pLineImageView02;     // 밑 라인
//@property (nonatomic, weak) IBOutlet UILabel     *pTitleLbl;            // 타이틀
//@property (nonatomic, weak) IBOutlet UILabel     *pTimeLbl;             // 시간

//- (void)setListData:(NSDictionary *)dic WithIndex:(int)index;

@property (nonatomic, weak) id <EpgSubTableViewDelegate>delegate;

@end

@protocol EpgSubTableViewDelegate <NSObject>

@optional
- (void)EpgSubTableViewMoreBtn:(int)nIndex;
- (void)EpgSubTableViewDeleteBtn:(int)nIndex;


@end