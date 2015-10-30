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

@property (nonatomic) BOOL isReservCheck;     // 초기 no, 한번 에러 나면 yes 로 바꿔주고 한번더 전문태움
@property (nonatomic) BOOL isListCheck;         // 상동
@property (nonatomic) BOOL isTabCheck;          // 초기 no 이면 녹화 예약관리, yes 면 녹화물 목록
@property (nonatomic, weak) IBOutlet UILabel *pListComentLbl;

- (IBAction)onBtnClick:(UIButton *)btn;

@end

