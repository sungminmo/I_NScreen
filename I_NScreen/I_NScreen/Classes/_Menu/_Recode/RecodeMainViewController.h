//
//  RecodeMainViewController.h
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 9. 14..
//  Copyright (c) 2015년 STVN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecodeMainTableViewCell.h"
#import "RecodeSubViewController.h"

@interface RecodeMainViewController : UIViewController

@property (nonatomic, weak) IBOutlet UIButton *pBackBtn;        // back 버튼
@property (nonatomic, weak) IBOutlet UIButton *pReservationBtn; // 녹화 예약 관리 버튼
@property (nonatomic, weak) IBOutlet UIButton *pListBtn;        // 녹화물 목록 버튼
@property (nonatomic, weak) IBOutlet UITableView *pTableView;

- (IBAction)onBtnClick:(UIButton *)btn;

@end
