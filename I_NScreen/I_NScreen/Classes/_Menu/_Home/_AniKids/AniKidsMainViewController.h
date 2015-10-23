//
//  AniKidsMainViewController.h
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 10. 12..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMBaseViewController.h"
#import "AnikidsMainTableViewCell.h"

@interface AniKidsMainViewController : CMBaseViewController

// 인기순위 화면
@property (nonatomic, strong) IBOutlet UIView *pPopularView;  // 인기순위 뷰
@property (nonatomic, strong) IBOutlet UIButton *pPopularBtn;  // 인기 순위 버튼
@property (nonatomic, strong) IBOutlet UIButton *pRealTimePopularBtn;   // 실시간 인기 순위 버튼
@property (nonatomic, strong) IBOutlet UIButton *pWeekPopularBtn;       // 주간 인기 순위 버튼
@property (nonatomic, strong) IBOutlet UITableView *pPopularTableView;  // 인기 순위 테이블 뷰

@property (nonatomic, strong) IBOutlet UIImageView *pPopularLine01;
@property (nonatomic, strong) IBOutlet UIImageView *pPopularLine02;

// 그외 화면
@property (nonatomic, strong) IBOutlet UIView *pElseView;   // 그외 뷰
@property (nonatomic, strong) IBOutlet UIButton *pElseBtn;  // 그외 버튼
@property (nonatomic, strong) IBOutlet UITableView *pElseTableView; // 그외 테이블 뷰

- (IBAction)onBtnClicked:(UIButton *)btn;

@end
