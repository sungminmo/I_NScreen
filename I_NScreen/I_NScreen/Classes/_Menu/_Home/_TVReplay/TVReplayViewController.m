//
//  TVReplayViewController.m
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 10. 23..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import "TVReplayViewController.h"
#import "UIAlertView+AFNetworking.h"
#import "NSMutableDictionary+VOD.h"

@interface TVReplayViewController ()
@property (nonatomic, strong) NSMutableArray *pTwoDepthTreeDataArr; // 투댑스 카테고리 데이터 저장
@property (nonatomic, strong) NSMutableArray *pThreeDepthDailyDataArr;  // 3댑스에 실시간 데이터 저장
@property (nonatomic, strong) NSMutableArray *pThreeDepthWeeklyDataArr; // 3댑스에 주간 인기 순위 데이터 저장
@property (nonatomic, strong) NSMutableArray *pThreeDepthElseDataArr;   // 3댑스에 그외 데이터 저장

// 전체 리스트 전문
@property (nonatomic, strong) NSString *pFourDepthListJsonStr;
@end

@implementation TVReplayViewController
@synthesize delegate;
@synthesize pDataDic;

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setTagInit];
    [self setViewInit];
    
    [self requestWithGetCategoryTree2Depth];
    [self requestWithGetCateforyTree4Depth];
}

