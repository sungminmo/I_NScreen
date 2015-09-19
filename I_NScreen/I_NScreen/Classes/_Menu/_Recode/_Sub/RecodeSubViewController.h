//
//  RecodeSubViewController.h
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 9. 14..
//  Copyright (c) 2015년 STVN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMBaseViewController.h"
#import "RecodeSubTableViewCell.h"

@interface RecodeSubViewController : CMBaseViewController

@property (nonatomic, weak) IBOutlet UIButton *pBackBtn;        // back 버튼
@property (nonatomic, weak) IBOutlet UITableView *pTableView;

- (IBAction)onBtnClick:(UIButton *)btn;

@end
