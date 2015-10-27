//
//  PairingAuthViewController.h
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 10. 24..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMTextField.h"
#import "CMBaseViewController.h"

@interface PairingAuthViewController : CMBaseViewController<UITextFieldDelegate>

@property (nonatomic, strong) IBOutlet CMTextField *pAuthTextField;

@property (nonatomic, strong) IBOutlet UIButton *pBackBtn;
@property (nonatomic, strong) IBOutlet UIButton *pCancelBtn;
@property (nonatomic, strong) IBOutlet UIButton *pOkBtn;

- (IBAction)onBtnClicked:(UIButton *)btn;

@end
