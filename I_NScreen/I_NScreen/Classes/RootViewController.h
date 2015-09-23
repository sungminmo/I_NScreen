//
//  RootViewController.h
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 8. 12..
//  Copyright (c) 2015년 JUNG KIL BAE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UITableViewController.h>
#import "CMBaseViewController.h"
#import "HomeGnbViewController.h"
#import "LeftMenuViewController.h"
#import "RecodeMainViewController.h"
#import "MyCMMainViewController.h"

@interface RootViewController : CMBaseViewController <HomeGnbViewDelegate, LeftMenuViewDelegate>

@property (nonatomic, strong) IBOutlet UIView *pGnbView;
@property (nonatomic, strong) IBOutlet UIView *pBodyView;


@end
