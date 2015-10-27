//
//  PairingFinishViewController.h
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 10. 24..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMBaseViewController.h"

@interface PairingFinishViewController : CMBaseViewController

@property (nonatomic, strong) IBOutlet UIButton *pOkBtn;

- (IBAction)onBtnClicked:(UIButton *)btn;


@end
