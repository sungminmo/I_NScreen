//
//  VodBuyViewController.m
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 11. 11..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import "VodBuyViewController.h"
#import "NSMutableDictionary+Payment.h"
#import "UIAlertView+AFNetworking.h"
#import "NSMutableDictionary+Payment.h"
#import "RootViewController.h"
#import "NSMutableDictionary+VOD.h"

@interface VodBuyViewController ()
//@property (nonatomic, strong) NSMutableArray *pPaymentTypeArr;
//@property (nonatomic, strong) NSMutableArray *pBuyTypeArr;
@property (nonatomic, strong) NSMutableArray *pProductArr;
@property (nonatomic, strong) NSMutableArray *pCouponBalanceArr;
@property (nonatomic, strong) NSString *sSeriesLink;        // 시리즈 인지 체크
@property (nonatomic, strong) NSString *sCouponMoney;       // 쿠폰 결제 금액
@property (nonatomic, strong) NSMutableArray *pDiscountCouponMasterIdArr;   // 할인 카드 유무
@property (nonatomic, strong) NSMutableArray *pPointBalanceArr;     // 포인트 조회
@property (nonatomic) BOOL isDiscount;      // 할인 카드 유무
@property (nonatomic) int nDisPrice;        // 할인 금액
@property (nonatomic) int nPointBalance;    // TV포인트 금액
@property (nonatomic) int nCouponPrice;     // 쿠폰 결제 금액

@property (nonatomic) int nStep1BtnTag;     // 버튼 테그 값
@property (nonatomic) int nStep2BtnTag;     // 버튼 테그 값

@end

@implementation VodBuyViewController
@synthesize pDetailDataDic;
@synthesize delegate;

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setDataInit];
    [self setTagInit];
    [self setViewInit];
    [self requestWithGetCouponBalance2];
    [self requestWithGetPointBalance];
}


#pragma mark - 초기화
#pragma mark - 태그 초기화
- (void)setTagInit
{
    self.pStep1SubView02Btn.tag = VOD_BUY_VIEW_BTN_01;
    self.pStep1SubView03Btn.tag = VOD_BUY_VIEW_BTN_02;
    self.pStep1SubView04Btn.tag = VOD_BUY_VIEW_BTN_03;
    
    self.pStep2SubView02Btn.tag = VOD_BUY_VIEW_BTN_04;
    self.pStep2SubView03Btn.tag = VOD_BUY_VIEW_BTN_05;
    self.pStep2SubView04Btn.tag = VOD_BUY_VIEW_BTN_06;
    
    self.pCancelBtn.tag = VOD_BUY_VIEW_BTN_07;
    self.pOkBtn.tag = VOD_BUY_VIEW_BTN_08;
}

#pragma mark - 데이터 초기화
- (void)setDataInit
{
    self.title = @"상세정보";
    self.isUseNavigationBar = YES;
    self.isDiscount = NO;
    self.nDisPrice = 0;
    self.nPointBalance = 0;
    self.nCouponPrice = 0;
    self.scrollContainer.contentSize = CGSizeMake(self.view.bounds.size.width, 642);
    
    self.sSeriesLink = [NSString stringWithFormat:@"%@", [[self.pDetailDataDic objectForKey:@"asset"] objectForKey:@"seriesLink"]];
    
    self.pProductArr = [[NSMutableArray alloc] init];
    self.pCouponBalanceArr = [[NSMutableArray alloc] init];
    self.pPointBalanceArr = [[NSMutableArray alloc] init];
    
    NSObject *itemObject = [[[self.pDetailDataDic objectForKey:@"asset"] objectForKey:@"productList"] objectForKey:@"product"];
    
    if ( [itemObject isKindOfClass:[NSDictionary class]] )
    {
        [self.pProductArr addObject:itemObject];
    }
    else
    {
        [self.pProductArr setArray:(NSArray *)itemObject];
    }
    
    
    // 할인 카드 데이터
    self.pDiscountCouponMasterIdArr = [[NSMutableArray alloc] init];
    NSObject *saleObject = [[[self.pDetailDataDic objectForKey:@"asset"] objectForKey:@"discountCouponMasterIdList"] objectForKey:@"discountCouponMasterId"];
    
    if ( [saleObject isKindOfClass:[NSDictionary class]] )
    {
        [self.pDiscountCouponMasterIdArr addObject:saleObject];
    }
    else
    {
        [self.pDiscountCouponMasterIdArr setArray:(NSArray *)saleObject];
    }
    
}

#pragma mark - 화면 뷰 초기화
- (void)setViewInit
{
    for ( int i = 0; i < [self.pProductArr count]; i++ )
    {
        switch (i) {
            case 0:
            {
                [self setStep1SubView02Init];
            }break;
            case 1:
            {
                [self setStep1SubView03Init];
            }break;
            case 2:
            {
                [self setStep1SubView04Init];
            }break;
        }
    }
}

- (void)setStep1SubView02Init
{
    self.pStep1SubView02.hidden = NO;
    
    NSString *sProductType = [NSString stringWithFormat:@"%@", [[self.pProductArr objectAtIndex:0] objectForKey:@"productType"]];
    NSString *sPrice = [NSString stringWithFormat:@"%@",[[CMAppManager sharedInstance] insertComma:[[self.pProductArr objectAtIndex:0] objectForKey:@"price"]]];
    // 단일
    if ( [sProductType isEqualToString:@"RVOD"] )
    {
        // 단일 회차 구매
        if ( [self.sSeriesLink isEqualToString:@"1"] )
        {
            self.pStep1SubView02TitleLbl.text = @"단일 회차 구매";
        }
        // 단일 상품 구매
        else
        {
            self.pStep1SubView02TitleLbl.text = @"단일 상품 구매";
        }
        self.pStep1SubView02MoneyLbl.text = [NSString stringWithFormat:@"%@원[부가세 별도]", sPrice];
    }
    // 묶음
    else if ( [sProductType isEqualToString:@"Bundle"] )
    {
        self.pStep1SubView02TitleLbl.text = @"묶음 할인상품 구매";
        self.pStep1SubView02MoneyLbl.text = [NSString stringWithFormat:@"%@원[부가세 별도]", sPrice];
    }
    // 월정액 시리즈
    else if ( [sProductType isEqualToString:@"SVOD"] )
    {
        NSString *sSvod = [NSString stringWithFormat:@"%@", [[self.pProductArr objectAtIndex:0] objectForKey:@"productName"]];
        NSArray *svodArr = [sSvod componentsSeparatedByString:@":"];
        self.pStep1SubView02TitleLbl.text = [NSString stringWithFormat:@"%@", [svodArr objectAtIndex:0]];
        self.pStep1SubView02MoneyLbl.text = [NSString stringWithFormat:@"%@원 / 월[부가세 별도]", sPrice];
    }
    // 시리즈 전체 회차 구매
    else if ( [sProductType isEqualToString:@"Package"] )
    {
        self.pStep1SubView02TitleLbl.text = @"시리즈 전체회차 구매";
        self.pStep1SubView02MoneyLbl.text = [NSString stringWithFormat:@"%@원[부가세 별도]", sPrice];
        
    }
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.tag = VOD_BUY_VIEW_BTN_01;
    [self onBtnClicked:btn];
    
    btn.tag = VOD_BUY_VIEW_BTN_04;
    [self onBtnClicked:btn];
}

