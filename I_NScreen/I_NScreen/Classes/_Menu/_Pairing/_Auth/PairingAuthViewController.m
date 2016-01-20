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
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *guideLabels;
@property (nonatomic, weak) IBOutlet UIScrollView* scrollView;
@property (nonatomic, weak) IBOutlet UIView* innerBottomView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint* innerBottomViewH;
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
    
    self.title = @"셋탑박스 등록";
    self.isUseNavigationBar = YES;
    
    if ([UIScreen mainScreen].bounds.size.width == 320) {
        for (id obj in self.guideLabels) {
            UILabel* lb = (UILabel*)obj;
            lb.font = [UIFont systemFontOfSize:12];
        }
    }
    
    [self setTagInit];
    [self setViewInit];
}

- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    
    CGRect frame = self.innerBottomView.frame;
    CGFloat maxY = CGRectGetMaxY(frame);
    if (self.scrollView.frame.size.height + self.scrollView.contentOffset.y > maxY)
    {
        self.innerBottomViewH.constant = self.scrollView.frame.size.height - frame.origin.y + self.scrollView.contentOffset.y;
    }
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
            
            CMDBDataManager *manager = [CMDBDataManager sharedInstance];
            [manager setSetTopBoxKind:sSetTopBoxKind];
            // 성공이면 터미널 키 획득 전문 날림
            [self requestWithPrivateTerminalKeyGet];
        }
        else if ( [sResultCode isEqualToString:@"205"] )
        {
            // 서버코드론 해당 아이템 없음이지만 럼퍼스 측에서 인증번호를 잘못 입력한 케이스로 판단하면 된다 함
            NSString *sMessage = @"인증번호가 일치하지 않습니다.";
            [SIAlertView alert:@"error" message:sMessage button:@"확인" completion:^(NSInteger buttonIndex, SIAlertView *alert) {
               self.pAuthTextField.text = @"";
            }];
        }
        else
        {
            NSString *sMessage = [NSString stringWithFormat:@"%@", [[pairing objectAtIndex:0] objectForKey:@"errorString"]];
            [SIAlertView alert:@"error" message:sMessage button:@"확인" completion:^(NSInteger buttonIndex, SIAlertView *alert) {
                self.pAuthTextField.text = @"";
            }];
        }
        
    }];
    
    [SIAlertView showAlertViewForTaskWithErrorOnCompletion:tesk delegate:nil];
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
    
    [SIAlertView showAlertViewForTaskWithErrorOnCompletion:tesk delegate:nil];
}

#pragma mark - 페어링 성공후 데이터 저장
- (void)setDataResponseWithTerminalKey:(NSString *)terminal
{
    CMDBDataManager *manager = [CMDBDataManager sharedInstance];
    [manager setPariringCheck:YES];
    
    [[CMAppManager sharedInstance] setKeychainPrivateTerminalkey:terminal];
    [[CMAppManager sharedInstance] setKeychainBuyPw:self.pPwStr];
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
