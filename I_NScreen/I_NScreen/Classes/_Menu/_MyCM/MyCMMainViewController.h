//
//  MyCMMainViewController.h
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 9. 16..
//  Copyright (c) 2015년 STVN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyCMZimListTableViewCell.h"
#import "MyCMBuyListTableViewCell.h"

@interface MyCMMainViewController : UIViewController

@property (nonatomic, weak) IBOutlet UIButton *pBackBtn;        // back 버튼
@property (nonatomic, weak) IBOutlet UIButton *pTapBtn01;       // vod 찜 목록
@property (nonatomic, weak) IBOutlet UIButton *pTapBtn02;       // vod 시청목록
@property (nonatomic, weak) IBOutlet UIButton *pTapBtn03;       // vod 구매목록

@property (nonatomic, weak) IBOutlet UITableView *pTableView;

@end
