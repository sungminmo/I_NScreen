//
//  VodDetailMainViewController.m
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 10. 28..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import "VodDetailMainViewController.h"
#import "NSMutableDictionary+VOD.h"
#import "UIAlertView+AFNetworking.h"
#import "UIImageView+AFNetworking.h"

@interface VodDetailMainViewController ()
@property (nonatomic, strong) NSMutableArray *pViewController;
@property (nonatomic, strong) NSMutableDictionary *pAssetInfoDic;
@property (nonatomic, strong) NSMutableArray *pContentGroupArr; // 연관 컨텐츠 그룹

@end

@implementation VodDetailMainViewController
@synthesize pAssetIdStr;

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setTagInit];
    [self setViewInit];
    
    [self requestWithAssetInfo];
    [self requestWithRecommendContentGroupByAssetId];
}

#pragma mark - 초기화
#pragma mark - 태그 초기화
- (void)setTagInit
{
    self.pBackBtn.tag = VOD_DETAIL_MAIN_VIEW_BTN_01;
    self.pWatchBtn.tag = VOD_DETAIL_MAIN_VIEW_BTN_02;
}

#pragma mark - 화면 초기화
- (void)setViewInit
{
    self.pAssetInfoDic = [[NSMutableDictionary alloc] init];
    self.pContentGroupArr = [[NSMutableArray alloc] init];
    
    [self.pBodyView addSubview:self.pView01];
    [self.pBodyView addSubview:self.pView02];
    [self.pBodyView addSubview:self.pView03];
    
    self.pView01.frame = CGRectMake(0, 0, self.pView01.frame.size.width, self.pView01.frame.size.height);
    self.pView02.frame = CGRectMake(0, self.pView01.frame.origin.y + self.pView01.frame.size.height, self.pView02.frame.size.width, self.pView02.frame.size.height);
    self.pView03.frame = CGRectMake(0, self.pView02.frame.origin.y + self.pView02.frame.size.height, self.pView03.frame.size.width, self.pView03.frame.size.height);
}

#pragma mark - 액션 이벤트
#pragma mark - 버튼 액션 이벤트
- (IBAction)onBtnClicked:(UIButton *)btn
{
    switch ([btn tag]) {
        case VOD_DETAIL_MAIN_VIEW_BTN_01:
        {
            [self.navigationController popViewControllerAnimated:YES];
        }break;
        case VOD_DETAIL_MAIN_VIEW_BTN_02:
        {
            // 시청 버튼
            
        }break;
    }
}

#pragma mark - 배너
#pragma mark - 배너 페이지 컨트롤 초기화
- (void)banPageControllerInit
{
    // 하드코딩 토탈 카운터 3개만 하자
    NSMutableArray *pControllers = [[NSMutableArray alloc] init];
    
//        int nTotalCount = 0;
    int nTotalCount = (int)[self.pContentGroupArr count];
    
    if ( nTotalCount >= 5 )
        nTotalCount = 5;
    
    for ( NSUInteger i = 0; i < nTotalCount; i++ )
    {
        [pControllers addObject:[NSNull null]];
    }
    
    self.pViewController = pControllers;
    
    self.pPageControl.numberOfPages = nTotalCount;
    self.pPageControl.currentPage = 0;
    
    self.pScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.pScrollView.frame) * nTotalCount, CGRectGetHeight(self.pScrollView.frame));
    self.pScrollView.pagingEnabled = YES;
    self.pScrollView.showsHorizontalScrollIndicator = NO;
    self.pScrollView.showsVerticalScrollIndicator = NO;
    self.pScrollView.scrollsToTop = NO;
    self.pScrollView.delegate = self;
//    int nWith = [UIScreen mainScreen].bounds.size.width;
//    self.pScrollView.frame = CGRectMake(6, 10, nWith - 12, 100);
    self.pScrollView.backgroundColor = [UIColor clearColor];
    
    [self banLoadScrollViewWithPage:0];
    [self banLoadScrollViewWithPage:1];
}

