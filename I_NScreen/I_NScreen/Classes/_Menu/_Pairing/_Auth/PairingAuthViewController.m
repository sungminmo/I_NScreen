//
//  PairingAuthViewController.m
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 10. 24..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import "PairingAuthViewController.h"
#import "NSMutableDictionary+Pairing.h"
#import "UIAlertView+AFNetworking.h"
#import "CMDBDataManager.h"

@interface PairingAuthViewController ()

@end

@implementation PairingAuthViewController
@synthesize pPwStr;
@synthesize delegate;

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

#pragma mark - 페어링 전문
- (void)requestWithPairingAuth
{

    NSURLSessionDataTask *tesk = [NSMutableDictionary pairingClientSetTopBoxRegistWithAuthKey:self.pAuthTextField.text completion:^(NSArray *pairing, NSError *error) {
        
        DDLogError(@"응답 결과 = [%@]", pairing);
        NSString *sResultCode = [NSString stringWithFormat:@"%@", [[pairing objectAtIndex:0] objectForKey:@"resultCode"]];
        
        if ( [sResultCode isEqualToString:@"100"] )
        {
            NSString *sSetTopBoxKind = [NSString stringWithFormat:@"%@", [[pairing objectAtIndex:0] objectForKey:@"SetTopBoxKind"]];
//            [[CMAppManager sharedInstance] setInfoDataKey:CNM_OPEN_API_SET_TOP_BOK_KIND Value:sSetTopBoxKind];
            CMDBDataManager *manager = [CMDBDataManager sharedInstance];
            [manager setSetTopBoxKind:sSetTopBoxKind];
            [self setDataAuthResponse];
            // 성공이면 터미널 키 획득 전문 날림
            [self requestWithPrivateTerminalKeyGet];
        }
        else
        {
            NSString *sMessage = [NSString stringWithFormat:@"%@", [[pairing objectAtIndex:0] objectForKey:@"errorString"]];
//            [[CMAppManager sharedInstance] removeInfoDataKey:CNM_OPEN_API_UUID_KEY];
            [SIAlertView alert:@"error" message:sMessage button:nil];
        }
        
    }];
    
    [UIAlertView showAlertViewForTaskWithErrorOnCompletion:tesk delegate:nil];
}

#pragma mark - Private 터미널 키 획득 전문
- (void)requestWithPrivateTerminalKeyGet
{
    NSURLSessionDataTask *tesk = [NSMutableDictionary pairingAuthenticateDeviceCompletion:^(NSArray *pairing, NSError *error) {
        
        DDLogError(@"등답 결과 = [%@]", pairing);
        
        NSString *sResultCode = [NSString stringWithFormat:@"%@", [[pairing objectAtIndex:0] objectForKey:@"resultCode"]];
        
        if ( [sResultCode isEqualToString:@"100"] )
        {
            // 성공이면
            // uuid 및 구매 번호 keychain 에 저장
            NSString *sTerminal = [NSString stringWithFormat:@"%@", [[pairing objectAtIndex:0] objectForKey:@"terminalKey"]];
            [self setDataResponseWithTerminalKey:sTerminal];
            
            // 받아온 terminalKey 값이 private terminalKey가 됨
            PairingFinishViewController *pViewController = [[PairingFinishViewController alloc] initWithNibName:@"PairingFinishViewController" bundle:nil];
            pViewController.delegate = self;
                        [self.navigationController pushViewController:pViewController animated:YES];
        }
        else
        {
            NSString *sMessage = [NSString stringWithFormat:@"%@", [[pairing objectAtIndex:0] objectForKey:@"errorString"]];
            [SIAlertView alert:@"error" message:sMessage button:nil];
        }
    }];
    
    [UIAlertView showAlertViewForTaskWithErrorOnCompletion:tesk delegate:nil];
}

#pragma mark - 페어링 성공후 데이터 저장
- (void)setDataAuthResponse
{
    // 일단 모든 데이터 userdefault 에 저장 나중에 수정
//    NSString *sUuid = [NSString stringWithFormat:@"%@", [[CMAppManager sharedInstance] getUniqueUuid]];
//    [[CMAppManager sharedInstance] setInfoDataKey:CNM_OPEN_API_UUID_KEY Value:sUuid];   // uuid   이미 저장 되어 있음
//    [[CMAppManager sharedInstance] setInfoDataKey:CNM_OPEN_API_BUY_PW Value:self.pPwStr];   // 구매 비밀번호
    CMDBDataManager *manager = [CMDBDataManager sharedInstance];
    [manager savePurchaseAuthorizedNumber:self.pPwStr];
    
}

- (void)setDataResponseWithTerminalKey:(NSString *)terminal
{
    //
//    [[CMAppManager sharedInstance] setInfoDataKey:CNM_OPEN_API_PRIVATE_TERMINAL_KEY_KEY Value:terminal];
    CMDBDataManager *manager = [CMDBDataManager sharedInstance];
    [manager savePrivateTerminalKey:terminal];
    
    [manager setPariringCheck:YES];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField.text.length > 5)  // 6 자리 까지 입력 가능
    {
        if([string length] == 0)
        {
            // 뒤로가기 버튼 상태일때는 지우기가 가능해야함
        }
        else
        {
            
            return NO;
        }
    }
    
    return YES;
}

#pragma mark - 델리게이트
#pragma mark - PairingFinshViewController 델리게이트
- (void)PairingFinishViewWithTag:(int)nTag
{
    switch (nTag) {
        case PAIRING_FINISH_VIEW_BTN_01:
        {
            [self.delegate PairingAuthViewWithTag:PAIRING_FINISH_VIEW_BTN_01];
        }break;
    }
}

@end
