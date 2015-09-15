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
#import "CMSearchMainViewController.h"//검색화면 메인
#import "CMPreferenceMainViewController.h"//설정화면 메인

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
            RecodeMainViewController *pViewController = [[RecodeMainViewController alloc] initWithNibName:@"RecodeMainViewController" bundle:nil];
            [self.navigationController pushViewController:pViewController animated:YES];
            
        }break;
        case 3:
        {
            // 검색
            CMSearchMainViewController* controller = [[CMSearchMainViewController alloc] initWithNibName:@"CMSearchMainViewController" bundle:nil];
            [self.navigationController pushViewController:controller animated:YES];
            
        }break;
        case 4:
        {
            // 설정
            CMPreferenceMainViewController* controller = [[CMPreferenceMainViewController alloc] initWithNibName:@"CMPreferenceMainViewController" bundle:nil];
            [self.navigationController pushViewController:controller animated:YES];
            
        }break;
    }
}

@end