- (void)setStep1SubView03Init
{
    self.pStep1SubView03.hidden = NO;
    
    NSString *sProductType = [NSString stringWithFormat:@"%@", [[self.pProductArr objectAtIndex:1] objectForKey:@"productType"]];
    NSString *sPrice = [NSString stringWithFormat:@"%@",[[CMAppManager sharedInstance] insertComma:[[self.pProductArr objectAtIndex:1] objectForKey:@"price"]]];
    
    
    // 단일
    if ( [sProductType isEqualToString:@"RVOD"] )
    {
        // 단일 회차 구매
        if ( [self.sSeriesLink isEqualToString:@"1"] )
        {
            self.pStep1SubView03TitleLbl.text = @"단일 회차 구매";
        }
        // 단일 상품 구매
        else
        {
            self.pStep1SubView03TitleLbl.text = @"단일 상품 구매";
        }
        self.pStep1SubView03MoneyLbl.text = [NSString stringWithFormat:@"%@원[부가세 별도]", sPrice];
    }
    // 묶음
    else if ( [sProductType isEqualToString:@"Bundle"] )
    {
        self.pStep1SubView03TitleLbl.text = @"묶음 할인상품 구매";
        self.pStep1SubView03MoneyLbl.text = [NSString stringWithFormat:@"%@원[부가세 별도]", sPrice];
    }
    // 월정액 시리즈
    else if ( [sProductType isEqualToString:@"SVOD"] )
    {
        NSString *sSvod = [NSString stringWithFormat:@"%@", [[self.pProductArr objectAtIndex:1] objectForKey:@"productName"]];
        NSArray *svodArr = [sSvod componentsSeparatedByString:@":"];
        self.pStep1SubView03TitleLbl.text = [NSString stringWithFormat:@"%@", [svodArr objectAtIndex:0]];
        self.pStep1SubView03MoneyLbl.text = [NSString stringWithFormat:@"%@원 / 월[부가세 별도]", sPrice];
    }
    // 시리즈 전체 회차 구매
    else if ( [sProductType isEqualToString:@"Package"] )
    {
        self.pStep1SubView03TitleLbl.text = @"시리즈 전체회차 구매";
        self.pStep1SubView03MoneyLbl.text = [NSString stringWithFormat:@"%@원[부가세 별도]", sPrice];
    }
    
}

- (void)setStep1SubView04Init
{
    self.pStep1SubView04.hidden = NO;
    
    NSString *sProductType = [NSString stringWithFormat:@"%@", [[self.pProductArr objectAtIndex:2] objectForKey:@"productType"]];
    NSString *sPrice = [NSString stringWithFormat:@"%@",[[CMAppManager sharedInstance] insertComma:[[self.pProductArr objectAtIndex:2] objectForKey:@"price"]]];
    
    // 단일
    if ( [sProductType isEqualToString:@"RVOD"] )
    {
        // 단일 회차 구매
        if ( [self.sSeriesLink isEqualToString:@"1"] )
        {
            self.pStep1SubView04TitleLbl.text = @"단일 회차 구매";
        }
        // 단일 상품 구매
        else
        {
            self.pStep1SubView04TitleLbl.text = @"단일 상품 구매";
        }
        self.pStep1SubView04MoneyLbl.text = [NSString stringWithFormat:@"%@원[부가세 별도]", sPrice];
    }
    // 묶음
    else if ( [sProductType isEqualToString:@"Bundle"] )
    {
        self.pStep1SubView04TitleLbl.text = @"묶음 할인상품 구매";
        self.pStep1SubView04MoneyLbl.text = [NSString stringWithFormat:@"%@원[부가세 별도]", sPrice];
    }
    // 월정액 시리즈
    else if ( [sProductType isEqualToString:@"SVOD"] )
    {
        NSString *sSvod = [NSString stringWithFormat:@"%@", [[self.pProductArr objectAtIndex:2] objectForKey:@"productName"]];
        NSArray *svodArr = [sSvod componentsSeparatedByString:@":"];
        self.pStep1SubView04TitleLbl.text = [NSString stringWithFormat:@"%@", [svodArr objectAtIndex:0]];
        self.pStep1SubView04MoneyLbl.text = [NSString stringWithFormat:@"%@원 / 월[부가세 별도]", sPrice];
    }
    // 시리즈 전체 회차 구매
    else if ( [sProductType isEqualToString:@"Package"] )
    {
        self.pStep1SubView04TitleLbl.text = @"시리즈 전체회차 구매";
        self.pStep1SubView04MoneyLbl.text = [NSString stringWithFormat:@"%@원[부가세 별도]", sPrice];
    }
    
}

- (void)setViewHiddenWithType:(NSString *)type
{
    if ( [type isEqualToString:@"RVOD"] || [type isEqualToString:@"Package"] )
    {
        self.pStep2SubView02.hidden = NO;
        self.pStep2SubView03.hidden = NO;
        self.pStep2SubView04.hidden = NO;
        
        self.pNoBuyLbl01.hidden = YES;
        self.pNoBuyLbl02.hidden = YES;
        self.pNoBuyLbl03.hidden = YES;
        self.pNoBuyLbl04.hidden = YES;
        self.pNoBuyLbl05.hidden = YES;
    }
    else
    {
        self.pStep2SubView02.hidden = YES;
        self.pStep2SubView03.hidden = YES;
        self.pStep2SubView04.hidden = YES;
        
        self.pNoBuyLbl01.hidden = NO;
        self.pNoBuyLbl02.hidden = NO;
        self.pNoBuyLbl03.hidden = NO;
        self.pNoBuyLbl04.hidden = NO;
        self.pNoBuyLbl05.hidden = NO;
    }
}

