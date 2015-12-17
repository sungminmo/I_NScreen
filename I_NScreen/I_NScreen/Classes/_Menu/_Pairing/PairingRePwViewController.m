//
//  PairingRePwViewController.m
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 10. 27..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import "PairingRePwViewController.h"
#import "NSMutableDictionary+Pairing.h"
#import "UIAlertView+AFNetworking.h"
#import "CMDBDataManager.h"

@interface PairingRePwViewController ()

@end

@implementation PairingRePwViewController
@synthesize delegate;

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"비밀번호 등록";
    self.isUseNavigationBar = YES;
    
    [self setTagInit];
    [self setViewInit];
    [self requestWithRemoveUser];
}

#pragma mark - 초기화
#pragma mark - 테그 초기화
- (void)setTagInit
{
    self.pBackBtn.tag = PAIRING_RE_PW_VIEW_BTN_01;
    self.pCancelBtn.tag = PAIRING_RE_PW_VIEW_BTN_02;
    self.pOkBtn.tag = PAIRING_RE_PW_VIEW_BTN_03;
}

#pragma mark - 화면 초기화
- (void)setViewInit
{
    self.pPwTextField.type = Secure_CMTextFieldType;
    self.pPwTextField.returnKeyType = UIReturnKeyNext;
    
    self.pRePwTextFiled.type = Secure_CMTextFieldType;
}

- (void)actionBackButton:(id)sender
{
    [self.delegate PairingRePwViewWithTag:PAIRING_FINISH_VIEW_BTN_01];
    [self.navigationController popViewControllerAnimated:YES];

}

#pragma mark - 액션이벤트
#pragma mark - 버튼 액션 이벤트
- (IBAction)onBtnClicked:(UIButton *)btn
{
    
    switch ([btn tag]) {
        case PAIRING_RE_PW_VIEW_BTN_01:
        case PAIRING_RE_PW_VIEW_BTN_02:
        {
            // 등록 취소
            [self.delegate PairingRePwViewWithTag:PAIRING_FINISH_VIEW_BTN_01];
            [self.navigationController popViewControllerAnimated:YES];
        }break;
        case PAIRING_RE_PW_VIEW_BTN_03:
        {
            // 다음 단계
            if ( [self.pPwTextField.text length] < 4 )
            {
                [SIAlertView alert:@"셋탑박스 등록" message:@"구매 비밀번호는 최소 4자리 이상 숫자+영문으로\n최대 20자리 까지 입력 가능 합니다." button:@"확인"];
                
            }
            else
            {
                if ( ![self.pPwTextField.text isEqualToString:self.pRePwTextFiled.text] )
                {
                    self.pDiscordLbl.hidden = NO;
                    [self.pRePwTextFiled setTextColor:[UIColor colorWithRed:255.0f/255.0f green:59.0f/255.0f blue:48.0f/255.0f alpha:1.0f]];
                    [self.pRePwTextFiled setBackground:[UIImage imageNamed:@"pwbox_error.png"]];
                }
                else
                {
                    self.pDiscordLbl.hidden = YES;
                    [self.pRePwTextFiled setTextColor:[UIColor colorWithRed:123.0f/255.0f green:90.0f/255.0f blue:163.0f/255.0f alpha:1.0f]];
                    [self.pRePwTextFiled setBackground:[UIImage imageNamed:@"pwbox.png"]];
                    NSString *sPw = [NSString stringWithFormat:@"%@", self.pPwTextField.text];
                    //                    [[FXKeychain defaultKeychain] setObject:sPw forKey:CNM_OPEN_API_BUY_PW];  // 이때 저장하면 안됨
                    // 다음 단계
                    PairingAuthViewController *pViewController = [[PairingAuthViewController alloc] initWithNibName:@"PairingAuthViewController" bundle:nil];
                    pViewController.delegate = self;
                    pViewController.pPwStr = sPw;
                    [self.navigationController pushViewController:pViewController animated:YES];
                }
                
            }

        }break;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField.text.length >= 4)  // 20 자리 까지 입력 가능
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
    else
    {
        if ( [string rangeOfString:@"-"].location != NSNotFound ||
            [string rangeOfString:@"/"].location != NSNotFound ||
            [string rangeOfString:@":"].location != NSNotFound ||
            [string rangeOfString:@";"].location != NSNotFound ||
            [string rangeOfString:@"("].location != NSNotFound ||
            [string rangeOfString:@")"].location != NSNotFound ||
            [string rangeOfString:@"₩"].location != NSNotFound ||
            [string rangeOfString:@"&"].location != NSNotFound ||
            [string rangeOfString:@"@"].location != NSNotFound ||
            [string rangeOfString:@"\""].location != NSNotFound ||
            [string rangeOfString:@"."].location != NSNotFound ||
            [string rangeOfString:@","].location != NSNotFound ||
            [string rangeOfString:@"?"].location != NSNotFound ||
            [string rangeOfString:@"!"].location != NSNotFound ||
            [string rangeOfString:@"'"].location != NSNotFound ||
            [string rangeOfString:@"["].location != NSNotFound ||
            [string rangeOfString:@"]"].location != NSNotFound ||
            [string rangeOfString:@"{"].location != NSNotFound ||
            [string rangeOfString:@"}"].location != NSNotFound ||
            [string rangeOfString:@"#"].location != NSNotFound ||
            [string rangeOfString:@"%"].location != NSNotFound ||
            [string rangeOfString:@"^"].location != NSNotFound ||
            [string rangeOfString:@"*"].location != NSNotFound ||
            [string rangeOfString:@"+"].location != NSNotFound ||
            [string rangeOfString:@"="].location != NSNotFound ||
            [string rangeOfString:@"-"].location != NSNotFound ||
            [string rangeOfString:@"_"].location != NSNotFound ||
            [string rangeOfString:@"\\"].location != NSNotFound ||
            [string rangeOfString:@"|"].location != NSNotFound ||
            [string rangeOfString:@"~"].location != NSNotFound ||
            [string rangeOfString:@"<"].location != NSNotFound ||
            [string rangeOfString:@">"].location != NSNotFound ||
            [string rangeOfString:@"$"].location != NSNotFound )
        {
            NSLog(@"입력 되었으면");
            
            return NO;
        }
        
    }

    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    NSString* pPwText = self.pPwTextField.text;
    NSString* pRePwText = self.pRePwTextFiled.text;
    
    if (![pPwText isEqualToString:pRePwText]) {
        textField.text = @"";
    }
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    NSString* pPwText = self.pPwTextField.text;
    NSString* pRePwText = self.pRePwTextFiled.text;
    
    if ( (pPwText != nil && pPwText.length > 0) && (pRePwText != nil && pRePwText.length > 0) )
    {
        if ([pPwText isEqualToString:pRePwText])
        {
            self.pOkBtn.enabled = YES;
            return YES;
        }
        else
        {
            self.pOkBtn.enabled = NO;
            
            self.pRePwTextFiled.text = @"";
            
            if (textField == self.pPwTextField)
            {
                [self.pRePwTextFiled performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0.2];
                return YES;
            }
            else
            {
                return NO;
            }
        }
    }
    
    self.pOkBtn.enabled = NO;
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.pPwTextField) {
        
        [self.pRePwTextFiled becomeFirstResponder];
    }
    
    return true;
}

