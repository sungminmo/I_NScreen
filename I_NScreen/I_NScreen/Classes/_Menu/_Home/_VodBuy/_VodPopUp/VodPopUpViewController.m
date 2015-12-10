//
//  VodPopUpViewController.m
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 11. 12..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import "VodPopUpViewController.h"
#import "UIAlertView+AFNetworking.h"
#import "NSMutableDictionary+Payment.h"
#import "CMDBDataManager.h"

@interface VodPopUpViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *lineView;
@property (nonatomic) int nBuyType;
@end

@implementation VodPopUpViewController
//@synthesize pBuyStr;
//@synthesize pBuyDic;
@synthesize delegate;
@synthesize pDetailDic;
@synthesize nStep1Tag;
@synthesize nStep2Tag;
@synthesize sStep1Price;
@synthesize sStep2Price;
@synthesize sStep2Price02;
@synthesize isCompounding;
@synthesize sProductId;
@synthesize sGoodId;
@synthesize sProductType;

@synthesize sAssetId;
@synthesize sEpisodePeerExistence;
@synthesize sContentGroupId;

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [self setViewInit];
    [self setViewTagInit];

    self.lineView.image = [UIImage imageWithColor:[UIColor lightGrayColor] withAlpha:1 withSize:self.lineView.bounds.size];
    
    NSString *sNewAssetId = nil;
    if (self.pDetailDic[@"assetId"] != nil) {
        sNewAssetId = [self.pDetailDic[@"assetId"] copy];
    }
    else if (self.pDetailDic[@"asset"] != nil && self.pDetailDic[@"asset"][@"assetId"] != nil ) {
        sNewAssetId = [self.pDetailDic[@"asset"][@"assetId"] copy];
    }
    else {
        sNewAssetId = @"";
    }
    
    if (sNewAssetId == nil) {
        sNewAssetId = @"";
    }
    
    self.sAssetId = [sNewAssetId copy];
    
    
}

#pragma mark - 초기화
#pragma mark - 뷰 테그 초기화
- (void)setViewTagInit
{
    self.pBgBtn.tag = VOD_POP_UP_VIEW_BTN_01;
    self.pCancelBtn.tag = VOD_POP_UP_VIEW_BTN_02;
    self.pOkBtn.tag = VOD_POP_UP_VIEW_BTN_03;
}

