//
//  PairingRePwViewController.h
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 10. 27..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMTextField.h"
#import "CMBaseViewController.h"

@interface PairingRePwViewController : CMBaseViewController<UITextFieldDelegate>

@property (nonatomic, strong) IBOutlet CMTextField *pPwTextField;
@property (nonatomic, strong) IBOutlet CMTextField *pRePwTextFiled;

@property (nonatomic, strong) IBOutlet UIButton *pBackBtn;
@property (nonatomic, strong) IBOutlet UIButton *pCancelBtn;
@property (nonatomic, strong) IBOutlet UIButton *pOkBtn;

- (IBAction)onBtnClicked:(UIButton *)btn;

@end
