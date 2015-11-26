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
    
    if ( !([self.sProductType isEqualToString:@"RVOD"] || [self.sProductType isEqualToString:@"Package"]) )
    {
        // 그외에는 하단 결제 타입 별도
        switch (self.nStep1Tag) {
            case VOD_BUY_VIEW_BTN_01:
            case VOD_BUY_VIEW_BTN_02:
            case VOD_BUY_VIEW_BTN_03:
            {
                self.pPriceTitleLbl.text = @"일반결제[부가세 별도]";
                self.pPriceLbl.text = [NSString stringWithFormat:@"%@원", [[CMAppManager sharedInstance] insertComma:self.sStep1Price]];
                self.nBuyType = BuyNomal;
                
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
                
                self.nBuyType = BuyNomal;
                
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
                    self.nBuyType = BuyCompounding;
                }
                else
                {
                    // 쿠폰결제
                    self.pPriceLbl.text = [NSString stringWithFormat:@"%@원", [[CMAppManager sharedInstance] insertComma:self.sStep1Price]];
                    self.nBuyType = BuyCoupon;
                }
                
            }break;
            case VOD_BUY_VIEW_BTN_06:
            {
                // tv 포인트 결제
                self.pPriceTitleLbl.text = @"TV포인트결제[부가세 별도]";
                self.pPriceLbl.text = [NSString stringWithFormat:@"%@원", [[CMAppManager sharedInstance] insertComma:self.sStep1Price]];
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
                }
                
            }
        }break;
         
    }
}

#pragma mark - 결제 전문
#pragma mark - 일반 결제
- (void)requestWithPurchaseAssetEx2
{
    NSString *sNewAssetId = [NSString stringWithFormat:@"%@", [[self.pDetailDic objectForKey:@"asset"] objectForKey:@"assetId"]];
    NSString *sNewProductId = self.sProductId;
    NSString *sNewGoodId = self.sGoodId;
    NSString *sNewPrice = self.sStep2Price;
    
    NSURLSessionDataTask *tesk = [NSMutableDictionary paymentPurchaseAssetEx2WithAssetId:sNewAssetId WithProductId:sNewProductId WithGoodId:sNewGoodId WithPrice:sNewPrice completion:^(NSArray *payment, NSError *error) {
        
        DDLogError(@"일반 결제 = [%@]", payment);
        
        if ( [payment count] == 0 )
            return;
        
        if ( [[[payment objectAtIndex:0] objectForKey:@"resultCode"] isEqualToString:@"100"] )
        {
            [SIAlertView alert:@"구매완료" message:@"구매가 완료되었습니다.\n[VOD 구매목록] 메뉴에서 구매내역을 확인하실 수 있습니다." completion:^(NSInteger buttonIndex, SIAlertView *alert) {
               
                
                [self.delegate VodPopUpViewWithTag:0];
            }];
        }
    }];
    
    [UIAlertView showAlertViewForTaskWithErrorOnCompletion:tesk delegate:nil];
}


#pragma mark - 쿠폰 결제
- (void)requestWithPurchaseByCoupon
{
    NSString *sNewAssetId = [NSString stringWithFormat:@"%@", [[self.pDetailDic objectForKey:@"asset"] objectForKey:@"assetId"]];
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
                
                [self.delegate VodPopUpViewWithTag:0];
            }];
        }
    }];
    
    [UIAlertView showAlertViewForTaskWithErrorOnCompletion:tesk delegate:nil];
}

#pragma mark - TV 포인트 결제
- (void)requestWithPurchaseByPoint
{
    NSString *sNewAssetId = [NSString stringWithFormat:@"%@", [[self.pDetailDic objectForKey:@"asset"] objectForKey:@"assetId"]];
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
                
               
                [self.delegate VodPopUpViewWithTag:0];
            }];
        }
    }];
    
    [UIAlertView showAlertViewForTaskWithErrorOnCompletion:tesk delegate:nil];
}