#pragma mark - 화면 초기화
- (void)setViewInit
{
    self.pTextField.type = Secure_CMTextFieldType;
    
    NSString* periodObj = self.pDetailDic[@"viewablePeriod"];
    if (periodObj == nil) {
        
        id obj = self.pDetailDic[@"asset"][@"productList"][@"product"];
        if ([obj isKindOfClass:[NSArray class]]) {
            periodObj = ((NSArray*)obj).firstObject[@"viewablePeriod"];
        }
        else if ([obj isKindOfClass:[NSDictionary class]]) {
            periodObj = ((NSDictionary*)obj)[@"viewablePeriod"];
        }
    }

    if (periodObj != nil) {
        NSTimeInterval periodInterval = -1;
        NSString* period = [periodObj copy];
        NSDate* periodDate = [NSDate dateFromString:period withFormat:[NSDate timestampFormatString]];
        if (periodDate == nil) {
            NSInteger index = [period rangeOfString:@" "].location;
            if ( [period rangeOfString:@" "].location != NSNotFound) {
                period = [period substringToIndex:index];
                period = [period stringByReplacingOccurrencesOfString:@"-" withString:@""];
            }
            else {
                period = @"0";
            }
            periodInterval = [period integerValue]*60*60*24;
        }
        else {
            periodInterval = [[NSDate date] timeIntervalSinceDate:periodDate];
        }
        
        NSString* periodText = @"24시간";
        NSInteger remain = periodInterval/(60*60*24);
        if (remain > 0) {
            periodText = [NSString stringWithFormat:@"%ld일", remain];
        }
        else {
            remain = periodInterval/(60*60);
            if (remain > 0) {
                periodText = [NSString stringWithFormat:@"%ld시간", remain];
            }
        }
        
        if ([periodText isEqualToString:@"999일"]) {
            periodText = @"무제한";
        }
        
        self.periodLabel.text = periodText;
    }
    
    
    if ( !([self.sProductType isEqualToString:@"RVOD"] || [self.sProductType isEqualToString:@"Package"] || [self.sProductType isEqualToString:@"Bundle"]) )
    {
        // 그외에는 하단 결제 타입 별도
        switch (self.nStep1Tag) {
            case VOD_BUY_VIEW_BTN_01: {
                self.pPriceTitleLbl.text = @"일반결제[부가세 별도]";
                self.pPriceLbl.text = [NSString stringWithFormat:@"%@원", [[CMAppManager sharedInstance] insertComma:self.sStep1Price]];
                self.nBuyType = BuyNomal;
                
                if ([self.sProductType isEqualToString:@"SVOD"]) {
                    self.pPriceLbl.text = [NSString stringWithFormat:@"%@원/월", [[CMAppManager sharedInstance] insertComma:self.sStep2Price]];
                    self.periodLabel.text = @"해지시까지";
                }
                
            }break;
            case VOD_BUY_VIEW_BTN_02: {
                self.pPriceTitleLbl.text = @"일반결제[부가세 별도]";
                self.pPriceLbl.text = [NSString stringWithFormat:@"%@원", [[CMAppManager sharedInstance] insertComma:self.sStep1Price]];
                self.nBuyType = BuyNomal;
                
                if ([self.sProductType isEqualToString:@"SVOD"]) {
                    self.pPriceLbl.text = [NSString stringWithFormat:@"%@원/월", [[CMAppManager sharedInstance] insertComma:self.sStep2Price]];
                    self.periodLabel.text = @"해지시까지";
                }
                
            }break;
            case VOD_BUY_VIEW_BTN_03:
            {
                self.pPriceTitleLbl.text = @"일반결제[부가세 별도]";
                self.pPriceLbl.text = [NSString stringWithFormat:@"%@원", [[CMAppManager sharedInstance] insertComma:self.sStep1Price]];
                self.nBuyType = BuyNomal;
                
                if ([self.sProductType isEqualToString:@"SVOD"]) {
                    self.pPriceLbl.text = [NSString stringWithFormat:@"%@원/월", [[CMAppManager sharedInstance] insertComma:self.sStep2Price]];
                    self.periodLabel.text = @"해지시까지";
                }
                
            }break;
        }
    }
    else
    {
        switch (self.nStep2Tag) {
            case VOD_BUY_VIEW_BTN_04:
            {
                // 일반 결제
                self.pPriceTitleLbl.text = @"일반결제[부가세 별도]";
                
                self.pPriceLbl.text = [NSString stringWithFormat:@"%@원", [[CMAppManager sharedInstance] insertComma:self.sStep2Price]];
                
                if ( [self.sProductType isEqualToString:@"Bundle"] ) {
                    self.nBuyType = BuyBundleNomal;
                }
                else {
                    self.nBuyType = BuyNomal;
                }
                
            }break;
            case VOD_BUY_VIEW_BTN_05:
            {
                // 쿠폰 결제
                self.pPriceTitleLbl.text = @"쿠폰결제[부가세 별도]";
                
                if ( self.isCompounding == YES )
                {
                    // 복합 결제
                    self.pCouponLbl.hidden = NO;
                    self.pCouponTitleLbl.hidden = NO;
                    // 총 금액에서 쿠폰 뺀 금액
                    NSString *sPrice = [NSString stringWithFormat:@"%d", [sStep2Price02 intValue] - [sStep2Price intValue]];
                    self.pPriceLbl.text = [NSString stringWithFormat:@"%@원", [[CMAppManager sharedInstance] insertComma:sPrice]];
                    
                    self.pCouponLbl.text = [NSString stringWithFormat:@"%@원 차감", [[CMAppManager sharedInstance] insertComma:sStep2Price]];
                    
                    if ( [self.sProductType isEqualToString:@"Bundle"] )
                        self.nBuyType = BuyBundleCompounding;
                    else
                        self.nBuyType = BuyCompounding;
                    
                }
                else
                {
                    // 쿠폰결제
                    self.pPriceLbl.text = [NSString stringWithFormat:@"%@원", [[CMAppManager sharedInstance] insertComma:self.sStep1Price]];
                    
                    if ( [self.sProductType isEqualToString:@"Bundle"] )
                        self.nBuyType = BuyBundleCoupon;
                    else
                        self.nBuyType = BuyCoupon;

                }
                
            }break;
            case VOD_BUY_VIEW_BTN_06:
            {
                // tv 포인트 결제
                self.pPriceTitleLbl.text = @"TV포인트결제[부가세 별도]";
                self.pPriceLbl.text = [NSString stringWithFormat:@"%@원", [[CMAppManager sharedInstance] insertComma:self.sStep1Price]];

                if ( [self.sProductType isEqualToString:@"Bundle"] )
                    self.nBuyType = BuyBundleTv;
                else
                    self.nBuyType = BuyTv;
                
            }break;
        }
    }
}

