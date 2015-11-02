//
//  TVReplayTableViewCell.h
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 11. 2..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TVReplayTableViewCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIImageView *pThumImageView01;
@property (nonatomic, strong) IBOutlet UIImageView *pThumImageView02;
@property (nonatomic, strong) IBOutlet UIImageView *pThumImageView03;
@property (nonatomic, strong) IBOutlet UIImageView *pThumImageView04;

@property (nonatomic, strong) IBOutlet UIImageView *pPromotionImageView01;
@property (nonatomic, strong) IBOutlet UIImageView *pPromotionImageView02;
@property (nonatomic, strong) IBOutlet UIImageView *pPromotionImageView03;
@property (nonatomic, strong) IBOutlet UIImageView *pPromotionImageView04;

@property (nonatomic, strong) IBOutlet UIImageView *pTvCheckImageView01;
@property (nonatomic, strong) IBOutlet UIImageView *pTvCheckImageView02;
@property (nonatomic, strong) IBOutlet UIImageView *pTvCheckImageView03;
@property (nonatomic, strong) IBOutlet UIImageView *pTvCheckImageView04;

@property (nonatomic, strong) IBOutlet UILabel *pTitleLbl01;
@property (nonatomic, strong) IBOutlet UILabel *pTitleLbl02;
@property (nonatomic, strong) IBOutlet UILabel *pTitleLbl03;
@property (nonatomic, strong) IBOutlet UILabel *pTitleLbl04;

- (void)setListData:(NSArray *)arr WithIndex:(int)index WithViewerType:(NSString *)viewerType;

@end
