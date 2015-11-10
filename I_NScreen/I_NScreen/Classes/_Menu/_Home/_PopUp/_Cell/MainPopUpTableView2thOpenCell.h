//
//  MainPopUpTableView2thOpenCell.h
//  I_NScreen
//
//  Created by 조백근 on 2015. 11. 10..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainPopUpTableViewCellDelegate.h"

@protocol MainPopUpTableViewCellDelegate;

@interface MainPopUpTableView2thOpenCell : UITableViewCell

@property (nonatomic, strong) NSDictionary *pDic;

@property (nonatomic, weak) IBOutlet UIView *pTwoDepthOpenView;
@property (nonatomic, weak) IBOutlet UILabel *pTwoDepthOpneLbl;
@property (nonatomic, weak) IBOutlet UIImageView *pTwoDepthOpenImg;

@property (nonatomic, weak) id <MainPopUpTableViewCellDelegate>delegate;

- (void)setListData:(NSDictionary *)dic WithIndex:(int)index WithOpen:(BOOL)isOpen;

- (IBAction)onBtnClicked:(UIButton *)btn;
@end
