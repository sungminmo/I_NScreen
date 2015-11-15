//
//  VodPopUpViewController.h
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 11. 12..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMTextField.h"
#import "CMBaseViewController.h"

@protocol VodPopUpViewDelegate;

@interface VodPopUpViewController : CMBaseViewController

@property (nonatomic, weak) IBOutlet UILabel *pPriceLbl;
@property (nonatomic, strong) NSString *pBuyStr;
@property (nonatomic, strong) NSMutableDictionary *pBuyDic;

@property (nonatomic, weak) IBOutlet UIButton *pCancelBtn;
@property (nonatomic, weak) IBOutlet UIButton *pOkBtn;
@property (nonatomic, weak) IBOutlet UIButton *pBgBtn;

@property (nonatomic, weak) IBOutlet CMTextField *pTextField;

@property (nonatomic, weak) id <VodPopUpViewDelegate>delegate;

- (IBAction)onBtnClicked:(UIButton *)btn;

@end

@protocol VodPopUpViewDelegate <NSObject>

@optional
- (void)VodPopUpViewWithTag:(int)nTag;

@end