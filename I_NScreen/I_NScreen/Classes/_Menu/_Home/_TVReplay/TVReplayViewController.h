//
//  TVReplayViewController.h
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 10. 23..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMBaseViewController.h"
#import "TVReplayTableViewCell.h"

@interface TVReplayViewController : CMBaseViewController

@property (nonatomic, strong) IBOutlet UIView *pView01; // 버튼 뷰
@property (nonatomic, strong) IBOutlet UIButton *pDepthBtn; // 댑스 버튼

@property (nonatomic, strong) IBOutlet UIView *pView02; // 리스트 뷰만 있는 뷰
@property (nonatomic, strong) IBOutlet UITableView *pTableView;
@property (nonatomic, strong) NSString *pViewerTypeStr;

- (IBAction)onBtnClicked:(UIButton *)btn;


@end
