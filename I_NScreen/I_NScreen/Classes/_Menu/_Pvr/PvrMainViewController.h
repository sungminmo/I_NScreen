//
//  PvrMainViewController.h
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 10. 19..
//  Copyright © 2015년 STVN. All rights reserved.
//
/*/================================================================================================
 PVR - MAIN
 ================================================================================================/*/

#import <UIKit/UIKit.h>
#import "CMBaseViewController.h"
#import "PvrMainTableViewCell.h"
#import "PvrSubViewController.h"

@interface PvrMainViewController : CMBaseViewController

@property (nonatomic, weak) IBOutlet UIButton *pBackBtn;        // back 버튼
@property (nonatomic, weak) IBOutlet UIButton *pReservationBtn; // 녹화 예약 관리 버튼
@property (nonatomic, weak) IBOutlet UIButton *pListBtn;        // 녹화물 목록 버튼
@property (nonatomic, weak) IBOutlet UITableView *pTableView;

- (IBAction)onBtnClick:(UIButton *)btn;

@end

