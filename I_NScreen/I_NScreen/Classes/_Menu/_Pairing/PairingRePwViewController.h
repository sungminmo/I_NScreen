//
//  PairingRePwViewController.h
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 10. 27..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PairingAuthViewController.h"
#import "CMTextField.h"
#import "CMBaseViewController.h"

@protocol PairingRePwViewDelegate;

@interface PairingRePwViewController : CMBaseViewController<UITextFieldDelegate, PairingAuthViewDelegate>

@property (nonatomic, strong) IBOutlet CMTextField *pPwTextField;
@property (nonatomic, strong) IBOutlet CMTextField *pRePwTextFiled;

@property (nonatomic, strong) IBOutlet UIButton *pBackBtn;
@property (nonatomic, strong) IBOutlet UIButton *pCancelBtn;
@property (nonatomic, strong) IBOutlet UIButton *pOkBtn;

@property (nonatomic, strong) IBOutlet UILabel *pDiscordLbl;    // 불일치 라벨

@property (nonatomic, weak) id <PairingRePwViewDelegate>delegate;

- (IBAction)onBtnClicked:(UIButton *)btn;

@end

@protocol PairingRePwViewDelegate <NSObject>

@optional
- (void)PairingRePwViewWithTag:(int)nTag;

@end