- (IBAction)onBtnClicked:(UIButton *)btn
{
    switch ([btn tag]) {
        case VOD_BUY_VIEW_BTN_01:
        {
            self.nStep1BtnTag = VOD_BUY_VIEW_BTN_01;
            
            [self.pStep1SubView02Btn setBackgroundImage:[UIImage imageNamed:@"purchase_select.jpg"] forState:UIControlStateNormal];
            [self.pStep1SubView03Btn setBackgroundImage:[UIImage imageNamed:@"purchase_normal.png"] forState:UIControlStateNormal];
            [self.pStep1SubView04Btn setBackgroundImage:[UIImage imageNamed:@"purchase_normal.png"] forState:UIControlStateNormal];
            
            self.pStep1SubView02TitleLbl.textColor = [UIColor whiteColor];
            self.pStep1SubView02MoneyLbl.textColor = [UIColor whiteColor];
            
            self.pStep1SubView03TitleLbl.textColor = [UIColor colorWithRed:123.0f/255.0f green:90.0f/255.0f blue:163.0f/255.0f alpha:1.0f];
            self.pStep1SubView03MoneyLbl.textColor = [UIColor blackColor];
            
            self.pStep1SubView04TitleLbl.textColor = [UIColor colorWithRed:123.0f/255.0f green:90.0f/255.0f blue:163.0f/255.0f alpha:1.0f];
            self.pStep1SubView04MoneyLbl.textColor = [UIColor blackColor];
            
            NSString *sProductType = [NSString stringWithFormat:@"%@", [[self.pProductArr objectAtIndex:0] objectForKey:@"productType"]];
            
            [self setViewHiddenWithType:sProductType];
            self.pStep2SubView04Btn.enabled = YES;
            if ( [sProductType isEqualToString:@"RVOD"] || [sProductType isEqualToString:@"Package"] )
            {
                if ( self.isDiscount == YES )
                {
                    if ( self.nDisPrice != 0 )
                    {
                        NSString *sPrice = [NSString stringWithFormat:@"%@",[[CMAppManager sharedInstance] insertComma:[[self.pProductArr objectAtIndex:0] objectForKey:@"price"]]];
                        int nPrice = [[[self.pProductArr objectAtIndex:0] objectForKey:@"price"] intValue];
                        self.pStep2SubView02MoneyLbl02.hidden = NO;
                        
                        self.pStep2SubView02MoneyLbl.strikeThroughEnabled = YES;
                        self.pStep2SubView02MoneyLbl.text = [NSString stringWithFormat:@"%@원", sPrice];
                        self.pStep2SubView02MoneyLbl02.text = [NSString stringWithFormat:@"%@원", [[CMAppManager sharedInstance] insertComma:[NSString stringWithFormat:@"%d", nPrice - self.nDisPrice]]];
                        
                        if( nPrice > self.nPointBalance )
                        {
                            // tv 포인트 딤 처리
                            self.pStep2SubView04Btn.enabled = NO;
                            [self.pStep2SubView04Btn setBackgroundImage:[UIImage imageNamed:@"purchase_dimmed.png"] forState:UIControlStateNormal];
                            
                            self.pStep2SubView04TitleLbl.textColor = [UIColor whiteColor];
                            self.pStep2SubView04MoneyLbl.textColor = [UIColor whiteColor];
                            self.pStep2SubView04ContentLbl01.textColor = [UIColor whiteColor];
                            self.pStep2SubView04ContentLbl02.textColor = [UIColor whiteColor];
                        }
                        else
                        {
                            self.pStep2SubView04Btn.enabled = YES;
                            
                            if ( self.nStep2BtnTag == VOD_BUY_VIEW_BTN_06 )
                            {
                                [self.pStep2SubView04Btn setBackgroundImage:[UIImage imageNamed:@"purchase_select.jpg"] forState:UIControlStateNormal];
                                
                                self.pStep2SubView04TitleLbl.textColor = [UIColor whiteColor];
                                self.pStep2SubView04MoneyLbl.textColor = [UIColor whiteColor];
                                self.pStep2SubView04ContentLbl01.textColor = [UIColor whiteColor];
                                self.pStep2SubView04ContentLbl02.textColor = [UIColor whiteColor];

                            }
                            else
                            {
                                [self.pStep2SubView04Btn setBackgroundImage:[UIImage imageNamed:@"purchase_normal.png"] forState:UIControlStateNormal];
                                
                                self.pStep2SubView04TitleLbl.textColor = [UIColor colorWithRed:123.0f/255.0f green:90.0f/255.0f blue:163.0f/255.0f alpha:1.0f];
                                self.pStep2SubView04MoneyLbl.textColor = [UIColor blackColor];
                                self.pStep2SubView04ContentLbl01.textColor = [UIColor blackColor];
                                self.pStep2SubView04ContentLbl02.textColor = [UIColor blackColor];
                            }
                        }
                    }
                    
                }
                else
                {
                    NSString *sPrice = [NSString stringWithFormat:@"%@",[[CMAppManager sharedInstance] insertComma:[[self.pProductArr objectAtIndex:0] objectForKey:@"price"]]];
                    self.pStep2SubView02MoneyLbl.text = [NSString stringWithFormat:@"%@원", sPrice];
                    
                    if( [[[self.pProductArr objectAtIndex:0] objectForKey:@"price"] intValue] > self.nPointBalance )
                    {
                        // tv 포인트 딤 처리
                        self.pStep2SubView04Btn.enabled = NO;
                        [self.pStep2SubView04Btn setBackgroundImage:[UIImage imageNamed:@"purchase_dimmed.png"] forState:UIControlStateNormal];
                        
                        self.pStep2SubView04TitleLbl.textColor = [UIColor whiteColor];
                        self.pStep2SubView04MoneyLbl.textColor = [UIColor whiteColor];
                        self.pStep2SubView04ContentLbl01.textColor = [UIColor whiteColor];
                        self.pStep2SubView04ContentLbl02.textColor = [UIColor whiteColor];
                    }
                    else
                    {
                        self.pStep2SubView04Btn.enabled = YES;
                        
                        if ( self.nStep2BtnTag == VOD_BUY_VIEW_BTN_06 )
                        {
                            [self.pStep2SubView04Btn setBackgroundImage:[UIImage imageNamed:@"purchase_select.jpg"] forState:UIControlStateNormal];
                            
                            self.pStep2SubView04TitleLbl.textColor = [UIColor whiteColor];
                            self.pStep2SubView04MoneyLbl.textColor = [UIColor whiteColor];
                            self.pStep2SubView04ContentLbl01.textColor = [UIColor whiteColor];
                            self.pStep2SubView04ContentLbl02.textColor = [UIColor whiteColor];
                            
                        }
                        else
                        {
                            [self.pStep2SubView04Btn setBackgroundImage:[UIImage imageNamed:@"purchase_normal.png"] forState:UIControlStateNormal];
                            
                            self.pStep2SubView04TitleLbl.textColor = [UIColor colorWithRed:123.0f/255.0f green:90.0f/255.0f blue:163.0f/255.0f alpha:1.0f];
                            self.pStep2SubView04MoneyLbl.textColor = [UIColor blackColor];
                            self.pStep2SubView04ContentLbl01.textColor = [UIColor blackColor];
                            self.pStep2SubView04ContentLbl02.textColor = [UIColor blackColor];
                        }

                    }
                }
            }
            
            if ( self.pStep2SubView04Btn.enabled == NO && self.nStep2BtnTag == VOD_BUY_VIEW_BTN_06 )
            {
                // tv 포인트가 딤이면
                self.nStep2BtnTag = VOD_BUY_VIEW_BTN_04;
                [self.pStep2SubView02Btn setBackgroundImage:[UIImage imageNamed:@"purchase_select.jpg"] forState:UIControlStateNormal];
               
                self.pStep2SubView02TitleLbl.textColor = [UIColor whiteColor];
                self.pStep2SubView02MoneyLbl.textColor = [UIColor whiteColor];
                self.pStep2SubView02ContentLbl.textColor = [UIColor whiteColor];
            }
            
        }break;
        case VOD_BUY_VIEW_BTN_02:
        {
            self.nStep1BtnTag = VOD_BUY_VIEW_BTN_02;
            
            [self.pStep1SubView02Btn setBackgroundImage:[UIImage imageNamed:@"purchase_normal.png"] forState:UIControlStateNormal];
            [self.pStep1SubView03Btn setBackgroundImage:[UIImage imageNamed:@"purchase_select.jpg"] forState:UIControlStateNormal];
            [self.pStep1SubView04Btn setBackgroundImage:[UIImage imageNamed:@"purchase_normal.png"] forState:UIControlStateNormal];
            
            self.pStep1SubView02TitleLbl.textColor = [UIColor colorWithRed:123.0f/255.0f green:90.0f/255.0f blue:163.0f/255.0f alpha:1.0f];
            self.pStep1SubView02MoneyLbl.textColor = [UIColor blackColor];
            
            self.pStep1SubView03TitleLbl.textColor = [UIColor whiteColor];
            self.pStep1SubView03MoneyLbl.textColor = [UIColor whiteColor];
            
            self.pStep1SubView04TitleLbl.textColor = [UIColor colorWithRed:123.0f/255.0f green:90.0f/255.0f blue:163.0f/255.0f alpha:1.0f];
            self.pStep1SubView04MoneyLbl.textColor = [UIColor blackColor];
            
            NSString *sProductType = [NSString stringWithFormat:@"%@", [[self.pProductArr objectAtIndex:1] objectForKey:@"productType"]];
            
            [self setViewHiddenWithType:sProductType];
            self.pStep2SubView04Btn.enabled = YES;
            if ( [sProductType isEqualToString:@"RVOD"] || [sProductType isEqualToString:@"Package"] )
            {
                if ( self.isDiscount == YES )
                {
                    if ( self.nDisPrice != 0 )
                    {
                        NSString *sPrice = [NSString stringWithFormat:@"%@",[[CMAppManager sharedInstance] insertComma:[[self.pProductArr objectAtIndex:1] objectForKey:@"price"]]];
                        int nPrice = [[[self.pProductArr objectAtIndex:0] objectForKey:@"price"] intValue];
                        self.pStep2SubView02MoneyLbl02.hidden = NO;
                        
                        self.pStep2SubView02MoneyLbl.strikeThroughEnabled = YES;
                        self.pStep2SubView02MoneyLbl.text = [NSString stringWithFormat:@"%@원", sPrice];
                        self.pStep2SubView02MoneyLbl02.text = [NSString stringWithFormat:@"%@원", [[CMAppManager sharedInstance] insertComma:[NSString stringWithFormat:@"%d", nPrice - self.nDisPrice]]];
                        
                        if( [[[self.pProductArr objectAtIndex:1] objectForKey:@"price"] intValue] > self.nPointBalance )
                        {
                            // tv 포인트 딤 처리
                            self.pStep2SubView04Btn.enabled = NO;
                            [self.pStep2SubView04Btn setBackgroundImage:[UIImage imageNamed:@"purchase_dimmed.png"] forState:UIControlStateNormal];
                            
                            self.pStep2SubView04TitleLbl.textColor = [UIColor whiteColor];
                            self.pStep2SubView04MoneyLbl.textColor = [UIColor whiteColor];
                            self.pStep2SubView04ContentLbl01.textColor = [UIColor whiteColor];
                            self.pStep2SubView04ContentLbl02.textColor = [UIColor whiteColor];
                        }
                        else
                        {
                            self.pStep2SubView04Btn.enabled = YES;
                            
                            if ( self.nStep2BtnTag == VOD_BUY_VIEW_BTN_06 )
                            {
                                [self.pStep2SubView04Btn setBackgroundImage:[UIImage imageNamed:@"purchase_select.jpg"] forState:UIControlStateNormal];
                                
                                self.pStep2SubView04TitleLbl.textColor = [UIColor whiteColor];
                                self.pStep2SubView04MoneyLbl.textColor = [UIColor whiteColor];
                                self.pStep2SubView04ContentLbl01.textColor = [UIColor whiteColor];
                                self.pStep2SubView04ContentLbl02.textColor = [UIColor whiteColor];
                                
                            }
                            else
                            {
                                [self.pStep2SubView04Btn setBackgroundImage:[UIImage imageNamed:@"purchase_normal.png"] forState:UIControlStateNormal];
                                
                                self.pStep2SubView04TitleLbl.textColor = [UIColor colorWithRed:123.0f/255.0f green:90.0f/255.0f blue:163.0f/255.0f alpha:1.0f];
                                self.pStep2SubView04MoneyLbl.textColor = [UIColor blackColor];
                                self.pStep2SubView04ContentLbl01.textColor = [UIColor blackColor];
                                self.pStep2SubView04ContentLbl02.textColor = [UIColor blackColor];
                            }

                        }
                    }
                    
                }
                else
                {
                    NSString *sPrice = [NSString stringWithFormat:@"%@",[[CMAppManager sharedInstance] insertComma:[[self.pProductArr objectAtIndex:1] objectForKey:@"price"]]];
                    self.pStep2SubView02MoneyLbl.text = [NSString stringWithFormat:@"%@원", sPrice];
                    
                    if( [[[self.pProductArr objectAtIndex:1] objectForKey:@"price"] intValue] > self.nPointBalance )
                    {
                        // tv 포인트 딤 처리
                        self.pStep2SubView04Btn.enabled = NO;
                        [self.pStep2SubView04Btn setBackgroundImage:[UIImage imageNamed:@"purchase_dimmed.png"] forState:UIControlStateNormal];
                        
                        self.pStep2SubView04TitleLbl.textColor = [UIColor whiteColor];
                        self.pStep2SubView04MoneyLbl.textColor = [UIColor whiteColor];
                        self.pStep2SubView04ContentLbl01.textColor = [UIColor whiteColor];
                        self.pStep2SubView04ContentLbl02.textColor = [UIColor whiteColor];
                    }
                    else
                    {
                        self.pStep2SubView04Btn.enabled = YES;
                        
                        if ( self.nStep2BtnTag == VOD_BUY_VIEW_BTN_06 )
                        {
                            [self.pStep2SubView04Btn setBackgroundImage:[UIImage imageNamed:@"purchase_select.jpg"] forState:UIControlStateNormal];
                            
                            self.pStep2SubView04TitleLbl.textColor = [UIColor whiteColor];
                            self.pStep2SubView04MoneyLbl.textColor = [UIColor whiteColor];
                            self.pStep2SubView04ContentLbl01.textColor = [UIColor whiteColor];
                            self.pStep2SubView04ContentLbl02.textColor = [UIColor whiteColor];
                            
                        }
                        else
                        {
                            [self.pStep2SubView04Btn setBackgroundImage:[UIImage imageNamed:@"purchase_normal.png"] forState:UIControlStateNormal];
                            
                            self.pStep2SubView04TitleLbl.textColor = [UIColor colorWithRed:123.0f/255.0f green:90.0f/255.0f blue:163.0f/255.0f alpha:1.0f];
                            self.pStep2SubView04MoneyLbl.textColor = [UIColor blackColor];
                            self.pStep2SubView04ContentLbl01.textColor = [UIColor blackColor];
                            self.pStep2SubView04ContentLbl02.textColor = [UIColor blackColor];
                        }

                    }
                }
            }
            
            if ( self.pStep2SubView04Btn.enabled == NO && self.nStep2BtnTag == VOD_BUY_VIEW_BTN_06 )
            {
                // tv 포인트가 딤이면
                self.nStep2BtnTag = VOD_BUY_VIEW_BTN_04;
                [self.pStep2SubView02Btn setBackgroundImage:[UIImage imageNamed:@"purchase_select.jpg"] forState:UIControlStateNormal];
                
                self.pStep2SubView02TitleLbl.textColor = [UIColor whiteColor];
                self.pStep2SubView02MoneyLbl.textColor = [UIColor whiteColor];
                self.pStep2SubView02ContentLbl.textColor = [UIColor whiteColor];
            }

        }break;
        case VOD_BUY_VIEW_BTN_03:
        {
            self.nStep1BtnTag = VOD_BUY_VIEW_BTN_03;
            
            [self.pStep1SubView02Btn setBackgroundImage:[UIImage imageNamed:@"purchase_normal.png"] forState:UIControlStateNormal];
            [self.pStep1SubView03Btn setBackgroundImage:[UIImage imageNamed:@"purchase_normal.png"] forState:UIControlStateNormal];
            [self.pStep1SubView04Btn setBackgroundImage:[UIImage imageNamed:@"purchase_select.jpg"] forState:UIControlStateNormal];
            
            self.pStep1SubView02TitleLbl.textColor = [UIColor colorWithRed:123.0f/255.0f green:90.0f/255.0f blue:163.0f/255.0f alpha:1.0f];
            self.pStep1SubView02MoneyLbl.textColor = [UIColor blackColor];
            
            self.pStep1SubView03TitleLbl.textColor = [UIColor colorWithRed:123.0f/255.0f green:90.0f/255.0f blue:163.0f/255.0f alpha:1.0f];
            self.pStep1SubView03MoneyLbl.textColor = [UIColor blackColor];
            
            self.pStep1SubView04TitleLbl.textColor = [UIColor whiteColor];
            self.pStep1SubView04MoneyLbl.textColor = [UIColor whiteColor];
            
            NSString *sProductType = [NSString stringWithFormat:@"%@", [[self.pProductArr objectAtIndex:2] objectForKey:@"productType"]];
            
            [self setViewHiddenWithType:sProductType];
            self.pStep2SubView04Btn.enabled = YES;
            if ( [sProductType isEqualToString:@"RVOD"] || [sProductType isEqualToString:@"Package"] )
            {
                if ( self.isDiscount == YES )
                {
                    if ( self.nDisPrice != 0 )
                    {
                        NSString *sPrice = [NSString stringWithFormat:@"%@",[[CMAppManager sharedInstance] insertComma:[[self.pProductArr objectAtIndex:2] objectForKey:@"price"]]];
                        int nPrice = [[[self.pProductArr objectAtIndex:0] objectForKey:@"price"] intValue];
                        self.pStep2SubView02MoneyLbl02.hidden = NO;
                        
                        self.pStep2SubView02MoneyLbl.strikeThroughEnabled = YES;
                        self.pStep2SubView02MoneyLbl.text = [NSString stringWithFormat:@"%@원", sPrice];
                        self.pStep2SubView02MoneyLbl02.text = [NSString stringWithFormat:@"%@원", [[CMAppManager sharedInstance] insertComma:[NSString stringWithFormat:@"%d", nPrice - self.nDisPrice]]];
                        
                        if( [[[self.pProductArr objectAtIndex:2] objectForKey:@"price"] intValue] > self.nPointBalance )
                        {
                            // tv 포인트 딤 처리
                            self.pStep2SubView04Btn.enabled = NO;
                            [self.pStep2SubView04Btn setBackgroundImage:[UIImage imageNamed:@"purchase_dimmed.png"] forState:UIControlStateNormal];
                            
                            self.pStep2SubView04TitleLbl.textColor = [UIColor whiteColor];
                            self.pStep2SubView04MoneyLbl.textColor = [UIColor whiteColor];
                            self.pStep2SubView04ContentLbl01.textColor = [UIColor whiteColor];
                            self.pStep2SubView04ContentLbl02.textColor = [UIColor whiteColor];
                        }
                        else
                        {
                            self.pStep2SubView04Btn.enabled = YES;
                            
                            if ( self.nStep2BtnTag == VOD_BUY_VIEW_BTN_06 )
                            {
                                [self.pStep2SubView04Btn setBackgroundImage:[UIImage imageNamed:@"purchase_select.jpg"] forState:UIControlStateNormal];
                                
                                self.pStep2SubView04TitleLbl.textColor = [UIColor whiteColor];
                                self.pStep2SubView04MoneyLbl.textColor = [UIColor whiteColor];
                                self.pStep2SubView04ContentLbl01.textColor = [UIColor whiteColor];
                                self.pStep2SubView04ContentLbl02.textColor = [UIColor whiteColor];
                                
                            }
                            else
                            {
                                [self.pStep2SubView04Btn setBackgroundImage:[UIImage imageNamed:@"purchase_normal.png"] forState:UIControlStateNormal];
                                
                                self.pStep2SubView04TitleLbl.textColor = [UIColor colorWithRed:123.0f/255.0f green:90.0f/255.0f blue:163.0f/255.0f alpha:1.0f];
                                self.pStep2SubView04MoneyLbl.textColor = [UIColor blackColor];
                                self.pStep2SubView04ContentLbl01.textColor = [UIColor blackColor];
                                self.pStep2SubView04ContentLbl02.textColor = [UIColor blackColor];
                            }

                        }
                    }
                    
                }
                else
                {
                    NSString *sPrice = [NSString stringWithFormat:@"%@",[[CMAppManager sharedInstance] insertComma:[[self.pProductArr objectAtIndex:2] objectForKey:@"price"]]];
                    self.pStep2SubView02MoneyLbl.text = [NSString stringWithFormat:@"%@원", sPrice];
                    
                    if( [[[self.pProductArr objectAtIndex:2] objectForKey:@"price"] intValue] > self.nPointBalance )
                    {
                        // tv 포인트 딤 처리
                        self.pStep2SubView04Btn.enabled = NO;
                        [self.pStep2SubView04Btn setBackgroundImage:[UIImage imageNamed:@"purchase_dimmed.png"] forState:UIControlStateNormal];
                        
                        self.pStep2SubView04TitleLbl.textColor = [UIColor whiteColor];
                        self.pStep2SubView04MoneyLbl.textColor = [UIColor whiteColor];
                        self.pStep2SubView04ContentLbl01.textColor = [UIColor whiteColor];
                        self.pStep2SubView04ContentLbl02.textColor = [UIColor whiteColor];
                    }
                    else
                    {
                        self.pStep2SubView04Btn.enabled = YES;
                        
                        if ( self.nStep2BtnTag == VOD_BUY_VIEW_BTN_06 )
                        {
                            [self.pStep2SubView04Btn setBackgroundImage:[UIImage imageNamed:@"purchase_select.jpg"] forState:UIControlStateNormal];
                            
                            self.pStep2SubView04TitleLbl.textColor = [UIColor whiteColor];
                            self.pStep2SubView04MoneyLbl.textColor = [UIColor whiteColor];
                            self.pStep2SubView04ContentLbl01.textColor = [UIColor whiteColor];
                            self.pStep2SubView04ContentLbl02.textColor = [UIColor whiteColor];
                            
                        }
                        else
                        {
                            [self.pStep2SubView04Btn setBackgroundImage:[UIImage imageNamed:@"purchase_normal.png"] forState:UIControlStateNormal];
                            
                            self.pStep2SubView04TitleLbl.textColor = [UIColor colorWithRed:123.0f/255.0f green:90.0f/255.0f blue:163.0f/255.0f alpha:1.0f];
                            self.pStep2SubView04MoneyLbl.textColor = [UIColor blackColor];
                            self.pStep2SubView04ContentLbl01.textColor = [UIColor blackColor];
                            self.pStep2SubView04ContentLbl02.textColor = [UIColor blackColor];
                        }

                    }
                }
            }
            
            if ( self.pStep2SubView04Btn.enabled == NO && self.nStep2BtnTag == VOD_BUY_VIEW_BTN_06 )
            {
                // tv 포인트가 딤이면
                self.nStep2BtnTag = VOD_BUY_VIEW_BTN_04;
                [self.pStep2SubView02Btn setBackgroundImage:[UIImage imageNamed:@"purchase_select.jpg"] forState:UIControlStateNormal];
                
                self.pStep2SubView02TitleLbl.textColor = [UIColor whiteColor];
                self.pStep2SubView02MoneyLbl.textColor = [UIColor whiteColor];
                self.pStep2SubView02ContentLbl.textColor = [UIColor whiteColor];
            }

        }break;
        case VOD_BUY_VIEW_BTN_04:
        {
            self.nStep2BtnTag = VOD_BUY_VIEW_BTN_04;
            
            if ( self.nCouponPrice == 0 )
            {
                self.pStep2SubView03Btn.enabled = NO;
                [self.pStep2SubView03Btn setBackgroundImage:[UIImage imageNamed:@"purchase_dimmed.png"] forState:UIControlStateNormal];
                self.pStep2SubView03TitleLbl.textColor = [UIColor whiteColor];
                self.pStep2SubView03MoneyLbl.textColor = [UIColor whiteColor];
                self.pStep2SubView03ContentLbl01.textColor = [UIColor whiteColor];
                self.pStep2SubView03ContentLbl02.textColor = [UIColor whiteColor];
            }
            else
            {
                self.pStep2SubView03Btn.enabled = YES;
                [self.pStep2SubView03Btn setBackgroundImage:[UIImage imageNamed:@"purchase_normal.png"] forState:UIControlStateNormal];
                self.pStep2SubView03TitleLbl.textColor = [UIColor colorWithRed:123.0f/255.0f green:90.0f/255.0f blue:163.0f/255.0f alpha:1.0f];
                self.pStep2SubView03MoneyLbl.textColor = [UIColor blackColor];
                self.pStep2SubView03ContentLbl01.textColor = [UIColor blackColor];
                self.pStep2SubView03ContentLbl02.textColor = [UIColor blackColor];
            }
            
            [self.pStep2SubView02Btn setBackgroundImage:[UIImage imageNamed:@"purchase_select.jpg"] forState:UIControlStateNormal];
            
            [self.pStep2SubView04Btn setBackgroundImage:[UIImage imageNamed:@"purchase_normal.png"] forState:UIControlStateNormal];
            
            self.pStep2SubView02TitleLbl.textColor = [UIColor whiteColor];
            self.pStep2SubView02MoneyLbl.textColor = [UIColor whiteColor];
            self.pStep2SubView02ContentLbl.textColor = [UIColor whiteColor];
            self.pStep2SubView02SaleImageView.image = [UIImage imageNamed:@"icon_discount_select.png"];

            self.pStep2SubView04TitleLbl.textColor = [UIColor colorWithRed:123.0f/255.0f green:90.0f/255.0f blue:163.0f/255.0f alpha:1.0f];
            self.pStep2SubView04MoneyLbl.textColor = [UIColor blackColor];
            self.pStep2SubView04ContentLbl01.textColor = [UIColor blackColor];
            self.pStep2SubView04ContentLbl02.textColor = [UIColor blackColor];
            
            if ( self.isDiscount == YES )
            {
                // 할인
                self.pStep2SubView02MoneyLbl02.textColor = [UIColor whiteColor];
            }
            
            NSString *step1Price = @"";
            self.pStep2SubView04Btn.enabled = YES;
            if ( self.nStep1BtnTag == VOD_BUY_VIEW_BTN_01 )
            {
                step1Price = [[self.pProductArr objectAtIndex:0] objectForKey:@"price"];
            }
            else if ( self.nStep1BtnTag == VOD_BUY_VIEW_BTN_02 )
            {
                step1Price = [[self.pProductArr objectAtIndex:1] objectForKey:@"price"];
            }
            else if ( self.nStep1BtnTag == VOD_BUY_VIEW_BTN_03 )
            {
                step1Price = [[self.pProductArr objectAtIndex:2] objectForKey:@"price"];
            }
            
            int nStep1Price = [step1Price intValue];
            
            if( nStep1Price > self.nPointBalance )
            {
                // tv 포인트 딤 처리
                self.pStep2SubView04Btn.enabled = NO;
                [self.pStep2SubView04Btn setBackgroundImage:[UIImage imageNamed:@"purchase_dimmed.png"] forState:UIControlStateNormal];
                
                self.pStep2SubView04TitleLbl.textColor = [UIColor whiteColor];
                self.pStep2SubView04MoneyLbl.textColor = [UIColor whiteColor];
                self.pStep2SubView04ContentLbl01.textColor = [UIColor whiteColor];
                self.pStep2SubView04ContentLbl02.textColor = [UIColor whiteColor];
            }
            else
            {
                self.pStep2SubView04Btn.enabled = YES;
                [self.pStep2SubView04Btn setBackgroundImage:[UIImage imageNamed:@"purchase_normal.png"] forState:UIControlStateNormal];
                
                self.pStep2SubView04TitleLbl.textColor = [UIColor colorWithRed:123.0f/255.0f green:90.0f/255.0f blue:163.0f/255.0f alpha:1.0f];
                self.pStep2SubView04MoneyLbl.textColor = [UIColor blackColor];
                self.pStep2SubView04ContentLbl01.textColor = [UIColor blackColor];
                self.pStep2SubView04ContentLbl02.textColor = [UIColor blackColor];
            }
            
        }break;
        case VOD_BUY_VIEW_BTN_05:
        {
            self.nStep2BtnTag = VOD_BUY_VIEW_BTN_05;
            
            [self.pStep2SubView02Btn setBackgroundImage:[UIImage imageNamed:@"purchase_normal.png"] forState:UIControlStateNormal];
            [self.pStep2SubView03Btn setBackgroundImage:[UIImage imageNamed:@"purchase_select.jpg"] forState:UIControlStateNormal];
            [self.pStep2SubView04Btn setBackgroundImage:[UIImage imageNamed:@"purchase_normal.png"] forState:UIControlStateNormal];
            
            self.pStep2SubView02TitleLbl.textColor = [UIColor colorWithRed:123.0f/255.0f green:90.0f/255.0f blue:163.0f/255.0f alpha:1.0f];
            self.pStep2SubView02MoneyLbl.textColor = [UIColor blackColor];
            self.pStep2SubView02ContentLbl.textColor = [UIColor blackColor];
            self.pStep2SubView02SaleImageView.image = [UIImage imageNamed:@"icon_discount_normal.png"];
            
            self.pStep2SubView03TitleLbl.textColor = [UIColor whiteColor];
            self.pStep2SubView03MoneyLbl.textColor = [UIColor whiteColor];
            self.pStep2SubView03ContentLbl01.textColor = [UIColor whiteColor];
            self.pStep2SubView03ContentLbl02.textColor = [UIColor whiteColor];
            
            self.pStep2SubView04TitleLbl.textColor = [UIColor colorWithRed:123.0f/255.0f green:90.0f/255.0f blue:163.0f/255.0f alpha:1.0f];
            self.pStep2SubView04MoneyLbl.textColor = [UIColor blackColor];
            self.pStep2SubView04ContentLbl01.textColor = [UIColor blackColor];
            self.pStep2SubView04ContentLbl02.textColor = [UIColor blackColor];
            
            if ( self.isDiscount == YES )
            {
                // 할인
                self.pStep2SubView02MoneyLbl02.textColor = [UIColor blackColor];
            }
            
            NSString *step1Price = @"";
            self.pStep2SubView04Btn.enabled = YES;
            if ( self.nStep1BtnTag == VOD_BUY_VIEW_BTN_01 )
            {
                step1Price = [[self.pProductArr objectAtIndex:0] objectForKey:@"price"];
            }
            else if ( self.nStep1BtnTag == VOD_BUY_VIEW_BTN_02 )
            {
                step1Price = [[self.pProductArr objectAtIndex:1] objectForKey:@"price"];
            }
            else if ( self.nStep1BtnTag == VOD_BUY_VIEW_BTN_03 )
            {
                step1Price = [[self.pProductArr objectAtIndex:2] objectForKey:@"price"];
            }
            
            int nStep1Price = [step1Price intValue];
            
            if( nStep1Price > self.nPointBalance )
            {
                // tv 포인트 딤 처리
                self.pStep2SubView04Btn.enabled = NO;
                [self.pStep2SubView04Btn setBackgroundImage:[UIImage imageNamed:@"purchase_dimmed.png"] forState:UIControlStateNormal];
                
                self.pStep2SubView04TitleLbl.textColor = [UIColor whiteColor];
                self.pStep2SubView04MoneyLbl.textColor = [UIColor whiteColor];
                self.pStep2SubView04ContentLbl01.textColor = [UIColor whiteColor];
                self.pStep2SubView04ContentLbl02.textColor = [UIColor whiteColor];
            }
            else
            {
                self.pStep2SubView04Btn.enabled = YES;
                [self.pStep2SubView04Btn setBackgroundImage:[UIImage imageNamed:@"purchase_normal.png"] forState:UIControlStateNormal];
                
                self.pStep2SubView04TitleLbl.textColor = [UIColor colorWithRed:123.0f/255.0f green:90.0f/255.0f blue:163.0f/255.0f alpha:1.0f];
                self.pStep2SubView04MoneyLbl.textColor = [UIColor blackColor];
                self.pStep2SubView04ContentLbl01.textColor = [UIColor blackColor];
                self.pStep2SubView04ContentLbl02.textColor = [UIColor blackColor];
            }

            
        }break;
        case VOD_BUY_VIEW_BTN_06:
        {
            self.nStep2BtnTag = VOD_BUY_VIEW_BTN_06;
            
            [self.pStep2SubView02Btn setBackgroundImage:[UIImage imageNamed:@"purchase_normal.png"] forState:UIControlStateNormal];
            [self.pStep2SubView03Btn setBackgroundImage:[UIImage imageNamed:@"purchase_normal.png"] forState:UIControlStateNormal];
            [self.pStep2SubView04Btn setBackgroundImage:[UIImage imageNamed:@"purchase_select.jpg"] forState:UIControlStateNormal];
            
            self.pStep2SubView02TitleLbl.textColor = [UIColor colorWithRed:123.0f/255.0f green:90.0f/255.0f blue:163.0f/255.0f alpha:1.0f];
            self.pStep2SubView02MoneyLbl.textColor = [UIColor blackColor];
            self.pStep2SubView02ContentLbl.textColor = [UIColor blackColor];
            self.pStep2SubView02SaleImageView.image = [UIImage imageNamed:@"icon_discount_normal.png"];
            
            self.pStep2SubView03TitleLbl.textColor = [UIColor colorWithRed:123.0f/255.0f green:90.0f/255.0f blue:163.0f/255.0f alpha:1.0f];
            self.pStep2SubView03MoneyLbl.textColor = [UIColor blackColor];
            self.pStep2SubView03ContentLbl01.textColor = [UIColor blackColor];
            self.pStep2SubView03ContentLbl02.textColor = [UIColor blackColor];
            
            self.pStep2SubView04TitleLbl.textColor = [UIColor whiteColor];
            self.pStep2SubView04MoneyLbl.textColor = [UIColor whiteColor];
            self.pStep2SubView04ContentLbl01.textColor = [UIColor whiteColor];
            self.pStep2SubView04ContentLbl02.textColor = [UIColor whiteColor];
            
            if ( self.isDiscount == YES )
            {
                // 할인
                self.pStep2SubView02MoneyLbl02.textColor = [UIColor blackColor];
            }

            
        }break;
        case VOD_BUY_VIEW_BTN_07:
        {
            // 취소
            
        }break;
        case VOD_BUY_VIEW_BTN_08:
        {
            // 결제
            VodPopUpViewController *pViewController = [[VodPopUpViewController alloc] initWithNibName:@"VodPopUpViewController" bundle:nil];
            self.navigationController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
            pViewController.navigationController.modalPresentationStyle= UIModalPresentationCurrentContext;
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0f) {
                pViewController.modalPresentationStyle= UIModalPresentationOverCurrentContext;
            }
//            pViewController.pBuyStr = [[self.pBuyTypeArr objectAtIndex:0] objectForKey:@"price"];
            pViewController.pBuyDic = self.pDetailDataDic;
            pViewController.delegate = self;
            [self presentViewController:pViewController animated:NO completion:^{
                
            }];
        }break;
    }
}

