//
//  AdultMainViewController.m
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 10. 12..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import "AdultMainViewController.h"
#import "UIAlertView+AFNetworking.h"
#import "NSMutableDictionary+VOD.h"

static NSString* const CollectionViewCell = @"CollectionViewCell";

@interface AdultMainViewController ()
@property (nonatomic, strong) NSMutableArray *pTwoDepthTreeDataArr; // 투댑스 카테고리 데이터 저장
@property (nonatomic, strong) NSMutableArray *pThreeDepthDailyDataArr;  // 3댑스에 실시간 데이터 저장
@property (nonatomic, strong) NSMutableArray *pThreeDepthWeeklyDataArr; // 3댑스에 주간 인기 순위 데이터 저장
@property (nonatomic, strong) NSMutableArray *pThreeDepthElseDataArr;   // 3댑스에 그외 데이터 저장

@end

@implementation AdultMainViewController
@synthesize pDataDic;

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UINib* nib;
    nib = [UINib nibWithNibName:@"CMHomeCommonCollectionViewCell" bundle:nil];
    [self.pCollectionView21 registerNib:nib forCellWithReuseIdentifier:CollectionViewCell];
    [self.pCollectionView22 registerNib:nib forCellWithReuseIdentifier:CollectionViewCell];
    
    [self setTagInit];
    [self setViewInit];
    
    [self requestWithGetCategoryTree2Depth];
}

