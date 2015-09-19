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

@interface EpgSubViewController : CMBaseViewController

@property (nonatomic, strong) IBOutlet UITableView *pTableView;
@property (nonatomic, weak) IBOutlet UIButton *pBackBtn;

@end
