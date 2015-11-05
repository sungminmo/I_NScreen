//
//  MainPopUpTableViewCell.h
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 11. 5..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MainPopUpTableViewCellDelegate;

@interface MainPopUpTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *pTitleLbl;
@property (nonatomic, weak) IBOutlet UIImageView *pArrowImgView;
@property (nonatomic, strong) NSDictionary *pDic;

//
@property (nonatomic, weak) IBOutlet UIView *pTwoDepthOpenView;
@property (nonatomic, weak) IBOutlet UILabel *pTwoDepthOpneLbl;
@property (nonatomic, weak) IBOutlet UIImageView *pTwoDepthOpenImg;

//
@property (nonatomic, weak) IBOutlet UIView *pTwoDepthCloseView;
@property (nonatomic, weak) IBOutlet UILabel *pTwoDepthCloseLbl;
@property (nonatomic, weak) IBOutlet UIImageView *pTwoDepthCloseImg;

//
@property (nonatomic, weak) IBOutlet UIView *pThreeDepthOpenView;
@property (nonatomic, weak) IBOutlet UILabel *pThreeDepthOpenLbl;
@property (nonatomic, weak) IBOutlet UIImageView *pThreeDepthOpenImg;

//
@property (nonatomic, weak) IBOutlet UIView *pThreeDepthCloseView;
@property (nonatomic, weak) IBOutlet UILabel *pThreeDepthCloseLbl;
@property (nonatomic, weak) IBOutlet UIImageView *pThreeDepthCloseImg;

//
@property (nonatomic, weak) IBOutlet UIView *pFourDepthView;
@property (nonatomic, weak) IBOutlet UILabel *pFourDepthLbl;

@property (nonatomic, weak) id <MainPopUpTableViewCellDelegate>delegate;

- (void)setListData:(NSDictionary *)dic WithIndex:(int)index WithOpen:(BOOL)isOpen;

- (IBAction)onBtnClicked:(UIButton *)btn;

@end

@protocol MainPopUpTableViewCellDelegate <NSObject>

@optional
- (void)MainPopUpTableViewCellData:(NSDictionary *)dic;

@end