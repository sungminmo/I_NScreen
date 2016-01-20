//
//  PairingMainViewController.h
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 10. 23..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PairingAuthViewController.h"
#import "CMTextField.h"
#import "CMBaseViewController.h"

@protocol PairingMainViewDelegate;

@interface PairingMainViewController : CMBaseViewController<UITextFieldDelegate, PairingAuthViewDelegate>

@property (nonatomic, strong) IBOutlet CMTextField *pPwTextField;
@property (nonatomic, strong) IBOutlet CMTextField *pRePwTextFiled;

@property (nonatomic, strong) IBOutlet UIButton *pBackBtn;
@property (nonatomic, strong) IBOutlet UIButton *pCancelBtn;
@property (nonatomic, strong) IBOutlet UIButton *pOkBtn;

@property (nonatomic, strong) IBOutlet UILabel *pDiscordLbl;    // 불일치 라벨

@property (nonatomic, weak) IBOutlet UIScrollView* scrollView;
@property (nonatomic, weak) IBOutlet UIView* contentView1;
@property (nonatomic, weak) IBOutlet UIView* contentView2;
@property (nonatomic, weak) IBOutlet UIView* contentView3;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint* contentView3H;

@property (nonatomic, weak) id <PairingMainViewDelegate>delegate;

- (IBAction)onBtnClicked:(UIButton *)btn;

@end

@protocol PairingMainViewDelegate <NSObject>

@optional
- (void)PairingMainViewWithTag:(int)nTag;

@end