#pragma mark - 액션 이벤트
#pragma mark - 버튼 액션 이벤트
- (IBAction)onBtnClicked:(UIButton *)btn
{
    [self.pTextField resignFirstResponder];
    
    switch ([btn tag]) {
        case VOD_POP_UP_VIEW_BTN_01:
        case VOD_POP_UP_VIEW_BTN_02:
        {
            [self dismissViewControllerAnimated:NO completion:nil];
        }break;
        case VOD_POP_UP_VIEW_BTN_03:
        {
            if ( ![self.pTextField.text isEqualToString:[[CMAppManager sharedInstance] getKeychainBuyPw]] )
            {
                [SIAlertView alert:@"알림" message:@"구매 비밀번호가 잘못되었습니다." button:nil];
            }
            else
            {
                [self dismissViewControllerAnimated:NO completion:nil];
                
                switch (self.nBuyType) {
                    case BuyNomal:
                    {
                        // 일반 결제
                        [self requestWithPurchaseAssetEx2];
                    }break;
                    case BuyCoupon:
                    {
                        // 쿠폰 결제
                        [self requestWithPurchaseByCoupon];
                    }break;
                    case BuyTv:
                    {
                        // tv 결제
                        [self requestWithPurchaseByPoint];
                    }break;
                    case BuyCompounding:
                    {
                        // 복합 결제
                        [self requestWithPurchaseByComplexMethods];
                    }break;
                    case BuyBundleNomal:
                    {
                        // 묶음 일반 결제
                        [self requestWithPurchaseProduct];
                    }break;
                    case BuyBundleCoupon:
                    {
                        // 묶음 쿠폰 결제
                        [self requestWithPurchaseProductByCoupon2];
                    }break;
                    case BuyBundleTv:
                    {
                        // 묶음 TV 결제
                        [self requestWithPurchaseProductByPoint];
                    }break;
                    case BuyBundleCompounding:
                    {
                        // 묶음 복합 결제
                        [self requestWithPurchaseProductByComplexMethods];
                    }break;
                }
                
            }
        }break;
         
    }
}

