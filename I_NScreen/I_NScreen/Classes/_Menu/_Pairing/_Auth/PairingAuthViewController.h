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
#import "PairingFinishViewController.h"

@protocol PairingAuthViewDelegate;

@interface PairingAuthViewController : CMBaseViewController<UITextFieldDelegate, PairingFinishViewDelegate>

@property (nonatomic, strong) IBOutlet CMTextField *pAuthTextField;

@property (nonatomic, strong) IBOutlet UIButton *pBackBtn;
@property (nonatomic, strong) IBOutlet UIButton *pCancelBtn;
@property (nonatomic, strong) IBOutlet UIButton *pOkBtn;

@property (nonatomic, strong) NSString *pPwStr;

@property (nonatomic, weak) id <PairingAuthViewDelegate>delegate;

- (IBAction)onBtnClicked:(UIButton *)btn;

@end

@protocol PairingAuthViewDelegate <NSObject>

@optional
- (void)PairingAuthViewWithTag:(int)nTag;

@end