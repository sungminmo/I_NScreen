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
- (void)CMHomeCommonCollectionViewDidItemSelectWithAssetId:(NSString *)sAssetId;

@end
