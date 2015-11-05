//
//  MainPopUpViewController.h
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 11. 5..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TreeListModel.h"
#import "MainPopUpTableViewCell.h"
#import "CMBaseViewController.h"

@protocol MainPopUpViewDelegate;

@interface MainPopUpViewController : CMBaseViewController

@property (nonatomic, strong) TreeListModel *pModel;
@property (nonatomic, strong) IBOutlet UITableView *pTableView;

@property (nonatomic, strong) IBOutlet UIButton *pBgBtn;

@property (nonatomic, strong) NSString *pDataStr;

@property (nonatomic) int nViewTag;

@property (nonatomic, weak) id<MainPopUpViewDelegate>delegate;

- (IBAction)onBtnClicked:(UIButton *)btn;

@end

@protocol MainPopUpViewDelegate <NSObject>

@optional
- (void)MainPopUpViewWithBtnTag:(int)nTag;

- (void)MainPopUpViewWithBtnData:(NSDictionary *)dataDic WithViewTag:(int)viewTag;

@end