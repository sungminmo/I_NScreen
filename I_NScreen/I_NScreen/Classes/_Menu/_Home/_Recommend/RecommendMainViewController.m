//
//  RecommendMainViewController.m
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 10. 12..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import "RecommendMainViewController.h"

@interface RecommendMainViewController ()
@property (nonatomic, strong) NSMutableArray *pBnViewController;    // 배너 컨트롤
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
    
    [self banPageControllerInit];
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
    [self.pMainScrollView addSubview:self.pBannerView];
    [self.pMainScrollView addSubview:self.pPopularityView];
    [self.pMainScrollView addSubview:self.pNewWorkView];
    [self.pMainScrollView addSubview:self.pRecommendView];
    
    self.pBannerView.frame = CGRectMake(0, 0, self.pBannerView.frame.size.width, self.pBannerView.frame.size.height);
    
    self.pPopularityView.frame = CGRectMake(0, self.pBannerView.frame.origin.y + self.pBannerView.frame.size.height, self.pPopularityView.frame.size.width, self.pPopularityView.frame.size.height);
    
    self.pNewWorkView.frame = CGRectMake(0, self.pPopularityView.frame.origin.y + self.pPopularityView.frame.size.height, self.pNewWorkView.frame.size.width, self.pNewWorkView.frame.size.height);
    
    self.pRecommendView.frame = CGRectMake(0, self.pNewWorkView.frame.origin.y + self.pNewWorkView.frame.size.height, self.pRecommendView.frame.size.width, self.pRecommendView.frame.size.height);
    
    int nHeight = self.pBannerView.frame.size.height + self.pPopularityView.frame.size.height + self.pNewWorkView.frame.size.height + self.pRecommendView.frame.size.height;
    
    [self.pMainScrollView setContentSize:CGSizeMake(self.pMainScrollView.frame.size.width, nHeight)];
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
        controller = [[CMPageViewController alloc] initWithData:nil WithPage:(int)page];
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

@end
