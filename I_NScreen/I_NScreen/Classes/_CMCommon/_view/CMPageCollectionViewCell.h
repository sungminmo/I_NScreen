//
//  CMPageCollectionViewCell.h
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 10. 16..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CMPageCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak) IBOutlet UILabel *pTitleLbl;
@property (nonatomic, weak) IBOutlet UIImageView *pThumImageView;
@property (nonatomic, weak) IBOutlet UIImageView *pStickerImageView;
@property (nonatomic, weak) IBOutlet UILabel *pRankingLbl;

- (void)setListData:(NSDictionary *)dic WithIndex:(int)index;

@end
