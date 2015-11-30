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

// 구매 타입
typedef enum : NSInteger {
    BuyNomal = 1000000,  // 일반 결제
    BuyCoupon,           // 쿠폰 결제
    BuyTv,       // TV 결제
    BuyCompounding,              // 복합 결제
    BuyBundleNomal,
    BuyBundleCoupon,
    BuyBundleTv,
    BuyBundleCompounding
}BuyType;

@protocol VodPopUpViewDelegate;

@interface VodPopUpViewController : CMBaseViewController

@property (nonatomic, weak) IBOutlet UILabel *pPriceLbl;
@property (nonatomic, weak) IBOutlet UILabel *pPriceTitleLbl;

@property (nonatomic, weak) IBOutlet UILabel *pCouponTitleLbl;
@property (nonatomic, weak) IBOutlet UILabel *pCouponLbl;

//@property (nonatomic, strong) NSString *pBuyStr;
//@property (nonatomic, strong) NSMutableDictionary *pBuyDic;

@property (nonatomic, weak) IBOutlet UIButton *pCancelBtn;
@property (nonatomic, weak) IBOutlet UIButton *pOkBtn;
@property (nonatomic, weak) IBOutlet UIButton *pBgBtn;

@property (nonatomic, weak) IBOutlet CMTextField *pTextField;
@property (nonatomic, strong) NSMutableDictionary *pDetailDic;
@property (nonatomic) int nStep1Tag;
@property (nonatomic) int nStep2Tag;
@property (nonatomic, strong) NSString *sStep1Price;
@property (nonatomic, strong) NSString *sStep2Price;
@property (nonatomic, strong) NSString *sStep2Price02;  // 디스 카운트 금액 총 결제 금액
@property (nonatomic) BOOL isCompounding;   // 복합 결제 유무
@property (nonatomic, strong) NSString *sProductId;
@property (nonatomic, strong) NSString *sGoodId;
@property (nonatomic, strong) NSString *sProductType;

@property (nonatomic, strong) NSString *sAssetId;
@property (nonatomic, strong) NSString *sEpisodePeerExistence;
@property (nonatomic, strong) NSString *sContentGroupId;

@property (nonatomic, weak) id <VodPopUpViewDelegate>delegate;

- (IBAction)onBtnClicked:(UIButton *)btn;

@end

@protocol VodPopUpViewDelegate <NSObject>

@optional
- (void)VodPopUpViewWithTag:(int)nTag;
- (void)VodPopUpViewWithTag:(int)nTag WithProductId:(NSString *)productId WithAssetId:(NSString *)assetId WithEpisodePeerExistence:(NSString *)EpisodePeerExistence WithContentGroupId:(NSString *)contentGroupId;

@end