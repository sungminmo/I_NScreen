//
//  MyCMMainViewController.h
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 9. 16..
//  Copyright (c) 2015년 STVN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMBaseViewController.h"
#import "MyCMZimListTableViewCell.h"
#import "MyCMBuyListTableViewCell.h"

@interface MyCMMainViewController : CMBaseViewController

@property (nonatomic, weak) IBOutlet UIButton *pBackBtn;        // back 버튼
@property (nonatomic, weak) IBOutlet UIButton *pTapBtn01;       // vod 찜 목록
@property (nonatomic, weak) IBOutlet UIButton *pTapBtn02;       // vod 시청목록
@property (nonatomic, weak) IBOutlet UIButton *pTapBtn03;       // vod 구매목록

@property (nonatomic, strong) IBOutlet UIView *pSubView01;      // vod 구매목록 뷰
@property (nonatomic, strong) IBOutlet UIView *pSubView02;      // vod 시청목록, vod 찜목록 뷰

@property (nonatomic, weak) IBOutlet UIButton *pSubTabBtn01;    // 모바일 구매목록
@property (nonatomic, weak) IBOutlet UIButton *pSubTabBtn02;    // TV 구매목록

@property (nonatomic, strong) IBOutlet UIView *pLeftLineView;
@property (nonatomic, strong) IBOutlet UIView *pRightLineView;

@property (nonatomic, weak) IBOutlet UILabel *pTotalExplanLbl01; // 총 목록
@property (nonatomic, weak) IBOutlet UILabel *pTotalExplanLbl02;

@property (nonatomic, strong) IBOutlet UITableView *pSubTableView01;
@property (nonatomic, strong) IBOutlet UITableView *pSubTableView02;


@end
