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

@property (nonatomic, weak) id <EpgSubTableViewDelegate>delegate1;

/**
 *  데이터 및 화면 정보를 갱신한다.
 *
 *  @param data 셀에 표출될 정보
 */
- (void)setData:(NSDictionary*)data WithIndex:(int)nIndex;

@end

@protocol EpgSubTableViewDelegate <NSObject>

@optional
- (void)EpgSubTableViewMoreBtn:(int)nIndex;
- (void)EpgSubTableViewDeleteBtn:(int)nIndex;


@end