#pragma mark - 결제 전문
#pragma mark - 일반 결제
- (void)requestWithPurchaseAssetEx2
{
    NSString *sNewAssetId = nil;
    if (self.pDetailDic[@"assetId"] != nil) {
        sNewAssetId = [self.pDetailDic[@"assetId"] copy];
    }
    else if (self.pDetailDic[@"asset"] != nil && self.pDetailDic[@"asset"][@"assetId"] != nil ) {
        sNewAssetId = [self.pDetailDic[@"asset"][@"assetId"] copy];
    }
    else {
        sNewAssetId = @"";
    }
    
    if (sNewAssetId == nil) {
        sNewAssetId = @"";
    }
    
    
    NSString *sNewProductId = self.sProductId;
    NSString *sNewGoodId = self.sGoodId;
    NSString *sNewPrice = self.sStep2Price;
    
    /*
     월정액 가입이 완료되었습니다.
     셋탑박스의 [마이TV>서비스 이용목록>월정액
     가입 목록]에서 가입 내역을 확인하실 수 있습니다
     */
    
    NSDictionary* discountDic = nil;
    if (self.isDiscount) {
        sNewPrice = [self.sStep1Price copy];
        NSString* couponId = self.discountCouponId;
        NSString* amount = self.discountAmount;
        //            url += "&discountCouponId=" + sdiscountCouponId + "&discountAmount=" + ldiscountAmount +"&price=" + listPrice;
        discountDic = @{
                        @"discountCouponId": couponId,
                        @"discountAmount": amount
                        };
    }
    
    NSURLSessionDataTask *tesk = [NSMutableDictionary paymentPurchaseAssetEx2WithAssetId:sNewAssetId WithProductId:sNewProductId WithGoodId:sNewGoodId WithPrice:sNewPrice extraParam:discountDic completion:^(NSArray *payment, NSError *error) {
        
        DDLogError(@"일반 결제 = [%@]", payment);
        
        if ( [payment count] == 0 )
            return;
        
        if ( [[[payment objectAtIndex:0] objectForKey:@"resultCode"] isEqualToString:@"100"] )
        {
            if ([self.sProductType isEqualToString:@"SVOD"]) {
                NSString* message = [NSString stringWithFormat:@"%@ 가입이 완료되었습니다.\n셋탑박스의 [마이TV>서비스 이용목록>월정액 가입 목록]에서 가입 내역을 확인하실 수 있습니다", self.sProductName];
                [SIAlertView alert:@"가입완료" message:message completion:^(NSInteger buttonIndex, SIAlertView *alert) {
                    [self.delegate VodPopUpViewWithTag:BUY_NOMAL_TAG];
                }];
            } else {
                [SIAlertView alert:@"구매완료" message:@"구매가 완료되었습니다.\n[VOD 구매목록] 메뉴에서 구매내역을 확인하실 수 있습니다." completion:^(NSInteger buttonIndex, SIAlertView *alert) {
                    [self.delegate VodPopUpViewWithTag:BUY_NOMAL_TAG];
                }];
            }
            
        }
    }];
    
    [SIAlertView showAlertViewForTaskWithErrorOnCompletion:tesk delegate:nil];
}


#pragma mark - 쿠폰 결제
- (void)requestWithPurchaseByCoupon
{
    
    NSString *sNewAssetId = nil;
    if (self.pDetailDic[@"assetId"] != nil) {
        sNewAssetId = [self.pDetailDic[@"assetId"] copy];
    }
    else if (self.pDetailDic[@"asset"] != nil && self.pDetailDic[@"asset"][@"assetId"] != nil ) {
        sNewAssetId = [self.pDetailDic[@"asset"][@"assetId"] copy];
    }
    else {
        sNewAssetId = @"";
    }
    
    if (sNewAssetId == nil) {
        sNewAssetId = @"";
    }
    
    
    NSString *sNewProductId = self.sProductId;
    NSString *sNewGoodId = self.sGoodId;
    NSString *sNewPrice = self.pPriceLbl.text;
    sNewPrice = [sNewPrice stringByReplacingOccurrencesOfString:@"원" withString:@""];
    sNewPrice = [sNewPrice stringByReplacingOccurrencesOfString:@"," withString:@""];
    NSString *sNewCategoryId = [NSString stringWithFormat:@"%@", [self.pDetailDic objectForKey:@"categoryId"]];
    
    NSURLSessionDataTask *tesk = [NSMutableDictionary paymentPurchaseByCouponWithAssetId:sNewAssetId WithProductId:sNewProductId WithGoodId:sNewGoodId WithPrice:sNewPrice WithCategoryId:sNewCategoryId completion:^(NSArray *payment, NSError *error) {
        
        DDLogError(@"쿠폰 결제 = [%@]", payment);
        if ( [payment count] == 0 )
            return;
        
        if ( [[[payment objectAtIndex:0] objectForKey:@"resultCode"] isEqualToString:@"100"] )
        {
            [SIAlertView alert:@"구매완료" message:@"구매가 완료되었습니다.\n[VOD 구매목록] 메뉴에서 구매내역을 확인하실 수 있습니다." completion:^(NSInteger buttonIndex, SIAlertView *alert) {
                
                [self.delegate VodPopUpViewWithTag:BUY_NOMAL_TAG];
            }];
        }
    }];
    
    [SIAlertView showAlertViewForTaskWithErrorOnCompletion:tesk delegate:nil];
}

