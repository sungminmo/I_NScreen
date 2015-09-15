//
//  EpgMainViewController.h
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 9. 11..
//  Copyright (c) 2015년 STVN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EpgMainTableViewCell.h"
#import "EpgPopUpViewController.h"
#import "EpgSubViewController.h"

@interface EpgMainViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) IBOutlet UIButton *pBackBtn;
@property (nonatomic, strong) IBOutlet UIButton *pPopUpBtn;
@property (nonatomic, strong) IBOutlet UITableView *pTableView;

- (IBAction)onBtnClick:(UIButton *)btn;

@end
