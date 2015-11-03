//
//  AnikidsMainTableViewCell.h
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 10. 23..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AnikidsMainTableViewCellDelegate;

@interface AnikidsMainTableViewCell : UITableViewCell

@property (nonatomic) int nIndex;
@property (nonatomic, strong) NSMutableArray *pAssetIdArr;

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

@property (nonatomic, strong) IBOutlet UIButton *pBtn01;
@property (nonatomic, strong) IBOutlet UIButton *pBtn02;
@property (nonatomic, strong) IBOutlet UIButton *pBtn03;
@property (nonatomic, strong) IBOutlet UIButton *pBtn04;

@property (nonatomic, strong) IBOutlet UIView *pView01;
@property (nonatomic, strong) IBOutlet UIView *pView02;
@property (nonatomic, strong) IBOutlet UIView *pView03;
@property (nonatomic, strong) IBOutlet UIView *pView04;

@property (nonatomic, weak) id <AnikidsMainTableViewCellDelegate>delegate;

- (IBAction)onBtnClicked:(UIButton *)btn;

- (void)setListData:(NSArray *)arr WithIndex:(int)index WithViewerType:(NSString *)viewerType;

@end

@protocol AnikidsMainTableViewCellDelegate <NSObject>

@optional
- (void)AnikidsMainTableViewCellBtnClicked:(int)nTag WithSelect:(int)nSelect WithAssetId:(NSString *)assetId;

@end
