//
//  PairingAuthViewController.m
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 10. 24..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import "PairingAuthViewController.h"
#import "PairingFinishViewController.h"
#import "NSMutableDictionary+Pairing.h"
#import "UIAlertView+AFNetworking.h"

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
     self.pAuthTextField.type = Secure_CMTextFieldType;
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
            if ( [self.pAuthTextField.text length] == 0 )
            {
                [SIAlertView alert:@"셋탑박스 등록" message:@"인증번호를 입력해 주세요." button:@"확인"];
            }
            else
            {
                [self requestWithPairingAuth];
            }
            
//            PairingFinishViewController *pViewController = [[PairingFinishViewController alloc] initWithNibName:@"PairingFinishViewController" bundle:nil];
//            [self.navigationController pushViewController:pViewController animated:YES];
        }break;
    }
}

#pragma mark - 이달의 추천 vod 전문
//- (void)requestWithThisMonthRecommend
//{
//    NSString *sCategoryId = @"713229";
//    NSString *sContentGroupProfile = @"2";
//    
//    NSURLSessionDataTask *tesk = [NSMutableDictionary vodGetContentGroupListWithContentGroupProfile:sContentGroupProfile WithCategoryId:sCategoryId completion:^(NSArray *vod, NSError *error) {
//        
//        NSLog(@"이달의 추천 vod = [%@]", vod);
//        
//       
//        
//    }];
//    
//    [UIAlertView showAlertViewForTaskWithErrorOnCompletion:tesk delegate:nil];
//}
#pragma mark - 페어링 전문
- (void)requestWithPairingAuth
{

    NSURLSessionDataTask *tesk = [NSMutableDictionary pairingAddUserWithAuthCode:self.pAuthTextField.text completion:^(NSArray *pairing, NSError *error) {
        
        NSLog(@"응답 결과 = [%@]", pairing);
        NSString *sResultCode = [NSString stringWithFormat:@"%@", [[pairing objectAtIndex:0] objectForKey:@"resultCode"]];
        
        if ( [sResultCode isEqualToString:@"100"] )
        {
            // 성공이면 터미널 키 획득 전문 날림
            [self requestWithPrivateTerminalKeyGet];
        }
        
    }];
    
    [UIAlertView showAlertViewForTaskWithErrorOnCompletion:tesk delegate:nil];
}

#pragma mark - Private 터미널 키 획득 전문
- (void)requestWithPrivateTerminalKeyGet
{
    NSURLSessionDataTask *tesk = [NSMutableDictionary pairingAuthenticateDeviceCompletion:^(NSArray *pairing, NSError *error) {
        
        NSLog(@"등답 결과 = [%@]", pairing);
        
        NSString *sResultCode = [NSString stringWithFormat:@"%@", [[pairing objectAtIndex:0] objectForKey:@"resultCode"]];
        
        if ( [sResultCode isEqualToString:@"100"] )
        {
            // 성공이면
            // uuid 및 구매 번호 keychain 에 저장
            // 받아온 terminalKey 값이 private terminalKey가 됨 현재 private terminal key 받는 api 안됨
            PairingFinishViewController *pViewController = [[PairingFinishViewController alloc] initWithNibName:@"PairingFinishViewController" bundle:nil];
                        [self.navigationController pushViewController:pViewController animated:YES];
        }
        
    }];
    
    [UIAlertView showAlertViewForTaskWithErrorOnCompletion:tesk delegate:nil];
}

@end
