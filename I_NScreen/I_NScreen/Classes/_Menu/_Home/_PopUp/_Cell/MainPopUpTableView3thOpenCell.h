//
//  MainPopUpTableView3thOpenCell.h
//  I_NScreen
//
//  Created by 조백근 on 2015. 11. 10..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainPopUpTableViewCellDelegate.h"
#import "MainPopUpViewController.h"

@protocol MainPopUpTableViewCellDelegate;

@interface MainPopUpTableView3thOpenCell : UITableViewCell

@property (nonatomic, strong) NSDictionary *pDic;
@property (nonatomic, weak) IBOutlet UIView *pThreeDepthOpenView;
@property (nonatomic, weak) IBOutlet UILabel *pThreeDepthOpenLbl;
@property (nonatomic, weak) IBOutlet UIImageView *pThreeDepthOpenImg;

@property (nonatomic, weak) id <MainPopUpTableViewCellDelegate>delegate;

- (void)setListData:(NSDictionary *)dic WithIndex:(int)index WithOpen:(BOOL)isOpen;

- (IBAction)onBtnClicked:(UIButton *)btn;
@end
