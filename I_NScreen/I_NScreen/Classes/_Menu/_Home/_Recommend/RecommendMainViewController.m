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
#import "NSMutableDictionary+Pairing.h"

@interface RecommendMainViewController ()
@property (nonatomic, strong) NSMutableArray *pBnViewController;    // 배너 컨트롤
@property (nonatomic, strong) NSMutableArray *pPopularityViewController;    // 인기 순위 컨트롤
@property (nonatomic, strong) NSMutableArray *pWeekMovieViewController; // 금주의 신작 영화 컨트롤
@property (nonatomic, strong) NSMutableArray *pThisMonthRecommendViewController;    // 이달의 추천 컨트롤
@property (nonatomic, strong) NSMutableArray *pPopularityArr;       // 인기순위 top 20 배열 데이터
@property (nonatomic, strong) NSMutableArray *pWeekMovieArr;        // 금주의 신작 영화
@property (nonatomic, strong) NSMutableArray *pThisMonthRecommendArr;   // 이달의 추천
@property (nonatomic, strong) NSMutableArray *pBnArr;           // 배너 배열
@property (nonatomic, strong) NSMutableArray *pGetAppInitialzeArr;  // 카테고리 배열
@end

@implementation RecommendMainViewController
@synthesize delegate;

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
    
    [self requestWithBanner];
    [self requestWithGetAppInitialze];
}

#pragma mark - 초기화
#pragma mark - 화면초기화
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [self setViewSize];
    
    CGFloat width = self.pMainScrollView.frame.size.width;
    CGFloat posY = 0;
    NSArray* items = @[self.pBannerView, self.pPopularityView, self.pNewWorkView, self.pRecommendView];
    
    for (UIView* item in items) {
        [self.pMainScrollView addSubview:item];
        
        
        item.frame = CGRectMake(0, posY, width, item.frame.size.height);
        posY += item.frame.size.height;
        
        NSLayoutConstraint *layout = [NSLayoutConstraint constraintWithItem:self.view
                                                                  attribute:NSLayoutAttributeWidth
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:item
                                                                  attribute:NSLayoutAttributeWidth
                                                                 multiplier:1.0
                                                                   constant:0];
        [self.view addConstraint:layout];
    }
    [self.pMainScrollView setContentSize:CGSizeMake(width, posY)];
    [self.view updateConstraintsIfNeeded];
}

- (void)setViewSize
{
    int nBannerHeight = 0;
    int nCollectionHeight = 0;
    
    if ( [[[CMAppManager sharedInstance] getDeviceCheck] isEqualToString:IPHONE_RESOLUTION_6_PLUS] )
    {
        nBannerHeight = self.pBannerView.frame.size.height;
        nCollectionHeight = self.pPopularityView.frame.size.height;
    }
    else if ( [[[CMAppManager sharedInstance] getDeviceCheck]isEqualToString:IPHONE_RESOLUTION_6] )
    {
        nBannerHeight = 202;
        nCollectionHeight = 354;
    }
    else
    {
        nBannerHeight = 174;
        nCollectionHeight = 304;
    }
    
    self.pBannerView.frame = CGRectMake(0, 0, self.pBannerView.frame.size.width, nBannerHeight);
    self.pPopularityView.frame = CGRectMake(0, 0, self.pPopularityView.frame.size.width, nCollectionHeight);
    self.pNewWorkView.frame = CGRectMake(0, 0, self.pNewWorkView.frame.size.width, nCollectionHeight);
    self.pRecommendView.frame = CGRectMake(0, 0, self.pRecommendView.frame.size.width, nCollectionHeight);
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
    self.pBnArr = [[NSMutableArray alloc] init];
    self.pGetAppInitialzeArr = [[NSMutableArray alloc] init];
}

