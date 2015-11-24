//
//  VodBuyViewController.h
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 11. 11..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMBaseViewController.h"
#import "VodPopUpViewController.h"
#import "VodPopUpViewController.h"

// 구매 타입
typedef enum : NSInteger {
    BuySingleChapter = 1000000,  // 단일 회차 구매
    BuySingleProduct,           // 단일상품 구매
    BuySeriesFullChapter,       // 시리즈 전체회차 구매
    BuyBundleSale,              // 묶음 할인상품 구매
    BuyMonthRate,               // 월정액
    BuyTotalRate                // 통합 월정액
}BuyType;

@protocol VodBuyViewDelegate;

@interface VodBuyViewController : CMBaseViewController<VodPopUpViewDelegate>

/**
 *  전체 스크롤 뷰 
 */
@property (weak, nonatomic) IBOutlet UIScrollView *scrollContainer;

@property (nonatomic, weak) IBOutlet UIView *pStep1View;
@property (nonatomic, weak) IBOutlet UIView *pStep1SubView01;

@property (nonatomic, weak) IBOutlet UIView *pStep1SubView02;
@property (nonatomic, weak) IBOutlet UILabel *pStep1SubView02TitleLbl;
@property (nonatomic, weak) IBOutlet UILabel *pStep1SubView02MoneyLbl;
@property (nonatomic, weak) IBOutlet UIButton *pStep1SubView02Btn;

@property (nonatomic, weak) IBOutlet UIView *pStep1SubView03;
@property (nonatomic, weak) IBOutlet UILabel *pStep1SubView03TitleLbl;
@property (nonatomic, weak) IBOutlet UILabel *pStep1SubView03MoneyLbl;
@property (nonatomic, weak) IBOutlet UIButton *pStep1SubView03Btn;

@property (nonatomic, weak) IBOutlet UIView *pStep1SubView04;
@property (nonatomic, weak) IBOutlet UILabel *pStep1SubView04TitleLbl;
@property (nonatomic, weak) IBOutlet UILabel *pStep1SubView04MoneyLbl;
@property (nonatomic, weak) IBOutlet UIButton *pStep1SubView04Btn;

@property (nonatomic, weak) IBOutlet UIView *pStep2View;
@property (nonatomic, weak) IBOutlet UIView *pStep2SubView01;

@property (nonatomic, weak) IBOutlet UIView *pStep2SubView02;
@property (nonatomic, weak) IBOutlet UILabel *pStep2SubView02TitleLbl;
@property (nonatomic, weak) IBOutlet UILabel *pStep2SubView02MoneyLbl;
@property (nonatomic, weak) IBOutlet UILabel *pStep2SubView02ContentLbl;
@property (nonatomic, weak) IBOutlet UIButton *pStep2SubView02Btn;
@property (nonatomic, weak) IBOutlet UIImageView *pStep2SubView02SaleImageView;

@property (nonatomic, weak) IBOutlet UIView *pStep2SubView03;
@property (nonatomic, weak) IBOutlet UILabel *pStep2SubView03TitleLbl;
@property (nonatomic, weak) IBOutlet UILabel *pStep2SubView03MoneyLbl;
@property (nonatomic, weak) IBOutlet UILabel *pStep2SubView03ContentLbl01;
@property (nonatomic, weak) IBOutlet UILabel *pStep2SubView03ContentLbl02;
@property (nonatomic, weak) IBOutlet UIButton *pStep2SubView03Btn;

@property (nonatomic, weak) IBOutlet UIView *pStep2SubView04;
@property (nonatomic, weak) IBOutlet UILabel *pStep2SubView04TitleLbl;
@property (nonatomic, weak) IBOutlet UILabel *pStep2SubView04MoneyLbl;
@property (nonatomic, weak) IBOutlet UILabel *pStep2SubView04ContentLbl01;
@property (nonatomic, weak) IBOutlet UILabel *pStep2SubView04ContentLbl02;
@property (nonatomic, weak) IBOutlet UIButton *pStep2SubView04Btn;

@property (nonatomic, weak) IBOutlet UIView *pBtnView;
@property (nonatomic, weak) IBOutlet UIButton *pCancelBtn;
@property (nonatomic, weak) IBOutlet UIButton *pOkBtn;

@property (nonatomic, weak) IBOutlet UILabel *pNoBuyLbl01;
@property (nonatomic, weak) IBOutlet UILabel *pNoBuyLbl02;
@property (nonatomic, weak) IBOutlet UILabel *pNoBuyLbl03;
@property (nonatomic, weak) IBOutlet UILabel *pNoBuyLbl04;
@property (nonatomic, weak) IBOutlet UILabel *pNoBuyLbl05;


@property (nonatomic, strong) NSMutableDictionary *pDetailDataDic;

@property (nonatomic, weak) id <VodBuyViewDelegate>delegate;

- (IBAction)onBtnClicked:(UIButton *)btn;

@end

@protocol VodBuyViewDelegate <NSObject>

@optional
- (void)VodBuyViewWithTag:(int)nTag;

@end