#pragma mark - 초기화
#pragma mark - 버튼 태그 초기화
- (void) setTagInit
{
    self.pDepthBtn.tag = ADULT_MAIN_VIEW_BTN_01;
    self.pRealTimeBtn.tag = ADULT_MAIN_VIEW_BTN_02;
    self.pWeekBtn.tag = ADULT_MAIN_VIEW_BTN_03;
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
        case ADULT_MAIN_VIEW_BTN_01:
        {
            [self.delegate AdultMainViewWithBtnTag:ADULT_MAIN_VIEW_BTN_01];
        }break;
        case ADULT_MAIN_VIEW_BTN_02:
        {
            // 실시간 인기 순위 버튼123 90 163   138 140 142
            self.isItemCheck = NO;
            
            [self.pRealTimeBtn setTitleColor:[UIColor colorWithRed:123.0f/255.0f green:90.0f/255.0f blue:163.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
            [self.pWeekBtn setTitleColor:[UIColor colorWithRed:138.0f/255.0f green:140.0f/255.0f blue:142.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
            
            self.pLeftLineHeight.constant = 2;
            self.pRightLineHeight.constant = 1;
            
            [self requestWithGetPopularityChart3DepthWithItem:self.isItemCheck];
            
        }break;
        case ADULT_MAIN_VIEW_BTN_03:
        {
            // 주간 인기 순위 버튼
            self.isItemCheck = YES;
            
            [self.pRealTimeBtn setTitleColor:[UIColor colorWithRed:138.0f/255.0f green:140.0f/255.0f blue:142.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
            [self.pWeekBtn setTitleColor:[UIColor colorWithRed:123.0f/255.0f green:90.0f/255.0f blue:163.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
            
            self.pLeftLineHeight.constant = 1;
            self.pRightLineHeight.constant = 2;
            
            [self requestWithGetPopularityChart3DepthWithItem:self.isItemCheck];
            
        }break;
    }
}

#pragma mark - 전문
#pragma mark - 2탭스 카테고리 tree 리스트 전문
- (void)requestWithGetCategoryTree2Depth
{
    NSURLSessionDataTask *tesk = [NSMutableDictionary vodGetCategoryTreeWithCategoryId:CNM_OPEN_API_ADULT_CATEGORY_ID WithDepth:@"2" block:^(NSArray *vod, NSError *error) {
        
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
            NSString *sCategoryName = [NSString stringWithFormat:@"%@", [self.pDataDic objectForKey:@"categoryName"]];
            
            [self.pDepthBtn setTitle:sCategoryName forState:UIControlStateNormal];
            
            sCategoryId = [NSString stringWithFormat:@"%@", [self.pDataDic objectForKey:@"categoryId"]];
            sViewerType = [NSString stringWithFormat:@"%@", [self.pDataDic objectForKey:@"viewerType"]];
            
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
    
    [UIAlertView showAlertViewForTaskWithErrorOnCompletion:tesk delegate:nil];
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
    
    [UIAlertView showAlertViewForTaskWithErrorOnCompletion:tesk delegate:nil];
}

#pragma mark - 3댑스 인기순위 외 전문 리스트
- (void)requestWithElse3DepthWithViewerType:(NSString *)viewerType WithCategoryId:(NSString *)categoryId
{
    [self.pThreeDepthElseDataArr removeAllObjects];
    
    if ( [viewerType isEqualToString:@"30"] )
    {
        // 카테고리형 포스터 리스트 getContentGroupList
        NSURLSessionDataTask *tesk = [NSMutableDictionary vodGetContentGroupListWithContentGroupProfile:@"2" WithCategoryId:categoryId completion:^(NSArray *vod, NSError *error) {
            
            DDLogError(@"카테고리형 포스터 리스트 = [%@]", vod);
            
            NSArray* contentGroup = (NSArray*)vod[0][@"contentGroupList"][@"contentGroup"];
            
            [self.pThreeDepthElseDataArr addObjectsFromArray:contentGroup];
            
            [self.pCollectionView22 reloadData];
        }];
        
        [UIAlertView showAlertViewForTaskWithErrorOnCompletion:tesk delegate:nil];
    }
    else if ( [viewerType isEqualToString:@"41"] )
    {
        // 묶음 리스트 getBundleProductList
        NSURLSessionDataTask *tesk = [NSMutableDictionary vodGetBundleProductListWithProductProfile:@"1" completion:^(NSArray *vod, NSError *error) {
            
            DDLogError(@"묶음 상품 리스트 = [%@]", vod);
            
            NSArray* product = (NSArray*)vod[0][@"productList"][@"product"];
            
            [self.pThreeDepthElseDataArr addObjectsFromArray:product];
            
            [self.pCollectionView22 reloadData];
        }];
        
        [UIAlertView showAlertViewForTaskWithErrorOnCompletion:tesk delegate:nil];
    }
    else if ( [viewerType isEqualToString:@"1021"] )
    {
        // 마니아 추천 vod getAssetList
        NSURLSessionDataTask *tesk = [NSMutableDictionary vodGetAssetInfoWithAssetId:categoryId WithAssetProfile:@"7" completion:^(NSArray *vod, NSError *error) {
            
            DDLogError(@"마니아 추천 = [%@]", vod);
            
            NSArray* asset = (NSArray*)vod[0][@"assetList"][@"asset"];

            [self.pThreeDepthElseDataArr addObjectsFromArray:asset];
            
            [self.pCollectionView22 reloadData];
        }];
        
        [UIAlertView showAlertViewForTaskWithErrorOnCompletion:tesk delegate:nil];
    }
    else if ( [viewerType isEqualToString:@"1311"] )
    {
        // 맞춤형 추천 리스트 recommendAssetBySubscriber
        NSURLSessionDataTask *tesk = [NSMutableDictionary vodRecommendAssetBySubscriberWithAssetProfile:@"7" block:^(NSArray *vod, NSError *error) {
            
            DDLogError(@"맞춤형 추천 리스트 = [%@]", vod);
            // 샘플 데이터 없음
        }];
        
        [UIAlertView showAlertViewForTaskWithErrorOnCompletion:tesk delegate:nil];
        
    }
    else
    {
        // !! TEST BJK error 테스트
        [SIAlertView alert:@"에러" message:@"없는 viewerType 입니다." button:@"확인"];
    }
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
    
    /*NSDictionary* data;
    
    if ( collectionView == self.pCollectionView21 )
    {
        if ( self.isItemCheck == NO )
        {
            data = self.pThreeDepthDailyDataArr[indexPath.row];

        }
        else
        {
            data = self.pThreeDepthWeeklyDataArr[indexPath.row];
        }
    }
    else
    {
        data = self.pThreeDepthElseDataArr[indexPath.row];
    }
    
    NSString* assetId = data[@"assetId"];
    
    VodDetailMainViewController *pViewController = [[VodDetailMainViewController alloc] initWithNibName:@"VodDetailMainViewController" bundle:nil];
    pViewController.pAssetIdStr = assetId;
    [self.navigationController pushViewController:pViewController animated:YES];*/
}

- (void)CMHomeCommonCollectionViewDidItemSelectWithAssetId:(NSString *)sAssetId
{
    VodDetailMainViewController *pViewController = [[VodDetailMainViewController alloc] initWithNibName:@"VodDetailMainViewController" bundle:nil];
    pViewController.pAssetIdStr = sAssetId;
    [self.navigationController pushViewController:pViewController animated:YES];
}

@end
