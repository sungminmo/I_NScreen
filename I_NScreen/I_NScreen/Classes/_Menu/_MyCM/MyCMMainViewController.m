//
//  MyCMMainViewController.m
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 9. 16..
//  Copyright (c) 2015년 STVN. All rights reserved.
//

#import "MyCMMainViewController.h"

#import "UIAlertView+AFNetworking.h"

#import "NSMutableDictionary+MyC_M.h"
#import "NSMutableDictionary+WISH.h"
#import "NSMutableDictionary+VOD.h"
#import "NSMutableDictionary+Payment.h"

#import "CMDBDataManager.h"
#import "CMVodWatchList.h"
#import "VodDetailBundleMainViewController.h"

@interface MyCMMainViewController ()
@property (nonatomic, strong) NSMutableArray *pValidPurchaseLogListMoblieArr;   // vod 찜 목록 모바일 구매 목록
@property (nonatomic, strong) NSMutableArray *pValidPurchaseLogListTvArr;       // vod 찜 목록 tv 구매 목록
@property (nonatomic, strong) NSMutableArray *pWishListArr;
@property (nonatomic, strong) NSMutableArray *pWatchListArr;        // 시청목록 데이터
@property (nonatomic) int nTapTag;
@property (nonatomic) int nSubTabTag;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftTabLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightTabLayout;

@end

@implementation MyCMMainViewController

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"마이 씨앤엠";
    self.isUseNavigationBar = YES;
    
    [self setTagInit];
    [self setViewInit];
    
    // 구매목록 전문
    [self requestWithGetValidPurchaseLogList];
}

#pragma mark - 초기화
#pragma mark - 화면 태그값 초기화
- (void)setTagInit
{
    self.pBackBtn.tag = MY_CM_MAIN_VIEW_BTN_01;
    self.pTapBtn01.tag = MY_CM_MAIN_VIEW_BTN_02;
    self.pTapBtn02.tag = MY_CM_MAIN_VIEW_BTN_03;
    self.pTapBtn03.tag = MY_CM_MAIN_VIEW_BTN_04;
    
    self.pSubTabBtn01.tag = MY_CM_MAIN_VIEW_BTN_05;
    self.pSubTabBtn02.tag = MY_CM_MAIN_VIEW_BTN_06;
}

#pragma mark - 화면 초기화
- (void)setViewInit
{
    self.pValidPurchaseLogListMoblieArr = [[NSMutableArray alloc] init];
    self.pValidPurchaseLogListTvArr = [[NSMutableArray alloc] init];
    self.pWishListArr = [[NSMutableArray alloc] init];
    self.pWatchListArr = [[NSMutableArray alloc] init];
    self.nTapTag = MY_CM_MAIN_VIEW_BTN_02;
    self.nSubTabTag = 0;
    self.leftTabLayout.constant = 2;
    self.rightTabLayout.constant = 1;
}
#pragma mark - Private

/**
 * payment type에 따른 리스트 추가 여부 반환
 * */

- (BOOL)checkAddListWithPaymentType:(NSString*)paymentType
{
    if ([@"normal" isEqualToString:paymentType] || [@"coupon" isEqualToString:paymentType] || [@"point" isEqualToString:paymentType] || [@"complex" isEqualToString:paymentType]) {
        return true;
    }
    
    return false;
}

/**
 * product type에 따른 리스트 추가 여부 반환
 * */

- (BOOL)checkAddListWithProductType:(NSString*)productType
{
    if ([@"rvod" isEqualToString:productType] || [@"package" isEqualToString:productType] || [@"bundle" isEqualToString:productType]) {
        return true;
    }
    
    return false;
}

- (void)refreshDesc
{
    int nTotal = (int)[self.pWatchListArr count];
    if ( nTotal == 0 )
        self.pTotalExplanLbl02.text = [NSString stringWithFormat:@"시청한 VOD가 없습니다."];
    else
        self.pTotalExplanLbl02.text = [NSString stringWithFormat:@"총 %d개의 VOD 시청목록이 있습니다.", nTotal];
}