#pragma mark - 전문
#pragma mark - 쿠폰 데이터 전문
- (void)requestWithGetCouponBalance2
{
    NSURLSessionDataTask *tesk = [NSMutableDictionary vodGetCouponBalance2Completion:^(NSArray *vodBuy, NSError *error) {
        
        DDLogError(@"쿠폰 데이터 전문 = [%@]", vodBuy);
        
        if ( [vodBuy count] == 0 )
            return;
        
        self.isDiscount = NO;
        // 쿠폰 결제 금액
        NSString *sTotalMoneyBalance = [NSString stringWithFormat:@"%@", [[vodBuy objectAtIndex:0] objectForKey:@"totalMoneyBalance"]];
        self.nCouponPrice = [[[vodBuy objectAtIndex:0] objectForKey:@"totalMoneyBalance"] intValue];
        
        if ( self.nCouponPrice == 0 )
        {
            self.pStep2SubView03Btn.enabled = NO;
            [self.pStep2SubView03Btn setBackgroundImage:[UIImage imageNamed:@"purchase_dimmed.png"] forState:UIControlStateNormal];
            self.pStep2SubView03TitleLbl.textColor = [UIColor whiteColor];
            self.pStep2SubView03MoneyLbl.textColor = [UIColor whiteColor];
            self.pStep2SubView03ContentLbl01.textColor = [UIColor whiteColor];
            self.pStep2SubView03ContentLbl02.textColor = [UIColor whiteColor];
        }
        else
        {
            self.pStep2SubView03Btn.enabled = YES;
            [self.pStep2SubView03Btn setBackgroundImage:[UIImage imageNamed:@"purchase_normal.png"] forState:UIControlStateNormal];
            self.pStep2SubView03TitleLbl.textColor = [UIColor colorWithRed:123.0f/255.0f green:90.0f/255.0f blue:163.0f/255.0f alpha:1.0f];
            self.pStep2SubView03MoneyLbl.textColor = [UIColor blackColor];
            self.pStep2SubView03ContentLbl01.textColor = [UIColor blackColor];
            self.pStep2SubView03ContentLbl02.textColor = [UIColor blackColor];
        }

        
        self.pStep2SubView03MoneyLbl.text = [NSString stringWithFormat:@"%@원", [[CMAppManager sharedInstance] insertComma:sTotalMoneyBalance]];
        
        [self.pCouponBalanceArr removeAllObjects];
        
        NSObject *itemObject = [[[vodBuy objectAtIndex:0] objectForKey:@"couponList"] objectForKey:@"coupon"];
        
        if ( [itemObject isKindOfClass:[NSDictionary class]] )
        {
            [self.pCouponBalanceArr addObject:itemObject];
        }
        else
        {
            [self.pCouponBalanceArr setArray:(NSArray *)itemObject];
        }
        
        
        
        [self setCouponBalanceInit];
    }];
    
    [UIAlertView showAlertViewForTaskWithErrorOnCompletion:tesk delegate:nil];
}

