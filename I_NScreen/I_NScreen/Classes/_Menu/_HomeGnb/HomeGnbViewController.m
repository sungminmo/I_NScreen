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
    [self setViewInit];
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
    self.pTestBtn.tag = HOME_GNB_VIEW_BTN_08;
}

#pragma mark - 화면 초기화
- (void)setViewInit
{
    if ( [[[CMAppManager sharedInstance] getDeviceCheck] isEqualToString:IPHONE_RESOLUTION_5]
        || [[[CMAppManager sharedInstance] getDeviceCheck] isEqualToString:IPHONE_RESOLUTION_ELSE] )
    {
        self.pMenu01.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        self.pMenu02.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        self.pMenu03.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        self.pMenu04.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        self.pMenu05.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        
    }
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
            [self.pMenu01 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.pMenu02 setTitleColor:[UIColor colorWithRed:195.0f/255.0f green:174.0f/255.0f blue:220.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
            [self.pMenu03 setTitleColor:[UIColor colorWithRed:195.0f/255.0f green:174.0f/255.0f blue:220.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
            [self.pMenu04 setTitleColor:[UIColor colorWithRed:195.0f/255.0f green:174.0f/255.0f blue:220.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
            [self.pMenu05 setTitleColor:[UIColor colorWithRed:195.0f/255.0f green:174.0f/255.0f blue:220.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
            
        }break;
        case HOME_GNB_VIEW_BTN_04:
        {
            // 영화
            [self.pMenu01 setTitleColor:[UIColor colorWithRed:195.0f/255.0f green:174.0f/255.0f blue:220.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
            [self.pMenu02 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.pMenu03 setTitleColor:[UIColor colorWithRed:195.0f/255.0f green:174.0f/255.0f blue:220.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
            [self.pMenu04 setTitleColor:[UIColor colorWithRed:195.0f/255.0f green:174.0f/255.0f blue:220.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
            [self.pMenu05 setTitleColor:[UIColor colorWithRed:195.0f/255.0f green:174.0f/255.0f blue:220.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
            
        }break;
        case HOME_GNB_VIEW_BTN_05:
        {
            // 애니키즈
            [self.pMenu01 setTitleColor:[UIColor colorWithRed:195.0f/255.0f green:174.0f/255.0f blue:220.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
            [self.pMenu02 setTitleColor:[UIColor colorWithRed:195.0f/255.0f green:174.0f/255.0f blue:220.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
            [self.pMenu03 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.pMenu04 setTitleColor:[UIColor colorWithRed:195.0f/255.0f green:174.0f/255.0f blue:220.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
            [self.pMenu05 setTitleColor:[UIColor colorWithRed:195.0f/255.0f green:174.0f/255.0f blue:220.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
            
        }break;
        case HOME_GNB_VIEW_BTN_06:
        {
            // 인기프로그램
            [self.pMenu01 setTitleColor:[UIColor colorWithRed:195.0f/255.0f green:174.0f/255.0f blue:220.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
            [self.pMenu02 setTitleColor:[UIColor colorWithRed:195.0f/255.0f green:174.0f/255.0f blue:220.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
            [self.pMenu03 setTitleColor:[UIColor colorWithRed:195.0f/255.0f green:174.0f/255.0f blue:220.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
            [self.pMenu04 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.pMenu05 setTitleColor:[UIColor colorWithRed:195.0f/255.0f green:174.0f/255.0f blue:220.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
            
        }break;
        case HOME_GNB_VIEW_BTN_07:
        {
            // 성인
            if ( [[CMAppManager sharedInstance] getKeychainAdultCertification] == YES )
            {
                [self.pMenu01 setTitleColor:[UIColor colorWithRed:195.0f/255.0f green:174.0f/255.0f blue:220.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
                [self.pMenu02 setTitleColor:[UIColor colorWithRed:195.0f/255.0f green:174.0f/255.0f blue:220.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
                [self.pMenu03 setTitleColor:[UIColor colorWithRed:195.0f/255.0f green:174.0f/255.0f blue:220.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
                [self.pMenu04 setTitleColor:[UIColor colorWithRed:195.0f/255.0f green:174.0f/255.0f blue:220.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
                [self.pMenu05 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }
            
        }break;
        case HOME_GNB_VIEW_BTN_08:
        {
            // 테스트 버튼
            [self.pMenu01 setTitleColor:[UIColor colorWithRed:195.0f/255.0f green:174.0f/255.0f blue:220.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
            [self.pMenu02 setTitleColor:[UIColor colorWithRed:195.0f/255.0f green:174.0f/255.0f blue:220.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
            [self.pMenu03 setTitleColor:[UIColor colorWithRed:195.0f/255.0f green:174.0f/255.0f blue:220.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
            [self.pMenu04 setTitleColor:[UIColor colorWithRed:195.0f/255.0f green:174.0f/255.0f blue:220.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
            [self.pMenu05 setTitleColor:[UIColor colorWithRed:195.0f/255.0f green:174.0f/255.0f blue:220.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
            
        }break;
    }
    [self.delegate onHomeGnbViewMenuList:(int)[btn tag]];
}


@end
