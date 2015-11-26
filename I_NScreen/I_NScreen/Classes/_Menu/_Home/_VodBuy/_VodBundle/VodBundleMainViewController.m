//
//  VodBundleMainViewController.m
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 11. 27..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import "VodBundleMainViewController.h"
#import "NSMutableDictionary+Payment.h"
#import "UIAlertView+AFNetworking.h"
#import "UIImageView+AFNetworking.h"

@interface VodBundleMainViewController ()
@property (nonatomic, weak) IBOutlet UIImageView *pThumImageView;
@property (nonatomic, weak) IBOutlet UIImageView *pSaleImageView;
@property (nonatomic, weak) IBOutlet UILabel *pTitleLbl;
@property (nonatomic, weak) IBOutlet UILabel *pSugPriceLbl; // 할인전 가격
@property (nonatomic, weak) IBOutlet UILabel *pPriceLbl;        // 할인 가격
@property (nonatomic, weak) IBOutlet UILabel *pLicenseTimeLbl;  // 시청 기간
@property (nonatomic, weak) IBOutlet UIImageView *pTvImageView;
@property (nonatomic, weak) IBOutlet UIImageView *pMobileImageView;

// 번들 어셋은 맥시멈 5개 까지
@property (nonatomic, weak) IBOutlet UIView *pBundleView01;
@property (nonatomic, weak) IBOutlet UIView *pBundleView02;
@property (nonatomic, weak) IBOutlet UIView *pBundleView03;
@property (nonatomic, weak) IBOutlet UIView *pBundleView04;
@property (nonatomic, weak) IBOutlet UIView *pBundleView05;

@property (nonatomic, weak) IBOutlet UIImageView *pBundleImageView01;
@property (nonatomic, weak) IBOutlet UIImageView *pBundleImageView02;
@property (nonatomic, weak) IBOutlet UIImageView *pBundleImageView03;
@property (nonatomic, weak) IBOutlet UIImageView *pBundleImageView04;
@property (nonatomic, weak) IBOutlet UIImageView *pBundleImageView05;

@property (nonatomic, weak) IBOutlet UILabel *pBundleTitleLbl01;
@property (nonatomic, weak) IBOutlet UILabel *pBundleTitleLbl02;
@property (nonatomic, weak) IBOutlet UILabel *pBundleTitleLbl03;
@property (nonatomic, weak) IBOutlet UILabel *pBundleTitleLbl04;
@property (nonatomic, weak) IBOutlet UILabel *pBundleTitleLbl05;

@property (nonatomic, weak) IBOutlet UILabel *pBundleMoneyLbl01;
@property (nonatomic, weak) IBOutlet UILabel *pBundleMoneyLbl02;
@property (nonatomic, weak) IBOutlet UILabel *pBundleMoneyLbl03;
@property (nonatomic, weak) IBOutlet UILabel *pBundleMoneyLbl04;
@property (nonatomic, weak) IBOutlet UILabel *pBundleMoneyLbl05;

@property (nonatomic, strong) NSMutableArray *pBundleAssetArr;
@property (nonatomic, strong) NSMutableDictionary *pDetailDic;

- (IBAction)onBtnClicked:(UIButton *)btn;

@end

@implementation VodBundleMainViewController
@synthesize sProductId;

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setViewInit];
    [self setDataInit];
    
    [self requestWithGetBundleProductInfo];
}

#pragma mark - 초기화
#pragma mark - 화면 초기화
- (void)setViewInit
{
    self.title = @"상세정보";
    self.isUseNavigationBar = YES;
}

#pragma mark - 데이터 초기화
- (void)setDataInit
{
    self.pBundleAssetArr = [[NSMutableArray alloc] init];
    self.pDetailDic = [[NSMutableDictionary alloc] init];
}