#pragma mark - TV 포인트 결제
- (void)requestWithGetPointBalance
{
    NSURLSessionDataTask *tesk = [NSMutableDictionary vodGetPointBalanceCompletion:^(NSArray *vodBuy, NSError *error) {
        
        DDLogError(@"tv 포인트 결제 = [%@]", vodBuy);
        
        if ( [vodBuy count] == 0 )
            return;
        
        if ( [[[vodBuy objectAtIndex:0] objectForKey:@"resultCode"] isEqualToString:@"100"] )
        {
            NSString *sPointBalance = [[vodBuy objectAtIndex:0] objectForKey:@"pointBalance"];
            self.nPointBalance = [sPointBalance intValue];
            
            self.pStep2SubView04MoneyLbl.text = [NSString stringWithFormat:@"잔액%@원", [[CMAppManager sharedInstance] insertComma:sPointBalance]];
            
            NSString *step1Price = @"";
            
            if ( self.nStep1BtnTag == VOD_BUY_VIEW_BTN_01 )
            {
                step1Price = [[self.pProductArr objectAtIndex:0] objectForKey:@"price"];
            }
            else if ( self.nStep1BtnTag == VOD_BUY_VIEW_BTN_02 )
            {
                step1Price = [[self.pProductArr objectAtIndex:1] objectForKey:@"price"];
            }
            else if ( self.nStep1BtnTag == VOD_BUY_VIEW_BTN_03 )
            {
                step1Price = [[self.pProductArr objectAtIndex:2] objectForKey:@"price"];
            }
            
            int nStep1Price = [step1Price intValue];
            
            if( nStep1Price > self.nPointBalance )
            {
                // tv 포인트 딤 처리
                self.pStep2SubView04Btn.enabled = NO;
                [self.pStep2SubView04Btn setBackgroundImage:[UIImage imageNamed:@"purchase_dimmed.png"] forState:UIControlStateNormal];
                
                self.pStep2SubView04TitleLbl.textColor = [UIColor whiteColor];
                self.pStep2SubView04MoneyLbl.textColor = [UIColor whiteColor];
                self.pStep2SubView04ContentLbl01.textColor = [UIColor whiteColor];
                self.pStep2SubView04ContentLbl02.textColor = [UIColor whiteColor];
            }
            else
            {
                self.pStep2SubView04Btn.enabled = YES;
                [self.pStep2SubView04Btn setBackgroundImage:[UIImage imageNamed:@"purchase_normal.png"] forState:UIControlStateNormal];
                
                self.pStep2SubView04TitleLbl.textColor = [UIColor colorWithRed:123.0f/255.0f green:90.0f/255.0f blue:163.0f/255.0f alpha:1.0f];
                self.pStep2SubView04MoneyLbl.textColor = [UIColor blackColor];
                self.pStep2SubView04ContentLbl01.textColor = [UIColor blackColor];
                self.pStep2SubView04ContentLbl02.textColor = [UIColor blackColor];


            }
        }
        else
        {
            self.pStep2SubView04MoneyLbl.text = @"잔액0원";
        }
    }];
    
    [UIAlertView showAlertViewForTaskWithErrorOnCompletion:tesk delegate:nil];
}