#pragma mark - TV 포인트 결제
- (void)requestWithPurchaseByPoint
{

    NSString *sNewAssetId = nil;
    if (self.pDetailDic[@"assetId"] != nil) {
        sNewAssetId = [self.pDetailDic[@"assetId"] copy];
    }
    else if (self.pDetailDic[@"asset"] != nil && self.pDetailDic[@"asset"][@"assetId"] != nil ) {
        sNewAssetId = [self.pDetailDic[@"asset"][@"assetId"] copy];
    }
    else {
        sNewAssetId = @"";
    }
    
    if (sNewAssetId == nil) {
        sNewAssetId = @"";
    }
    
    NSString *sNewProductId = self.sProductId;
    NSString *sNewGoodId = self.sGoodId;
    NSString *sNewPrice = self.sStep1Price;
    NSString *sNewCategoryId = [NSString stringWithFormat:@"%@", [self.pDetailDic objectForKey:@"categoryId"]];
    
    NSURLSessionDataTask *tesk = [NSMutableDictionary paymentPurchaseByPointWithAssetId:sNewAssetId WithProductId:sNewProductId WithGoodId:sNewGoodId WithPrice:sNewPrice WithCategoryId:sNewCategoryId completion:^(NSArray *payment, NSError *error) {
        
        DDLogError(@"TV 포인트 결제 = [%@]", payment);
        if ( [payment count] == 0 )
            return;
        
        if ( [[[payment objectAtIndex:0] objectForKey:@"resultCode"] isEqualToString:@"100"] )
        {
            [SIAlertView alert:@"구매완료" message:@"구매가 완료되었습니다.\n[VOD 구매목록] 메뉴에서 구매내역을 확인하실 수 있습니다." completion:^(NSInteger buttonIndex, SIAlertView *alert) {
                
               
                [self.delegate VodPopUpViewWithTag:BUY_NOMAL_TAG];
            }];
        }
    }];
    
    [SIAlertView showAlertViewForTaskWithErrorOnCompletion:tesk delegate:nil];
}