#pragma mark - 전문
#pragma mark - 셋탑쪽 페어링 정보 삭제
- (void)requestWithRemoveUser
{
    NSURLSessionDataTask *tesk = [NSMutableDictionary pairingRemoveUserCompletion:^(NSArray *pairing, NSError *error) {
        
        DDLogError(@"pairing = [%@]", pairing);
        
        // 페어링 삭제후 데이터 삭제
        // 구매 비밀번호 삭제
        [[CMAppManager sharedInstance] removeKeychainBuyPw];
        
        // 프라이빗 터미널 키
        [[CMAppManager sharedInstance] removeKeychainPrivateTerminalKey];
        
        // 성인 인증 여부 체크 삭제
        [[CMAppManager sharedInstance] removeKeychainAdultCertification];
        
        // 성인 검색 제한 설정 삭제
        [[CMAppManager sharedInstance] removeKeychainAdultLimit];
        
        // 지역 설정 삭제
        [[CMAppManager sharedInstance] removeKeychainAreaCodeValue];
        
        //시청목록 삭제
        [[CMDBDataManager sharedInstance] removeAllVodWatchList];
        
        CMDBDataManager *manager = [CMDBDataManager sharedInstance];
        [manager setPariringCheck:NO];
    }];
    
    [SIAlertView showAlertViewForTaskWithErrorOnCompletion:tesk delegate:nil];
}

#pragma mark - 델리게이트
#pragma mark - PairingAuthViewController 델리게이트
- (void)PairingAuthViewWithTag:(int)nTag
{
    switch (nTag) {
        case PAIRING_FINISH_VIEW_BTN_01:
        {
            [self.delegate PairingRePwViewWithTag:PAIRING_FINISH_VIEW_BTN_01];
        }break;
    }
}

@end
