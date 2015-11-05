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
@property (nonatomic, weak) id <MainPopUpTableViewCellDelegate>delegate;

- (void)setListData:(NSDictionary *)dic WithIndex:(int)index WithOpen:(BOOL)isOpen;

- (IBAction)onBtnClicked:(UIButton *)btn;

@end

@protocol MainPopUpTableViewCellDelegate <NSObject>

@optional
- (void)MainPopUpTableViewCellData:(NSDictionary *)dic;

@end