#pragma mark - 배너 페이지 전환
- (void)banLoadScrollViewWithPage:(NSInteger )page
{
//        int nTotalCount = 0;
    
    int nTotalCount = (int)[self.pContentGroupArr count];
    
    if ( nTotalCount >= 5 )
        nTotalCount = 5;
    
    // 초기값 리턴
    if ( page >= nTotalCount || page < 0 )
        return;
    
    CMContentGroupCollectionViewController *controller = [self.pViewController objectAtIndex:page];
    
    if ( (NSNull *)controller == [NSNull null] )
    {
        controller = [[CMContentGroupCollectionViewController alloc] initWithData:[self.pContentGroupArr objectAtIndex:page] WithPage:(int)page];
//        controller = [[CMPageViewController alloc] initWithData:nil WithPage:(int)page];
        controller.delegate = self;
        [self.pViewController replaceObjectAtIndex:page withObject:controller];
    }
    
    if ( [controller.view superview] == nil )
    {
        CGRect frame = self.pScrollView.frame;
        frame.origin.x = CGRectGetWidth(frame) * page;
        frame.origin.y = 0;
        controller.view.frame = frame;
        
        [self.pScrollView addSubview:controller.view];
    }
}

#pragma mark - UIScrollView 델리게이트
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pageWidth = CGRectGetWidth(self.pScrollView.frame);
    NSUInteger page = floor((self.pScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pPageControl.currentPage = page;
    
    [self banLoadScrollViewWithPage:page - 1];
    [self banLoadScrollViewWithPage:page];
    [self banLoadScrollViewWithPage:page + 1];
}

- (void)CMPageCollectionBtnClicked:(int)nSelect 
{
    
}


#pragma mark - 전문
#pragma mark - vod 상세
- (void)requestWithAssetInfo
{
    NSURLSessionDataTask *tesk = [NSMutableDictionary vodGetAssetInfoWithAssetId:self.pAssetIdStr WithAssetProfile:@"9" completion:^(NSArray *vod, NSError *error) {
        
        DDLogError(@"vod 상세 = [%@]", vod);
        
        if ( [vod count] == 0 )
            return;
        [self.pAssetInfoDic removeAllObjects];
        [self.pAssetInfoDic setDictionary:[vod objectAtIndex:0]];
        
        [self setResponseViewInit];
        
    }];
    
    [UIAlertView showAlertViewForTaskWithErrorOnCompletion:tesk delegate:nil];
}

#pragma mark - 연관 이미지
- (void)requestWithRecommendContentGroupByAssetId
{
    NSURLSessionDataTask *tesk = [NSMutableDictionary vodRecommendContentGroupByAssetId:self.pAssetIdStr WithContentGroupProfile:@"2" completion:^(NSArray *vod, NSError *error) {
        
        DDLogError(@"연관 이미지 데이터 = [%@]", vod);
        [self.pContentGroupArr removeAllObjects];
//        [self.pContentGroupArr setArray:[[[vod objectAtIndex:0] objectForKey:@"contentGroupList"] objectForKey:@"contentGroup"]];
        
        int nIndex = 1;
        int nTotal = (int)[[[[vod objectAtIndex:0] objectForKey:@"contentGroupList"] objectForKey:@"contentGroup"] count];
        
        NSMutableArray *pArr = [[NSMutableArray alloc] init];
        
        for ( NSDictionary *dic in [[[vod objectAtIndex:0] objectForKey:@"contentGroupList"] objectForKey:@"contentGroup"] )
        {
            NSMutableDictionary *nDic = [[NSMutableDictionary alloc] init];
            
            [nDic setObject:[dic objectForKey:@"smallImageFileName"] forKey:@"smallImageFileName"];
            [nDic setObject:[dic objectForKey:@"title"] forKey:@"title"];
            [pArr addObject:nDic];
            
            if ( nIndex % 4 == 0 || nIndex == nTotal)
            {
                [self.pContentGroupArr addObject:[pArr copy]];
                [pArr removeAllObjects];
            }
            
            nIndex++;
        }

        [self banPageControllerInit];
    }];
    
    [UIAlertView showAlertViewForTaskWithErrorOnCompletion:tesk delegate:nil];
}

- (void)setResponseViewInit
{
    NSString *sUrl = [NSString stringWithFormat:@"%@", [[self.pAssetInfoDic objectForKey:@"asset"] objectForKey:@"imageFileName"]];
    [self.pThumImageView setImageWithURL:[NSURL URLWithString:sUrl]];
    
    self.pTitleLbl.text = [NSString stringWithFormat:@"%@", [[self.pAssetInfoDic objectForKey:@"asset"] objectForKey:@"title"]];
    
    self.pCastLbl.text = [NSString stringWithFormat:@"%@", [[self.pAssetInfoDic objectForKey:@"asset"] objectForKey:@"starring"]];
    
    NSString *sHDContent = [NSString stringWithFormat:@"%@", [[self.pAssetInfoDic objectForKey:@"asset"] objectForKey:@"HDContent"]];
    
    if ( [sHDContent isEqualToString:@"0"] )
    {
        // SD
        self.pResolutionImageView.image = [UIImage imageNamed:@"sd.png"];
    }
    else
    {
        // HD
        self.pResolutionImageView.image = [UIImage imageNamed:@"hd.png"];
    }
    
    NSString *sPrice = [NSString stringWithFormat:@"%@", [[[[[self pAssetInfoDic] objectForKey:@"asset"] objectForKey:@"productList"] objectForKey:@"product"] objectForKey:@"listPrice"]];
    self.pPriceLbl.text = [NSString stringWithFormat:@"%@ [부가세 별도]", [[CMAppManager sharedInstance] insertComma:sPrice]];
    
    
    // 러닝 타임
    NSString *sRunningTime = [NSString stringWithFormat:@"%@", [[[self pAssetInfoDic] objectForKey:@"asset"] objectForKey:@"runningTime"]];

    NSArray *runningTimeArr = [sRunningTime componentsSeparatedByString:@":"];
    
    NSString *sRunningHH = @""; // 시
    NSString *sRunningMM = @""; // 분
    int nRunningHH = 0;
    int nRunningMM = 0;
    int nTotalMM = 0;
    
    if ( [runningTimeArr count] == 2 )
    {
        sRunningHH = [NSString stringWithFormat:@"%@", [runningTimeArr objectAtIndex:0]];
        sRunningMM = [NSString stringWithFormat:@"%@", [runningTimeArr objectAtIndex:1]];
        
        nRunningHH = [sRunningHH intValue];
        nRunningMM = [sRunningMM intValue];
        
        nTotalMM = nRunningHH * 60 + nRunningMM;
    }
    
    self.pSummaryLbl.text = [NSString stringWithFormat:@"%@/%d", [[[self pAssetInfoDic] objectForKey:@"asset"] objectForKey:@"genre"], nTotalMM];
    
    self.pContentTextView.text = [NSString stringWithFormat:@"%@", [[[self pAssetInfoDic] objectForKey:@"asset"] objectForKey:@"synopsis"]];
    
    self.pManagerLbl.text = [NSString stringWithFormat:@"%@", [[[self pAssetInfoDic] objectForKey:@"asset"] objectForKey:@"director"]];
    
    // 시청기간 다시 봐야 함
    NSString *sSeeDay = [NSString stringWithFormat:@"%@", [[[[[self pAssetInfoDic] objectForKey:@"asset"] objectForKey:@"productList"] objectForKey:@"product"] objectForKey:@"viewablePeriod"]];
    NSArray *seeDayArr = [sSeeDay componentsSeparatedByString:@" "];
    NSString *sNewSeeDay = [NSString stringWithFormat:@"%@", [seeDayArr objectAtIndex:0]];
    NSArray *newSeeDayArr = [sNewSeeDay componentsSeparatedByString:@"-"];
    if ( [newSeeDayArr count] == 0 )
        return;
    NSString *sDay = [NSString stringWithFormat:@"%@", [newSeeDayArr objectAtIndex:(int)([newSeeDayArr count] - 1)]];
    int nDay = [sDay intValue];
    self.pTermLbl.text = [NSString stringWithFormat:@"%d일", nDay];
}

- (void)CMContentGroupCollectionBtnClicked:(int)nSelect WithAssetId:(NSString *)assetId
{
    
}

@end