- (void)setCouponBalanceInit
{
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    
    for ( NSDictionary *dic in self.pCouponBalanceArr )
    {
        NSString *disMasterId = [NSString stringWithFormat:@"%@", [dic objectForKey:@"discountCouponMasterId"]];
        
        for ( NSString *subStr in self.pDiscountCouponMasterIdArr )
        {
            if ( [subStr isEqualToString:disMasterId] )
            {
                self.pStep2SubView02SaleImageView.hidden = NO;
                self.isDiscount = YES;
                
                NSString *sDiscountAmount = [NSString stringWithFormat:@"%@", [dic objectForKey:@"discountAmount"]];
                [arr addObject:sDiscountAmount];
            }
        }
    }
    
    if ( self.isDiscount == YES )
    {
        NSString *sPrice = [NSString stringWithFormat:@"%@",[[CMAppManager sharedInstance] insertComma:[[self.pProductArr objectAtIndex:0] objectForKey:@"price"]]];
        int nPrice = [[[self.pProductArr objectAtIndex:0] objectForKey:@"price"] intValue];
        self.nDisPrice = [[arr objectAtIndex:0] intValue];
        
        self.pStep2SubView02MoneyLbl.strikeThroughEnabled = YES;
        self.pStep2SubView02MoneyLbl.text = [NSString stringWithFormat:@"%@원", sPrice];
        self.pStep2SubView02MoneyLbl02.hidden = NO;
        
        self.pStep2SubView02MoneyLbl02.text = [NSString stringWithFormat:@"%@원", [[CMAppManager sharedInstance] insertComma:[NSString stringWithFormat:@"%d", nPrice - self.nDisPrice]]];
    }
    else
    {
        NSString *sPrice = [NSString stringWithFormat:@"%@",[[CMAppManager sharedInstance] insertComma:[[self.pProductArr objectAtIndex:0] objectForKey:@"price"]]];
        self.pStep2SubView02MoneyLbl.text = [NSString stringWithFormat:@"%@원", sPrice];
    }
    
    
}



