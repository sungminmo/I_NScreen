//
//  RootViewController.m
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 8. 12..
//  Copyright (c) 2015년 JUNG KIL BAE. All rights reserved.
//

#import "RootViewController.h"
#import "CMSearchHistory.h"
#import "EpgMainViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    HomeGnbViewController *pViewController = [[HomeGnbViewController alloc] initWithNibName:@"HomeGnbViewController" bundle:nil];
    pViewController.delegate = self;
    [self addChildViewController:pViewController];
    [pViewController didMoveToParentViewController:self];
    [self.pGnbView addSubview:pViewController.view];
}


- (void)onHomeGnbViewMenuList:(int)nTag
{
    switch (nTag) {
        case HOME_GNB_VIEW_BTN_TAG_01:
        {
            [[CMAppManager sharedInstance] onLeftMenuListOpen:self];
        }break;
    }
}

- (void)onLeftMenuViewCloseCompletReflash:(int)nTag
{
    switch (nTag) {
        case 0:
        {
            // 닫기 버튼
            
        }break;
        case 1:
        {
            // EPG
            EpgMainViewController *pViewController = [[EpgMainViewController alloc] initWithNibName:@"EpgMainViewController" bundle:nil];
            [self.navigationController pushViewController:pViewController animated:YES];
        }break;
        case 2:
        {
            // PVR
            
        }break;
        case 3:
        {
            // 검색
            
        }break;
        case 4:
        {
            // 설정
            
        }break;
    }
}

@end