#pragma mark - 초기화
#pragma mark - 버튼 태그 초기화
- (void) setTagInit
{
    self.pDepthBtn.tag = TV_REPLAY_VIEW_BTN_01;
    self.pRealTimeBtn.tag = TV_REPLAY_VIEW_BTN_02;
    self.pWeekBtn.tag = TV_REPLAY_VIEW_BTN_03;
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
        case TV_REPLAY_VIEW_BTN_01:
        {
            [self.delegate TVReplayViewWithBtnTag:TV_REPLAY_VIEW_BTN_01 WithDataStr:self.pFourDepthListJsonStr];
        }break;
        case TV_REPLAY_VIEW_BTN_02:
        {
            // 실시간 인기 순위 버튼123 90 163   138 140 142
            self.isItemCheck = NO;
            
            [self.pRealTimeBtn setTitleColor:[UIColor colorWithRed:123.0f/255.0f green:90.0f/255.0f blue:163.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
            [self.pWeekBtn setTitleColor:[UIColor colorWithRed:138.0f/255.0f green:140.0f/255.0f blue:142.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
            
            self.pLeftLineView.frame = CGRectMake(self.pLeftLineView.frame.origin.x, 39, self.pLeftLineView.frame.size.width, 2);
            self.pRightLineView.frame = CGRectMake(self.pRightLineView.frame.origin.x, 40, self.pRightLineView.frame.size.width, 1);
            
            [self requestWithGetPopularityChart3DepthWithItem:self.isItemCheck];
            
        }break;
        case TV_REPLAY_VIEW_BTN_03:
        {
            // 주간 인기 순위 버튼
            self.isItemCheck = YES;
            
            [self.pRealTimeBtn setTitleColor:[UIColor colorWithRed:138.0f/255.0f green:140.0f/255.0f blue:142.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
            [self.pWeekBtn setTitleColor:[UIColor colorWithRed:123.0f/255.0f green:90.0f/255.0f blue:163.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
            
            self.pLeftLineView.frame = CGRectMake(self.pLeftLineView.frame.origin.x, 40, self.pLeftLineView.frame.size.width, 1);
            self.pRightLineView.frame = CGRectMake(self.pRightLineView.frame.origin.x, 39, self.pRightLineView.frame.size.width, 2);
            
            [self requestWithGetPopularityChart3DepthWithItem:self.isItemCheck];
            
        }break;
    }
}

#pragma mark - 전문
#pragma mark - 4댑스 카테고리 tree 리스트 전문
- (void)requestWithGetCateforyTree4Depth
{
    NSURLSessionDataTask *tesk = [NSMutableDictionary vodGetCategoryTreeWithCategoryId:CNM_OPEN_API_ANNI_CATEGORY_ID WithDepth:@"4" block:^(NSArray *vod, NSError *error) {
        
        DDLogError(@"4댑스 카테고리 tree 리스트 = [%@]", vod);
        
        NSData* jsonData = [NSJSONSerialization dataWithJSONObject:[[CMAppManager sharedInstance] getResponseTreeSplitWithData:vod WithCategoryIdSearch:CNM_OPEN_API_ANNI_CATEGORY_ID]
                                                           options:NSJSONWritingPrettyPrinted error:&error];
        self.pFourDepthListJsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        NSLog(@"jsonString = [%@]", self.pFourDepthListJsonStr);
    }];
    
    
    [UIAlertView showAlertViewForTaskWithErrorOnCompletion:tesk delegate:nil];
}

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
            
            int nIndex = 1;
            int nTotal = (int)[[[[[vod objectAtIndex:0] objectForKey:@"dailyChart"] objectForKey:@"popularityList"] objectForKey:@"popularity"] count];
            
            NSMutableArray *pArr = [[NSMutableArray alloc] init];
            
            for ( NSDictionary *dic in [[[[vod objectAtIndex:0] objectForKey:@"dailyChart"] objectForKey:@"popularityList"] objectForKey:@"popularity"] )
            {
                [pArr addObject:dic];
                
                if ( nIndex % 4 == 0 || nIndex == nTotal)
                {
                    [self.pThreeDepthDailyDataArr addObject:[pArr copy]];
                    [pArr removeAllObjects];
                }
                
                nIndex++;
            }
            
            [self.pTableView21 reloadData];
        }
        else
        {
            // 주간 인기 순위
            [self.pThreeDepthWeeklyDataArr removeAllObjects];
            
            
            int nIndex = 1;
            int nTotal = (int)[[[[[vod objectAtIndex:0] objectForKey:@"weeklyChart"] objectForKey:@"popularityList"] objectForKey:@"popularity"] count];
            
            NSMutableArray *pArr = [[NSMutableArray alloc] init];
            
            for ( NSDictionary *dic in [[[[vod objectAtIndex:0] objectForKey:@"weeklyChart"] objectForKey:@"popularityList"] objectForKey:@"popularity"] )
            {
                [pArr addObject:dic];
                
                if ( nIndex % 4 == 0 || nIndex == nTotal)
                {
                    [self.pThreeDepthWeeklyDataArr addObject:[pArr copy]];
                    [pArr removeAllObjects];
                }
                
                nIndex++;
            }
            
            [self.pTableView21 reloadData];
            
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
            
            int nIndex = 1;
            int nTotal = (int)[[[[vod objectAtIndex:0] objectForKey:@"contentGroupList"] objectForKey:@"contentGroup"] count];
            
            NSMutableArray *pArr = [[NSMutableArray alloc] init];
            
            for ( NSDictionary *dic in [[[vod objectAtIndex:0] objectForKey:@"contentGroupList"] objectForKey:@"contentGroup"] )
            {
                [pArr addObject:dic];
                
                if ( nIndex % 4 == 0 || nIndex == nTotal)
                {
                    [self.pThreeDepthElseDataArr addObject:[pArr copy]];
                    [pArr removeAllObjects];
                }
                
                nIndex++;
                
            }
            
            [self.pTableView22 reloadData];
        }];
        
        [UIAlertView showAlertViewForTaskWithErrorOnCompletion:tesk delegate:nil];
    }
    else if ( [viewerType isEqualToString:@"41"] )
    {
        // 묶음 리스트 getBundleProductList
        NSURLSessionDataTask *tesk = [NSMutableDictionary vodGetBundleProductListWithProductProfile:@"1" completion:^(NSArray *vod, NSError *error) {
            
            DDLogError(@"묶음 상품 리스트 = [%@]", vod);
            
            int nIndex = 1;
            int nTotal = (int)[[[[vod objectAtIndex:0] objectForKey:@"productList"] objectForKey:@"product"] count];
            
            NSMutableArray *pArr = [[NSMutableArray alloc] init];
            
            for ( NSDictionary *dic in [[[vod objectAtIndex:0] objectForKey:@"productList"] objectForKey:@"product"] )
            {
                [pArr addObject:dic];
                
                if ( nIndex % 4 == 0 || nIndex == nTotal)
                {
                    [self.pThreeDepthElseDataArr addObject:[pArr copy]];
                    [pArr removeAllObjects];
                }
                
                nIndex++;
            }
            
            [self.pTableView22 reloadData];
        }];
        
        [UIAlertView showAlertViewForTaskWithErrorOnCompletion:tesk delegate:nil];
    }
    else if ( [viewerType isEqualToString:@"1021"] )
    {
        // 마니아 추천 vod getAssetList
        NSURLSessionDataTask *tesk = [NSMutableDictionary vodGetAssetInfoWithAssetId:categoryId WithAssetProfile:@"7" completion:^(NSArray *vod, NSError *error) {
            
            DDLogError(@"마니아 추천 = [%@]", vod);
            int nIndex = 1;
            int nTotal = (int)[[[[vod objectAtIndex:0] objectForKey:@"assetList"] objectForKey:@"asset"] count];
            
            NSMutableArray *pArr = [[NSMutableArray alloc] init];
            
            for ( NSDictionary *dic in [[[vod objectAtIndex:0] objectForKey:@"assetList"] objectForKey:@"asset"] )
            {
                [pArr addObject:dic];
                
                if ( nIndex % 4 == 0 || nIndex == nTotal)
                {
                    [self.pThreeDepthElseDataArr addObject:[pArr copy]];
                    [pArr removeAllObjects];
                }
                
                nIndex++;
            }
            
            [self.pTableView22 reloadData];
            
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *pCellIn = @"TVReplayTableViewCellIn";
    
    TVReplayTableViewCell *pCell = (TVReplayTableViewCell *)[tableView dequeueReusableCellWithIdentifier:pCellIn];
    
    if (pCell == nil)
    {
        NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"TVReplayTableViewCell" owner:nil options:nil];
        pCell = [arr objectAtIndex:0];
    }
    pCell.delegate = self;
    [pCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    if ( tableView == self.pTableView21 )
    {
        if ( self.isItemCheck == NO )
        {
            [pCell setListData:[self.pThreeDepthDailyDataArr objectAtIndex:indexPath.row] WithIndex:(int)indexPath.row WithViewerType:self.pViewerTypeStr];
        }
        else
        {
            [pCell setListData:[self.pThreeDepthWeeklyDataArr objectAtIndex:indexPath.row] WithIndex:(int)indexPath.row WithViewerType:self.pViewerTypeStr];
        }
    }
    else
    {
        [pCell setListData:[self.pThreeDepthElseDataArr objectAtIndex:indexPath.row] WithIndex:(int)indexPath.row WithViewerType:self.pViewerTypeStr];
    }
    
    return pCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    EpgSubViewController *pViewController = [[EpgSubViewController alloc] initWithNibName:@"EpgSubViewController" bundle:nil];
    //    [self.navigationController pushViewController:pViewController animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 170;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int nTotalCount = 0;
    
    if ( tableView == self.pTableView21 )
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (void)TVReplayTableViewCellBtnClicked:(int)nTag WithSelect:(int)nSelect WithAssetId:(NSString *)assetId
{
    VodDetailMainViewController *pViewController = [[VodDetailMainViewController alloc] initWithNibName:@"VodDetailMainViewController" bundle:nil];
    pViewController.pAssetIdStr = assetId;
    [self.navigationController pushViewController:pViewController animated:YES];
    
}

@end
