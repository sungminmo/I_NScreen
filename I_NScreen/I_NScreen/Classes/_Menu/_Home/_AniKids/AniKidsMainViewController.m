//
//  AniKidsMainViewController.m
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 10. 12..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import "AniKidsMainViewController.h"
#import "UIAlertView+AFNetworking.h"
#import "NSMutableDictionary+VOD.h"
#import "VodDetailBundleMainViewController.h"
#import "VodDetailMainViewController.h"

static NSString* const CollectionViewCell = @"CollectionViewCell";

@interface AniKidsMainViewController ()
@property (nonatomic, strong) NSMutableArray *pTwoDepthTreeDataArr; // 투댑스 카테고리 데이터 저장
@property (nonatomic, strong) NSMutableArray *pThreeDepthDailyDataArr;  // 3댑스에 실시간 데이터 저장
@property (nonatomic, strong) NSMutableArray *pThreeDepthWeeklyDataArr; // 3댑스에 주간 인기 순위 데이터 저장
@property (nonatomic, strong) NSMutableArray *pThreeDepthElseDataArr;   // 3댑스에 그외 데이터 저장

@property (nonatomic, strong) NSString *pCategoryId;
@end

@implementation AniKidsMainViewController
@synthesize delegate;
@synthesize pDataDic;

- (void)viewDidLoad {
    [super viewDidLoad];

    UINib* nib;
    nib = [UINib nibWithNibName:@"CMHomeCommonCollectionViewCell" bundle:nil];
    [self.pCollectionView21 registerNib:nib forCellWithReuseIdentifier:CollectionViewCell];
    [self.pCollectionView22 registerNib:nib forCellWithReuseIdentifier:CollectionViewCell];
    
    [self setTagInit];
    [self setViewInit];
    
    [self requestWithGetCategoryTree];
}

#pragma mark - 초기화
#pragma mark - 버튼 태그 초기화
- (void) setTagInit
{
    self.pDepthBtn.tag = ANI_KIDS_MAIN_VIEW_BTN_01;
    self.pRealTimeBtn.tag = ANI_KIDS_MAIN_VIEW_BTN_02;
    self.pWeekBtn.tag = ANI_KIDS_MAIN_VIEW_BTN_03;
}

#pragma mark - 화면 초기화
- (void) setViewInit
{
    self.pTwoDepthTreeDataArr = [[NSMutableArray alloc] init];
    self.pThreeDepthDailyDataArr = [[NSMutableArray alloc] init];
    self.pThreeDepthWeeklyDataArr = [[NSMutableArray alloc] init];
    self.pThreeDepthElseDataArr = [[NSMutableArray alloc] init];
    
    self.isItemCheck = NO;      // 실시간 인기 순위
    self.pViewerTypeStr = @"0";
}

