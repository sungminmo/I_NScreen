//
//  CMPageCollectionViewCell.h
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 10. 16..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CMPageCollectionViewCellDelegate;

@interface CMPageCollectionViewCell : UICollectionViewCell

@property (nonatomic) int nIndex;
@property (nonatomic, weak) IBOutlet UILabel *pTitleLbl;
@property (nonatomic, weak) IBOutlet UIImageView *pThumImageView;
@property (nonatomic, weak) IBOutlet UIImageView *pStickerImageView;
@property (nonatomic, weak) IBOutlet UILabel *pRankingLbl;
@property (nonatomic, weak) IBOutlet UIImageView *pDimImageView;

@property (nonatomic, strong) NSString  *pAssetIdStr;

@property (nonatomic, weak) id <CMPageCollectionViewCellDelegate>delegate;

- (void)setListData:(NSDictionary *)dic WithIndex:(int)index WithPage:(int)nPage;

- (IBAction)onBtnClicked:(id)sender;

@end


@protocol CMPageCollectionViewCellDelegate <NSObject>

@optional
- (void)CMPageCollectionCellBtnClicked:(int)nSelect WithAssetId:(NSString *)assetId;

@end