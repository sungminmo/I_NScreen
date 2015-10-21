//
//  RecommendMainViewController.m
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 10. 12..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import "RecommendMainViewController.h"
#import "NSMutableDictionary+VOD.h"
#import "UIAlertView+AFNetworking.h"

@interface RecommendMainViewController ()
@property (nonatomic, strong) NSMutableArray *pBnViewController;    // 배너 컨트롤
@property (nonatomic, strong) NSMutableArray *pPopularityArr;       // 인기순위 top 20 배열 데이터
@property (nonatomic, strong) NSMutableArray *pWeekMovieArr;        // 금주의 신작 영화
@property (nonatomic, strong) NSMutableArray *pThisMonthRecommendArr;   // 이달의 추천

@end

@implementation RecommendMainViewController

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setTagInit];
    [self setViewInit];
    [self setDataInit];
    
//    [self banPageControllerInit];
    
    [self requestWithPopularTopTwenty];
    [self requestWithThisMonthRecommend];
    [self requestWithWeekMovie];
}

#pragma mark - 초기화
#pragma mark - 버튼 태그 초기화
- (void)setTagInit
{
    self.pMorePopulariryBtn.tag = RECOMMEND_MAIN_VIEW_BTN_01;
    self.pMoreNewWorkBtn.tag = RECOMMEND_MAIN_VIEW_BTN_02;
    self.pMoreRecommendBtn.tag = RECOMMEND_MAIN_VIEW_BTN_03;
}

#pragma mark - 화면 초기화
- (void)setViewInit
{
   
}

#pragma mark - 데이터 초기화
- (void)setDataInit
{
    self.pPopularityArr = [[NSMutableArray alloc] init];
    self.pWeekMovieArr = [[NSMutableArray alloc] init];
    self.pThisMonthRecommendArr = [[NSMutableArray alloc] init];
}

#pragma mark - 액션 이벤트
#pragma mark - 버튼 액션 이벤트
- (IBAction)onBtnClicked:(UIButton *)btn
{
    switch ([btn tag]) {
        case RECOMMEND_MAIN_VIEW_BTN_01:
        {
            // 인기 순위
            
        }break;
        case RECOMMEND_MAIN_VIEW_BTN_02:
        {
            // 금주의 신작 영화
            
        }break;
        case RECOMMEND_MAIN_VIEW_BTN_03:
        {
            // 이달의 추천 VOD
            
        }break;
    }
}

#pragma mark - 배너
#pragma mark - 배너 페이지 컨트롤 초기화
- (void)banPageControllerInit
{
    // 하드코딩 토탈 카운터 3개만 하자
    NSMutableArray *pControllers = [[NSMutableArray alloc] init];
    
    int nTotalCount = 3;
    
    for ( NSUInteger i = 0; i < nTotalCount; i++ )
    {
        [pControllers addObject:[NSNull null]];
    }
    
    self.pBnViewController = pControllers;
    
    self.pBannerPgControl.numberOfPages = nTotalCount;
    self.pBannerPgControl.currentPage = 0;
    
    self.pBannerScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.pBannerScrollView.frame) * nTotalCount, CGRectGetHeight(self.pBannerScrollView.frame));
    self.pBannerScrollView.pagingEnabled = YES;
    self.pBannerScrollView.showsHorizontalScrollIndicator = NO;
    self.pBannerScrollView.showsVerticalScrollIndicator = NO;
    self.pBannerScrollView.scrollsToTop = NO;
    self.pBannerScrollView.delegate = self;
    int nWith = [UIScreen mainScreen].bounds.size.width;
    self.pBannerScrollView.frame = CGRectMake(6, 10, nWith - 12, 100);
    self.pBannerScrollView.backgroundColor = [UIColor redColor];
    
    [self banLoadScrollViewWithPage:0];
    [self banLoadScrollViewWithPage:1];
}