#pragma mark - 액션 이벤트
#pragma mark - 버튼 액션 이벤트
- (IBAction)onBtnClicked:(UIButton *)btn
{
    switch ([btn tag]) {
        case RECOMMEND_MAIN_VIEW_BTN_01:
        {
            // 인기 순위
            [self.delegate RecommendMainViewWithTag:RECOMMEND_MAIN_VIEW_BTN_01];
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
    
//    int nTotalCount = 3;
    int nTotalCount = (int)[self.pBnArr count];
    
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
    self.pBannerScrollView.backgroundColor = [UIColor clearColor];
    
    [self banLoadScrollViewWithPage:0];
    [self banLoadScrollViewWithPage:1];
}

#pragma mark - 배너 페이지 전환
- (void)banLoadScrollViewWithPage:(NSInteger )page
{
//    int nTotalCount = 3;
    
    int nTotalCount = (int)[self.pBnArr count];
    
    // 초기값 리턴
    if ( page >= nTotalCount || page < 0 )
        return;
    
    CMPageViewController *controller = [self.pBnViewController objectAtIndex:page];
    
    if ( (NSNull *)controller == [NSNull null] )
    {
        controller = [[CMPageViewController alloc] initWithData:[self.pBnArr objectAtIndex:page] WithPage:(int)page];
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

#pragma mark - 컬렉션
#pragma mark - 컬렉션 페이지 컨트롤 초기화
- (void)collectionPageControllerInitWithTrinfoType:(TrinfoType )trinfoType
{
    switch (trinfoType) {
        case TrinfoPopularity:
        {
            // 인기순위
            NSMutableArray *pControllers1 = [[NSMutableArray alloc] init];
            
            int nTotal = (int)[self.pPopularityArr count];
            
            if ( nTotal >= 5 )
                nTotal = 5;
            
            for ( NSUInteger i = 0; i < nTotal; i++ )
            {
                [pControllers1 addObject:[NSNull null]];
            }
            
            self.pPopularityViewController = pControllers1;
            self.pPopularityPgControl.numberOfPages = nTotal;
            self.pPopularityPgControl.currentPage = 0;
            
            self.pPopularityScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.pPopularityScrollView.frame) * nTotal, CGRectGetHeight(self.pPopularityScrollView.frame));
            
        }break;
        case TrinfoNewWork:
        {
            NSMutableArray *pControllers2 = [[NSMutableArray alloc] init];
            
            int nTotal = (int)[self.pWeekMovieArr count];
            
            if ( nTotal >= 5 )
                nTotal = 5;
            
            for ( NSUInteger i = 0; i < nTotal; i++ )
            {
                [pControllers2 addObject:[NSNull null]];
            }
            
            self.pWeekMovieViewController = pControllers2;
            self.pNewWorkPgControl.numberOfPages = nTotal;
            self.pNewWorkPgControl.currentPage = 0;
            
            self.pNewWorkScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.pNewWorkScrollView.frame) * nTotal, CGRectGetHeight(self.pNewWorkScrollView.frame));
            
        }break;
        case TrinfoRecommend:
        {
            NSMutableArray *pControllers3 = [[NSMutableArray alloc] init];
            
            int nTotal = (int)[self.pThisMonthRecommendArr count];
            if ( nTotal >= 5 )
                nTotal = 5;
            
            for ( NSUInteger i = 0; i < nTotal; i++ )
            {
                [pControllers3 addObject:[NSNull null]];
            }
            
            self.pThisMonthRecommendViewController = pControllers3;
            self.pRecommendPgControl.numberOfPages = nTotal;
            self.pRecommendPgControl.currentPage = 0;
            
            self.pRecommendScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.pRecommendScrollView.frame) * nTotal, CGRectGetHeight(self.pRecommendScrollView.frame));
            
        }break;
    }
    
    [self collectionLoadScrollViewWithTrinfoType:trinfoType WithPage:0];
    [self collectionLoadScrollViewWithTrinfoType:trinfoType WithPage:1];
}

