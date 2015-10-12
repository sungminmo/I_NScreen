//
//  HomeGnbViewController.m
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 9. 11..
//  Copyright (c) 2015년 STVN. All rights reserved.
//

#import "HomeGnbViewController.h"

@interface HomeGnbViewController ()

@end

@implementation HomeGnbViewController

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setTagInit];
}

#pragma mark - 초기화
#pragma mark - tag 초기화
- (void)setTagInit
{
    self.pListBtn.tag = HOME_GNB_VIEW_BTN_01;
    self.pSearchBtn.tag = HOME_GNB_VIEW_BTN_02;
    self.pMenu01.tag = HOME_GNB_VIEW_BTN_03;
    self.pMenu02.tag = HOME_GNB_VIEW_BTN_04;
    self.pMenu03.tag = HOME_GNB_VIEW_BTN_05;
    self.pMenu04.tag = HOME_GNB_VIEW_BTN_06;
    self.pMenu05.tag = HOME_GNB_VIEW_BTN_07;
}

#pragma mark - 액션 이벤트
#pragma mark - 버튼 액션 이벤트
- (IBAction)onBtnClicked:(UIButton *)btn
{
    switch ([btn tag]) {
        case HOME_GNB_VIEW_BTN_01:
        {
            
        }break;
        case HOME_GNB_VIEW_BTN_02:
        {
            // 검색
            
        }break;
        case HOME_GNB_VIEW_BTN_03:
        {
            // 추천
            
        }break;
        case HOME_GNB_VIEW_BTN_04:
        {
            // 영화
            
        }break;
        case HOME_GNB_VIEW_BTN_05:
        {
            // 애니키즈
            
        }break;
        case HOME_GNB_VIEW_BTN_06:
        {
            // 인기프로그램
            
        }break;
        case HOME_GNB_VIEW_BTN_07:
        {
            // 성인
            
        }break;
    }
    [self.delegate onHomeGnbViewMenuList:(int)[btn tag]];
}


@end
