//
//  PvrMainTableViewCell.h
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 10. 19..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PvrMainTableViewCell : UITableViewCell

// 녹화 예약 관리
- (void)setListDataReservation:(NSDictionary *)dic WithIndex:(int)index;

// 녹화물 목록
- (void)setListDataList:(NSDictionary *)dic WithIndex:(int)index;

@end
