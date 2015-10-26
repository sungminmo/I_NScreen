//
//  RemoconMainTableViewCell.h
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 10. 19..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RemoconMainTableViewCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIImageView *pStarImageView; // 별표
@property (nonatomic, strong) IBOutlet UIImageView *pChannelLogoImageView;  // 체널 로그 이미지 뷰
@property (nonatomic, strong) IBOutlet UIImageView *pAllImageView;
@property (nonatomic, strong) IBOutlet UIImageView *pHdImageView;

@property (nonatomic, strong) IBOutlet UILabel *pChannelLbl;
@property (nonatomic, strong) IBOutlet UILabel *pTitleLbl;
@property (nonatomic, strong) IBOutlet UILabel *pTimeLbl;

- (void)setListData:(NSDictionary *)dic WithIndex:(int)index;

@end
