//
//  PairingAuthViewController.m
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 10. 24..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import "PairingAuthViewController.h"
#import "PairingFinishViewController.h"

@interface PairingAuthViewController ()

@end

@implementation PairingAuthViewController

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
#pragma mark - 테그 초기화
- (void)setTagInit
{
    self.pBackBtn.tag = PAIRING_AUTH_VIEW_BTN_01;
    self.pCancelBtn.tag = PAIRING_AUTH_VIEW_BTN_02;
    self.pOkBtn.tag = PAIRING_AUTH_VIEW_BTN_03;
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
        case PAIRING_AUTH_VIEW_BTN_01:
        case PAIRING_AUTH_VIEW_BTN_02:
        {
            // 등록 취소
            [self.navigationController popViewControllerAnimated:YES];
        }break;
        case PAIRING_AUTH_VIEW_BTN_03:
        {
            // 다음 단계
            PairingFinishViewController *pViewController = [[PairingFinishViewController alloc] initWithNibName:@"PairingFinishViewController" bundle:nil];
            [self.navigationController pushViewController:pViewController animated:YES];
        }break;
    }
}

@end