#pragma mark - 복합 결제
- (void)requestWithPurchaseByComplexMethods
{
    NSString *sNewAssetId = [NSString stringWithFormat:@"%@", [[self.pDetailDic objectForKey:@"asset"] objectForKey:@"assetId"]];
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
               
               
                [self.delegate VodPopUpViewWithTag:0];
                
            }];
        }
    }];
    
    [UIAlertView showAlertViewForTaskWithErrorOnCompletion:tesk delegate:nil];
}

//#pragma mark - 일반 결제
//- (void)requestWithPurchaseAssetEx2
//{
//    NSLog(@"일반 결제");
//    
//    NSObject *itemObj = [[[[self pBuyDic] objectForKey:@"asset"] objectForKey:@"productList"] objectForKey:@"product"];
//    
//    if ( [itemObj isKindOfClass:[NSDictionary class]] )
//    {
//        NSString *sProductId = [NSString stringWithFormat:@"%@", [[[[[self pBuyDic] objectForKey:@"asset"] objectForKey:@"productList"] objectForKey:@"product"] objectForKey:@"productId"]];
//        NSString *sGoodi = [NSString stringWithFormat:@"%@", [[[[[self pBuyDic] objectForKey:@"asset"] objectForKey:@"productList"] objectForKey:@"product"] objectForKey:@"goodId"]];
//        NSString *sPrice = [NSString stringWithFormat:@"%@", [[[[[self pBuyDic] objectForKey:@"asset"] objectForKey:@"productList"] objectForKey:@"product"] objectForKey:@"price"]];
//        
//        NSURLSessionDataTask *tesk = [NSMutableDictionary paymentPurchaseAssetEx2WithProductId:sProductId WithGoodId:sGoodi WithUiComponentDomain:sPrice WithUiComponentId:@"0" WithPrice:@"0" completion:^(NSArray *preference, NSError *error) {
//            
//            DDLogError(@"preference = [%@]", preference);
//            
//            [SIAlertView alert:@"구매완료" message:@"가입이 완료 되었습니다.\n[VOD 구매목록]메뉴에서 구매내역을\n확인하실 수 있습니다."
//                        cancel:nil
//                       buttons:@[@"확인"]
//                    completion:^(NSInteger buttonIndex, SIAlertView *alert) {
//                        
//                        [self dismissViewControllerAnimated:NO completion:^{
//                            
//                            [self.delegate VodPopUpViewWithTag:0];
//                            
//                        }];
//                        
//                    }];
//
//        }];
//        
//        [UIAlertView showAlertViewForTaskWithErrorOnCompletion:tesk delegate:nil];
//        
//    }
//    else if ( [itemObj isKindOfClass:[NSArray class]] )
//    {
//        NSString *sProductId = [NSString stringWithFormat:@"%@", [[[[[[self pBuyDic] objectForKey:@"asset"] objectForKey:@"productList"] objectForKey:@"product"] objectAtIndex:0] objectForKey:@"productId"]];
//        NSString *sGoodi = [NSString stringWithFormat:@"%@", [[[[[[self pBuyDic] objectForKey:@"asset"] objectForKey:@"productList"] objectForKey:@"product"] objectAtIndex:0] objectForKey:@"goodId"]];
//        NSString *sPrice = [NSString stringWithFormat:@"%@", [[[[[[self pBuyDic] objectForKey:@"asset"] objectForKey:@"productList"] objectForKey:@"product"] objectAtIndex:0] objectForKey:@"price"]];
//        
//        NSURLSessionDataTask *tesk = [NSMutableDictionary paymentPurchaseAssetEx2WithProductId:sProductId WithGoodId:sGoodi WithUiComponentDomain:@"0" WithUiComponentId:@"0" WithPrice:sPrice completion:^(NSArray *preference, NSError *error) {
//            
//            DDLogError(@"preference = [%@]", preference);
//        }];
//        
//        [UIAlertView showAlertViewForTaskWithErrorOnCompletion:tesk delegate:nil];
//        
//    }
//    
//    
//}
@end
