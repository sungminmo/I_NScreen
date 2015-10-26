//
//  EpgSubViewController.h
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 9. 14..
//  Copyright (c) 2015년 STVN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMBaseViewController.h"
#import "EpgSubTableViewCell.h"
#import "IDScrollableTabBarDelegate.h"
#import "CMSearchTableViewCell.h"

@interface EpgSubViewController : CMBaseViewController<IDScrollableTabBarDelegate, EpgSubTableViewDelegate>

@property (nonatomic, strong) IBOutlet UITableView *pTableView;
@property (nonatomic, weak) IBOutlet UIButton *pBackBtn;
@property (nonatomic, strong) IBOutlet UIView *pSubChannelView;

@end
