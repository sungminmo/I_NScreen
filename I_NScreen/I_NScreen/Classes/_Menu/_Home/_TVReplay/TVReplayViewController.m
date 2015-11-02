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
@property (nonatomic, strong) NSMutableArray *pThreeDepthDataArr;   // 3댑스에 그외 데이터 저장

@end

@implementation TVReplayViewController

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
    
}

#pragma mark - 초기화
#pragma mark - 버튼 태그 초기화
- (void) setTagInit
{
    self.pDepthBtn.tag = TV_REPLAY_VIEW_BTN_01;
}

#pragma mark - 화면 초기화
- (void) setViewInit
{
    self.pTwoDepthTreeDataArr = [[NSMutableArray alloc] init];
    self.pThreeDepthDataArr = [[NSMutableArray alloc] init];
    
    self.pViewerTypeStr = @"0";
}

#pragma mark - 액션 이벤트
#pragma mark - 버튼 액션 이벤트
- (IBAction)onBtnClicked:(UIButton *)btn
{
    switch ([btn tag]) {
        case TV_REPLAY_VIEW_BTN_01:
        {
            //            [self.delegate MovieMainViewWithBtnTag:MOVIE_MAIN_VIEW_BTN_01];
        }break;
    }
}

#pragma mark - 전문
#pragma mark - 2탭스 카테고리 tree 리스트 전문
- (void)requestWithGetCategoryTree2Depth
{
    NSURLSessionDataTask *tesk = [NSMutableDictionary vodGetCategoryTreeWithCategoryId:CNM_OPEN_API_TV_REPLAY_CATEGORY_ID WithDepth:@"2" block:^(NSArray *vod, NSError *error) {
        
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
        
//        [self requestWithElse3DepthWithViewerType:sViewerType WithCategoryId:sCategoryId];
    }];
    
    [UIAlertView showAlertViewForTaskWithErrorOnCompletion:tesk delegate:nil];
}



#pragma mark - 3댑스 인기순위 외 전문 리스트
- (void)requestWithElse3DepthWithViewerType:(NSString *)viewerType WithCategoryId:(NSString *)categoryId
{
//    [self.pThreeDepthElseDataArr removeAllObjects];
//    
//    if ( [viewerType isEqualToString:@"30"] )
//    {
//        // 카테고리형 포스터 리스트 getContentGroupList
//        NSURLSessionDataTask *tesk = [NSMutableDictionary vodGetContentGroupListWithContentGroupProfile:@"2" WithCategoryId:categoryId completion:^(NSArray *vod, NSError *error) {
//            
//            DDLogError(@"카테고리형 포스터 리스트 = [%@]", vod);
//            
//            int nIndex = 1;
//            int nTotal = (int)[[[[vod objectAtIndex:0] objectForKey:@"contentGroupList"] objectForKey:@"contentGroup"] count];
//            
//            NSMutableArray *pArr = [[NSMutableArray alloc] init];
//            
//            for ( NSDictionary *dic in [[[vod objectAtIndex:0] objectForKey:@"contentGroupList"] objectForKey:@"contentGroup"] )
//            {
//                [pArr addObject:dic];
//                
//                if ( nIndex % 4 == 0 || nIndex == nTotal)
//                {
//                    [self.pThreeDepthElseDataArr addObject:[pArr copy]];
//                    [pArr removeAllObjects];
//                }
//                
//                nIndex++;
//                
//            }
//            
//            [self.pTableView22 reloadData];
//        }];
//        
//        [UIAlertView showAlertViewForTaskWithErrorOnCompletion:tesk delegate:nil];
//    }
//    else if ( [viewerType isEqualToString:@"41"] )
//    {
//        // 묶음 리스트 getBundleProductList
//        NSURLSessionDataTask *tesk = [NSMutableDictionary vodGetBundleProductListWithProductProfile:@"1" completion:^(NSArray *vod, NSError *error) {
//            
//            DDLogError(@"묶음 상품 리스트 = [%@]", vod);
//            
//            int nIndex = 1;
//            int nTotal = (int)[[[[vod objectAtIndex:0] objectForKey:@"productList"] objectForKey:@"product"] count];
//            
//            NSMutableArray *pArr = [[NSMutableArray alloc] init];
//            
//            for ( NSDictionary *dic in [[[vod objectAtIndex:0] objectForKey:@"productList"] objectForKey:@"product"] )
//            {
//                [pArr addObject:dic];
//                
//                if ( nIndex % 4 == 0 || nIndex == nTotal)
//                {
//                    [self.pThreeDepthElseDataArr addObject:[pArr copy]];
//                    [pArr removeAllObjects];
//                }
//                
//                nIndex++;
//            }
//            
//            [self.pTableView22 reloadData];
//        }];
//        
//        [UIAlertView showAlertViewForTaskWithErrorOnCompletion:tesk delegate:nil];
//    }
//    else if ( [viewerType isEqualToString:@"1021"] )
//    {
//        // 마니아 추천 vod getAssetList
//        NSURLSessionDataTask *tesk = [NSMutableDictionary vodGetAssetInfoWithAssetId:categoryId WithAssetProfile:@"7" completion:^(NSArray *vod, NSError *error) {
//            
//            DDLogError(@"마니아 추천 = [%@]", vod);
//            int nIndex = 1;
//            int nTotal = (int)[[[[vod objectAtIndex:0] objectForKey:@"assetList"] objectForKey:@"asset"] count];
//            
//            NSMutableArray *pArr = [[NSMutableArray alloc] init];
//            
//            for ( NSDictionary *dic in [[[vod objectAtIndex:0] objectForKey:@"assetList"] objectForKey:@"asset"] )
//            {
//                [pArr addObject:dic];
//                
//                if ( nIndex % 4 == 0 || nIndex == nTotal)
//                {
//                    [self.pThreeDepthElseDataArr addObject:[pArr copy]];
//                    [pArr removeAllObjects];
//                }
//                
//                nIndex++;
//            }
//            
//            [self.pTableView22 reloadData];
//            
//        }];
//        
//        [UIAlertView showAlertViewForTaskWithErrorOnCompletion:tesk delegate:nil];
//    }
//    else if ( [viewerType isEqualToString:@"1311"] )
//    {
//        // 맞춤형 추천 리스트 recommendAssetBySubscriber
//        NSURLSessionDataTask *tesk = [NSMutableDictionary vodRecommendAssetBySubscriberWithAssetProfile:@"7" block:^(NSArray *vod, NSError *error) {
//            
//            DDLogError(@"맞춤형 추천 리스트 = [%@]", vod);
//            // 샘플 데이터 없음
//        }];
//        
//        [UIAlertView showAlertViewForTaskWithErrorOnCompletion:tesk delegate:nil];
//        
//    }
//    else
//    {
//        // !! TEST BJK error 테스트
//        [SIAlertView alert:@"에러" message:@"없는 viewerType 입니다." button:@"확인"];
//    }
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
    
    [pCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
   [pCell setListData:[self.pThreeDepthDataArr objectAtIndex:indexPath.row] WithIndex:(int)indexPath.row WithViewerType:self.pViewerTypeStr];
    
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
    
    // 그외 테이블 뷰
    nTotalCount = (int)[self.pThreeDepthDataArr count];
    return nTotalCount;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

@end
