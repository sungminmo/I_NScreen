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
@property (nonatomic, strong) NSString *sSeriesLink;

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
    self.scrollContainer.contentSize = CGSizeMake(self.view.bounds.size.width, 642);
    
    self.sSeriesLink = [NSString stringWithFormat:@"%@", [[self.pDetailDataDic objectForKey:@"asset"] objectForKey:@"seriesLink"]];
    
    self.pProductArr = [[NSMutableArray alloc] init];
    self.pCouponBalanceArr = [[NSMutableArray alloc] init];
    
    NSObject *itemObject = [[[self.pDetailDataDic objectForKey:@"asset"] objectForKey:@"productList"] objectForKey:@"product"];
    
    if ( [itemObject isKindOfClass:[NSDictionary class]] )
    {
        [self.pProductArr addObject:itemObject];
    }
    else
    {
        [self.pProductArr setArray:(NSArray *)itemObject];
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
        self.pStep1SubView02MoneyLbl.text = [NSString stringWithFormat:@"%@원", sPrice];
    }
    // 묶음
    else if ( [sProductType isEqualToString:@"Bundle"] )
    {
        self.pStep1SubView02TitleLbl.text = @"묶음 할인상품 구매";
        self.pStep1SubView02MoneyLbl.text = [NSString stringWithFormat:@"%@원", sPrice];
    }
    // 월정액 시리즈
    else if ( [sProductType isEqualToString:@"SVOD"] )
    {
        NSString *sSvod = [NSString stringWithFormat:@"%@", [[self.pProductArr objectAtIndex:0] objectForKey:@"productName"]];
        NSArray *svodArr = [sSvod componentsSeparatedByString:@":"];
        self.pStep1SubView02TitleLbl.text = [NSString stringWithFormat:@"%@", [svodArr objectAtIndex:0]];
        self.pStep1SubView02MoneyLbl.text = [NSString stringWithFormat:@"%@원 / 월", sPrice];
    }
    // 시리즈 전체 회차 구매
    else if ( [sProductType isEqualToString:@"Package"] )
    {
        self.pStep1SubView02TitleLbl.text = @"시리즈 전체회차 구매";
        self.pStep1SubView02MoneyLbl.text = [NSString stringWithFormat:@"%@원", sPrice];
    }
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
        self.pStep1SubView03MoneyLbl.text = [NSString stringWithFormat:@"%@원", sPrice];
    }
    // 묶음
    else if ( [sProductType isEqualToString:@"Bundle"] )
    {
        self.pStep1SubView03TitleLbl.text = @"묶음 할인상품 구매";
        self.pStep1SubView03MoneyLbl.text = [NSString stringWithFormat:@"%@원", sPrice];
    }
    // 월정액 시리즈
    else if ( [sProductType isEqualToString:@"SVOD"] )
    {
        NSString *sSvod = [NSString stringWithFormat:@"%@", [[self.pProductArr objectAtIndex:1] objectForKey:@"productName"]];
        NSArray *svodArr = [sSvod componentsSeparatedByString:@":"];
        self.pStep1SubView03TitleLbl.text = [NSString stringWithFormat:@"%@", [svodArr objectAtIndex:0]];
        self.pStep1SubView03MoneyLbl.text = [NSString stringWithFormat:@"%@원 / 월", sPrice];
    }
    // 시리즈 전체 회차 구매
    else if ( [sProductType isEqualToString:@"Package"] )
    {
        self.pStep1SubView03TitleLbl.text = @"시리즈 전체회차 구매";
        self.pStep1SubView03MoneyLbl.text = [NSString stringWithFormat:@"%@원", sPrice];
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
        self.pStep1SubView04MoneyLbl.text = [NSString stringWithFormat:@"%@원", sPrice];
    }
    // 묶음
    else if ( [sProductType isEqualToString:@"Bundle"] )
    {
        self.pStep1SubView04TitleLbl.text = @"묶음 할인상품 구매";
        self.pStep1SubView04MoneyLbl.text = [NSString stringWithFormat:@"%@원", sPrice];
    }
    // 월정액 시리즈
    else if ( [sProductType isEqualToString:@"SVOD"] )
    {
        NSString *sSvod = [NSString stringWithFormat:@"%@", [[self.pProductArr objectAtIndex:2] objectForKey:@"productName"]];
        NSArray *svodArr = [sSvod componentsSeparatedByString:@":"];
        self.pStep1SubView04TitleLbl.text = [NSString stringWithFormat:@"%@", [svodArr objectAtIndex:0]];
        self.pStep1SubView04MoneyLbl.text = [NSString stringWithFormat:@"%@원 / 월", sPrice];
    }
    // 시리즈 전체 회차 구매
    else if ( [sProductType isEqualToString:@"Package"] )
    {
        self.pStep1SubView04TitleLbl.text = @"시리즈 전체회차 구매";
        self.pStep1SubView04MoneyLbl.text = [NSString stringWithFormat:@"%@원", sPrice];
    }

}

