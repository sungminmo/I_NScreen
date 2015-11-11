//
//  VodBuyViewController.h
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 11. 11..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMBaseViewController.h"

@interface VodBuyViewController : CMBaseViewController

@property (nonatomic, strong) IBOutlet UIView *pStep1View;
@property (nonatomic, strong) IBOutlet UIView *pStep1SubView01;

@property (nonatomic, strong) IBOutlet UIView *pStep1SubView02;
@property (nonatomic, strong) IBOutlet UILabel *pStep1SubView02TitleLbl;
@property (nonatomic, strong) IBOutlet UILabel *pStep1SubView02MoneyLbl;
@property (nonatomic, strong) IBOutlet UIButton *pStep1SubView02Btn;

@property (nonatomic, strong) IBOutlet UIView *pStep1SubView03;
@property (nonatomic, strong) IBOutlet UILabel *pStep1SubView03TitleLbl;
@property (nonatomic, strong) IBOutlet UILabel *pStep1SubView03MoneyLbl;
@property (nonatomic, strong) IBOutlet UIButton *pStep1SubView03Btn;

@property (nonatomic, strong) IBOutlet UIView *pStep1SubView04;
@property (nonatomic, strong) IBOutlet UILabel *pStep1SubView04TitleLbl;
@property (nonatomic, strong) IBOutlet UILabel *pStep1SubView04MoneyLbl;
@property (nonatomic, strong) IBOutlet UIButton *pStep1SubView04Btn;

@property (nonatomic, strong) IBOutlet UIView *pStep2View;
@property (nonatomic, strong) IBOutlet UIView *pStep2SubView01;

@property (nonatomic, strong) IBOutlet UIView *pStep2SubView02;
@property (nonatomic, strong) IBOutlet UILabel *pStep2SubView02TitleLbl;
@property (nonatomic, strong) IBOutlet UILabel *pStep2SubView02MoneyLbl;
@property (nonatomic, strong) IBOutlet UILabel *pStep2SubView02ContentLbl;
@property (nonatomic, strong) IBOutlet UIButton *pStep2SubView02Btn;

@property (nonatomic, strong) IBOutlet UIView *pStep2SubView03;
@property (nonatomic, strong) IBOutlet UILabel *pStep2SubView03TitleLbl;
@property (nonatomic, strong) IBOutlet UILabel *pStep2SubView03MoneyLbl;
@property (nonatomic, strong) IBOutlet UILabel *pStep2SubView03ContentLbl01;
@property (nonatomic, strong) IBOutlet UILabel *pStep2SubView03ContentLbl02;
@property (nonatomic, strong) IBOutlet UIButton *pStep2SubView03Btn;

@property (nonatomic, strong) IBOutlet UIView *pStep2SubView04;
@property (nonatomic, strong) IBOutlet UILabel *pStep2SubView04TitleLbl;
@property (nonatomic, strong) IBOutlet UILabel *pStep2SubView04MoneyLbl;
@property (nonatomic, strong) IBOutlet UILabel *pStep2SubView04ContentLbl01;
@property (nonatomic, strong) IBOutlet UILabel *pStep2SubView04ContentLbl02;
@property (nonatomic, strong) IBOutlet UIButton *pStep2SubView04Btn;

@property (nonatomic, strong) IBOutlet UIView *pBtnView;
@property (nonatomic, strong) IBOutlet UIButton *pCancelBtn;
@property (nonatomic, strong) IBOutlet UIButton *pOkBtn;

@property (nonatomic, strong) IBOutlet UILabel *pNoBuyLbl01;
@property (nonatomic, strong) IBOutlet UILabel *pNoBuyLbl02;
@property (nonatomic, strong) IBOutlet UILabel *pNoBuyLbl03;
@property (nonatomic, strong) IBOutlet UILabel *pNoBuyLbl04;
@property (nonatomic, strong) IBOutlet UILabel *pNoBuyLbl05;

- (IBAction)onBtnClicked:(UIButton *)btn;

@end
