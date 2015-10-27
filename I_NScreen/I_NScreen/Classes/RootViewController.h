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
#import "MyCMMainViewController.h"
#import "AdultMainViewController.h"
#import "AniKidsMainViewController.h"
#import "MovieMainViewController.h"
#import "RecommendMainViewController.h"
#import "MoviePopUpViewController.h"
#import "PvrMainViewController.h"
#import "RemoconMainViewController.h"
#import "TestMainViewController.h"
#import "TVReplayViewController.h"
#import "PairingMainViewController.h"
#import "PairingRePwViewController.h"

@interface RootViewController : CMBaseViewController <HomeGnbViewDelegate, LeftMenuViewDelegate, MovieMainViewDelegate, MoviePopUpViewDelegate>

@property (nonatomic, strong) IBOutlet UIView *pGnbView;
@property (nonatomic, strong) IBOutlet UIView *pBodyView;


@end