#pragma mark - 액션 이벤트
#pragma mark - 버튼 액션 이벤트
- (IBAction)onBtnClicked:(UIButton *)btn
{
    // 구매 버튼
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 전문
#pragma mark - 상세 전문
- (void)requestWithGetBundleProductInfo
{
    NSURLSessionDataTask *tesk = [NSMutableDictionary paymentGetBundleProductInfoWithProductId:self.sProductId completion:^(NSArray *payment, NSError *error) {
    
        DDLogError(@"번들 상세 = [%@]", payment);
        
        if ( [payment count] == 0 )
            return;
        
        [self.pDetailDic removeAllObjects];
        [self.pBundleAssetArr removeAllObjects];
        
        [self.pDetailDic setDictionary:[[payment objectAtIndex:0] objectForKey:@"bundleProduct"]];
        
        NSObject *itemObject = [[[[payment objectAtIndex:0] objectForKey:@"bundleProduct"] objectForKey:@"bundleAssetList"] objectForKey:@"bundleAsset"];
        
        if ( [itemObject isKindOfClass:[NSDictionary class]] )
        {
            [self.pBundleAssetArr addObject:itemObject];
        }
        else
        {
            [self.pBundleAssetArr setArray:(NSArray *)itemObject];
        }
        
        [self setResponseInit];
    }];
    
    [UIAlertView showAlertViewForTaskWithErrorOnCompletion:tesk delegate:nil];
}

- (void)setResponseInit
{
    NSString *sUrl = [NSString stringWithFormat:@"%@", [self.pDetailDic objectForKey:@"imageFileName"]];
    
    sUrl = [sUrl stringByReplacingOccurrencesOfString:@"http://192.168.40.12:8080" withString:@"http://58.141.255.79:8080"];
    
    [self.pThumImageView setImageWithURL:[NSURL URLWithString:sUrl]];
    
    self.pTitleLbl.text = [NSString stringWithFormat:@"%@", [self.pDetailDic objectForKey:@"productName"]];
    self.pSugPriceLbl.text = [NSString stringWithFormat:@"%@", [self.pDetailDic objectForKey:@"suggestedPriceTotal"]];
    self.pPriceLbl.text = [NSString stringWithFormat:@"%@", [self.pDetailDic objectForKey:@"price"]];
    
    NSArray *keyArr = [self.pDetailDic allKeys];
    BOOL isCheck = NO;
    for ( NSString *key in keyArr )
    {
        if ( [key isEqualToString:@"mobilePublicationRight"] )
        {
            isCheck = YES;
        }
    }
    
    if ( isCheck == YES )
    {
        if ( [[self.pDetailDic objectForKey:@"mobilePublicationRight"] isEqualToString:@"1"] )
        {
            // 모바일
            self.pMobileImageView.hidden = NO;
        }
        else
        {
            // tv
            self.pMobileImageView.hidden = YES;
        }
    }
    else
    {
        if ( [[self.pDetailDic objectForKey:@"publicationRight"] isEqualToString:@"2"] )
        {
            // tv모바일
            self.pMobileImageView.hidden = NO;
        }
        else
        {
            // tv
            self.pMobileImageView.hidden = YES;
        }
    }

    // 묶음 상품
    for ( int i = 0; i < self.pBundleAssetArr.count; i++ )
    {
        switch (i) {
            case 0:
            {
                self.pBundleView01.hidden = NO;
                
                NSString *sUrl = [NSString stringWithFormat:@"%@", [[self.pBundleAssetArr objectAtIndex:i] objectForKey:@"imageFileName"]];
                [self.pBundleImageView01 setImageWithURL:[NSURL URLWithString:sUrl]];
                self.pBundleTitleLbl01.text = [NSString stringWithFormat:@"%@", [[self.pBundleAssetArr objectAtIndex:i] objectForKey:@"displayName"]];
                self.pBundleMoneyLbl01.text = [NSString stringWithFormat:@"%@", [[self.pBundleAssetArr objectAtIndex:i] objectForKey:@"suggestedPrice"]];
                
            }break;
            case 1:
            {
                self.pBundleView02.hidden = NO;
                
                NSString *sUrl = [NSString stringWithFormat:@"%@", [[self.pBundleAssetArr objectAtIndex:i] objectForKey:@"imageFileName"]];
                [self.pBundleImageView02 setImageWithURL:[NSURL URLWithString:sUrl]];
                self.pBundleTitleLbl02.text = [NSString stringWithFormat:@"%@", [[self.pBundleAssetArr objectAtIndex:i] objectForKey:@"displayName"]];
                self.pBundleMoneyLbl02.text = [NSString stringWithFormat:@"%@", [[self.pBundleAssetArr objectAtIndex:i] objectForKey:@"suggestedPrice"]];
            }break;
            case 2:
            {
                self.pBundleView03.hidden = NO;
                
                NSString *sUrl = [NSString stringWithFormat:@"%@", [[self.pBundleAssetArr objectAtIndex:i] objectForKey:@"imageFileName"]];
                [self.pBundleImageView03 setImageWithURL:[NSURL URLWithString:sUrl]];
                self.pBundleTitleLbl03.text = [NSString stringWithFormat:@"%@", [[self.pBundleAssetArr objectAtIndex:i] objectForKey:@"displayName"]];
                self.pBundleMoneyLbl03.text = [NSString stringWithFormat:@"%@", [[self.pBundleAssetArr objectAtIndex:i] objectForKey:@"suggestedPrice"]];
            }break;
            case 3:
            {
                self.pBundleView04.hidden = NO;
                
                NSString *sUrl = [NSString stringWithFormat:@"%@", [[self.pBundleAssetArr objectAtIndex:i] objectForKey:@"imageFileName"]];
                [self.pBundleImageView04 setImageWithURL:[NSURL URLWithString:sUrl]];
                self.pBundleTitleLbl04.text = [NSString stringWithFormat:@"%@", [[self.pBundleAssetArr objectAtIndex:i] objectForKey:@"displayName"]];
                self.pBundleMoneyLbl04.text = [NSString stringWithFormat:@"%@", [[self.pBundleAssetArr objectAtIndex:i] objectForKey:@"suggestedPrice"]];
            }break;
            case 4:
            {
                self.pBundleView05.hidden = NO;
                
                NSString *sUrl = [NSString stringWithFormat:@"%@", [[self.pBundleAssetArr objectAtIndex:i] objectForKey:@"imageFileName"]];
                [self.pBundleImageView05 setImageWithURL:[NSURL URLWithString:sUrl]];
                self.pBundleTitleLbl05.text = [NSString stringWithFormat:@"%@", [[self.pBundleAssetArr objectAtIndex:i] objectForKey:@"displayName"]];
                self.pBundleMoneyLbl05.text = [NSString stringWithFormat:@"%@", [[self.pBundleAssetArr objectAtIndex:i] objectForKey:@"suggestedPrice"]];
            }break;
        }
    }
}

@end