- (IBAction)onBtnClicked:(UIButton *)btn
{
    switch ([btn tag]) {
        case VOD_BUY_VIEW_BTN_01:
        {
            
        }break;
        case VOD_BUY_VIEW_BTN_02:
        {
            
        }break;
        case VOD_BUY_VIEW_BTN_03:
        {
            
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
        
        
    }];
    
    [UIAlertView showAlertViewForTaskWithErrorOnCompletion:tesk delegate:nil];
}

/*!<
#pragma mark - 화면 초기화
- (void)setViewInit
{
    self.title = @"상세정보";
    self.isUseNavigationBar = YES;
    self.scrollContainer.contentSize = CGSizeMake(self.view.bounds.size.width, 642);
    
    self.pPaymentTypeArr = [[NSMutableArray alloc] init];
    
    self.pBuyTypeArr = [[NSMutableArray alloc] init];

    
    NSString *sSeriesLink = [NSString stringWithFormat:@"%@", [[[self pDetailDataDic] objectForKey:@"asset"] objectForKey:@"seriesLink"]];
    NSObject *itemObj = [[[[self pDetailDataDic] objectForKey:@"asset"] objectForKey:@"productList"] objectForKey:@"product"];
    
    if ( [itemObj isKindOfClass:[NSDictionary class]] )
    {
        NSString *sProductType = [NSString stringWithFormat:@"%@", [(NSDictionary *)itemObj objectForKey:@"productType"]];
        NSString *sPrice = [NSString stringWithFormat:@"%@", [(NSDictionary *)itemObj objectForKey:@"price"]];
        NSMutableDictionary *pDic = [[NSMutableDictionary alloc] init];
        
        if ( [sSeriesLink isEqualToString:@"0"] )
        {
            // 시리즈가 아님
            if ( [sProductType isEqualToString:@"Bundle"] )
            {
                // 묶음 상품
                // 묶음 할인 상품 구매, 월정액, 통합월정액
                [pDic setObject:sPrice forKey:@"price"];
                [pDic setObject:sProductType forKey:@"productType"];
                [pDic setObject:@"묶음 할인상품 구매" forKey:@"productName"];

                [self.pBuyTypeArr addObject:pDic];
//                [self.pBuyTypeArr addObject:@"월정액"];
//                [self.pBuyTypeArr addObject:@"통합 월정액"];
                
            }
            else
            {
                // 단일 상품
                // 단일 상품 구매, 월정액, 통합월정액
                [pDic setObject:sPrice forKey:@"price"];
                [pDic setObject:sProductType forKey:@"productType"];
                [pDic setObject:@"단일 상품 구매" forKey:@"productName"];
                
                [self.pBuyTypeArr addObject:pDic];
//                [self.pBuyTypeArr addObject:@"월정액"];
//                [self.pBuyTypeArr addObject:@"통합 월정액"];
            }
        }
        else
        {
            // 시리즈임
            // 단일 회차, 월정액, 통합 월정액
            [pDic setObject:sPrice forKey:@"price"];
            [pDic setObject:sProductType forKey:@"productType"];
            [pDic setObject:@"단일 회차 구매" forKey:@"productName"];
            
            [self.pBuyTypeArr addObject:pDic];
//            [self.pBuyTypeArr addObject:@"월정액"];
//            [self.pBuyTypeArr addObject:@"통합 월정액"];
        }
    }
    else if ( [itemObj isKindOfClass:[NSArray class]] )
    {
        if  ( [sSeriesLink isEqualToString:@"0"] )
        {
            BOOL isBundle = NO;
            BOOL isSvod = NO;       // 월정액 체크
            BOOL isRvod = NO;       // 단일 상품 체크
            
            
            NSMutableDictionary *pDic1 = [[NSMutableDictionary alloc] init];
            NSMutableDictionary *pDic2 = [[NSMutableDictionary alloc] init];
            NSMutableDictionary *pDic3 = [[NSMutableDictionary alloc] init];
            
            
            // 시리즈가 아님
            for ( NSDictionary *dic in (NSArray *)itemObj )
            {
                NSString *sProductType = [NSString stringWithFormat:@"%@", [dic objectForKey:@"productType"]];
                NSString *sPrice = [NSString stringWithFormat:@"%@", [dic objectForKey:@"price"]];
                if ( [sProductType isEqualToString:@"Bundle"] )
                {
                    // 단일 상품 구매 , 묶음 상품 구매
                    isBundle = YES;
                    [pDic1 setObject:sPrice forKey:@"price"];
                    [pDic1 setObject:sProductType forKey:@"productType"];
                    [pDic1 setObject:@"묶음 상품 구매" forKey:@"productName"];
                }
                if ( [sProductType isEqualToString:@"SVOD"] )
                {
                    // 월정액 인지 아닌지
                    isSvod = YES;
                    
                    [pDic2 setObject:sPrice forKey:@"price"];
                    [pDic2 setObject:sProductType forKey:@"productType"];
                    [pDic2 setObject:@"월정액" forKey:@"productName"];

                }
                if ( [sProductType isEqualToString:@"RVOD"] )
                {
                    // 단일 상품 체크
                    isRvod = YES;
                    
                    [pDic3 setObject:sPrice forKey:@"price"];
                    [pDic3 setObject:sProductType forKey:@"productType"];
                    [pDic3 setObject:@"단일 상품 구매" forKey:@"productName"];
                }
            }
            
            if ( isBundle == YES )
            {
                // 묶음 상품 구매
                if ( isRvod == YES )
                {
                    // 단일 상품 구매
                    [self.pBuyTypeArr addObject:pDic3];
                    [self.pBuyTypeArr addObject:pDic1];
                    
                    if ( isSvod == YES )
                    {
                        // 월정액
                        [self.pBuyTypeArr addObject:pDic2];
                    }
                }
                else
                {
                    if ( isRvod == YES )
                    {
                        // 단일 상품 구매
                        [self.pBuyTypeArr addObject:pDic3];
                        [self.pBuyTypeArr addObject:pDic1];
                        
                        if ( isSvod == YES )
                        {
                            [self.pBuyTypeArr addObject:pDic2];
                        }
                    }
                    else
                    {
                         [self.pBuyTypeArr addObject:pDic1];
                        if ( isSvod == YES )
                        {
                            [self.pBuyTypeArr addObject:pDic2];
                        }
                    }
                    
                    
                }
            }
            else
            {
                // 단일 상품 구매, 월정액, 통합 월정액
                if ( isRvod == YES )
                {
                    // 단일 상품 구매
                    if ( isSvod == YES )
                    {
                        // 월정액
                        [self.pBuyTypeArr addObject:pDic3];
                        [self.pBuyTypeArr addObject:pDic2];
                    }
                    else
                    {
                        [self.pBuyTypeArr addObject:pDic3];
                    }
                }
            }
            
        }
        else
        {
            // 시리즈임
            // 시리즈이면 단일 회차 구매, 시리즈 전체 회차 구매
            NSString *sProductType = [NSString stringWithFormat:@"%@", [[(NSArray *)itemObj objectAtIndex:0] objectForKey:@"productType"]];
            NSString *sPrice = [NSString stringWithFormat:@"%@", [[(NSArray *)itemObj objectAtIndex:1] objectForKey:@"price"]];
            
            NSMutableDictionary *pDic1 = [[NSMutableDictionary alloc] init];
            NSMutableDictionary *pDic2 = [[NSMutableDictionary alloc] init];
            
            [pDic1 setObject:sProductType forKey:@"productType"];
            [pDic1 setObject:sPrice forKey:@"price"];
            [pDic1 setObject:@"단일 회차 구매" forKey:@"productName"];
            
            [pDic2 setObject:sProductType forKey:@"productType"];
            [pDic2 setObject:sPrice forKey:@"price"];
            [pDic2 setObject:@"시리즈 전체회차 구매" forKey:@"productName"];
            
        }
    }
    
    [self setBtnTitle];
}


#pragma mark - 구매 상품 버튼 타이틀 셋팅
- (void)setBtnTitle
{
    self.pStep1SubView02.hidden = YES;
    self.pStep1SubView03.hidden = YES;
    self.pStep1SubView04.hidden = YES;
    for ( int i =0; i < [self.pBuyTypeArr count]; i++ )
    {
        switch (i) {
            case 0:
            {
                self.pStep1SubView02.hidden = NO;
                self.pStep1SubView02TitleLbl.text = [NSString stringWithFormat:@"%@", [[self.pBuyTypeArr objectAtIndex:i] objectForKey:@"productName"]];
                self.pStep1SubView02MoneyLbl.text = [NSString stringWithFormat:@"%@", [[self.pBuyTypeArr objectAtIndex:i] objectForKey:@"price"]];
            }break;
            case 1:
            {
                self.pStep1SubView03.hidden = NO;
                self.pStep1SubView03TitleLbl.text = [NSString stringWithFormat:@"%@", [[self.pBuyTypeArr objectAtIndex:i] objectForKey:@"productName"]];
                self.pStep1SubView03MoneyLbl.text = [NSString stringWithFormat:@"%@", [[self.pBuyTypeArr objectAtIndex:i] objectForKey:@"price"]];
            }break;
            case 2:
            {
                self.pStep1SubView04.hidden = NO;
                self.pStep1SubView04TitleLbl.text = [NSString stringWithFormat:@"%@", [[self.pBuyTypeArr objectAtIndex:i] objectForKey:@"productName"]];
                self.pStep1SubView04MoneyLbl.text = [NSString stringWithFormat:@"%@", [[self.pBuyTypeArr objectAtIndex:i] objectForKey:@"price"]];
            }break;
        }
        
    }
}

- (void)setBtnSubDepthWithTitle:(NSDictionary *)pDic
{
    self.pStep2SubView02.hidden = NO;
    self.pStep2SubView03.hidden = NO;
    self.pStep2SubView04.hidden = NO;
    
    self.pNoBuyLbl01.hidden = YES;
    self.pNoBuyLbl02.hidden = YES;
    self.pNoBuyLbl03.hidden = YES;
    self.pNoBuyLbl04.hidden = YES;
    
    if ( [[pDic objectForKey:@"productName"] isEqualToString:@"단일 회차 구매"] )
    {
        
    }
    else if ( [[pDic objectForKey:@"productName"] isEqualToString:@"단일 상품 구매"])
    {
    
    }
    else if ( [[pDic objectForKey:@"productName"] isEqualToString:@"시리즈 전체회차 구매"] )
    {
    
    }
    else if ( [[pDic objectForKey:@"productName"] isEqualToString:@"묶음 할인 상품 구매"] )
    {
    
    }
    else if ( [[pDic objectForKey:@"productName"] isEqualToString:@"월정액"] )
    {
        self.pStep2SubView02.hidden = YES;
        self.pStep2SubView03.hidden = YES;
        self.pStep2SubView04.hidden = YES;
        
        self.pNoBuyLbl01.hidden = NO;
        self.pNoBuyLbl02.hidden = NO;
        self.pNoBuyLbl03.hidden = NO;
        self.pNoBuyLbl04.hidden = NO;
    }
    else if ( [[pDic objectForKey:@"productName"] isEqualToString:@"통합 월정액"] )
    {
        self.pStep2SubView02.hidden = YES;
        self.pStep2SubView03.hidden = YES;
        self.pStep2SubView04.hidden = YES;
        
        self.pNoBuyLbl01.hidden = NO;
        self.pNoBuyLbl02.hidden = NO;
        self.pNoBuyLbl03.hidden = NO;
        self.pNoBuyLbl04.hidden = NO;
    }
}

#pragma mark - 액션 이벤트
#pragma mark - 버튼 액션 이벤트
- (IBAction)onBtnClicked:(UIButton *)btn
{
    switch ([btn tag]) {
        case VOD_BUY_VIEW_BTN_01:
        {
            // 구매 버튼1
            [self.pStep1SubView02Btn setBackgroundImage:[UIImage imageNamed:@"purchase_select.jpg"] forState:UIControlStateNormal];
            [self.pStep1SubView03Btn setBackgroundImage:[UIImage imageNamed:@"purchase_normal.png"] forState:UIControlStateNormal];
            [self.pStep1SubView04Btn setBackgroundImage:[UIImage imageNamed:@"purchase_normal.png"] forState:UIControlStateNormal];
            
            self.pStep1SubView02TitleLbl.textColor = [UIColor whiteColor];
            self.pStep1SubView02MoneyLbl.textColor = [UIColor whiteColor];
            
            self.pStep1SubView03TitleLbl.textColor = [UIColor colorWithRed:123.0f/255.0f green:90.0f/255.0f blue:163.0f/255.0f alpha:1.0f];
            self.pStep1SubView03MoneyLbl.textColor = [UIColor blackColor];
            
            self.pStep1SubView04TitleLbl.textColor = [UIColor colorWithRed:123.0f/255.0f green:90.0f/255.0f blue:163.0f/255.0f alpha:1.0f];
            self.pStep1SubView04MoneyLbl.textColor = [UIColor blackColor];
            
            [self setBtnSubDepthWithTitle:[self.pBuyTypeArr objectAtIndex:0]];
        }break;
        case VOD_BUY_VIEW_BTN_02:
        {
            // 구매 버튼2
            [self.pStep1SubView02Btn setBackgroundImage:[UIImage imageNamed:@"purchase_normal.png"] forState:UIControlStateNormal];
            [self.pStep1SubView03Btn setBackgroundImage:[UIImage imageNamed:@"purchase_select.jpg"] forState:UIControlStateNormal];
            [self.pStep1SubView04Btn setBackgroundImage:[UIImage imageNamed:@"purchase_normal.png"] forState:UIControlStateNormal];
            
            self.pStep1SubView02TitleLbl.textColor = [UIColor colorWithRed:123.0f/255.0f green:90.0f/255.0f blue:163.0f/255.0f alpha:1.0f];
            self.pStep1SubView02MoneyLbl.textColor = [UIColor blackColor];
            
            self.pStep1SubView03TitleLbl.textColor = [UIColor whiteColor];
            self.pStep1SubView03MoneyLbl.textColor = [UIColor whiteColor];
            
            self.pStep1SubView04TitleLbl.textColor = [UIColor colorWithRed:123.0f/255.0f green:90.0f/255.0f blue:163.0f/255.0f alpha:1.0f];
            self.pStep1SubView04MoneyLbl.textColor = [UIColor blackColor];
            [self setBtnSubDepthWithTitle:[self.pBuyTypeArr objectAtIndex:1]];
            
            
        }break;
        case VOD_BUY_VIEW_BTN_03:
        {
            // 구매 버튼3
            [self.pStep1SubView02Btn setBackgroundImage:[UIImage imageNamed:@"purchase_normal.png"] forState:UIControlStateNormal];
            [self.pStep1SubView03Btn setBackgroundImage:[UIImage imageNamed:@"purchase_normal.png"] forState:UIControlStateNormal];
            [self.pStep1SubView04Btn setBackgroundImage:[UIImage imageNamed:@"purchase_select.jpg"] forState:UIControlStateNormal];
            
            self.pStep1SubView02TitleLbl.textColor = [UIColor colorWithRed:123.0f/255.0f green:90.0f/255.0f blue:163.0f/255.0f alpha:1.0f];
            self.pStep1SubView02MoneyLbl.textColor = [UIColor blackColor];
            
            self.pStep1SubView03TitleLbl.textColor = [UIColor colorWithRed:123.0f/255.0f green:90.0f/255.0f blue:163.0f/255.0f alpha:1.0f];
            self.pStep1SubView03MoneyLbl.textColor = [UIColor blackColor];
            
            self.pStep1SubView04TitleLbl.textColor = [UIColor whiteColor];
            self.pStep1SubView04MoneyLbl.textColor = [UIColor whiteColor];
            [self setBtnSubDepthWithTitle:[self.pBuyTypeArr objectAtIndex:2]];
        }break;
        case VOD_BUY_VIEW_BTN_04:
        {
            // 결제 버튼1
            [self.pStep2SubView02Btn setBackgroundImage:[UIImage imageNamed:@"purchase_select.jpg"] forState:UIControlStateNormal];
//            [self.pStep2SubView03Btn setBackgroundImage:[UIImage imageNamed:@"purchase_normal.png"] forState:UIControlStateNormal];
//            [self.pStep2SubView04Btn setBackgroundImage:[UIImage imageNamed:@"purchase_normal.png"] forState:UIControlStateNormal];
            
            self.pStep2SubView02TitleLbl.textColor = [UIColor whiteColor];
            self.pStep2SubView02MoneyLbl.textColor = [UIColor whiteColor];
            
//            self.pStep2SubView03TitleLbl.textColor = [UIColor colorWithRed:123.0f/255.0f green:90.0f/255.0f blue:163.0f/255.0f alpha:1.0f];
//            self.pStep2SubView03MoneyLbl.textColor = [UIColor blackColor];
//            
//            self.pStep2SubView04TitleLbl.textColor = [UIColor colorWithRed:123.0f/255.0f green:90.0f/255.0f blue:163.0f/255.0f alpha:1.0f];
//            self.pStep2SubView04MoneyLbl.textColor = [UIColor blackColor];
            // 일반 결제
//            VodPopUpViewController *pViewController = [[VodPopUpViewController alloc] initWithNibName:@"VodPopUpViewController" bundle:nil];
//            
//            [self addChildViewController:pViewController];
//            [pViewController didMoveToParentViewController:self];
//            [self.view addSubview:pViewController.view];
//
            // 결제 테스트
//            [self requestWithPurchaseAssetEx2];
//            [SIAlertView alert:@"알림" message:@"일반 결제 테스트 중입니다." button:nil];
//            
        }break;
        case VOD_BUY_VIEW_BTN_05:
        {
            // 결제 버튼2
            [self.pStep2SubView02Btn setBackgroundImage:[UIImage imageNamed:@"purchase_normal.png"] forState:UIControlStateNormal];
            [self.pStep2SubView03Btn setBackgroundImage:[UIImage imageNamed:@"purchase_select.jpg"] forState:UIControlStateNormal];
            [self.pStep2SubView04Btn setBackgroundImage:[UIImage imageNamed:@"purchase_normal.png"] forState:UIControlStateNormal];
            
            self.pStep2SubView02TitleLbl.textColor = [UIColor colorWithRed:123.0f/255.0f green:90.0f/255.0f blue:163.0f/255.0f alpha:1.0f];
            self.pStep2SubView02MoneyLbl.textColor = [UIColor blackColor];
            
            self.pStep2SubView03TitleLbl.textColor = [UIColor whiteColor];
            self.pStep2SubView03MoneyLbl.textColor = [UIColor whiteColor];
            
            self.pStep2SubView04TitleLbl.textColor = [UIColor colorWithRed:123.0f/255.0f green:90.0f/255.0f blue:163.0f/255.0f alpha:1.0f];
            self.pStep2SubView04MoneyLbl.textColor = [UIColor blackColor];
        }break;
        case VOD_BUY_VIEW_BTN_06:
        {
            // 결제 버튼3
            [self.pStep2SubView02Btn setBackgroundImage:[UIImage imageNamed:@"purchase_normal.png"] forState:UIControlStateNormal];
            [self.pStep2SubView03Btn setBackgroundImage:[UIImage imageNamed:@"purchase_normal.png"] forState:UIControlStateNormal];
            [self.pStep2SubView04Btn setBackgroundImage:[UIImage imageNamed:@"purchase_select.jpg"] forState:UIControlStateNormal];
            
            self.pStep2SubView02TitleLbl.textColor = [UIColor colorWithRed:123.0f/255.0f green:90.0f/255.0f blue:163.0f/255.0f alpha:1.0f];
            self.pStep2SubView02MoneyLbl.textColor = [UIColor blackColor];
            
            self.pStep2SubView03TitleLbl.textColor = [UIColor colorWithRed:123.0f/255.0f green:90.0f/255.0f blue:163.0f/255.0f alpha:1.0f];
            self.pStep2SubView03MoneyLbl.textColor = [UIColor blackColor];
            
            self.pStep2SubView04TitleLbl.textColor = [UIColor whiteColor];
            self.pStep2SubView04MoneyLbl.textColor = [UIColor whiteColor];
        }break;
        case VOD_BUY_VIEW_BTN_07:
        {
            // 취소
            [self.navigationController popViewControllerAnimated:YES];
        }break;
        case VOD_BUY_VIEW_BTN_08:
        {
            // 결제 하기

            VodPopUpViewController *pViewController = [[VodPopUpViewController alloc] initWithNibName:@"VodPopUpViewController" bundle:nil];
            self.navigationController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
            pViewController.navigationController.modalPresentationStyle= UIModalPresentationCurrentContext;
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0f) {
                pViewController.modalPresentationStyle= UIModalPresentationOverCurrentContext;
            }
            pViewController.pBuyStr = [[self.pBuyTypeArr objectAtIndex:0] objectForKey:@"price"];
            pViewController.pBuyDic = self.pDetailDataDic;
            pViewController.delegate = self;
            [self presentViewController:pViewController animated:NO completion:^{
                
            }];

            
        }break;
    }
}

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