#pragma mark - 결제 전문
#pragma mark - 일반 결제
//- (void)requestWithPurchaseAssetEx2
//{
//    NSString *sProductId = @"";
//    NSString *goodId = @"";
//    NSObject *itemObjet = [[[[self pDetailDataDic] objectForKey:@"asset"] objectForKey:@"productList"] objectForKey:@"product"];
//
//    switch (self.nStep1BtnTag) {
//        case VOD_BUY_VIEW_BTN_01:
//        {
//            if ( [itemObjet isKindOfClass:[NSDictionary class]] )
//            {
//                sProductId = [(NSDictionary *)itemObjet objectForKey:@"productId"];
//
//                NSArray *goodIdArrKey = [(NSDictionary *)itemObjet allKeys];
//
//                for ( NSString *goodStr in goodIdArrKey )
//                {
//                    if ( [goodStr isEqualToString:@"goodId"] )
//                    {
//                        goodId = [NSString stringWithFormat:@"%@", [(NSDictionary *)itemObjet objectForKey:@"goodId"]];
//                    }
//                }
//            }
//            else
//            {
//                sProductId = [[(NSArray *)itemObjet objectAtIndex:0] objectForKey:@"productId"];
//
//                NSArray *goodIdArrKey = [[(NSArray *)itemObjet objectAtIndex:0] allKeys];
//
//                for ( NSString *goodStr in goodIdArrKey )
//                {
//                    if ( [goodStr isEqualToString:@"goodId"] )
//                    {
//                        goodId = [NSString stringWithFormat:@"%@", [[(NSArray *)itemObjet objectAtIndex:0] objectForKey:@"goodId"]];
//                    }
//                }
//            }
//        }break;
//        case VOD_BUY_VIEW_BTN_02:
//        {
//            sProductId = [[(NSArray *)itemObjet objectAtIndex:1] objectForKey:@"productId"];
//
//            NSArray *goodIdArrKey = [[(NSArray *)itemObjet objectAtIndex:1] allKeys];
//
//            for ( NSString *goodStr in goodIdArrKey )
//            {
//                if ( [goodStr isEqualToString:@"goodId"] )
//                {
//                    goodId = [NSString stringWithFormat:@"%@", [[(NSArray *)itemObjet objectAtIndex:1] objectForKey:@"goodId"]];
//                }
//            }
//        }break;
//        case VOD_BUY_VIEW_BTN_03:
//        {
//            sProductId = [[(NSArray *)itemObjet objectAtIndex:2] objectForKey:@"productId"];
//
//            NSArray *goodIdArrKey = [[(NSArray *)itemObjet objectAtIndex:2] allKeys];
//
//            for ( NSString *goodStr in goodIdArrKey )
//            {
//                if ( [goodStr isEqualToString:@"goodId"] )
//                {
//                    goodId = [NSString stringWithFormat:@"%@", [[(NSArray *)itemObjet objectAtIndex:2] objectForKey:@"goodId"]];
//                }
//            }
//        }break;
//    }
//
////    NSURLSessionDataTask *tesk = [NSMutableDictionary paymentPurchaseAssetEx2WithProductId:<#(NSString *)#> WithGoodId:<#(NSString *)#> WithUiComponentDomain:<#(NSString *)#> WithUiComponentId:<#(NSString *)#> WithPrice:<#(NSString *)#> completion:<#^(NSArray *preference, NSError *error)block#>]
//}