#pragma mark - 액션 이벤트
#pragma mark - 버튼 클릭 이벤트
- (IBAction)onBtnClick:(UIButton *)btn
{
    self.nTapTag = (int)[btn tag];
    
    switch (btn.tag) {
        case MY_CM_MAIN_VIEW_BTN_01:
        {
            // back
            [self.navigationController popViewControllerAnimated:YES];
            
        }break;
        case MY_CM_MAIN_VIEW_BTN_02:
        {
            [self.pValidPurchaseLogListMoblieArr removeAllObjects];
            [self.pValidPurchaseLogListTvArr removeAllObjects];
            [self.pWishListArr removeAllObjects];
            [self.pWatchListArr removeAllObjects];
        
            [self.pSubTableView01 reloadData];
            [self.pSubTableView02 reloadData];
            
            self.pSubView01.hidden = NO;
            self.pSubView02.hidden = YES;
            // vod 구매목록
            [self.pTapBtn01 setBackgroundImage:[UIImage imageNamed:@"3btn_select.png"] forState:UIControlStateNormal];
            [self.pTapBtn02 setBackgroundImage:[UIImage imageNamed:@"3btn_normal.png"] forState:UIControlStateNormal];
            [self.pTapBtn03 setBackgroundImage:[UIImage imageNamed:@"3btn_normal.png"] forState:UIControlStateNormal];
            
            [self.pTapBtn01 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.pTapBtn02 setTitleColor:[UIColor colorWithRed:123.0f/255.0f green:90.0f/255.0f blue:163.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
            [self.pTapBtn03 setTitleColor:[UIColor colorWithRed:123.0f/255.0f green:90.0f/255.0f blue:163.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
            
            [self requestWithGetValidPurchaseLogList];
        }break;
        case MY_CM_MAIN_VIEW_BTN_03:
        {
            [self.pValidPurchaseLogListMoblieArr removeAllObjects];
            [self.pValidPurchaseLogListTvArr removeAllObjects];
            [self.pWishListArr removeAllObjects];
            [self.pWatchListArr removeAllObjects];
            
            [self.pSubTableView01 reloadData];
            [self.pSubTableView02 reloadData];
            
            self.pSubView01.hidden = YES;
            self.pSubView02.hidden = NO;
            // vod 시청목록
            [self.pTapBtn01 setBackgroundImage:[UIImage imageNamed:@"3btn_normal.png"] forState:UIControlStateNormal];
            [self.pTapBtn02 setBackgroundImage:[UIImage imageNamed:@"3btn_select.png"] forState:UIControlStateNormal];
            [self.pTapBtn03 setBackgroundImage:[UIImage imageNamed:@"3btn_normal.png"] forState:UIControlStateNormal];
            
            [self.pTapBtn01 setTitleColor:[UIColor colorWithRed:123.0f/255.0f green:90.0f/255.0f blue:163.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
            [self.pTapBtn02 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.pTapBtn03 setTitleColor:[UIColor colorWithRed:123.0f/255.0f green:90.0f/255.0f blue:163.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];

            [self.pWatchListArr removeAllObjects];
            
            CMDBDataManager *manager = [CMDBDataManager sharedInstance];
            for ( CMVodWatchList *info in [manager getVodWatchList] )
            {
                NSString *sTitle = [NSString stringWithFormat:@"%@", [info pTitleStr]];
                NSString *sDate = [NSString stringWithFormat:@"%@", [info pWatchDateStr]];
                NSString *sAssetId = [NSString stringWithFormat:@"%@", [info pAssetIdStr]];
                NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:sTitle, @"title", sDate, @"date", sAssetId, @"assetId", nil];
                [self.pWatchListArr addObject:dic];
            }
            
            [self refreshDesc];
            
            [self.pSubTableView02 reloadData];
        }break;
        case MY_CM_MAIN_VIEW_BTN_04:
        {
            [self.pValidPurchaseLogListMoblieArr removeAllObjects];
            [self.pValidPurchaseLogListTvArr removeAllObjects];
            [self.pWishListArr removeAllObjects];
            [self.pWatchListArr removeAllObjects];
            
            [self.pSubTableView01 reloadData];
            [self.pSubTableView02 reloadData];
            
            self.pSubView01.hidden = YES;
            self.pSubView02.hidden = NO;
            // vod 찜목록
            [self.pTapBtn01 setBackgroundImage:[UIImage imageNamed:@"3btn_normal.png"] forState:UIControlStateNormal];
            [self.pTapBtn02 setBackgroundImage:[UIImage imageNamed:@"3btn_normal.png"] forState:UIControlStateNormal];
            [self.pTapBtn03 setBackgroundImage:[UIImage imageNamed:@"3btn_select.png"] forState:UIControlStateNormal];
            
            [self.pTapBtn01 setTitleColor:[UIColor colorWithRed:123.0f/255.0f green:90.0f/255.0f blue:163.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
            [self.pTapBtn02 setTitleColor:[UIColor colorWithRed:123.0f/255.0f green:90.0f/255.0f blue:163.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
            [self.pTapBtn03 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
            [self requestWithGetWishList];
            
        }break;
        case MY_CM_MAIN_VIEW_BTN_05:
        {
            // 모바일 구매목록
            self.nSubTabTag = 0;
            self.nTapTag = MY_CM_MAIN_VIEW_BTN_02;
            [self.pSubTabBtn01 setTitleColor:[UIColor colorWithRed:123.0f/255.0f green:90.0f/255.0f blue:163.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
            [self.pSubTabBtn02 setTitleColor:[UIColor colorWithRed:138.0f/255.0f green:140.0f/255.0f blue:142.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];

            self.pSubTabBtn01.selected = YES;
            self.pSubTabBtn02.selected = NO;
            self.leftTabLayout.constant = 2;
            self.rightTabLayout.constant = 1;
            
            [self.pSubTableView01 reloadData];
            
            int nTotal = (int)[self.pValidPurchaseLogListMoblieArr count];
            if ( nTotal == 0 )
            {
                self.pTotalExplanLbl01.text = [NSString stringWithFormat:@"구매한 모바일 VOD가 없습니다."];
            }
            else
            {
                self.pTotalExplanLbl01.text = [NSString stringWithFormat:@"총 %d개의 모바일 VOD 구매목록이 있습니다.", nTotal];
                
                NSIndexPath* indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
                [self.pSubTableView01 scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
            }
        }break;
        case MY_CM_MAIN_VIEW_BTN_06:
        {
            // tv 구매목록
            self.nSubTabTag = 1;
            self.nTapTag = MY_CM_MAIN_VIEW_BTN_02;
            [self.pSubTabBtn01 setTitleColor:[UIColor colorWithRed:138.0f/255.0f green:140.0f/255.0f blue:142.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
            [self.pSubTabBtn02 setTitleColor:[UIColor colorWithRed:123.0f/255.0f green:90.0f/255.0f blue:163.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
            
            self.pSubTabBtn01.selected = NO;
            self.pSubTabBtn02.selected = YES;
            self.leftTabLayout.constant = 1;
            self.rightTabLayout.constant = 2;
            
            [self.pSubTableView01 reloadData];
            
            int nTotal = (int)[self.pValidPurchaseLogListTvArr count];
            if ( nTotal == 0 )
            {
                self.pTotalExplanLbl01.text = [NSString stringWithFormat:@"구매한 TV VOD가 없습니다."];
            }
            else
            {
                self.pTotalExplanLbl01.text = [NSString stringWithFormat:@"총 %d개의 TV VOD 구매목록이 있습니다.", nTotal];
                
                NSIndexPath* indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
                [self.pSubTableView01 scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
            }
            
        }break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *pCellIn = @"MyCMBuyListTableViewCellIn";
    
    MyCMBuyListTableViewCell *pCell = (MyCMBuyListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:pCellIn];
    
    if (pCell == nil)
    {
        NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"MyCMBuyListTableViewCell" owner:nil options:nil];
        pCell = [arr objectAtIndex:0];
    }
    
    [pCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    if ( self.nTapTag == MY_CM_MAIN_VIEW_BTN_02 )
    {
        // 구매 목록
        if ( self.nSubTabTag == 0 )
        {
            // 모바일 구매목록
            [pCell setListData:[self.pValidPurchaseLogListMoblieArr objectAtIndex:indexPath.row] WithIndex:(int)indexPath.row WithViewType:self.nTapTag];
        }
        else
        {
            // tv 수매목록
            [pCell setListData:[self.pValidPurchaseLogListTvArr objectAtIndex:indexPath.row] WithIndex:(int)indexPath.row WithViewType:self.nTapTag];
        }
    }
    else if ( self.nTapTag == MY_CM_MAIN_VIEW_BTN_03 )
    {
        // 시청목록
        [pCell setListData:[self.pWatchListArr objectAtIndex:indexPath.row] WithIndex:(int)indexPath.row WithViewType:self.nTapTag];
    }
    else
    {
        // 찜목록
        [pCell setListData:[self.pWishListArr objectAtIndex:indexPath.row] WithIndex:(int)indexPath.row WithViewType:self.nTapTag];
    }
    
    return pCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    EpgSubViewController *pViewController = [[EpgSubViewController alloc] initWithNibName:@"EpgSubViewController" bundle:nil];
    //    [self.navigationController pushViewController:pViewController animated:YES];
    
    BOOL isValidCheck = NO;
    NSDictionary* item = nil;
    
    if ( self.nTapTag == MY_CM_MAIN_VIEW_BTN_04 ) {
        item = self.pWishListArr[indexPath.row][@"asset"];
    }
    else if ( self.nTapTag == MY_CM_MAIN_VIEW_BTN_03 ) {
        item = self.pWatchListArr[indexPath.row];
    }
    else if ( self.nTapTag == MY_CM_MAIN_VIEW_BTN_02 ) {
        isValidCheck = YES;
        if ( self.nSubTabTag == 0 ) {
            item = self.pValidPurchaseLogListMoblieArr[indexPath.row];
        } else {
            item = self.pValidPurchaseLogListTvArr[indexPath.row];
        }
    }
    
    NSString *sRating = item[@"rating"];
    __block NSString *sAssetId = item[@"assetId"];
    NSString *sProductType = item[@"productType"];
    NSString *sPurchasedTime = item[@"purchasedTime"];
    
    //1. 성인컨텐츠 처리
    if ( [sRating isEqualToString:@"19"] ) {
        if ( [[CMAppManager sharedInstance] getKeychainAdultCertification] == NO )
        {
            [SIAlertView alert:@"성인인증 필요" message:@"성인 인증이 필요한 콘텐츠입니다.\n성인 인증을 하시겠습니까?" cancel:@"취소" buttons:@[@"확인"]
                    completion:^(NSInteger buttonIndex, SIAlertView *alert) {
                        if ( buttonIndex == 1 ) {
                            // 설정 창으로 이동
                            CMPreferenceMainViewController* controller = [[CMPreferenceMainViewController alloc] initWithNibName:@"CMPreferenceMainViewController" bundle:nil];
                            [self.navigationController pushViewController:controller animated:YES];
                        }
            }];
            return;
        }
    }
    
    //2. 묶음 상품 확인
    __block NSString* resultCode = nil;
    __block BOOL isRun = NO;
    
    if ( ([sProductType isEqualToString:@"Bundle"] && [sPurchasedTime length] != 0) ) { // 번들이고 구매한 사용자
        NSString* sProductId = item[@"productId"];
        isRun = YES;
        [NSMutableDictionary paymentGetBundleProductInfoWithProductId:sProductId completion:^(NSArray *payment, NSError *error) {
            DDLogError(@"번들 상세 = [%@]", payment);
            id obj = [payment valueForKeyPath:@"resultCode"];
            if ([obj isKindOfClass:[NSString class]]) {
                resultCode = (NSString*)obj;
            }
            else {
                resultCode = ((NSArray*)obj)[0];
            }
            
            isRun = NO;
        }];
        
        while (isRun) {
            [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
        }
        
        if (isValidCheck) {//구매목록이고 결과가 유효하지 않으면 돌아간다.
            if (resultCode.length > 0 && [resultCode isEqualToString:@"100"] == NO) {
                [self callAlertInvalidContents];
                return;
            }
            else {
                // 묶음 페이지이동
                VodDetailBundleMainViewController *pViewController = [[VodDetailBundleMainViewController alloc] initWithNibName:@"VodDetailBundleMainViewController" bundle:nil];
                pViewController.sAssetId = sAssetId;
                pViewController.sEpisodePeerExistence = @"0";
                pViewController.sContentGroupId = @"";
                pViewController.sProductId = sProductId;
                [self.navigationController pushViewController:pViewController animated:YES];
            }
            resultCode = nil;
        }
        return;
    }
    else {
        
        if (sAssetId == nil || [[sAssetId emptyCheck] isEqualToString:@""]) {
            [SIAlertView alert:@"알림" message:@"상품정보가 유효하지 않습니다."];
            return;
        }
        
        [NSMutableDictionary vodGetAssetInfoWithAssetId:sAssetId WithAssetProfile:@"9" completion:^(NSArray *vod, NSError *error) {
            DDLogError(@"vod 상세 = [%@]", vod);
            id obj = [vod valueForKeyPath:@"resultCode"];
            if ([obj isKindOfClass:[NSString class]]) {
                resultCode = (NSString*)obj;
            }
            else {
                resultCode = ((NSArray*)obj)[0];
            }
            
            if (resultCode.length > 0 && [resultCode isEqualToString:@"100"] == NO) {
                [self callAlertInvalidContents];
                return;
            }
            else {
                // 기존 상세 로직
                VodDetailMainViewController *pViewController = [[VodDetailMainViewController alloc] initWithNibName:@"VodDetailMainViewController" bundle:nil];
                pViewController.pAssetIdStr = sAssetId;
                pViewController.delegate = self;
                pViewController.pEpisodePeerExistence = @"0";
                pViewController.pContentGroupId = @"";
                [self.navigationController pushViewController:pViewController animated:YES];
            }
        }];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 66;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int nSection = 0;
    
    if ( self.nTapTag == MY_CM_MAIN_VIEW_BTN_02 )
    {
        if ( self.nSubTabTag == 0 )
        {
            // 모바일 구매목록
            nSection = (int)[self.pValidPurchaseLogListMoblieArr count];
        }
        else
        {
            // tv 구매목록
            nSection = (int)[self.pValidPurchaseLogListTvArr count];
        }
    }
    else if ( self.nTapTag == MY_CM_MAIN_VIEW_BTN_03 )
    {
        // vod 시청목록
        nSection = (int)[self.pWatchListArr count];
    }
    else if ( self.nTapTag == MY_CM_MAIN_VIEW_BTN_04 )
    {
        // vod 찜목록
        nSection = (int)[self.pWishListArr count];
    }

    return nSection;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

#pragma mark - 전문
#pragma mark - 구매목록
- (void)requestWithGetValidPurchaseLogList
{
    
    NSURLSessionDataTask *tesk = [NSMutableDictionary myCmGetValidPurchaseLogListCompletion:^(NSArray *myCm, NSError *error) {
        
        DDLogError(@"구매목록 = [%@]", myCm);
        
        NSMutableArray* mobile = [@[] mutableCopy];
        NSMutableArray* tv = [@[] mutableCopy];
        
        NSObject *itemObject = [[[myCm objectAtIndex:0] objectForKey:@"purchaseLogList"] objectForKey:@"purchaseLog"];
        
        if ( [itemObject isKindOfClass:[NSDictionary class]] )
        {
            NSString *sPurchaseDeviceType = [NSString stringWithFormat:@"%@", [(NSDictionary *)itemObject objectForKey:@"purchaseDeviceType"]];
            NSMutableDictionary* mDic = [itemObject mutableCopy];
            
            NSString* p = mDic[@"viewablePeriod"];
            NSString* s = mDic[@"viewablePeriodState"];
            NSString* b = mDic[@"purchasedTime"];
            
            NSNumber* validTime =  [[CMAppManager sharedInstance] expiredDateIntervalWithPeriod:p purchased:b state:s];
            [mDic setObject:validTime forKey:@"validTime"];
            
            if ( [sPurchaseDeviceType isEqualToString:@"2"] )
            {
                // 모바일구매
                
                [mobile addObject:mDic];
            }
            else
            {
                // tv 구매
                [tv addObject:mDic];
            }

        }
        else
        {
            for ( NSDictionary *dic in [[[myCm objectAtIndex:0] objectForKey:@"purchaseLogList"] objectForKey:@"purchaseLog"] )
            {
                NSString* productType = [(NSString*)dic[@"productType"] lowercaseString];
                NSString* paymentType = [(NSString*)dic[@"paymentType"] lowercaseString];
                
                if ([self checkAddListWithPaymentType:paymentType] && [self checkAddListWithProductType:productType]) {
                    NSString *sPurchaseDeviceType = [NSString stringWithFormat:@"%@", [dic objectForKey:@"purchaseDeviceType"]];
                    
                    NSMutableDictionary* mDic = [dic mutableCopy];
                    
                    NSString* p = mDic[@"viewablePeriod"];
                    NSString* s = mDic[@"viewablePeriodState"];
                    NSString* b = mDic[@"purchasedTime"];
                    
                    NSNumber* validTime =  [[CMAppManager sharedInstance] expiredDateIntervalWithPeriod:p purchased:b state:s];
                    [mDic setObject:validTime forKey:@"validTime"];
                    
                    if ( [sPurchaseDeviceType isEqualToString:@"2"] )
                    {
                        // 모바일구매
                        [mobile addObject:mDic];
                    }
                    else
                    {
                        // tv 구매
                        [tv addObject:mDic];
                    }
                }
                
            }
        }
        
        [self.pValidPurchaseLogListMoblieArr removeAllObjects];
        [self.pValidPurchaseLogListTvArr removeAllObjects];
        //소팅
        NSSortDescriptor* desc1 = [[NSSortDescriptor alloc] initWithKey:@"viewablePeriodState" ascending:NO];
        NSSortDescriptor* desc2 = [[NSSortDescriptor alloc] initWithKey:@"validTime" ascending:NO];
        NSSortDescriptor* desc3 = [[NSSortDescriptor alloc] initWithKey:@"purchasedTime" ascending:NO];
        NSArray* sorted = nil;
        if (mobile.count > 1) {//licenseEnd
            sorted = [mobile sortedArrayUsingDescriptors:@[desc1, desc2, desc3]];
            [self.pValidPurchaseLogListMoblieArr addObjectsFromArray:sorted];
        }
        else {
            [self.pValidPurchaseLogListMoblieArr addObjectsFromArray:mobile];
        }
        
        if (tv.count > 1) {
            sorted = [tv sortedArrayUsingDescriptors:@[desc1, desc2, desc3]];
            [self.pValidPurchaseLogListTvArr addObjectsFromArray:sorted];
        } else {
            [self.pValidPurchaseLogListTvArr addObjectsFromArray:tv];
        }
        
        
        if ( self.nSubTabTag == 0 )
        {
            // 모바일 구매목록
            int nTotal = (int)[self.pValidPurchaseLogListMoblieArr count];
            if ( nTotal == 0 )
                self.pTotalExplanLbl01.text = [NSString stringWithFormat:@"구매한 모바일 VOD가 없습니다."];
            else
                self.pTotalExplanLbl01.text = [NSString stringWithFormat:@"총 %d개의 모바일 VOD 구매목록이 있습니다.", nTotal];
            
        }
        else
        {
            // tv 구매목록
            int nTotal = (int)[self.pValidPurchaseLogListTvArr count];
            if ( nTotal == 0 )
                self.pTotalExplanLbl01.text = [NSString stringWithFormat:@"구매한 TV VOD가 없습니다."];
            else
                self.pTotalExplanLbl01.text = [NSString stringWithFormat:@"총 %d개의 TV VOD 구매목록이 있습니다.", nTotal];
            
        }
        
        [self.pSubTableView01 reloadData];
    }];
    
    [SIAlertView showAlertViewForTaskWithErrorOnCompletion:tesk delegate:nil];
}

#pragma mark - 찜목록
- (void)requestWithGetWishList
{
    NSURLSessionDataTask *tesk = [NSMutableDictionary myCmGetWishListCompletion:^(NSArray *myCm, NSError *error) {
        
        DDLogError(@"찜목록 = [%@]", myCm);
        
        if ( [myCm count] == 0 )
            return;
    
        [self.pWishListArr removeAllObjects];
        
        if ( [[[myCm objectAtIndex:0] objectForKey:@"errorString"] isEqualToString:@"WishList Not Found"] )
        {
            self.pTotalExplanLbl02.text = [NSString stringWithFormat:@"찜 한 VOD 가 없습니다."];
        }
        
        NSObject *itemObject = [[[myCm objectAtIndex:0] objectForKey:@"wishItemList"] objectForKey:@"wishItem"];
        
        if ( [itemObject isKindOfClass:[NSDictionary class]] )
        {
            // dictionary
            [self.pWishListArr addObject:(NSDictionary *)itemObject];
            
            self.pTotalExplanLbl02.text = [NSString stringWithFormat:@"총 1개의 찜 VOD가 있습니다."];
            
        }
        else
        {
            // array
            [self.pWishListArr setArray:(NSArray *)itemObject];
            
            int nTotal = (int)[self.pWishListArr count];
            self.pTotalExplanLbl02.text = [NSString stringWithFormat:@"총 %d개의 찜 VOD가 있습니다.", nTotal];
        }
        
        
        [self.pSubTableView02 reloadData];
    }];
    
    [SIAlertView showAlertViewForTaskWithErrorOnCompletion:tesk delegate:nil];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        DDLogError(@"delete");
        
        if ( self.nTapTag == MY_CM_MAIN_VIEW_BTN_02 )
        {
            // vod 구매목록
            NSString *sTitle = @"";
            if ( self.nSubTabTag == 0 )
            {
                // 모바일 구매목록
                sTitle = [NSString stringWithFormat:@"선택하신 VOD를\n목록에서 삭제하시겠습니까?\n%@", [[self.pValidPurchaseLogListMoblieArr objectAtIndex:indexPath.row] objectForKey:@"productName"]];
            }
            else
            {
                // tv 구매목록
                sTitle = [NSString stringWithFormat:@"선택하신 VOD를\n목록에서 삭제하시겠습니까?\n%@", [[self.pValidPurchaseLogListTvArr objectAtIndex:indexPath.row] objectForKey:@"productName"]];
            }
            
            
            [SIAlertView alert:@"VOD 구매 목록 삭제" message:sTitle cancel:@"취소" buttons:@[@"확인"]
                    completion:^(NSInteger buttonIndex, SIAlertView *alert) {
                        
                        if ( buttonIndex == 1 )
                        {
                            [self requestWithDisablePurchaseLogWithIndex:(int)indexPath.row];
                        }
                    }];
        }
        else if ( self.nTapTag == MY_CM_MAIN_VIEW_BTN_03 )
        {
            // vod 시청목록
            NSString *sTitle = [NSString stringWithFormat:@"선택하신 VOD를\n목록에서 삭제하시겠습니까?\n%@", [[self.pWatchListArr objectAtIndex:indexPath.row] objectForKey:@"title"]];
            
            [SIAlertView alert:@"VOD 시청 목록 삭제" message:sTitle cancel:@"취소" buttons:@[@"확인"]
                    completion:^(NSInteger buttonIndex, SIAlertView *alert) {
                        
                        if ( buttonIndex == 1 )
                        {
                            CMDBDataManager *manager = [CMDBDataManager sharedInstance];
                            [manager removeVodWatchList:(int)indexPath.row];
                            [self.pWatchListArr removeObjectAtIndex:indexPath.row];
                            [self refreshDesc];
                            [self.pSubTableView02 reloadData];
                        }
                    }];
        }
        else
        {
            NSString *sTitle = [NSString stringWithFormat:@"선택하신 VOD를\n목록에서 삭제하시겠습니까?\n%@", [[[self.pWishListArr objectAtIndex:indexPath.row] objectForKey:@"asset"] objectForKey:@"title"]];
            
            [SIAlertView alert:@"VOD 찜 목록 삭제" message:sTitle cancel:@"취소" buttons:@[@"확인"]
                    completion:^(NSInteger buttonIndex, SIAlertView *alert) {
                        
                        if ( buttonIndex == 1 )
                        {
                            [self requestWithRemoveWishItemWithIndex:(int)indexPath.row];
                        }
                    }];
        }
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *sTapName = @"";
    
    if ( self.nTapTag == MY_CM_MAIN_VIEW_BTN_02 )
    {
        // vod 구매목록
        sTapName = @"삭제";
    }
    else if ( self.nTapTag == MY_CM_MAIN_VIEW_BTN_03 )
    {
        // vod 시청목록
        sTapName = @"삭제";
    }
    else
    {
        sTapName = @"찜 해제";
    }
    return sTapName;
}

#pragma mark - 찜해제
- (void)requestWithRemoveWishItemWithIndex:(int)index
{
    NSString *sAssetId = [NSString stringWithFormat:@"%@", [[[self.pWishListArr objectAtIndex:index] objectForKey:@"asset"] objectForKey:@"assetId"]];
    NSURLSessionDataTask *tesk = [NSMutableDictionary wishRemoveWishWithAssetId:sAssetId completion:^(NSArray *wish, NSError *error) {
        
        DDLogError(@"찜해제 = [%@]", wish);
        
        if ( [wish count] == 0 )
            return;
        
        if ( [[[wish objectAtIndex:0] objectForKey:@"resultCode"] isEqualToString:@"100"] )
        {
            // 성공이면
            [self.pWishListArr removeObjectAtIndex:index];
            
            int nTotal = (int)[self.pWishListArr count];
            if ( nTotal == 0 )
            {
               self.pTotalExplanLbl02.text = [NSString stringWithFormat:@"찜 한 VOD 가 없습니다."];
            }
            else
            {
                self.pTotalExplanLbl02.text = [NSString stringWithFormat:@"총 %d개의 찜 VOD가 있습니다.", nTotal];
            }
            
            [self.pSubTableView02 reloadData];
        }
        
        
    }];
    
    [SIAlertView showAlertViewForTaskWithErrorOnCompletion:tesk delegate:nil];
}

#pragma mark - 구매목록 삭제
- (void)requestWithDisablePurchaseLogWithIndex:(int)index
{
    NSString *sPurchasedId = @"";
    
    if ( self.nSubTabTag == 0 )
    {
        // 모바일 구매목록
        sPurchasedId = [NSString stringWithFormat:@"%@", [[self.pValidPurchaseLogListMoblieArr objectAtIndex:index] objectForKey:@"purchasedId"]];
    }
    else
    {
        // tv 구매목록
        sPurchasedId = [NSString stringWithFormat:@"%@", [[self.pValidPurchaseLogListTvArr objectAtIndex:index] objectForKey:@"purchasedId"]];
    }
    NSURLSessionDataTask *tesk = [NSMutableDictionary myCmDisablePurchaseLogWithPurchaseEventId:sPurchasedId completion:^(NSArray *myCm, NSError *error) {
        
        DDLogError(@"구매목록 삭제 = [%@]", myCm);
        if ( [myCm count] == 0 )
            return;
        if ( [[[myCm objectAtIndex:0] objectForKey:@"resultCode"] isEqualToString:@"100"] )
        {
            if ( self.nSubTabTag == 0 )
            {
                // 모바일 구매목록
                [self.pValidPurchaseLogListMoblieArr removeObjectAtIndex:index];
                [self.pSubTableView01 reloadData];
                int nTotal = (int)[self.pValidPurchaseLogListMoblieArr count];
                if ( nTotal == 0 )
                    self.pTotalExplanLbl01.text = [NSString stringWithFormat:@"구매한 모바일 VOD가 없습니다."];
                else
                    self.pTotalExplanLbl01.text = [NSString stringWithFormat:@"총 %d개의 모바일 VOD 구매목록이 있습니다.", nTotal];
                

            }
            else
            {
                // tv 구매목록
                [self.pValidPurchaseLogListTvArr removeObjectAtIndex:index];
                [self.pSubTableView01 reloadData];
                int nTotal = (int)[self.pValidPurchaseLogListTvArr count];
                if ( nTotal == 0 )
                    self.pTotalExplanLbl01.text = [NSString stringWithFormat:@"구매한 TV VOD가 없습니다."];
                else
                    self.pTotalExplanLbl01.text = [NSString stringWithFormat:@"총 %d개의 TV VOD 구매목록이 있습니다.", nTotal];
            }
        }
    }];
    
    [SIAlertView showAlertViewForTaskWithErrorOnCompletion:tesk delegate:nil];
}

#pragma mark - 컨텐츠 유효기간 만료 팝업
- (void)callAlertInvalidContents {
    NSString* message = @"선택하신 VOD는 유효기간이 만료되어\n시청 및 구매가 제한된 상품입니다.";
    [SIAlertView alert:@"VOD 유효기간 만료" message:message containBoldText:message button:@"확인" completion:^(NSInteger buttonIndex, SIAlertView *alert) {
    }];
}


@end
