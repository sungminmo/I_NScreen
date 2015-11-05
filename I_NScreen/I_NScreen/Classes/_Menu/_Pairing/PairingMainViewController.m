//
//  PairingMainViewController.m
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 10. 23..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import "PairingMainViewController.h"
#import "PairingAuthViewController.h"
#import "FXKeychain.h"

@interface PairingMainViewController ()
@end

@implementation PairingMainViewController

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
    self.pBackBtn.tag = PAIRING_MAIN_VIEW_BTN_01;
    self.pCancelBtn.tag = PAIRING_MAIN_VIEW_BTN_02;
    self.pOkBtn.tag = PAIRING_MAIN_VIEW_BTN_03;
}

#pragma mark - 화면 초기화
- (void)setViewInit
{
    self.pPwTextField.type = Secure_CMTextFieldType;
    self.pRePwTextFiled.type = Secure_CMTextFieldType;
}

#pragma mark - 액션이벤트
#pragma mark - 버튼 액션 이벤트
- (IBAction)onBtnClicked:(UIButton *)btn
{

    switch ([btn tag]) {
        case PAIRING_MAIN_VIEW_BTN_01:
        case PAIRING_MAIN_VIEW_BTN_02:
        {
            // 등록 취소
            [self.navigationController popViewControllerAnimated:YES];
        }break;
        case PAIRING_MAIN_VIEW_BTN_03:
        {
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
                    pViewController.pPwStr = sPw;
                    [self.navigationController pushViewController:pViewController animated:YES];
                }

            }
            
            
        }break;
    }
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField.text.length > 19)  // 20 자리 까지 입력 가능
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

@end