#pragma mark - 복합 결제
- (void)requestWithPurchaseByComplexMethods
{
    NSString *sNewAssetId = nil;
    if (self.pDetailDic[@"assetId"] != nil) {
        sNewAssetId = [self.pDetailDic[@"assetId"] copy];
    }
    else if (self.pDetailDic[@"asset"] != nil && self.pDetailDic[@"asset"][@"assetId"] != nil ) {
        sNewAssetId = [self.pDetailDic[@"asset"][@"assetId"] copy];
    }
    else {
        sNewAssetId = @"";
    }
    
    if (sNewAssetId == nil) {
        sNewAssetId = @"";
    }
    
    NSString *sNewProductId = self.sProductId;
    NSString *sNewGoodId = self.sGoodId;
    NSString *sNewPrice = self.sStep2Price02;   // 총 할인 받은 결제 금액
    NSString *sNewCouponPrice = self.sStep2Price;
    NSString *sNewNormalPrice = self.pPriceLbl.text;
    sNewNormalPrice = [sNewNormalPrice stringByReplacingOccurrencesOfString:@"원" withString:@""];
    sNewNormalPrice = [sNewNormalPrice stringByReplacingOccurrencesOfString:@"," withString:@""];
    
    NSURLSessionDataTask *tesk = [NSMutableDictionary paymentPurchaseByComplexMethodsWithAssetId:sNewAssetId WithProductId:sNewProductId WithGoodId:sNewGoodId WithPrice:sNewPrice WithCouponPrice:sNewCouponPrice WithNomalPrice:sNewNormalPrice completion:^(NSArray *payment, NSError *error) {
        
        DDLogError(@"복합 결제 = [%@]", payment);
        if ( [payment count] == 0 )
            return;
        
        if ( [[[payment objectAtIndex:0] objectForKey:@"resultCode"] isEqualToString:@"100"] )
        {
            [SIAlertView alert:@"구매완료" message:@"구매가 완료되었습니다.\n[VOD 구매목록] 메뉴에서 구매내역을 확인하실 수 있습니다." completion:^(NSInteger buttonIndex, SIAlertView *alert) {
               
               
                [self.delegate VodPopUpViewWithTag:BUY_NOMAL_TAG];
                
            }];
        }
    }];
    
    [SIAlertView showAlertViewForTaskWithErrorOnCompletion:tesk delegate:nil];
}

#pragma mark - 묶음 일반 결제
- (void)requestWithPurchaseProduct
{
    NSString *sNewProductId = self.sProductId;
    NSURLSessionDataTask *tesk = [NSMutableDictionary paymentPurchaseProductWithProductId:sNewProductId completion:^(NSArray *payment, NSError *error) {
        
        DDLogError(@"묶음 일반 결제 = [%@]", payment);
        
        if ( [payment count] == 0 )
            return;
        
        if ( [[[payment objectAtIndex:0] objectForKey:@"resultCode"] isEqualToString:@"100"] )
        {
            [SIAlertView alert:@"구매완료" message:@"구매가 완료되었습니다.\n[VOD 구매목록] 메뉴에서 구매내역을 확인하실 수 있습니다." completion:^(NSInteger buttonIndex, SIAlertView *alert) {
                
                
//                [self.delegate VodPopUpViewWithTag:BUY_BUNDLE_TAG];
                [self.delegate VodPopUpViewWithTag:BUY_BUNDLE_TAG WithProductId:self.sProductId WithAssetId:self.sAssetId WithEpisodePeerExistence:self.sEpisodePeerExistence WithContentGroupId:self.sContentGroupId];
            }];
        }
    }];
    
    [SIAlertView showAlertViewForTaskWithErrorOnCompletion:tesk delegate:nil];
}

#pragma mark - 묶음 쿠폰 결제
- (void)requestWithPurchaseProductByCoupon2
{
    NSString *sNewProductId = self.sProductId;
    NSString *sNewPrice = self.pPriceLbl.text;
    NSURLSessionDataTask *tesk = [NSMutableDictionary paymentPurchaseProductByCoupon2WithProductId:sNewProductId WithPrice:sNewPrice completion:^(NSArray *payment, NSError *error) {
       
        DDLogError(@"묶음 쿠폰 결제 = [%@]", payment);
        
        if ( [payment count] == 0 )
            return;
        
        if ( [[[payment objectAtIndex:0] objectForKey:@"resultCode"] isEqualToString:@"100"] )
        {
            [SIAlertView alert:@"구매완료" message:@"구매가 완료되었습니다.\n[VOD 구매목록] 메뉴에서 구매내역을 확인하실 수 있습니다." completion:^(NSInteger buttonIndex, SIAlertView *alert) {
                
//                [self.delegate VodPopUpViewWithTag:BUY_BUNDLE_TAG];
                [self.delegate VodPopUpViewWithTag:BUY_BUNDLE_TAG WithProductId:self.sProductId WithAssetId:self.sAssetId WithEpisodePeerExistence:self.sEpisodePeerExistence WithContentGroupId:self.sContentGroupId];
            }];
        }
    }];
    
    [SIAlertView showAlertViewForTaskWithErrorOnCompletion:tesk delegate:nil];
}

