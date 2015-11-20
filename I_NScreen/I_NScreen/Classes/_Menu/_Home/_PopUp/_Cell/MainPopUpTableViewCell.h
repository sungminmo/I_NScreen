//
//  MainPopUpTableViewCell.h
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 11. 5..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainPopUpTableViewCellDelegate.h"


@protocol MainPopUpTableViewCellDelegate;

@interface MainPopUpTableViewCell : UITableViewCell

@property (nonatomic, strong) NSDictionary *pDic;
@property (nonatomic, weak) IBOutlet UIView *pFourDepthView;
@property (nonatomic, weak) IBOutlet UILabel *pFourDepthLbl;
@property (nonatomic, weak) IBOutlet UIImageView* pressEffectView;

@property (nonatomic, weak) id <MainPopUpTableViewCellDelegate>delegate;

- (void)setListData:(NSDictionary *)dic WithIndex:(int)index WithOpen:(BOOL)isOpen;

- (IBAction)onBtnClicked:(UIButton *)btn;

@end

