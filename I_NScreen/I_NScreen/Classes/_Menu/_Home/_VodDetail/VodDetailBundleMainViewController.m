//
//  VodDetailBundleMainViewController.m
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 11. 29..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import "VodDetailBundleMainViewController.h"
#import "NSMutableDictionary+Payment.h"
#import "UIAlertView+AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import "VodDetailMainViewController.h"

@interface VodDetailBundleMainViewController ()
@property (nonatomic, weak) IBOutlet UIImageView *pThumImageView;
@property (nonatomic, weak) IBOutlet UIImageView *pSaleImageView;
@property (nonatomic, weak) IBOutlet UILabel *pTitleLbl;
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

@property (nonatomic, weak) IBOutlet UIButton *pBundleBtn01;
@property (nonatomic, weak) IBOutlet UIButton *pBundleBtn02;
@property (nonatomic, weak) IBOutlet UIButton *pBundleBtn03;
@property (nonatomic, weak) IBOutlet UIButton *pBundleBtn04;
@property (nonatomic, weak) IBOutlet UIButton *pBundleBtn05;

- (IBAction)onBtnClicked:(UIButton *)btn;
@end

@implementation VodDetailBundleMainViewController

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setViewInit];
    [self setTagInit];
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

#pragma mark - 버튼 테그
- (void)setTagInit
{
    self.pBundleBtn01.tag = VOD_DETAIL_BUNDLE_MAIN_VIEW_BTN_01;
    self.pBundleBtn02.tag = VOD_DETAIL_BUNDLE_MAIN_VIEW_BTN_02;
    self.pBundleBtn03.tag = VOD_DETAIL_BUNDLE_MAIN_VIEW_BTN_03;
    self.pBundleBtn04.tag = VOD_DETAIL_BUNDLE_MAIN_VIEW_BTN_04;
    self.pBundleBtn05.tag = VOD_DETAIL_BUNDLE_MAIN_VIEW_BTN_05;
}

#pragma mark - 액션 이벤트
#pragma mark - 버튼 액션 이벤트
- (IBAction)onBtnClicked:(UIButton *)btn
{
    NSString *sAssetIdStr = @"";
    
    switch ([btn tag]) {
        case VOD_DETAIL_BUNDLE_MAIN_VIEW_BTN_01:
        {
            // 구매 버튼
            sAssetIdStr = [[self.pBundleAssetArr objectAtIndex:0] objectForKey:@"assetId"];
        }break;
        case VOD_DETAIL_BUNDLE_MAIN_VIEW_BTN_02:
        {
            sAssetIdStr = [[self.pBundleAssetArr objectAtIndex:1] objectForKey:@"assetId"];
        }break;
        case VOD_DETAIL_BUNDLE_MAIN_VIEW_BTN_03:
        {
            sAssetIdStr = [[self.pBundleAssetArr objectAtIndex:2] objectForKey:@"assetId"];
        }break;
        case VOD_DETAIL_BUNDLE_MAIN_VIEW_BTN_04:
        {
            sAssetIdStr = [[self.pBundleAssetArr objectAtIndex:3] objectForKey:@"assetId"];
        }break;
        case VOD_DETAIL_BUNDLE_MAIN_VIEW_BTN_05:
        {
            sAssetIdStr = [[self.pBundleAssetArr objectAtIndex:4] objectForKey:@"assetId"];
        }break;
    }
    
    VodDetailMainViewController *pViewController = [[VodDetailMainViewController alloc] initWithNibName:@"VodDetailMainViewController" bundle:nil];
    pViewController.pAssetIdStr = sAssetIdStr;
    pViewController.pEpisodePeerExistence = self.sEpisodePeerExistence;
    pViewController.pContentGroupId = self.sContentGroupId;
    [self.navigationController pushViewController:pViewController animated:YES];
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
    
    [SIAlertView showAlertViewForTaskWithErrorOnCompletion:tesk delegate:nil];
}

