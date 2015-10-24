//
//  CMPurchaseCertPasswordViewController.m
//  I_NScreen
//
//  Created by 조백근 on 2015. 9. 29..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import "CMPurchaseCertPasswordViewController.h"
#import "CMTextField.h"
#import "CMTextFieldView.h"
#import "CMDBDataManager.h"

typedef enum : NSInteger {
    TAG_CANCEL = 10000000,
    TAG_COMPLETE
} ButtonsInPurchaseCertPassword;

@interface CMPurchaseCertPasswordViewController ()

@property (nonatomic, strong) IBOutlet CMTextField* textField1;
@property (nonatomic, strong) IBOutlet CMTextField* textField2;
@property (nonatomic, strong) IBOutlet UILabel* infoLabel;

@property (nonatomic, strong) IBOutlet UIButton* cancelButton;
@property (nonatomic, strong) IBOutlet UIButton* completButton;

@end

@implementation CMPurchaseCertPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"구매인증 비밀번호 관리";
    self.isUseNavigationBar = YES;
    
    self.cancelButton.tag = TAG_CANCEL;
    self.completButton.tag = TAG_COMPLETE;
 
    self.textField1.type = Secure_CMTextFieldType;
    self.textField2.type = Secure_CMTextFieldType;
    
    CMDBDataManager* manager= [CMDBDataManager sharedInstance];
    NSString* savedPurchaseNumber = [manager purchaseAuthorizedNumber];
    if (savedPurchaseNumber.length > 0) {
        [SIAlertView alert:@"구매인증 비밀번호 입력" message:@"구매인증 비밀번호를 입력해주세요.##FIELD##인증번호가 기억나지 않으실 경우,\n셋탑박스를 다시 등록 해주세요." containBoldText:@"" textHoloder:@"" textValue:@"" textPosition:SIAlertViewTextFieldPositionMiddle textLength:0 cancel:@"취소" buttons:@[@"확인"] completion:^(NSInteger buttonIndex, SIAlertView *alert) {
            if (buttonIndex == 0) {
                [self backCommonAction];
            }
            else {
                NSString* input = alert.fieldView.inputField.text;
                if ([input isEqualToString:savedPurchaseNumber] == NO) {
                    [self backCommonAction];
                }
            }
        }];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private

- (BOOL)validateValue {
    
    self.infoLabel.text = @"";
    self.infoLabel.hidden = YES;
    [self.textField2 resetColor];

    BOOL validation = true;
    if ([[self.textField1.text trim] isEqualToString:[self.textField2.text trim]] == false) {
        validation = false;
        
        self.infoLabel.text = @"인증번호가 일치하지 않습니다.";
        self.infoLabel.hidden = NO;
        
        [self.textField2 changeColor:[UIColor redColor]];
    }
    
    return validation;
}

#pragma mark - Event

- (IBAction)buttonWasTouchUpInside:(id)sender {
    NSInteger tag = ((UIButton*)sender).tag;
    
    switch (tag) {
        case TAG_CANCEL: {
            [self backCommonAction];
        }
            break;
        case TAG_COMPLETE: {
            
            if ([self validateValue]) {
                NSString* value = [self.textField1.text trim];
                CMDBDataManager* manager= [CMDBDataManager sharedInstance];
                [manager savePurchaseAuthorizedNumber:value];
                [self backCommonAction];                
            }
        }
            break;
        default:
            break;
    }
}

@end