#pragma mark - 묶음 포인트 결제
- (void)requestWithPurchaseProductByPoint
{
    NSString *sNewProductId = self.sProductId;
    NSString *sNewPrice = self.sStep1Price;
    
    NSURLSessionDataTask *tesk = [NSMutableDictionary paymentPurchaseProductByPointWithProductId:sNewProductId WithPrice:sNewPrice completion:^(NSArray *payment, NSError *error) {
        
        DDLogError(@"묶음 포인트 결제 = [%@]", payment);
        
        if ( [payment count] == 0 )
            return;
        
        if ( [[[payment objectAtIndex:0] objectForKey:@"resultCode"] isEqualToString:@"100"] )
        {
            [SIAlertView alert:@"구매완료" message:@"구매가 완료되었습니다.\n[VOD 구매목록] 메뉴에서 구매내역을 확인하실 수 있습니다." completion:^(NSInteger buttonIndex, SIAlertView *alert) {
                
                
//                [self.delegate VodPopUpViewWithTag:BUY_BUNDLE_TAG];
                [self.delegate VodPopUpViewWithTag:BUY_BUNDLE_TAG WithProductId:self.sProductId WithAssetId:self.sAssetId WithEpisodePeerExistence:self.sEpisodePeerExistence WithContentGroupId:self.sContentGroupId];
            }];
        }
    }];
    
    [SIAlertView showAlertViewForTaskWithErrorOnCompletion:tesk delegate:nil];
}

#pragma mark - 묶음 복합 결제
- (void)requestWithPurchaseProductByComplexMethods
{
    NSString *sNewProductId = self.sProductId;
    NSString *sNewPrice = self.sStep2Price02;   // 총 할인 받은 결제 금액
    NSString *sNewCouponPrice = self.sStep2Price;
    NSString *sNewNormalPrice = self.pPriceLbl.text;
    sNewNormalPrice = [sNewNormalPrice stringByReplacingOccurrencesOfString:@"원" withString:@""];
    sNewNormalPrice = [sNewNormalPrice stringByReplacingOccurrencesOfString:@"," withString:@""];

    
    NSURLSessionDataTask *tesk = [NSMutableDictionary paymentPurchaseProductByComplexMethodsWithProductId:sNewProductId WithPrice:sNewPrice WithCouponPrice:sNewCouponPrice WithNormalPrice:sNewNormalPrice completion:^(NSArray *payment, NSError *error) {
        
        DDLogError(@"묶음 복합 결제 = [%@]", payment);
        
        if ( [payment count] == 0 )
            return;
        
        if ( [[[payment objectAtIndex:0] objectForKey:@"resultCode"] isEqualToString:@"100"] )
        {
            [SIAlertView alert:@"구매완료" message:@"구매가 완료되었습니다.\n[VOD 구매목록] 메뉴에서 구매내역을 확인하실 수 있습니다." completion:^(NSInteger buttonIndex, SIAlertView *alert) {
                
                
//                [self.delegate VodPopUpViewWithTag:BUY_BUNDLE_TAG];
                [self.delegate VodPopUpViewWithTag:BUY_BUNDLE_TAG WithProductId:self.sProductId WithAssetId:self.sAssetId WithEpisodePeerExistence:self.sEpisodePeerExistence WithContentGroupId:self.sContentGroupId];
                
            }];
        }

    }];
    
    [SIAlertView showAlertViewForTaskWithErrorOnCompletion:tesk delegate:nil];
}
@end
