//
//  TestPageViewController.h
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 10. 29..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "WViPhoneAPI.h"

@interface TestPageViewController : UIViewController

@property (nonatomic, strong) IBOutlet UIButton *pBackBtn;
@property (nonatomic, strong) IBOutlet UIButton *pInitBtn;
@property (nonatomic, strong) IBOutlet UIButton *pPlayBtn;

- (IBAction)onBtnClicked:(UIButton *)btn;

@end
