//
//  CMHomeCommonCollectionViewCell.h
//  I_NScreen
//
//  Created by 조백근 on 2015. 11. 8..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CMHomeCommonCollectionViewCellDelegate;

@interface CMHomeCommonCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak) IBOutlet UIImageView *pOnlyTvImageView;
@property (nonatomic, weak) id <CMHomeCommonCollectionViewCellDelegate>delegate;

- (void)setListData:(NSDictionary*)data WithViewerType:(NSString*)type;

- (IBAction)onBtnClicked:(UIButton *)btn;

@end

@protocol CMHomeCommonCollectionViewCellDelegate <NSObject>

@optional
// assetBundle 이 1이면 구매 여부 assetinfo 전문 한번 더 태움
- (void)CMHomeCommonCollectionViewDidItemSelectWithAssetId:(NSString *)sAssetId WithAdultCheck:(BOOL)isAdult WithEpisodePeerExistentce:(NSString *)episodePeerExistence WithContentGroupId:(NSString *)contentGroupId WithAssetBundle:(NSString *)assetBundle;

@end