- (void)setResponseInit
{
    NSString *sUrl = [NSString stringWithFormat:@"%@", [self.pDetailDic objectForKey:@"imageFileName"]];
    
    sUrl = [sUrl stringByReplacingOccurrencesOfString:@"http://192.168.40.12:8080" withString:@"http://58.141.255.79:8080"];
    
    [self.pThumImageView setImageWithURL:[NSURL URLWithString:sUrl]];
    
    self.pTitleLbl.text = [NSString stringWithFormat:@"%@", [self.pDetailDic objectForKey:@"productName"]];
   
    NSString* rentalDuration = nil;
    NSString* rentalDurationUnit = nil;
    rentalDuration = self.pDetailDic[@"rentalDuration"];
    rentalDurationUnit = self.pDetailDic[@"rentalDurationUnit"];
    
    if (rentalDurationUnit != nil && rentalDuration != nil) {
        NSString* value = [NSString stringWithFormat:@"%@ %@", rentalDuration, [self durationUnit:rentalDurationUnit]];
        self.pLicenseTimeLbl.text = value;
    }
    else {
        self.pLicenseTimeLbl.text = @"";
    }
    
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
                self.pBundleMoneyLbl01.text = [NSString stringWithFormat:@"%@", [[CMAppManager sharedInstance] insertComma:[[self.pBundleAssetArr objectAtIndex:i] objectForKey:@"suggestedPrice"]]];

            }break;
            case 1:
            {
                self.pBundleView02.hidden = NO;
                
                NSString *sUrl = [NSString stringWithFormat:@"%@", [[self.pBundleAssetArr objectAtIndex:i] objectForKey:@"imageFileName"]];
                [self.pBundleImageView02 setImageWithURL:[NSURL URLWithString:sUrl]];
                self.pBundleTitleLbl02.text = [NSString stringWithFormat:@"%@", [[self.pBundleAssetArr objectAtIndex:i] objectForKey:@"displayName"]];
                self.pBundleMoneyLbl02.text = [NSString stringWithFormat:@"%@", [[CMAppManager sharedInstance] insertComma:[[self.pBundleAssetArr objectAtIndex:i] objectForKey:@"suggestedPrice"]]];
            }break;
            case 2:
            {
                self.pBundleView03.hidden = NO;
                
                NSString *sUrl = [NSString stringWithFormat:@"%@", [[self.pBundleAssetArr objectAtIndex:i] objectForKey:@"imageFileName"]];
                [self.pBundleImageView03 setImageWithURL:[NSURL URLWithString:sUrl]];
                self.pBundleTitleLbl03.text = [NSString stringWithFormat:@"%@", [[self.pBundleAssetArr objectAtIndex:i] objectForKey:@"displayName"]];
                self.pBundleMoneyLbl03.text = [NSString stringWithFormat:@"%@", [[CMAppManager sharedInstance] insertComma:[[self.pBundleAssetArr objectAtIndex:i] objectForKey:@"suggestedPrice"]]];
            }break;
            case 3:
            {
                self.pBundleView04.hidden = NO;
                
                NSString *sUrl = [NSString stringWithFormat:@"%@", [[self.pBundleAssetArr objectAtIndex:i] objectForKey:@"imageFileName"]];
                [self.pBundleImageView04 setImageWithURL:[NSURL URLWithString:sUrl]];
                self.pBundleTitleLbl04.text = [NSString stringWithFormat:@"%@", [[self.pBundleAssetArr objectAtIndex:i] objectForKey:@"displayName"]];
                self.pBundleMoneyLbl04.text = [NSString stringWithFormat:@"%@", [[CMAppManager sharedInstance] insertComma:[[self.pBundleAssetArr objectAtIndex:i] objectForKey:@"suggestedPrice"]]];
            }break;
            case 4:
            {
                self.pBundleView05.hidden = NO;
                
                NSString *sUrl = [NSString stringWithFormat:@"%@", [[self.pBundleAssetArr objectAtIndex:i] objectForKey:@"imageFileName"]];
                [self.pBundleImageView05 setImageWithURL:[NSURL URLWithString:sUrl]];
                self.pBundleTitleLbl05.text = [NSString stringWithFormat:@"%@", [[self.pBundleAssetArr objectAtIndex:i] objectForKey:@"displayName"]];
                self.pBundleMoneyLbl05.text = [NSString stringWithFormat:@"%@", [[CMAppManager sharedInstance] insertComma:[[self.pBundleAssetArr objectAtIndex:i] objectForKey:@"suggestedPrice"]]];
            }break;
        }
    }
}


#pragma mark - code parsing
- (NSString*)durationUnit:(NSString*)code {
    NSString* result = @"";
    if ([code isEqualToString:@"0"]) {//시간
        result = @"시간";
    }
    else if ([code isEqualToString:@"1"]) {//일
        result = @"일";
    }
    else if ([code isEqualToString:@"2"]) {//주
        result = @"주";
    }
    else if ([code isEqualToString:@"3"]) {//월
        result = @"월";
    }
    else if ([code isEqualToString:@"4"]) {//년
        result = @"년";
    }
    return result;
}

@end