#pragma mark - 쿠폰 결제


#pragma mark - TV 포인트 결제

#pragma mark - 복합결제


/*!<
 
 #pragma mark - 전문
 #pragma mark - 결제 타입
 - (void)requestWithPaymenetGetAvailablePaymentType
 {
 NSURLSessionDataTask *tesk = [NSMutableDictionary paymentGetAvailablePaymentTypeWithDomainId:@"CnM" completion:^(NSArray *preference, NSError *error) {
 
 DDLogError(@"결제 타입 = %@]", preference);
 
 // 일단 일반 만 해 놓자
 self.pStep2SubView02Btn.enabled = YES;
 self.pStep2SubView03Btn.enabled = NO;
 self.pStep2SubView04Btn.enabled = NO;
 
 [self.pStep2SubView03Btn setBackgroundImage:[UIImage imageNamed:@"purchase_dimmed.png"] forState:UIControlStateNormal];
 [self.pStep2SubView04Btn setBackgroundImage:[UIImage imageNamed:@"purchase_dimmed.png"] forState:UIControlStateNormal];
 }];
 
 [UIAlertView showAlertViewForTaskWithErrorOnCompletion:tesk delegate:nil];
 }
 
 #pragma mark - 일반 결제
 - (void)requestWithPurchaseAssetEx2
 {
 NSLog(@"일반 결제");
 
 NSObject *itemObj = [[[[self pDetailDataDic] objectForKey:@"asset"] objectForKey:@"productList"] objectForKey:@"product"];
 
 if ( [itemObj isKindOfClass:[NSDictionary class]] )
 {
 NSString *sProductId = [NSString stringWithFormat:@"%@", [[[[[self pDetailDataDic] objectForKey:@"asset"] objectForKey:@"productList"] objectForKey:@"product"] objectForKey:@"productId"]];
 NSString *sGoodi = [NSString stringWithFormat:@"%@", [[[[[self pDetailDataDic] objectForKey:@"asset"] objectForKey:@"productList"] objectForKey:@"product"] objectForKey:@"goodId"]];
 NSString *sPrice = [NSString stringWithFormat:@"%@", [[[[[self pDetailDataDic] objectForKey:@"asset"] objectForKey:@"productList"] objectForKey:@"product"] objectForKey:@"price"]];
 
 NSURLSessionDataTask *tesk = [NSMutableDictionary paymentPurchaseAssetEx2WithProductId:sProductId WithGoodId:sGoodi WithUiComponentDomain:sPrice WithUiComponentId:@"0" WithPrice:@"0" completion:^(NSArray *preference, NSError *error) {
 
 DDLogError(@"preference = [%@]", preference);
 }];
 
 [UIAlertView showAlertViewForTaskWithErrorOnCompletion:tesk delegate:nil];
 
 }
 else if ( [itemObj isKindOfClass:[NSArray class]] )
 {
 NSString *sProductId = [NSString stringWithFormat:@"%@", [[[[[[self pDetailDataDic] objectForKey:@"asset"] objectForKey:@"productList"] objectForKey:@"product"] objectAtIndex:0] objectForKey:@"productId"]];
 NSString *sGoodi = [NSString stringWithFormat:@"%@", [[[[[[self pDetailDataDic] objectForKey:@"asset"] objectForKey:@"productList"] objectForKey:@"product"] objectAtIndex:0] objectForKey:@"goodId"]];
 NSString *sPrice = [NSString stringWithFormat:@"%@", [[[[[[self pDetailDataDic] objectForKey:@"asset"] objectForKey:@"productList"] objectForKey:@"product"] objectAtIndex:0] objectForKey:@"price"]];
 
 NSURLSessionDataTask *tesk = [NSMutableDictionary paymentPurchaseAssetEx2WithProductId:sProductId WithGoodId:sGoodi WithUiComponentDomain:@"0" WithUiComponentId:@"0" WithPrice:sPrice completion:^(NSArray *preference, NSError *error) {
 
 DDLogError(@"preference = [%@]", preference);
 }];
 
 [UIAlertView showAlertViewForTaskWithErrorOnCompletion:tesk delegate:nil];
 
 }
 
 
 }
 
 - (void)VodPopUpViewWithTag:(int)nTag
 {
 [self.navigationController popViewControllerAnimated:YES];
 [self.delegate VodBuyViewWithTag:0];
 }
 
 */

@end
