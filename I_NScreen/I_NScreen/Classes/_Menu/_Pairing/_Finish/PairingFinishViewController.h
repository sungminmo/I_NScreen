//
//  PairingFinishViewController.h
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 10. 24..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMBaseViewController.h"

@protocol PairingFinishViewDelegate;

@interface PairingFinishViewController : CMBaseViewController

@property (nonatomic, strong) IBOutlet UIButton *pOkBtn;

@property (nonatomic, weak) id <PairingFinishViewDelegate>delegate;

- (IBAction)onBtnClicked:(UIButton *)btn;

@end

@protocol PairingFinishViewDelegate <NSObject>

@optional
- (void)PairingFinishViewWithTag:(int)nTag;

@end