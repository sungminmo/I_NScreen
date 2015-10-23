//
//  PairingMainViewController.h
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 10. 23..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMBaseViewController.h"

@interface PairingMainViewController : CMBaseViewController

@property (nonatomic, strong) IBOutlet UITextField *pPwTextField;
@property (nonatomic, strong) IBOutlet UITextField *pRePwTextFiled;

@property (nonatomic, strong) IBOutlet UIButton *pCancelBtn;
@property (nonatomic, strong) IBOutlet UIButton *pOkBtn;

- (IBAction)onBtnClicked:(UIButton *)btn;

@end
