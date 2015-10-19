//
//  RemoconMainViewController.h
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 10. 19..
//  Copyright © 2015년 STVN. All rights reserved.
//
/*/================================================================================================
 리모컨 - MAIN
 ================================================================================================/*/

#import <UIKit/UIKit.h>
#import "CMBaseViewController.h"
#import "RemoconMainTableViewCell.h"

@interface RemoconMainViewController : CMBaseViewController

@property (nonatomic, weak) IBOutlet UIButton *pBackBtn;        // back 버튼
@property (nonatomic, weak) IBOutlet UIButton *pPowerBtn;       // 전원 버튼
@property (nonatomic, weak) IBOutlet UIButton *pChannelBtn;     // 채널 버튼
@property (nonatomic, weak) IBOutlet UIButton *pVolumeDownBtn;  // 볼륨 다운 버튼
@property (nonatomic, weak) IBOutlet UIButton *pVoluumeUpBtn;   // 볼륨 업 버튼
@property (nonatomic, weak) IBOutlet UITableView *pTableView;

- (IBAction)onBtnClick:(UIButton *)btn;

@end