#pragma mark - 배너 페이지 전환
- (void)banLoadScrollViewWithPage:(NSInteger )page
{
    int nTotalCount = 3;
    
    // 초기값 리턴
    if ( page >= nTotalCount || page < 0 )
        return;
    
    CMPageViewController *controller = [self.pBnViewController objectAtIndex:page];
    
    if ( (NSNull *)controller == [NSNull null] )
    {
        CGRect rect = self.pBannerScrollView.frame;
        
        controller = [[CMPageViewController alloc] initWithData:nil WithPage:(int)page WithFrame:rect];
        controller.delegate = self;
        [self.pBnViewController replaceObjectAtIndex:page withObject:controller];
    }
    
    if ( [controller.view superview] == nil )
    {
        CGRect frame = self.pBannerScrollView.frame;
        frame.origin.x = CGRectGetWidth(frame) * page;
        frame.origin.y = 0;
        controller.view.frame = frame;
        
        [self.pBannerScrollView addSubview:controller.view];
    }
}

#pragma mark - UIScrollView 델리게이트
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ( scrollView == self.pBannerScrollView )
    {
        CGFloat pageWidth = CGRectGetWidth(self.pBannerScrollView.frame);
        NSUInteger page = floor((self.pBannerScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        self.pBannerPgControl.currentPage = page;
        
        [self banLoadScrollViewWithPage:page - 1];
        [self banLoadScrollViewWithPage:page];
        [self banLoadScrollViewWithPage:page + 1];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ( indexPath.row == 0 )
    {
        static NSString *pCellIn1 = @"BannerTableViewCellIn";
        
        BannerTableViewCell *pCell1 = (BannerTableViewCell *)[tableView dequeueReusableCellWithIdentifier:pCellIn1];
        
        if ( pCell1 == nil )
        {
            NSArray *arr1 = [[NSBundle mainBundle] loadNibNamed:@"BannerTableViewCell" owner:nil options:nil];
            pCell1 = [arr1 objectAtIndex:0];
        }
        
        [pCell1 setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        return pCell1;
    }
 
    static NSString *pCellIn2 = @"CategoryTableViewCellIn";

    CategoryTableViewCell *pCell2 = (CategoryTableViewCell *)[tableView dequeueReusableCellWithIdentifier:pCellIn2];
    
    if ( pCell2 == nil )
    {
        NSArray *arr2 = [[NSBundle mainBundle] loadNibNamed:@"CategoryTableViewCell" owner:nil options:nil];
        pCell2 = [arr2 objectAtIndex:0];
    }
    
    [pCell2 setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    [pCell2 setListData:nil WithIndex:(int)indexPath.row];
    
    return pCell2;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    EpgSubViewController *pViewController = [[EpgSubViewController alloc] initWithNibName:@"EpgSubViewController" bundle:nil];
    //    [self.navigationController pushViewController:pViewController animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.row == 0 )
    {
        if ( [[[CMAppManager sharedInstance] getDeviceCheck] isEqualToString:IPHONE_RESOLUTION_6_PLUS] )
            return 230;
        else if ( [[[CMAppManager sharedInstance] getDeviceCheck] isEqualToString:IPHONE_RESOLUTION_6] )
            return 207;
        else
            return 177;
    }
    else
    {
        if ( [[[CMAppManager sharedInstance] getDeviceCheck] isEqualToString:IPHONE_RESOLUTION_6_PLUS] )
            return 405;
        else if ( [[[CMAppManager sharedInstance] getDeviceCheck] isEqualToString:IPHONE_RESOLUTION_6] )
            return 364;
        else
            return 313;
    }
    
    return 0;
}

#pragma mark - 전문
#pragma mark - 인기순위 Top 20 전문
- (void)requestWithPopularTopTwenty
{
    NSString *sCategoryId = @"713230";
    NSString *sRequestItems = @"weekly";
    
    NSURLSessionDataTask *tesk = [NSMutableDictionary vodGetPopularityChartWithCategoryId:sCategoryId WithRequestItems:sRequestItems completion:^(NSArray *vod, NSError *error) {
        
        
        NSLog(@"인기순위 top 20 = [%@]", vod);
        
        if ( [vod count] == 0 )
            return;
        
        [self.pPopularityArr removeAllObjects];
        
        for ( NSDictionary *dic in [[[[vod objectAtIndex:0] objectForKey:@"weeklyChart"] objectForKey:@"popularityList"] objectForKey:@"popularity"]  )
        {
            NSMutableDictionary *nDic = [[NSMutableDictionary alloc] init];
            
            [nDic setObject:[dic objectForKey:@"assetId"] forKey:@"assetId"];
            [nDic setObject:[dic objectForKey:@"isNew"] forKey:@"isNew"];
            [nDic setObject:[dic objectForKey:@"comparision"] forKey:@"comparision"];
            [nDic setObject:[dic objectForKey:@"title"] forKey:@"title"];
            [nDic setObject:[dic objectForKey:@"hitCount"] forKey:@"hitCount"];
            [nDic setObject:[dic objectForKey:@"categoryId"] forKey:@"categoryId"];
            [nDic setObject:[dic objectForKey:@"hot"] forKey:@"hot"];
            [nDic setObject:[dic objectForKey:@"ranking"] forKey:@"ranking"];
            [nDic setObject:[dic objectForKey:@"new"] forKey:@"new"];
            
            
            [self.pPopularityArr addObject:nDic];
        }
        
        
    }];
    
    [UIAlertView showAlertViewForTaskWithErrorOnCompletion:tesk delegate:nil];
    

}

#pragma mark - 금주의 신작 영화 전문
- (void)requestWithWeekMovie
{
    NSString *sCategoryId = @"723049";
    NSString *sContentGroupProfile = @"2";  // 이건 무슨값??
    
    NSURLSessionDataTask *tesk = [NSMutableDictionary vodGetContentGroupListWithContentGroupProfile:sContentGroupProfile WithCategoryId:sCategoryId completion:^(NSArray *vod, NSError *error) {
        
        NSLog(@"금주의 신작 영화 = [%@]", vod);
        
        if ( [vod count] == 0 )
            return;
        
        [self.pWeekMovieArr removeAllObjects];
        
        for ( NSDictionary *dic in [[[vod objectAtIndex:0] objectForKey:@"contentGroupList"] objectForKey:@"contentGroup"] )
        {
            NSMutableDictionary *nDic = [[NSMutableDictionary alloc] init];
            
            [nDic setObject:[dic objectForKey:@"assetNew"] forKey:@"assetNew"];
            [nDic setObject:[dic objectForKey:@"imageFileName"] forKey:@"imageFileName"];
            [nDic setObject:[dic objectForKey:@"rating"] forKey:@"rating"];
            [nDic setObject:[dic objectForKey:@"runningTime"] forKey:@"runningTime"];
            [nDic setObject:[dic objectForKey:@"smallImageFileName"] forKey:@"smallImageFileName"];
            [nDic setObject:[dic objectForKey:@"primaryAssetId"] forKey:@"primaryAssetId"];
            [nDic setObject:[dic objectForKey:@"title"] forKey:@"title"];
            [nDic setObject:[dic objectForKey:@"synopsis"] forKey:@"synopsis"];
            [nDic setObject:[dic objectForKey:@"assetBundle"] forKey:@"assetBundle"];
            [nDic setObject:[dic objectForKey:@"likedCount"] forKey:@"likedCount"];
            [nDic setObject:[dic objectForKey:@"starring"] forKey:@"starring"];
            [nDic setObject:[dic objectForKey:@"assetFree"] forKey:@"assetFree"];
            [nDic setObject:[dic objectForKey:@"episodePeerExistence"] forKey:@"episodePeerExistence"];
            [nDic setObject:[dic objectForKey:@"assetSeriesLink"] forKey:@"assetSeriesLink"];
            [nDic setObject:[dic objectForKey:@"isLiked"] forKey:@"isLiked"];
            [nDic setObject:[dic objectForKey:@"production"] forKey:@"production"];
            [nDic setObject:[dic objectForKey:@"UHDAssetCount"] forKey:@"UHDAssetCount"];
            [nDic setObject:[dic objectForKey:@"isFavorite"] forKey:@"isFavorite"];
            [nDic setObject:[dic objectForKey:@"director"] forKey:@"director"];
            [nDic setObject:[dic objectForKey:@"HDAssetCount"] forKey:@"HDAssetCount"];
            [nDic setObject:[dic objectForKey:@"SDAssetCount"] forKey:@"SDAssetCount"];
            [nDic setObject:[dic objectForKey:@"genre"] forKey:@"genre"];
            [nDic setObject:[dic objectForKey:@"promotionSticker"] forKey:@"promotionSticker"];
            [nDic setObject:[dic objectForKey:@"reviewRating"] forKey:@"reviewRating"];
            [nDic setObject:[dic objectForKey:@"assetHot"] forKey:@"assetHot"];
            [nDic setObject:[dic objectForKey:@"categoryId"] forKey:@"categoryId"];
            [nDic setObject:[dic objectForKey:@"contentGroupId"] forKey:@"contentGroupId"];
            
            [self.pWeekMovieArr addObject:nDic];
        }
        
    }];
    
    [UIAlertView showAlertViewForTaskWithErrorOnCompletion:tesk delegate:nil];
}

#pragma mark - 이달의 추천 vod 전문
- (void)requestWithThisMonthRecommend
{
    NSString *sCategoryId = @"713229";
    NSString *sContentGroupProfile = @"2";
    
    NSURLSessionDataTask *tesk = [NSMutableDictionary vodGetContentGroupListWithContentGroupProfile:sContentGroupProfile WithCategoryId:sCategoryId completion:^(NSArray *vod, NSError *error) {
        
        NSLog(@"이달의 추천 vod = [%@]", vod);
        
        if ( [vod count] == 0 )
            return;
        
        [self.pThisMonthRecommendArr removeAllObjects];
        
        for ( NSDictionary *dic in [[[vod objectAtIndex:0] objectForKey:@"contentGroupList"] objectForKey:@"contentGroup"] )
        {
            NSMutableDictionary *nDic = [[NSMutableDictionary alloc] init];
            
            [nDic setObject:[dic objectForKey:@"assetNew"] forKey:@"assetNew"];
            [nDic setObject:[dic objectForKey:@"imageFileName"] forKey:@"imageFileName"];
            [nDic setObject:[dic objectForKey:@"rating"] forKey:@"rating"];
            [nDic setObject:[dic objectForKey:@"runningTime"] forKey:@"runningTime"];
            [nDic setObject:[dic objectForKey:@"smallImageFileName"] forKey:@"smallImageFileName"];
            [nDic setObject:[dic objectForKey:@"primaryAssetId"] forKey:@"primaryAssetId"];
            [nDic setObject:[dic objectForKey:@"title"] forKey:@"title"];
            [nDic setObject:[dic objectForKey:@"synopsis"] forKey:@"synopsis"];
            [nDic setObject:[dic objectForKey:@"assetBundle"] forKey:@"assetBundle"];
            [nDic setObject:[dic objectForKey:@"likedCount"] forKey:@"likedCount"];
            [nDic setObject:[dic objectForKey:@"starring"] forKey:@"starring"];
            [nDic setObject:[dic objectForKey:@"assetFree"] forKey:@"assetFree"];
            [nDic setObject:[dic objectForKey:@"episodePeerExistence"] forKey:@"episodePeerExistence"];
            [nDic setObject:[dic objectForKey:@"assetSeriesLink"] forKey:@"assetSeriesLink"];
            [nDic setObject:[dic objectForKey:@"isLiked"] forKey:@"isLiked"];
            [nDic setObject:[dic objectForKey:@"production"] forKey:@"production"];
            [nDic setObject:[dic objectForKey:@"UHDAssetCount"] forKey:@"UHDAssetCount"];
            [nDic setObject:[dic objectForKey:@"isFavorite"] forKey:@"isFavorite"];
            [nDic setObject:[dic objectForKey:@"director"] forKey:@"director"];
            [nDic setObject:[dic objectForKey:@"HDAssetCount"] forKey:@"HDAssetCount"];
            [nDic setObject:[dic objectForKey:@"SDAssetCount"] forKey:@"SDAssetCount"];
            [nDic setObject:[dic objectForKey:@"genre"] forKey:@"genre"];
            [nDic setObject:[dic objectForKey:@"promotionSticker"] forKey:@"promotionSticker"];
            [nDic setObject:[dic objectForKey:@"reviewRating"] forKey:@"reviewRating"];
            [nDic setObject:[dic objectForKey:@"assetHot"] forKey:@"assetHot"];
            [nDic setObject:[dic objectForKey:@"categoryId"] forKey:@"categoryId"];
            [nDic setObject:[dic objectForKey:@"contentGroupId"] forKey:@"contentGroupId"];
            
            [self.pThisMonthRecommendArr addObject:nDic];
        }
        
    }];
    
    [UIAlertView showAlertViewForTaskWithErrorOnCompletion:tesk delegate:nil];
}

@end
