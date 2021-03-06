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
#import "CMDBDataManager.h"
#import "FXKeychain.h"
#import "VodDetailBundleMainViewController.h"

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
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if(version < 8.0){
        [self.view layoutIfNeeded];
    }

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
    [self.pBannerPgControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
    [self.pPopularityPgControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
    [self.pNewWorkPgControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
    [self.pRecommendPgControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
}

-(void)changePage:(id)sender
{
    NSInteger page = [(UIPageControl*)sender currentPage];
    if (sender == self.pBannerPgControl)
    {
        [self.pBannerScrollView setContentOffset:CGPointMake(page * self.pBannerScrollView.frame.size.width, 0) animated:YES];
        [self banLoadScrollViewWithPage:page - 1];
        [self banLoadScrollViewWithPage:page];
        [self banLoadScrollViewWithPage:page + 1];
    }
    else if (sender == self.pPopularityPgControl)
    {
        [self.pPopularityScrollView setContentOffset:CGPointMake(page * self.pPopularityScrollView.frame.size.width, 0) animated:YES];
        [self collectionLoadScrollViewWithTrinfoType:TrinfoPopularity WithPage:page - 1];
        [self collectionLoadScrollViewWithTrinfoType:TrinfoPopularity WithPage:page];
        [self collectionLoadScrollViewWithTrinfoType:TrinfoPopularity WithPage:page + 1];
    }
    else if (sender == self.pNewWorkPgControl)
    {
        [self.pNewWorkScrollView setContentOffset:CGPointMake(page * self.pNewWorkScrollView.frame.size.width, 0) animated:YES];
        [self collectionLoadScrollViewWithTrinfoType:TrinfoNewWork WithPage:page - 1];
        [self collectionLoadScrollViewWithTrinfoType:TrinfoNewWork WithPage:page];
        [self collectionLoadScrollViewWithTrinfoType:TrinfoNewWork WithPage:page + 1];
    }
    else if (sender == self.pRecommendPgControl)
    {
        [self.pRecommendScrollView setContentOffset:CGPointMake(page * self.pRecommendScrollView.frame.size.width, 0) animated:YES];
        [self collectionLoadScrollViewWithTrinfoType:TrinfoRecommend WithPage:page - 1];
        [self collectionLoadScrollViewWithTrinfoType:TrinfoRecommend WithPage:page];
        [self collectionLoadScrollViewWithTrinfoType:TrinfoRecommend WithPage:page + 1];
    }
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
            NSString *sCategoryId = [NSString stringWithFormat:@"%@", [[self.pGetAppInitialzeArr objectAtIndex:0] objectForKey:@"categoryId"]];
            NSString *sViewerType = [NSString stringWithFormat:@"%@", [[self.pGetAppInitialzeArr objectAtIndex:0] objectForKey:@"categorytype"]];
            NSString *sName = [NSString stringWithFormat:@"%@", [[self.pGetAppInitialzeArr objectAtIndex:0] objectForKey:@"category_title"]];
            [self.delegate RecommendMainViewWithTag:RECOMMEND_MAIN_VIEW_BTN_01 WithCategoryId:sCategoryId WithViewerType:sViewerType WithTitleName:sName];
        }break;
        case RECOMMEND_MAIN_VIEW_BTN_02:
        {
            // 금주의 신작 영화
            NSString *sCategoryId = [NSString stringWithFormat:@"%@", [[self.pGetAppInitialzeArr objectAtIndex:1] objectForKey:@"categoryId"]];
            NSString *sViewerType = [NSString stringWithFormat:@"%@", [[self.pGetAppInitialzeArr objectAtIndex:1] objectForKey:@"categorytype"]];
            NSString *sName = [NSString stringWithFormat:@"%@", [[self.pGetAppInitialzeArr objectAtIndex:1] objectForKey:@"category_title"]];
            [self.delegate RecommendMainViewWithTag:RECOMMEND_MAIN_VIEW_BTN_02 WithCategoryId:sCategoryId WithViewerType:sViewerType WithTitleName:sName];
        }break;
        case RECOMMEND_MAIN_VIEW_BTN_03:
        {
            // 이달의 추천 VOD
            NSString *sCategoryId = [NSString stringWithFormat:@"%@", [[self.pGetAppInitialzeArr objectAtIndex:2] objectForKey:@"categoryId"]];
            NSString *sViewerType = [NSString stringWithFormat:@"%@", [[self.pGetAppInitialzeArr objectAtIndex:2] objectForKey:@"categorytype"]];
            NSString *sName = [NSString stringWithFormat:@"%@", [[self.pGetAppInitialzeArr objectAtIndex:2] objectForKey:@"category_title"]];
            [self.delegate RecommendMainViewWithTag:RECOMMEND_MAIN_VIEW_BTN_03 WithCategoryId:sCategoryId WithViewerType:sViewerType WithTitleName:sName];
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
    self.pBannerScrollView.frame = CGRectMake(6, 10, nWith - 12, CGRectGetHeight(self.pBannerScrollView.frame));
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
    
    [SIAlertView showAlertViewForTaskWithErrorOnCompletion:tesk delegate:nil];
}

- (void)isPariringCheckWithSetTopBoxItem:(NSDictionary *)item
{
    // 셋탑 정보가 내려오는데 페어링 했던 정보가 없으면 앱만 삭제 한거이므로 remove user api 호출해서 셋탑에도 삭제 해주고 uuid 는 키체인에 저장 되어 있으므로 uuid 도 삭제
    NSArray *keyArr = [item allKeys];
    
    CMDBDataManager *manager = [CMDBDataManager sharedInstance];
    
    BOOL isCheck = NO;
    for ( int i = 0; i < [keyArr count]; i++ )
    {
        if ( [[keyArr objectAtIndex:i] isEqualToString:@"SetTopBox_Item"] )
            isCheck = YES;
    }
    
    if ( isCheck == YES )
    {
        if ( [manager getPairingCheck] == NO )
        {
            // 페어링 된 상태에서 앱만 삭제한 경우
            [manager setPariringCheck:YES]; // 페어링을 한 상태로 바꿔줌
            
            //방어코드 추가 (앱 삭제후 재설치 시 페어링 정보 한번에 연동안되는 문제 수정)
            if ([manager getSetTopBoxKind].length == 0) {
                [manager setSetTopBoxKind:[[item objectForKey:@"SetTopBox_Item"] objectForKey:@"SetTopBoxKind"]];
            }
            
        }
        else
        {
            // 기존에 페어링시 정보가 있어서 저장 안해줘도 되는데 안정화 코딩 굳이 없어도됨
            [manager setSetTopBoxKind:[[item objectForKey:@"SetTopBox_Item"] objectForKey:@"SetTopBoxKind"]];
        }
    }
    else
    {
        // 셋탑엔 페어링 안되어 있는 경우
        if ( [manager getPairingCheck] == YES )
        {
            // 셋탑에서 페어링 지운 경우
            // 정보 삭제 해줌
            // 구매 비밀번호, 프라잇 터미널 키, 성인 인증 여부, 성인 검색 제하 설정 값, 지역 설정 값 삭제
            [[CMAppManager sharedInstance] removeKeychainBuyPw];
            [[CMAppManager sharedInstance] removeKeychainPrivateTerminalKey];
            [[CMAppManager sharedInstance] removeKeychainAdultCertification];
            [[CMAppManager sharedInstance] removeKeychainAdultLimit];
            [[CMAppManager sharedInstance] removeKeychainAreaCodeValue];
            [manager setPariringCheck:NO];
        }
    }
}

#pragma mark - 카테고리 리스트
- (void)requestWithGetAppInitialze
{
    NSURLSessionDataTask *tesk = [NSMutableDictionary vodGetAppInitializeCompletion:^(NSArray *pairing, NSError *error) {
        
        DDLogError(@"%@", pairing);
        
        if ( [pairing count] == 0 )
            return;
        
        NSDictionary* appVersionItem = pairing[0][@"AppVersion_Item"];
        NSString* appCurVersion = appVersionItem[@"appversion"];
        NSString* appVersion = [CMAppManager getAppShortVersion];
        
        NSArray* appCurVersionSplits = [appCurVersion componentsSeparatedByString:@"."];
        NSArray* appVersionSplits = [appVersion componentsSeparatedByString:@"."];
        
        for (int i = 0; i < appCurVersionSplits.count; i++) {
            
            NSComparisonResult rs = [appCurVersionSplits[i] compare:appVersionSplits[i] options:NSLiteralSearch];
            
            if (rs == NSOrderedDescending) {
                
                NSString* messagge = [NSString stringWithFormat:@"%@\n\n 사용 중인 버전 : %@\n최신 버전 : %@", appVersionItem[@"contents"], appVersion, appCurVersion];
                
                NSString* appurl = appVersionItem[@"appurl"];
                appurl = [appurl stringByReplacingOccurrencesOfString:@"https://" withString:@""];
                appurl = [NSString stringWithFormat:@"itms://%@", appurl];
                
                [SIAlertView alert:@"알림" message:messagge cancel:@"확인" buttons:@[@"앱스토어"]
                        completion:^(NSInteger buttonIndex, SIAlertView *alert) {
                            
                            if ( buttonIndex == 1 )
                            {
                                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appurl]];
                            }
                        }];
                
                break;
            } else if (rs == NSOrderedSame) {
                
                continue;
            } else {
                
                break;
            }
        }
        
        [self.pGetAppInitialzeArr removeAllObjects];
        [self.pGetAppInitialzeArr setArray:[[pairing objectAtIndex:0] objectForKey:@"Category_Item"]];
        
        ///
        [self isPariringCheckWithSetTopBoxItem:[pairing objectAtIndex:0]];
        ///
        
        
        self.pPopularityTitleLbl.text = [NSString stringWithFormat:@"%@", [[self.pGetAppInitialzeArr objectAtIndex:0] objectForKey:@"category_title"]];
        self.pNewWorkLbl.text = [NSString stringWithFormat:@"%@", [[self.pGetAppInitialzeArr objectAtIndex:1] objectForKey:@"category_title"]];
        self.pRecommendLbl.text = [NSString stringWithFormat:@"%@", [[self.pGetAppInitialzeArr objectAtIndex:2] objectForKey:@"category_title"]];
        
        // 3개 데이터 고정으로 내려옴
        [self requestWithPopularTopTwenty];
        [self requestWithThisMonthRecommend];
        [self requestWithWeekMovie];
    }];
    
    [SIAlertView showAlertViewForTaskWithErrorOnCompletion:tesk delegate:nil];
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
            [nDic setObject:[dic objectForKey:@"publicationRight"] forKey:@"publicationRight"];
            [nDic setObject:[dic objectForKey:@"rating"] forKey:@"rating"];
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
    
    [SIAlertView showAlertViewForTaskWithErrorOnCompletion:tesk delegate:nil];
    

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
            [nDic setObject:[dic objectForKey:@"mobilePublicationRight"] forKey:@"mobilePublicationRight"];
            // 수정
            [nDic setObject:[dic objectForKey:@"primaryAssetId"] forKey:@"assetId"];
            
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
    
    [SIAlertView showAlertViewForTaskWithErrorOnCompletion:tesk delegate:nil];
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
            [nDic setObject:[dic objectForKey:@"mobilePublicationRight"] forKey:@"mobilePublicationRight"];
            
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
    
    [SIAlertView showAlertViewForTaskWithErrorOnCompletion:tesk delegate:nil];
}

- (void)CMPageCollectionBtnClicked:(int)nSelect WithAssetId:(NSString *)assetId WithAdultCheck:(BOOL)isAdult WithEpisodePeerExistence:(NSString *)episodePeerExistence WithContentGroupId:(NSString *)contentGroupId WithAssetBundle:(NSString *)assetBundle
{
    if ( isAdult == YES )
    {
        // 성인 여부 컨텐츠이면
        if ( [[CMAppManager sharedInstance] getKeychainAdultCertification] == YES )
        {
            if ( [assetBundle isEqualToString:@"1"] )
            {
                // 묶음 상품 일시
                
            }
            else
            {
                VodDetailMainViewController *pViewController = [[VodDetailMainViewController alloc] initWithNibName:@"VodDetailMainViewController" bundle:nil];
                pViewController.pAssetIdStr = assetId;
                pViewController.pEpisodePeerExistence = episodePeerExistence;
                pViewController.pContentGroupId = contentGroupId;
                pViewController.delegate = self;
                [self.navigationController pushViewController:pViewController animated:YES];
            }
        }
        else
        {
            [SIAlertView alert:@"성인인증 필요" message:@"성인 인증이 필요한 콘텐츠입니다.\n성인 인증을 하시겠습니까?" cancel:@"취소" buttons:@[@"확인"]
                    completion:^(NSInteger buttonIndex, SIAlertView *alert) {
                        
                        if ( buttonIndex == 1 )
                        {
                            [[CMAppManager sharedInstance] setRefreshVodInfoWithAssetId:assetId episodePeerExistence:episodePeerExistence contentGroupId:contentGroupId delegate:self];
                            
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
            [self requestWithAssetInfo:assetId WithEpisodePeerExistence:episodePeerExistence WithContentGroupId:contentGroupId];
        }
        else
        {
            VodDetailMainViewController *pViewController = [[VodDetailMainViewController alloc] initWithNibName:@"VodDetailMainViewController" bundle:nil];
            pViewController.pAssetIdStr = assetId;
            pViewController.pEpisodePeerExistence = episodePeerExistence;
            pViewController.pContentGroupId = contentGroupId;
            pViewController.delegate = self;
            [self.navigationController pushViewController:pViewController animated:YES];

        }
    }
}

- (void)CMPageViewWithAssetId:(NSString *)sAssetId WithAdultCheck:(BOOL)isAdult
{
    // 배너는 성인 컨텐츠가 안내려오는가보네 구분 데이터가 없네
    VodDetailMainViewController *pViewController = [[VodDetailMainViewController alloc] initWithNibName:@"VodDetailMainViewController" bundle:nil];
    pViewController.pAssetIdStr = sAssetId;
    pViewController.pEpisodePeerExistence = @"0";
    pViewController.pContentGroupId = @"";
    pViewController.delegate = self;
    [self.navigationController pushViewController:pViewController animated:YES];

}

#pragma mark - 델리게이트
#pragma mark - VodDetailViewController 델리게이트
- (void)VodDetailMainViewWithTag:(int)nTag
{
    [self.delegate RecommendMainViewWithTag:VOD_BUY_VIEW_BTN_08];
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
            pViewController.pAssetIdStr = assetInfo;
            pViewController.pEpisodePeerExistence = episodePeerExistence;
            pViewController.pContentGroupId = contentGroupId;
            [self.navigationController pushViewController:pViewController animated:YES];
        }
        
    }];
    
    [SIAlertView showAlertViewForTaskWithErrorOnCompletion:tesk delegate:nil];
}
@end