#pragma mark - 컬렉션 페이지 전환
- (void)collectionLoadScrollViewWithTrinfoType:(TrinfoType )trinfoType WithPage:(NSInteger)page
{
    int nTotal = 0;
    
    switch (trinfoType) {
        case TrinfoPopularity:
        {
            // 인기 순위
            nTotal = (int)[self.pPopularityArr count];
            
            if ( nTotal >= 5 )
                nTotal = 5;
            
            // 초기값 리턴
            if ( page >= nTotal || page < 0 )
                return;
            
            CMPageCollectionViewController *controller = [self.pPopularityViewController objectAtIndex:page];
            
            if ( (NSNull *)controller == [NSNull null] )
            {
                controller = [[CMPageCollectionViewController alloc] initWithData:[self.pPopularityArr objectAtIndex:page] WithPage:(int)page];
                controller.delegate = self;
                [self.pPopularityViewController replaceObjectAtIndex:page withObject:controller];
            }
            
            if ( [controller.view superview] == nil )
            {
                CGRect frame = self.pPopularityScrollView.frame;
                frame.origin.x = CGRectGetWidth(frame) * page;
                frame.origin.y = 0;
                controller.view.frame = frame;
                
                [self.pPopularityScrollView addSubview:controller.view];
            }
            
        }break;
        case TrinfoNewWork:
        {
            // 금주의 신작
            nTotal = (int)[self.pWeekMovieArr count];
            
            if ( nTotal >= 5 )
                nTotal = 5;
            
            // 초기값 리턴
            if ( page >= nTotal || page < 0 )
                return;
            
            CMPageCollectionViewController *controller = [self.pWeekMovieViewController objectAtIndex:page];
            
            if ( (NSNull *)controller == [NSNull null] )
            {
                controller = [[CMPageCollectionViewController alloc] initWithData:[self.pWeekMovieArr objectAtIndex:page] WithPage:(int)page];
                controller.delegate = self;
                [self.pWeekMovieViewController replaceObjectAtIndex:page withObject:controller];
            }
            
            if ( [controller.view superview] == nil )
            {
                CGRect frame = self.pNewWorkScrollView.frame;
                frame.origin.x = CGRectGetWidth(frame) * page;
                frame.origin.y = 0;
                controller.view.frame = frame;
                
                [self.pNewWorkScrollView addSubview:controller.view];
            }

        }break;
        case TrinfoRecommend:
        {
            // 이달의 추천
            nTotal = (int)[self.pThisMonthRecommendArr count];
            
            if ( nTotal >= 5 )
                nTotal = 5;
            
            // 초기값 리턴
            if ( page >= nTotal || page < 0 )
                return;
            
            CMPageCollectionViewController *controller = [self.pThisMonthRecommendViewController objectAtIndex:page];
            
            if ( (NSNull *)controller == [NSNull null] )
            {
                controller = [[CMPageCollectionViewController alloc] initWithData:[self.pThisMonthRecommendArr objectAtIndex:page] WithPage:(int)page];
                controller.delegate = self;
                [self.pThisMonthRecommendViewController replaceObjectAtIndex:page withObject:controller];
            }
            
            if ( [controller.view superview] == nil )
            {
                CGRect frame = self.pRecommendScrollView.frame;
                frame.origin.x = CGRectGetWidth(frame) * page;
                frame.origin.y = 0;
                controller.view.frame = frame;
                
                [self.pRecommendScrollView addSubview:controller.view];
            }
            
        }break;
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
    else if ( scrollView == self.pPopularityScrollView )
    {
        CGFloat pageWidth = CGRectGetWidth(self.pPopularityScrollView.frame);
        NSUInteger page = floor((self.pPopularityScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        self.pPopularityPgControl.currentPage = page;
        
        [self collectionLoadScrollViewWithTrinfoType:TrinfoPopularity WithPage:page - 1];
        [self collectionLoadScrollViewWithTrinfoType:TrinfoPopularity WithPage:page];
        [self collectionLoadScrollViewWithTrinfoType:TrinfoPopularity WithPage:page + 1];
    }
    else if ( scrollView == self.pNewWorkScrollView )
    {
        CGFloat pageWidth = CGRectGetWidth(self.pNewWorkScrollView.frame);
        NSUInteger page = floor((self.pNewWorkScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        self.pNewWorkPgControl.currentPage = page;
        
        [self collectionLoadScrollViewWithTrinfoType:TrinfoNewWork WithPage:page - 1];
        [self collectionLoadScrollViewWithTrinfoType:TrinfoNewWork WithPage:page];
        [self collectionLoadScrollViewWithTrinfoType:TrinfoNewWork WithPage:page + 1];
    }
    else if ( scrollView == self.pRecommendScrollView )
    {
        CGFloat pageWidth = CGRectGetWidth(self.pRecommendScrollView.frame);
        NSUInteger page = floor((self.pRecommendScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        self.pRecommendPgControl.currentPage = page;
        
        [self collectionLoadScrollViewWithTrinfoType:TrinfoRecommend WithPage:page - 1];
        [self collectionLoadScrollViewWithTrinfoType:TrinfoRecommend WithPage:page];
        [self collectionLoadScrollViewWithTrinfoType:TrinfoRecommend WithPage:page + 1];
    }
}

#pragma mark - 전문
#pragma mark - 배너
- (void)requestWithBanner
{
    NSURLSessionDataTask *tesk = [NSMutableDictionary vodGetServicebannerlistCompletion:^(NSArray *banner, NSError *error) {
        
        DDLogError(@"banner = [%@]", banner);
        
        [self.pBnArr removeAllObjects];
        
        [self.pBnArr setArray:[[banner objectAtIndex:0] objectForKey:@"BannerList_Item"]];
        
        [self banPageControllerInit];
    }];
    
    [UIAlertView showAlertViewForTaskWithErrorOnCompletion:tesk delegate:nil];
}

#pragma mark - 카테고리 리스트 
- (void)requestWithGetAppInitialze
{
    NSURLSessionDataTask *tesk = [NSMutableDictionary vodGetAppInitializeCompletion:^(NSArray *pairing, NSError *error) {
        
        DDLogError(@"%@", pairing);
        [self.pGetAppInitialzeArr removeAllObjects];
        [self.pGetAppInitialzeArr setArray:[[pairing objectAtIndex:0] objectForKey:@"Category_Item"]];
        
        self.pPopularityTitleLbl.text = [NSString stringWithFormat:@"%@", [[self.pGetAppInitialzeArr objectAtIndex:0] objectForKey:@"category_title"]];
        self.pNewWorkLbl.text = [NSString stringWithFormat:@"%@", [[self.pGetAppInitialzeArr objectAtIndex:1] objectForKey:@"category_title"]];
        self.pRecommendLbl.text = [NSString stringWithFormat:@"%@", [[self.pGetAppInitialzeArr objectAtIndex:2] objectForKey:@"category_title"]];
        
        // 3개 데이터 고정으로 내려옴
        [self requestWithPopularTopTwenty];
        [self requestWithThisMonthRecommend];
        [self requestWithWeekMovie];
    }];
    
    [UIAlertView showAlertViewForTaskWithErrorOnCompletion:tesk delegate:nil];
}

#pragma mark - 인기순위 Top 20 전문
- (void)requestWithPopularTopTwenty
{
//    NSString *sCategoryId = @"713230";
    NSString *sCategoryId = [NSString stringWithFormat:@"%@", [[self.pGetAppInitialzeArr objectAtIndex:0] objectForKey:@"categoryId"]];
    NSString *sRequestItems = @"weekly";
    
    NSURLSessionDataTask *tesk = [NSMutableDictionary vodGetPopularityChartWithCategoryId:sCategoryId WithRequestItems:sRequestItems completion:^(NSArray *vod, NSError *error) {
        
        DDLogError(@"인기순위 top 20 = [%@]", vod);
        
        if ( [vod count] == 0 )
            return;
        
        [self.pPopularityArr removeAllObjects];

        int nIndex = 1;
        int nTotal = (int)[[[[vod objectAtIndex:0] objectForKey:@"weeklyChart"] objectForKey:@"totalCount"] integerValue];
        
        NSMutableArray *pArr = [[NSMutableArray alloc] init];
        
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
            [nDic setObject:[dic objectForKey:@"smallImageFileName"] forKey:@"smallImageFileName"];
            [nDic setObject:[dic objectForKey:@"imageFileName"] forKey:@"imageFileName"];
            [nDic setObject:[dic objectForKey:@"promotionSticker"] forKey:@"promotionSticker"];
            [pArr addObject:nDic];
            
            if ( nIndex % 8 == 0 || nIndex == nTotal)
            {
                [self.pPopularityArr addObject:[pArr copy]];
                [pArr removeAllObjects];
            }
            
            nIndex++;
        }
        
        [self collectionPageControllerInitWithTrinfoType:TrinfoPopularity];
    }];
    
    [UIAlertView showAlertViewForTaskWithErrorOnCompletion:tesk delegate:nil];
    

}

#pragma mark - 금주의 신작 영화 전문
- (void)requestWithWeekMovie
{
//    NSString *sCategoryId = @"723049";
    NSString *sCategoryId = [NSString stringWithFormat:@"%@", [[self.pGetAppInitialzeArr objectAtIndex:1] objectForKey:@"categoryId"]];
    NSString *sContentGroupProfile = @"2";  // 이건 무슨값??
    
    NSURLSessionDataTask *tesk = [NSMutableDictionary vodGetContentGroupListWithContentGroupProfile:sContentGroupProfile WithCategoryId:sCategoryId completion:^(NSArray *vod, NSError *error) {
        
        DDLogError(@"금주의 신작 영화 = [%@]", vod);
        
        if ( [vod count] == 0 )
            return;
        
        [self.pWeekMovieArr removeAllObjects];
        
        int nIndex = 1;
        int nTotal = (int)[[[vod objectAtIndex:0] objectForKey:@"totalCount"] integerValue];
        
        NSMutableArray *pArr = [[NSMutableArray alloc] init];
        
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
            
            // 수정
            [nDic setObject:[dic objectForKey:@"primaryAssetId"] forKey:@"assetId"];
            
//            [self.pWeekMovieArr addObject:nDic];
            [pArr addObject:nDic];
            
            if ( nIndex % 8 == 0 || nIndex == nTotal)
            {
                [self.pWeekMovieArr addObject:[pArr copy]];
                [pArr removeAllObjects];
            }
            
            nIndex++;
        }
        
        [self collectionPageControllerInitWithTrinfoType:TrinfoNewWork];
    }];
    
    [UIAlertView showAlertViewForTaskWithErrorOnCompletion:tesk delegate:nil];
}

#pragma mark - 이달의 추천 vod 전문
- (void)requestWithThisMonthRecommend
{
//    NSString *sCategoryId = @"713229";
    NSString *sCategoryId = [NSString stringWithFormat:@"%@", [[self.pGetAppInitialzeArr objectAtIndex:2] objectForKey:@"categoryId"]];
    NSString *sContentGroupProfile = @"2";
    
    NSURLSessionDataTask *tesk = [NSMutableDictionary vodGetContentGroupListWithContentGroupProfile:sContentGroupProfile WithCategoryId:sCategoryId completion:^(NSArray *vod, NSError *error) {
        
        DDLogError(@"이달의 추천 vod = [%@]", vod);
        
        if ( [vod count] == 0 )
            return;
        
        [self.pThisMonthRecommendArr removeAllObjects];
        
        int nIndex = 1;
        int nTotal = (int)[[[vod objectAtIndex:0] objectForKey:@"totalCount"] integerValue];
        
        NSMutableArray *pArr = [[NSMutableArray alloc] init];
        
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
            
            [nDic setObject:[dic objectForKey:@"primaryAssetId"] forKey:@"assetId"];
            
//            [self.pThisMonthRecommendArr addObject:nDic];
            [pArr addObject:nDic];
            
            if ( nIndex % 8 == 0 || nIndex == nTotal)
            {
                [self.pThisMonthRecommendArr addObject:[pArr copy]];
                [pArr removeAllObjects];
            }
            
            nIndex++;
        }
        
        [self collectionPageControllerInitWithTrinfoType:TrinfoRecommend];
    }];
    
    [UIAlertView showAlertViewForTaskWithErrorOnCompletion:tesk delegate:nil];
}

- (void)requestWithTest
{
//    NSString *sCategoryId = @"713229";
//    NSString *sContentGroupProfile = @"2";
//    
//    NSURLSessionDataTask *tesk = [NSMutableDictionary vodGetContentGroupListWithContentGroupProfile:sContentGroupProfile WithCategoryId:sCategoryId completion:^(NSArray *vod, NSError *error) {
//        
//        DDLogError(@"이달의 추천 vod = [%@]", vod);
//        
//       
//    }];
    
    
//    [UIAlertView showAlertViewForTaskWithErrorOnCompletion:tesk delegate:nil];
    NSURLSessionDataTask *tesk = [NSMutableDictionary pairingAuthenticateDeviceCompletion:^(NSArray *pairing, NSError *error) {
       
        DDLogError(@"PAIRAIN = [%@]", pairing);
    }];
}

- (void)CMPageCollectionBtnClicked:(int)nSelect WithAssetId:(NSString *)assetId
{
    VodDetailMainViewController *pViewController = [[VodDetailMainViewController alloc] initWithNibName:@"VodDetailMainViewController" bundle:nil];
    pViewController.pAssetIdStr = assetId;
    [self.navigationController pushViewController:pViewController animated:YES];
//    
//        TestPageViewController *pViewController = [[TestPageViewController alloc] initWithNibName:@"TestPageViewController" bundle:nil];
//        pViewController.pAssetIdStr = assetId;
//        [self.navigationController pushViewController:pViewController animated:YES];
}

- (void)CMPageViewWithAssetId:(NSString *)sAssetId
{
    VodDetailMainViewController *pViewController = [[VodDetailMainViewController alloc] initWithNibName:@"VodDetailMainViewController" bundle:nil];
    pViewController.pAssetIdStr = sAssetId;
    [self.navigationController pushViewController:pViewController animated:YES];
}

@end
