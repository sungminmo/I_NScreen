//
//  RecodeMainTableViewCell.h
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 9. 14..
//  Copyright (c) 2015년 STVN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecodeMainTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView *pLineImageView01;     // 윗라인
@property (nonatomic, weak) IBOutlet UIImageView *pLineImageView02;     // 밑 라인
@property (nonatomic, weak) IBOutlet UILabel *pTitleLbl;

- (void)setListData:(NSDictionary *)dic WithIndex:(int)index;

@end
