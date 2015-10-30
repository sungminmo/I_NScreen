//
//  EpgPopUpViewController.m
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 9. 14..
//  Copyright (c) 2015년 STVN. All rights reserved.
//

#import "EpgPopUpViewController.h"

@interface EpgPopUpViewController ()

@end

@implementation EpgPopUpViewController

- (id)init{
    self = [super init];
    if(self){
        self.isUseNavigationBar = NO;        
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}


- (void)viewWillDisappear:(BOOL)animated  {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTagInit];
}

#pragma mark - 초기화
#pragma mark - 화면 태그값 초기화
- (void)setTagInit
{
    self.pCloseBtn.tag = EPG_POPUP_VIEW_BTN_01;
    self.pChannelFullBtn.tag = EPG_POPUP_VIEW_BTN_02;
    self.pChannelFavorBtn.tag = EPG_POPUP_VIEW_BTN_03;
    self.pChannelBgBtn.tag = EPG_POPUP_VIEW_BTN_04;
}

#pragma mark - 액션 이벤트
#pragma mark - 버튼 클릭 이벤트
- (IBAction)onBtnClick:(UIButton *)btn
{
    switch (btn.tag) {
        case EPG_POPUP_VIEW_BTN_01:
        case EPG_POPUP_VIEW_BTN_04:
        {
            // 닫기
            [self.view removeFromSuperview];
            [self willMoveToParentViewController:nil];
            [self removeFromParentViewController];
            
        }break;
        case EPG_POPUP_VIEW_BTN_02:
        {
            // 전체 채널
            
        }break;
        case EPG_POPUP_VIEW_BTN_03:
        {
            // 선호 채널
            
        }break;
    }
}

@end