#pragma mark - 액션 이벤트
#pragma mark - 버튼 액션 이벤트
- (IBAction)onBtnClicked:(UIButton *)btn
{
    switch ([btn tag]) {
        case ANI_KIDS_MAIN_VIEW_BTN_01:
        {
            [self.delegate AniKidsMainViewWithBtnTag:ANI_KIDS_MAIN_VIEW_BTN_01 WithCategoryId:self.pCategoryId];
        }break;
        case ANI_KIDS_MAIN_VIEW_BTN_02:
        {
            // 실시간 인기 순위 버튼123 90 163   138 140 142
            self.isItemCheck = NO;
            
            [self.pRealTimeBtn setTitleColor:[UIColor colorWithRed:123.0f/255.0f green:90.0f/255.0f blue:163.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
            [self.pWeekBtn setTitleColor:[UIColor colorWithRed:138.0f/255.0f green:140.0f/255.0f blue:142.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
            
            
            self.pRealTimeBtn.selected = YES;
            self.pWeekBtn.selected = NO;
            self.pLeftLineHeight.constant = 2;
            self.pRightLineHeight.constant = 1;
            
            [self requestWithGetPopularityChart3DepthWithItem:self.isItemCheck];
            
        }break;
        case ANI_KIDS_MAIN_VIEW_BTN_03:
        {
            // 주간 인기 순위 버튼
            self.isItemCheck = YES;
            
            [self.pRealTimeBtn setTitleColor:[UIColor colorWithRed:138.0f/255.0f green:140.0f/255.0f blue:142.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
            [self.pWeekBtn setTitleColor:[UIColor colorWithRed:123.0f/255.0f green:90.0f/255.0f blue:163.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
            
            self.pRealTimeBtn.selected = NO;
            self.pWeekBtn.selected = YES;
            self.pLeftLineHeight.constant = 1;
            self.pRightLineHeight.constant = 2;
            
            [self requestWithGetPopularityChart3DepthWithItem:self.isItemCheck];
            
        }break;
    }
}

#pragma mark - 전문
#pragma mark - 2탭스 카테고리 id 가져옴
- (void)requestWithGetCategoryTree
{
    NSURLSessionDataTask *tesk = [NSMutableDictionary vodGetCategoryTreeBlock:^(NSArray *vod, NSError *error) {
        
        DDLogError(@"카테고리 id = [%@]", vod);
        
        if ( [vod count] == 0 )
            return;
        
        NSString *sCategoryId = @"";
        
        for ( NSDictionary *dic in [[[vod objectAtIndex:0] objectForKey:@"categoryList"] objectForKey:@"category"] )
        {
            if ( [[dic objectForKey:@"description"] isEqualToString:@"mobileTV_02"] )
            {
                sCategoryId = [NSString stringWithFormat:@"%@", [dic objectForKey:@"categoryId"]];
            }
        }
        
        [self requestWithGetCategoryTree2DepthWithCategoryId:sCategoryId];
    }];
    
    [SIAlertView showAlertViewForTaskWithErrorOnCompletion:tesk delegate:nil];
}

#pragma mark - 2탭스 카테고리 tree 리스트 전문
- (void)requestWithGetCategoryTree2DepthWithCategoryId:(NSString *)categoryId
{
    self.pCategoryId = [NSString stringWithFormat:@"%@", categoryId];
    NSURLSessionDataTask *tesk = [NSMutableDictionary vodGetCategoryTreeWithCategoryId:categoryId WithDepth:@"2" block:^(NSArray *vod, NSError *error) {
        
        DDLogError(@"2탭스 카테고리 tree 리스트 = [%@]", vod);
        [self.pTwoDepthTreeDataArr removeAllObjects];
        
        if ( [[[[vod objectAtIndex:0] objectForKey:@"categoryList"] objectForKey:@"category"] count] <= 1 )
            return; // 서브 댑스가 없음 첫번째는 1댑스
        
        int nCount = 0;
        
        for ( NSDictionary *dic in [[[vod objectAtIndex:0] objectForKey:@"categoryList"] objectForKey:@"category"] )
        {
            NSString *sDicViewerType = [NSString stringWithFormat:@"%@", [dic objectForKey:@"viewerType"]];
            
            if ( nCount != 0 )
            {
                if ( ![sDicViewerType isEqualToString:@"60"] )
                {
                    [self.pTwoDepthTreeDataArr addObject:dic];
                }
            }
            
            nCount++;
        }
        
        NSString *sViewerType = [NSString stringWithFormat:@"%@", [[[self pTwoDepthTreeDataArr] objectAtIndex:0] objectForKey:@"viewerType"]];
        NSString *sCategoryId = [NSString stringWithFormat:@"%@", [[[self pTwoDepthTreeDataArr] objectAtIndex:0] objectForKey:@"categoryId"]];
        
        self.pViewerTypeStr = [NSString stringWithString:sViewerType];
        
        if ( [self.pDataDic count] != 0 )
        {
            sCategoryId = [NSString stringWithFormat:@"%@", [self.pDataDic objectForKey:@"categoryId"]];
            sViewerType = [NSString stringWithFormat:@"%@", [self.pDataDic objectForKey:@"viewerType"]];
            
            NSString *sCategoryName = [NSString stringWithFormat:@"%@", [self.pDataDic objectForKey:@"categoryName"]];
            
            [self.pDepthBtn setTitle:sCategoryName forState:UIControlStateNormal];
            
            if ( [sViewerType isEqualToString:@"200"] )
            {
                // 인기순위
                self.pView21.hidden = NO;
                self.pView22.hidden = YES;
                
                
                self.isItemCheck = NO;
                [self requestWithGetPopularityChart3DepthWithItem:self.isItemCheck];
            }
            else
            {
                // 그외
                self.pView21.hidden = YES;
                self.pView22.hidden = NO;
                
                [self requestWithElse3DepthWithViewerType:sViewerType WithCategoryId:sCategoryId];
            }
            
        }
        else
        {
            
            NSString *sCategoryName = [NSString stringWithFormat:@"%@", [[self.pTwoDepthTreeDataArr objectAtIndex:0] objectForKey:@"categoryName"]];
            
            [self.pDepthBtn setTitle:sCategoryName forState:UIControlStateNormal];
            
            if ( [sViewerType isEqualToString:@"200"] )
            {
                // 인기순위
                self.pView21.hidden = NO;
                self.pView22.hidden = YES;
                
                
                self.isItemCheck = NO;
                [self requestWithGetPopularityChart3DepthWithItem:self.isItemCheck];
            }
            else
            {
                // 그외
                self.pView21.hidden = YES;
                self.pView22.hidden = NO;
                
                [self requestWithElse3DepthWithViewerType:sViewerType WithCategoryId:sCategoryId];
            }
            
        }
        
        
    }];
    
    [SIAlertView showAlertViewForTaskWithErrorOnCompletion:tesk delegate:nil];
}

#pragma mark - 인기순위 3댑스 리스트 뿌려줌   daily, weekly, all
- (void)requestWithGetPopularityChart3DepthWithItem:(BOOL)isItemCheck
{
    NSString *sItem = @"daily";
    if ( isItemCheck == YES )
    {
        // 주간 인기 순위
        sItem = @"weekly";
    }
    
    NSString *sCategoryId = @"";
    for ( NSDictionary *dic in self.pTwoDepthTreeDataArr )
    {
        NSString *sViewerType = [NSString stringWithFormat:@"%@", [dic objectForKey:@"viewerType"]];
        
        
        if ( [sViewerType isEqualToString:@"200"] )
        {
            // 인기 순위
            sCategoryId = [NSString stringWithFormat:@"%@", [dic objectForKey:@"categoryId"]];
            
        }
    }
    
    NSURLSessionDataTask *tesk = [NSMutableDictionary vodGetPopularityChartWithCategoryId:sCategoryId WithRequestItems:sItem completion:^(NSArray *vod, NSError *error) {
        
        DDLogError(@"인기순위 3댑스 리스트 = [%@]", vod);
        
        if ( isItemCheck == NO )
        {
            // 실시간 인기 순위
            [self.pThreeDepthDailyDataArr removeAllObjects];
            
            NSArray* popularity = (NSArray*)vod[0][@"dailyChart"][@"popularityList"][@"popularity"];
            
            [self.pThreeDepthDailyDataArr addObjectsFromArray:popularity];
            
            [self.pCollectionView21 reloadData];
        }
        else
        {
            // 주간 인기 순위
            [self.pThreeDepthWeeklyDataArr removeAllObjects];
            
            NSArray* popularity = (NSArray*)vod[0][@"weeklyChart"][@"popularityList"][@"popularity"];
            
            [self.pThreeDepthWeeklyDataArr addObjectsFromArray:popularity];
            
            [self.pCollectionView21 reloadData];
        }
        
        
    }];
    
    [SIAlertView showAlertViewForTaskWithErrorOnCompletion:tesk delegate:nil];
}

#pragma mark - 3댑스 인기순위 외 전문 리스트
- (void)requestWithElse3DepthWithViewerType:(NSString *)viewerType WithCategoryId:(NSString *)categoryId
{
    [self.pThreeDepthElseDataArr removeAllObjects];
    NSURLSessionDataTask *tesk = [NSMutableDictionary vodGetContentGroupListWithContentGroupProfile:@"2" WithCategoryId:categoryId completion:^(NSArray *vod, NSError *error) {
        
        DDLogError(@"카테고리형 포스터 리스트 = [%@]", vod);
        
        
        NSObject *itemObjet = vod[0][@"contentGroupList"][@"contentGroup"];
        
        if ( [itemObjet isKindOfClass:[NSDictionary class]] )
        {
            [self.pThreeDepthElseDataArr addObject:itemObjet];
        }
        else
        {
            [self.pThreeDepthElseDataArr addObjectsFromArray:(NSArray *)itemObjet];
        }
        
        [self.pCollectionView22 reloadData];
    }];
    
    [SIAlertView showAlertViewForTaskWithErrorOnCompletion:tesk delegate:nil];
}

#pragma mark - UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    int nTotalCount = 0;
    
    if ( collectionView == self.pCollectionView21 )
    {
        // 인기순위 테이블 뷰
        if ( self.isItemCheck == NO )
        {
            // 실시간 인기순위
            nTotalCount = (int)[self.pThreeDepthDailyDataArr count];
        }
        else
        {
            // 주간 인기순위
            nTotalCount = (int)[self.pThreeDepthWeeklyDataArr count];
        }
    }
    else
    {
        // 그외 테이블 뷰
        nTotalCount = (int)[self.pThreeDepthElseDataArr count];
    }
    return nTotalCount;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size;
    
    if ( [[[CMAppManager sharedInstance] getDeviceCheck] isEqualToString:IPHONE_RESOLUTION_6_PLUS] )
    {
        size.width = 95;
        size.height = 158;
    }
    else if ( [[[CMAppManager sharedInstance] getDeviceCheck] isEqualToString:IPHONE_RESOLUTION_6] )
    {
        size.width = 85;
        size.height = 138;
    }
    else
    {
        size.width = 70;
        size.height = 113;
    }
    
    
    return size;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CMHomeCommonCollectionViewCell* pCell = (CMHomeCommonCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:CollectionViewCell forIndexPath:indexPath];
    
    pCell.delegate = self;
    if ( collectionView == self.pCollectionView21 )
    {
        if ( self.isItemCheck == NO )
        {
            [pCell setListData:self.pThreeDepthDailyDataArr[indexPath.row] WithViewerType:self.pViewerTypeStr];
        }
        else
        {
            [pCell setListData:self.pThreeDepthWeeklyDataArr[indexPath.row] WithViewerType:self.pViewerTypeStr];
        }
    }
    else
    {
        [pCell setListData:self.pThreeDepthElseDataArr[indexPath.row] WithViewerType:self.pViewerTypeStr];
    }
    
    return pCell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)CMHomeCommonCollectionViewDidItemSelectWithAssetId:(NSString *)sAssetId WithAdultCheck:(BOOL)isAdult WithEpisodePeerExistentce:(NSString *)episodePeerExistence WithContentGroupId:(NSString *)contentGroupId WithAssetBundle:(NSString *)assetBundle
{
    if ( isAdult == YES )
    {
        // 성인 컨첸츠이면
        if ( [[CMAppManager sharedInstance] getKeychainAdultCertification] == YES )
        {
            if ( [assetBundle isEqualToString:@"1"] )
            {
                // 묶음 상품일시
                [self requestWithAssetInfo:sAssetId WithEpisodePeerExistence:episodePeerExistence WithContentGroupId:contentGroupId];
            }
            else
            {
                VodDetailMainViewController *pViewController = [[VodDetailMainViewController alloc] initWithNibName:@"VodDetailMainViewController" bundle:nil];
                pViewController.delegate = self;
                pViewController.pAssetIdStr = sAssetId;
                pViewController.pEpisodePeerExistence = episodePeerExistence;
                pViewController.pContentGroupId = contentGroupId;
                [self.navigationController pushViewController:pViewController animated:YES];
            }
        }
        else
        {
            [SIAlertView alert:@"성인인증 필요" message:@"성인 인증이 필요한 콘텐츠입니다.\n성인 인증을 하시겠습니까?" cancel:@"취소" buttons:@[@"확인"]
                    completion:^(NSInteger buttonIndex, SIAlertView *alert) {
                        
                        if ( buttonIndex == 1 )
                        {
                            // 설정 창으로 이동
                            CMPreferenceMainViewController* controller = [[CMPreferenceMainViewController alloc] initWithNibName:@"CMPreferenceMainViewController" bundle:nil];
                            [self.navigationController pushViewController:controller animated:YES];
                        }
                    }];

        }
    }
    else
    {
        if ( [assetBundle isEqualToString:@"1"] )
        {
            [self requestWithAssetInfo:sAssetId WithEpisodePeerExistence:episodePeerExistence WithContentGroupId:contentGroupId];
        }
        else
        {
            VodDetailMainViewController *pViewController = [[VodDetailMainViewController alloc] initWithNibName:@"VodDetailMainViewController" bundle:nil];
            pViewController.delegate = self;
            pViewController.pAssetIdStr = sAssetId;
            pViewController.pEpisodePeerExistence = episodePeerExistence;
            pViewController.pContentGroupId = contentGroupId;
            [self.navigationController pushViewController:pViewController animated:YES];
        }
    }
}


#pragma mark - vod 상세 bundle 이며 구매 여부를 가져오기 위해 호출
- (void)requestWithAssetInfo:(NSString *)assetInfo WithEpisodePeerExistence:(NSString *)episodePeerExistence WithContentGroupId:(NSString *)contentGroupId
{
    NSURLSessionDataTask *tesk = [NSMutableDictionary vodGetAssetInfoWithAssetId:assetInfo WithAssetProfile:@"9" completion:^(NSArray *vod, NSError *error) {
        
        DDLogError(@"vod 상세 = [%@]", vod);
        
        if ( [vod count] == 0 )
            return;
        
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        NSObject *itemObject = [[[[vod objectAtIndex:0] objectForKey:@"asset"] objectForKey:@"productList"] objectForKey:@"product"];
        
        if ( [itemObject isKindOfClass:[NSDictionary class]] )
        {
            [arr addObject:itemObject];
        }
        else
        {
            [arr setArray:(NSArray *)itemObject];
        }
        
        NSString *sProductId = @"";
        
        BOOL isCheck = NO;
        for ( NSDictionary *dic in arr )
        {
            NSString *sProductType = dic[@"productType"];
            NSString *sPurchasedTime = dic[@"purchasedTime"];
            
            if ( [sProductType isEqualToString:@"Bundle"] &&
                [sPurchasedTime length] != 0 )
            {   // 번들이고 구매한 사용자
                isCheck = YES;
                sProductId = dic[@"productId"];
            }
        }
        
        if ( isCheck == YES )
        {
            // 묶음 페이지이동
            VodDetailBundleMainViewController *pViewController = [[VodDetailBundleMainViewController alloc] initWithNibName:@"VodDetailBundleMainViewController" bundle:nil];
            pViewController.sAssetId = assetInfo;
            pViewController.sEpisodePeerExistence = episodePeerExistence;
            pViewController.sContentGroupId = contentGroupId;
            pViewController.sProductId = sProductId;
            [self.navigationController pushViewController:pViewController animated:YES];
        }
        else
        {
            // 기존 상세 로직
            VodDetailMainViewController *pViewController = [[VodDetailMainViewController alloc] initWithNibName:@"VodDetailMainViewController" bundle:nil];
            pViewController.delegate = self;
            pViewController.pAssetIdStr = assetInfo;
            pViewController.pEpisodePeerExistence = episodePeerExistence;
            pViewController.pContentGroupId = contentGroupId;
            [self.navigationController pushViewController:pViewController animated:YES];
        }
        
    }];
    
    [SIAlertView showAlertViewForTaskWithErrorOnCompletion:tesk delegate:nil];
}

- (void)VodDetailMainViewWithTag:(int)nTag WithProductId:(NSString *)productId WithAssetId:(NSString *)assetId WithEpisodePeerExistence:(NSString *)EpisodePeerExistence WithContentGroupId:(NSString *)contentGroupId
{
    VodDetailBundleMainViewController *pViewController = [[VodDetailBundleMainViewController alloc] initWithNibName:@"VodDetailBundleMainViewController" bundle:nil];
    pViewController.sAssetId = assetId;
    pViewController.sEpisodePeerExistence = EpisodePeerExistence;
    pViewController.sContentGroupId = contentGroupId;
    pViewController.sProductId = productId;
    [self.navigationController pushViewController:pViewController animated:YES];
}

@end
