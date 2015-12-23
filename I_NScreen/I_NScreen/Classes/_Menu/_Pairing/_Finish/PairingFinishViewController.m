//
//  PairingFinishViewController.m
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 10. 24..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import "PairingFinishViewController.h"

@interface PairingFinishViewController ()

@end

@implementation PairingFinishViewController
@synthesize delegate;

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"셋탑박스 등록";
    self.isUseNavigationBar = YES;
    [self hideBackButton:YES];
    
    [self setTagInit];
    [self setViewInit];
}

#pragma mark - 초기화
#pragma mark - 테그 초기화
- (void)setTagInit
{
    self.pOkBtn.tag = PAIRING_FINISH_VIEW_BTN_01;
}

#pragma mark - 화면 초기화
- (void)setViewInit
{
    
}


#pragma mark - 액션이벤트
#pragma mark - 버튼 액션 이벤트
- (IBAction)onBtnClicked:(UIButton *)btn
{
    switch ([btn tag]) {
        case PAIRING_FINISH_VIEW_BTN_01:
        {
            // 완료
            [self.navigationController popToRootViewControllerAnimated:YES];
            [self.delegate PairingFinishViewWithTag:PAIRING_FINISH_VIEW_BTN_01];
        }break;
    }
}

@end
