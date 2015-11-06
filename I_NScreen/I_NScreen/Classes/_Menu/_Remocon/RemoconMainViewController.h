//
//  RemoconMainViewController.h
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 10. 19..
//  Copyright © 2015년 STVN. All rights reserved.
//
/*/================================================================================================
 리모컨 - MAIN
 ================================================================================================/*/

#import <UIKit/UIKit.h>
#import "CMBaseViewController.h"
#import "RemoconMainTableViewCell.h"
#import "EpgPopUpViewController.h"

@interface RemoconMainViewController : CMBaseViewController<EpgPopUpViewDelegate>

- (IBAction)onBtnClick:(UIButton *)btn;

@end
