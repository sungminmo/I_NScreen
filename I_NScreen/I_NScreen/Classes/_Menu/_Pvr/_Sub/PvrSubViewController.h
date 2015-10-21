//
//  PvrSubViewController.h
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 10. 19..
//  Copyright © 2015년 STVN. All rights reserved.
//
/*/================================================================================================
 PVR - SUB
 ================================================================================================/*/

#import <UIKit/UIKit.h>
#import "CMBaseViewController.h"
#import "PvrSubTableViewCell.h"

@interface PvrSubViewController : CMBaseViewController

@property (nonatomic, weak) IBOutlet UIButton *pBackBtn;        // back 버튼
@property (nonatomic, weak) IBOutlet UITableView *pTableView;

- (IBAction)onBtnClick:(UIButton *)btn;

@end