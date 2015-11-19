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
#import "CMDBDataManager.h"
#import "NSMutableDictionary+WISH.h"

@interface VodDetailMainViewController ()
@property (nonatomic, strong) NSMutableArray *pViewController;
@property (nonatomic, strong) NSMutableDictionary *pAssetInfoDic;
@property (nonatomic, strong) NSMutableArray *pContentGroupArr; // 연관 컨텐츠 그룹
@property (nonatomic, strong) NSMutableDictionary *pDrmDic;
@property (nonatomic, strong) NSMutableArray *pSeriesDataArr;
@property (nonatomic, strong) NSMutableArray *pGetWishListArr;
@property (nonatomic) BOOL isZzimCheck;

@end

@implementation VodDetailMainViewController
@synthesize pAssetIdStr;
@synthesize pFileNameStr;
@synthesize delegate;

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"상세정보";
    self.isUseNavigationBar = YES;
    
    [self setTagInit];
    [self setViewInit];
//    return;
    [self requestWithGetWithList];
    [self requestWithAssetInfo];
    [self requestWithRecommendContentGroupByAssetId];
}

#pragma mark - 초기화
#pragma mark - 태그 초기화
- (void)setTagInit
{
    self.pWatchBtn21.tag = VOD_DETAIL_MAIN_VIEW_BTN_01;    // 시청하기
    
    self.pReviewBtn22.tag = VOD_DETAIL_MAIN_VIEW_BTN_02;   // 미리보기
//    self.pWatchBtn22.tag = VOD_DETAIL_MAIN_VIEW_BTN_03;    // 시청하기
    self.pBuyBtn22.tag = VOD_DETAIL_MAIN_VIEW_BTN_03;       // 구매하기
    self.pZzimBtn22.tag = VOD_DETAIL_MAIN_VIEW_BTN_04;     // 찜하기
    
    self.pReviewBtn23.tag = VOD_DETAIL_MAIN_VIEW_BTN_05;   // 미리보기
//    self.pWatchBtn23.tag = VOD_DETAIL_MAIN_VIEW_BTN_06;    // 시청하기
    self.pBuyBtn23.tag = VOD_DETAIL_MAIN_VIEW_BTN_06;       // 구매하기
    self.pZzimBtn23.tag = VOD_DETAIL_MAIN_VIEW_BTN_07;     // 찜하기
    
    self.pWatchBtn24.tag = VOD_DETAIL_MAIN_VIEW_BTN_08;     // 시청하기
    
}

#pragma mark - 화면 초기화
- (void)setViewInit
{
    self.pAssetInfoDic = [[NSMutableDictionary alloc] init];
    self.pContentGroupArr = [[NSMutableArray alloc] init];
    self.pDrmDic = [[NSMutableDictionary alloc] init];
    self.pSeriesDataArr = [[NSMutableArray alloc] init];
    self.pGetWishListArr = [[NSMutableArray alloc] init];
}

#pragma mark - 액션 이벤트
#pragma mark - 버튼 액션 이벤트
- (IBAction)onBtnClicked:(UIButton *)btn
{
    CMDBDataManager* manager= [CMDBDataManager sharedInstance];
    
    if ( [manager getPairingCheck] == NO )
    {
        // 미 페어링시
        [SIAlertView alert:@"셋탑박스 연동 필요" message:@"셋탑박스와 연결한 후 이용하실 수 있습니다.\n메인 화면 좌측상단 아이콘을 눌러 안내에 따라\n쉽고 편리하게 셋탑박스를 연동해보세요."];
        
        return;
    }
    switch ([btn tag]) {
        case VOD_DETAIL_MAIN_VIEW_BTN_02:
        case VOD_DETAIL_MAIN_VIEW_BTN_05:
        {
            // 미리보기
            PlayerViewController *pViewController = [[PlayerViewController alloc] initWithNibName:@"PlayerViewController" bundle:nil];
            pViewController.delegate = self;
            pViewController.pStyleStr = @"preview";
            pViewController.pFileNameStr = self.pFileNameStr;
            [self.navigationController pushViewController:pViewController animated:NO];
        }break;
        case VOD_DETAIL_MAIN_VIEW_BTN_03:
        case VOD_DETAIL_MAIN_VIEW_BTN_06:
        {
            // 구매하기
            CMDBDataManager *manager = [CMDBDataManager sharedInstance];
            if ( [manager getPairingCheck] == NO )
            {
                [SIAlertView alert:@"알림" message:@"셋탑박스와 연결한 후 이용하실 수 있습니다." button:nil];
            }
            else
            {
                VodBuyViewController *pViewController = [[VodBuyViewController alloc] initWithNibName:@"VodBuyViewController" bundle:nil];
                pViewController.pDetailDataDic = self.pAssetInfoDic;
                pViewController.delegate = self;
                [self.navigationController pushViewController:pViewController animated:YES];
            }
            
        }break;
        case VOD_DETAIL_MAIN_VIEW_BTN_04:
        case VOD_DETAIL_MAIN_VIEW_BTN_07:
        {
            // 찜하기
            if ( self.isZzimCheck == YES )
            {
                // 찜하기 되어 있으면 찜하기 해제
                [self.pZzimBtn22 setBackgroundImage:[UIImage imageNamed:@"vod3btn_pick_normal.png"] forState:UIControlStateNormal];
                [self.pZzimBtn23 setBackgroundImage:[UIImage imageNamed:@"vod3btn_pick_normal.png"] forState:UIControlStateNormal];
                [self.pZzimBtn22 setTitleColor:[UIColor colorWithRed:123.0f/255.0f green:90.0f/255.0f blue:163.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
                [self.pZzimBtn23 setTitleColor:[UIColor colorWithRed:123.0f/255.0f green:90.0f/255.0f blue:163.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];

                [self requestWithRemoveWishItem];
            }
            else
            {
                // 찜하기 안되어 있으면 찜하기
                [self.pZzimBtn22 setBackgroundImage:[UIImage imageNamed:@"vod3btn_pick_select.png"] forState:UIControlStateNormal];
                [self.pZzimBtn23 setBackgroundImage:[UIImage imageNamed:@"vod3btn_pick_select.png"] forState:UIControlStateNormal];
                [self.pZzimBtn22 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [self.pZzimBtn23 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

                [self requestWithAddWishItem];
            }

            
        }break;
        case VOD_DETAIL_MAIN_VIEW_BTN_01:
        case VOD_DETAIL_MAIN_VIEW_BTN_08:
        {
            // 시청하기
            PlayerViewController *pViewController = [[PlayerViewController alloc] initWithNibName:@"PlayerViewController" bundle:nil];
            pViewController.delegate = self;
            pViewController.pStyleStr = @"play";
            pViewController.pFileNameStr = self.pFileNameStr;
            [self.navigationController pushViewController:pViewController animated:NO];
        }break;
    }
}

#pragma mark - 중간 화면 초기화
#pragma mark - 시리즈가 아니고 구매 사용자
- (void)setViewInit21
{
    CGFloat width = self.pBodyView.frame.size.width;
    CGFloat posY = 0;
    NSArray* items = @[self.pView01, self.pView21, self.pView03];
    
    for (UIView* item in items) {
        [self.pBodyView addSubview:item];
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
    [self.pBodyView setContentSize:CGSizeMake(width, posY)];
    [self.view updateConstraintsIfNeeded];
    
    self.pContentTextView21.text = [NSString stringWithFormat:@"%@", [[[self pAssetInfoDic] objectForKey:@"asset"] objectForKey:@"synopsis"]];
}

#pragma mark - 시리즈가 아니고 구매 하지 않은 사용자
- (void)setViewInit22
{
    CGFloat width = self.pBodyView.frame.size.width;
    CGFloat posY = 0;
    NSArray* items = @[self.pView01, self.pView22, self.pView03];
    
    for (UIView* item in items) {
        [self.pBodyView addSubview:item];
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
    [self.pBodyView setContentSize:CGSizeMake(width, posY)];
    [self.view updateConstraintsIfNeeded];
    
    self.pContentTextView22.text = [NSString stringWithFormat:@"%@", [[[self pAssetInfoDic] objectForKey:@"asset"] objectForKey:@"synopsis"]];
}

#pragma mark - 시리즈이고 구매 하지 않은 사용자
- (void)setViewInit23
{
    CGFloat width = self.pBodyView.frame.size.width;
    CGFloat posY = 0;
    NSArray* items = @[self.pView01, self.pView23, self.pView03];
    
    for (UIView* item in items) {
        [self.pBodyView addSubview:item];
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
    [self.pBodyView setContentSize:CGSizeMake(width, posY)];
    [self.view updateConstraintsIfNeeded];
    
    
    
    self.pContentTextView23.text = [NSString stringWithFormat:@"%@", [[[self pAssetInfoDic] objectForKey:@"asset"] objectForKey:@"synopsis"]];
    
    
}

#pragma mark - 시리즈이고 구매한 사용자
- (void)setViewInit24
{
    CGFloat width = self.pBodyView.frame.size.width;
    CGFloat posY = 0;
    NSArray* items = @[self.pView01, self.pView24, self.pView03];
    
    for (UIView* item in items) {
        [self.pBodyView addSubview:item];
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
    [self.pBodyView setContentSize:CGSizeMake(width, posY)];
    [self.view updateConstraintsIfNeeded];
    
    self.pContentTextView24.text = [NSString stringWithFormat:@"%@", [[[self pAssetInfoDic] objectForKey:@"asset"] objectForKey:@"synopsis"]];
    
  
}

#pragma mark  - 시리즈 이고 tv
- (void)setViewInit25
{
    CGFloat width = self.pBodyView.frame.size.width;
    CGFloat posY = 0;
    NSArray* items = @[self.pView01, self.pView25, self.pView03];
    
    for (UIView* item in items) {
        [self.pBodyView addSubview:item];
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
    [self.pBodyView setContentSize:CGSizeMake(width, posY)];
    [self.view updateConstraintsIfNeeded];
    
    self.pContentTextView25.text = [NSString stringWithFormat:@"%@", [[[self pAssetInfoDic] objectForKey:@"asset"] objectForKey:@"synopsis"]];
    
    self.pCommentLbl25.text = [NSString stringWithFormat:@"%@는(은)\nTV에서 시청하실 수 있습니다.", [[self.pAssetInfoDic objectForKey:@"asset"] objectForKey:@"productName"]];
}


#pragma mark - 단일 이고 TV시청
- (void)setViewInit26
{
    CGFloat width = self.pBodyView.frame.size.width;
    CGFloat posY = 0;
    NSArray* items = @[self.pView01, self.pView26, self.pView03];
    
    for (UIView* item in items) {
        [self.pBodyView addSubview:item];
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
    [self.pBodyView setContentSize:CGSizeMake(width, posY)];
    [self.view updateConstraintsIfNeeded];
    
    self.pContentTextView26.text = [NSString stringWithFormat:@"%@", [[[self pAssetInfoDic] objectForKey:@"asset"] objectForKey:@"synopsis"]];
    self.pCommentLbl26.text = [NSString stringWithFormat:@"%@는(은)\nTV에서 시청하실 수 있습니다.", [[self.pAssetInfoDic objectForKey:@"asset"] objectForKey:@"productName"]];
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

#pragma mark - 전문
#pragma mark - 찜목록 가져오기
- (void)requestWithGetWithList
{
    NSURLSessionDataTask *tesk = [NSMutableDictionary wishGetWishListCompletion:^(NSArray *wish, NSError *error) {
        
        DDLogError(@"찜목록 가져오기 = [%@]", wish);
        
        if ( [wish count] == 0 )
            return;
        
        [self.pGetWishListArr removeAllObjects];
        
        NSObject *itemObject = [[[wish objectAtIndex:0] objectForKey:@"wishItemList"] objectForKey:@"wishItem"];
        
        if ( [itemObject isKindOfClass:[NSDictionary class]] )
        {
            [self.pGetWishListArr addObject:(NSDictionary *)itemObject];
        }
        else
        {
            [self.pGetWishListArr setArray:(NSArray *)itemObject];
        }
        
        self.isZzimCheck = NO;
        for ( NSDictionary *dic in self.pGetWishListArr )
        {
//            NSString *sAssetId = [NSString stringWithFormat:@"%@", [[[[dic objectForKey:@"wishItemList"] objectForKey:@"wishItem"] objectForKey:@"asset"] objectForKey:@"assetId"]];
            NSString *sAssetId = [NSString stringWithFormat:@"%@", [[dic objectForKey:@"asset"] objectForKey:@"assetId"]];
            
            if ( [self.pAssetIdStr isEqualToString:sAssetId] )
                self.isZzimCheck = YES;
        }
        
        if ( self.isZzimCheck == YES )
        {
            // 찜하기 되어 있으면 123 90 163
            [self.pZzimBtn22 setBackgroundImage:[UIImage imageNamed:@"vod3btn_pick_select.png"] forState:UIControlStateNormal];
            [self.pZzimBtn23 setBackgroundImage:[UIImage imageNamed:@"vod3btn_pick_select.png"] forState:UIControlStateNormal];
            [self.pZzimBtn22 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.pZzimBtn23 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        else
        {
            [self.pZzimBtn22 setBackgroundImage:[UIImage imageNamed:@"vod3btn_pick_normal.png"] forState:UIControlStateNormal];
            [self.pZzimBtn23 setBackgroundImage:[UIImage imageNamed:@"vod3btn_pick_normal.png"] forState:UIControlStateNormal];
            [self.pZzimBtn22 setTitleColor:[UIColor colorWithRed:123.0f/255.0f green:90.0f/255.0f blue:163.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
            [self.pZzimBtn23 setTitleColor:[UIColor colorWithRed:123.0f/255.0f green:90.0f/255.0f blue:163.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
        }
    }];
    
    [UIAlertView showAlertViewForTaskWithErrorOnCompletion:tesk delegate:nil];
}

#pragma mark - 찜하기
- (void)requestWithAddWishItem
{
    NSURLSessionDataTask *tesk = [NSMutableDictionary wishAddWishItemWithAssetId:self.pAssetIdStr completion:^(NSArray *wish, NSError *error) {
        
        DDLogError(@"찜하기 = %@]", wish);
        self.isZzimCheck = YES;
    }];
    
    [UIAlertView showAlertViewForTaskWithErrorOnCompletion:tesk delegate:nil];
}

#pragma mark - 찜해제
- (void)requestWithRemoveWishItem
{
    NSURLSessionDataTask *tesk = [NSMutableDictionary wishRemoveWishWithAssetId:self.pAssetIdStr completion:^(NSArray *wish, NSError *error) {
        
        DDLogError(@"찜해제 = [%@]", wish);
        self.isZzimCheck = NO;
    }];
    
    [UIAlertView showAlertViewForTaskWithErrorOnCompletion:tesk delegate:nil];
}

#pragma mark - 시리즈 갯수 가져오는 전문
- (void)requestWithGetSeriesAssetListWithViewTag:(int)nTag
{
    NSString *sSeriesId = [NSString stringWithFormat:@"%@", [[self.pAssetInfoDic objectForKey:@"asset"] objectForKey:@"seriesId"]];
    NSString *sCategoryId = [NSString stringWithFormat:@"%@", [[self.pAssetInfoDic objectForKey:@"asset"] objectForKey:@"categoryId"]];
    
    NSURLSessionDataTask *tesk = [NSMutableDictionary vodGetSeriesAssetListWithSeriesId:sSeriesId WithCategoryId:sCategoryId WithAssetProfile:@"3" completion:^(NSArray *vod, NSError *error) {
        
        DDLogError(@"시리즈 어셋 = [%@]", vod);
        
        if ( [vod count] == 0 )
            return;
        
        [self.pSeriesDataArr removeAllObjects];
        
        NSObject* itemObject = [[[vod objectAtIndex:0] objectForKey:@"assetList"] objectForKey:@"asset"];
        
//        [self.pSeriesDataArr setArray:[[[vod objectAtIndex:0] objectForKey:@"assetList"] objectForKey:@"asset"]];
        if ([itemObject isKindOfClass:[NSDictionary class]]) {
            
            [self.pSeriesDataArr addObject:(NSDictionary *)itemObject];
            
        } else if ([itemObject isKindOfClass:[NSArray class]]) {
            
           [self.pSeriesDataArr setArray:(NSArray *)itemObject];
            
        }
        

        
        NSString *sSeriesEndIndex = [NSString stringWithFormat:@"%@", [[[self pAssetInfoDic] objectForKey:@"asset"] objectForKey:@"seriesEndIndex"]];
        NSString *sTotalCount = [NSString stringWithFormat:@"%@", [[vod objectAtIndex:0] objectForKey:@"totalAssetCount"]];
        
        int nSeriesEndIndex = [sSeriesEndIndex intValue];
        int nTotalCount = [sTotalCount intValue];
        
        if ( [sSeriesEndIndex isEqualToString:sTotalCount] )
        {
            // 같으면 종료된 시리즈 1회부터 보여줌
            
        }
        else
        {
            // 다르면 종료되지 않음 최신회차 보여줌
            
        }
        
        [self createSeriesButtonWithTag:nTag WithTotalCount:nTotalCount];
    }];
    
    [UIAlertView showAlertViewForTaskWithErrorOnCompletion:tesk delegate:nil];
}

- (void)onSeriesBtnClicked:(UIButton *)btn
{
    NSLog(@"btn tag = [%d]", (int)[btn tag]);
    
    NSString *sIndex = [NSString stringWithFormat:@"%d", (int)[btn tag]];
    
    for ( NSDictionary *dic in self.pSeriesDataArr )
    {
        if  ( [[dic objectForKey:@"seriesCurIndex"] isEqualToString:sIndex] )
        {
            self.pAssetIdStr = [NSString stringWithFormat:@"%@", [dic objectForKey:@"assetId"]];
            [self requestWithAssetInfo];
            [self requestWithRecommendContentGroupByAssetId];
        }
    }
}

- (void)createSeriesButtonWithTag:(int)nTag WithTotalCount:(int)nTotalCount
{
    
    NSString *sSeriesCurIndex = [NSString stringWithFormat:@"%@", [[self.pAssetInfoDic objectForKey:@"asset"] objectForKey:@"seriesCurIndex"]];
    int nSeriesCurIndex = [sSeriesCurIndex intValue];
    
    switch (nTag) {
        case 23:
        {
            for ( id button in [self.pSeriesScrollView23 subviews] )
            {
                if ( [button isKindOfClass:[UIButton class]] )
                {
                    [button removeFromSuperview];
                }
            }
            
            int nPosX = 0;
            
            for ( int i = 0; i < nTotalCount; i++ )
            {
                nPosX = i * 64;
                UIButton *pBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [pBtn setTitle:[NSString stringWithFormat:@"%d회", i+1] forState:UIControlStateNormal];
                [pBtn setTitleColor:[UIColor colorWithRed:123.0f/255.0f green:90.0f/255.0f blue:163.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
                if ( i + 1 == nSeriesCurIndex )
                {
                    // 선택 버튼
                    [pBtn setBackgroundImage:[UIImage imageNamed:@"seriesno_press.png"] forState:UIControlStateNormal];
                }
                pBtn.frame = CGRectMake(nPosX, 4, 47, 35);
                pBtn.tag = i + 1;
                [pBtn addTarget:self action:@selector(onSeriesBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
                [self.pSeriesScrollView23 addSubview:pBtn];
            }
            self.pSeriesScrollView23.contentSize = CGSizeMake((nTotalCount - 1) * 64 + 47, CGRectGetHeight(self.pSeriesScrollView23.frame));
        }break;
        case 24:
        {
            for ( id button in [self.pSeriesScrollView24 subviews] )
            {
                if ( [button isKindOfClass:[UIButton class]] )
                {
                    [button removeFromSuperview];
                }
            }
            
            int nPosX = 0;
            
            for ( int i = 0; i < nTotalCount; i++ )
            {
                nPosX = i * 64;
                UIButton *pBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [pBtn setTitle:[NSString stringWithFormat:@"%d회", i+1] forState:UIControlStateNormal];
                [pBtn setTitleColor:[UIColor colorWithRed:123.0f/255.0f green:90.0f/255.0f blue:163.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
                if ( i + 1 == nSeriesCurIndex )
                {
                    // 선택 버튼
                    [pBtn setBackgroundImage:[UIImage imageNamed:@"seriesno_press.png"] forState:UIControlStateNormal];
                }
                pBtn.frame = CGRectMake(nPosX, 4, 47, 35);
                pBtn.tag = i + 1;
                [pBtn addTarget:self action:@selector(onSeriesBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
                [self.pSeriesScrollView24 addSubview:pBtn];
            }
            
            self.pSeriesScrollView24.contentSize = CGSizeMake((nTotalCount - 1) * 64 + 47, CGRectGetHeight(self.pSeriesScrollView24.frame));

        }break;
        case 25:
        {
            for ( id button in [self.pSeriesScrollView25 subviews] )
            {
                if ( [button isKindOfClass:[UIButton class]] )
                {
                    [button removeFromSuperview];
                }
            }
            
            int nPosX = 0;
            
            for ( int i = 0; i < nTotalCount; i++ )
            {
                nPosX = i * 64;
                UIButton *pBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [pBtn setTitle:[NSString stringWithFormat:@"%d회", i+1] forState:UIControlStateNormal];
                [pBtn setTitleColor:[UIColor colorWithRed:123.0f/255.0f green:90.0f/255.0f blue:163.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
                if ( i + 1 == nSeriesCurIndex )
                {
                    // 선택 버튼
                    [pBtn setBackgroundImage:[UIImage imageNamed:@"seriesno_press.png"] forState:UIControlStateNormal];
                }
                pBtn.frame = CGRectMake(nPosX, 4, 47, 35);
                pBtn.tag = i + 1;
                [pBtn addTarget:self action:@selector(onSeriesBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
                [self.pSeriesScrollView25 addSubview:pBtn];
            }

            self.pSeriesScrollView25.contentSize = CGSizeMake((nTotalCount - 1) * 64 + 47, CGRectGetHeight(self.pSeriesScrollView25.frame));
        }break;
    }
}

#pragma mark - vod 상세
- (void)requestWithAssetInfo
{
    NSURLSessionDataTask *tesk = [NSMutableDictionary vodGetAssetInfoWithAssetId:self.pAssetIdStr WithAssetProfile:@"9" completion:^(NSArray *vod, NSError *error) {
        
        DDLogError(@"vod 상세 = [%@]", vod);
        
        if ( [vod count] == 0 )
            return;
        [self.pAssetInfoDic removeAllObjects];
        [self.pAssetInfoDic setDictionary:[vod objectAtIndex:0]];
        
        self.pFileNameStr = [NSString stringWithFormat:@"%@", [[[vod objectAtIndex:0] objectForKey:@"asset"] objectForKey:@"fileName"]];
        
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

        int nIndex = 1;
        int nTotal = (int)[[[[vod objectAtIndex:0] objectForKey:@"contentGroupList"] objectForKey:@"contentGroup"] count];
        
        NSMutableArray *pArr = [[NSMutableArray alloc] init];
        
        if ( [[[[vod objectAtIndex:0] objectForKey:@"contentGroupList"] objectForKey:@"contentGroup"] isKindOfClass:[NSDictionary class]] )
        {
            [self.pContentGroupArr addObject:[[[[vod objectAtIndex:0] objectForKey:@"contentGroupList"] objectForKey:@"contentGroup"] copy]];
            
            [self banPageControllerInit];
        }
        else if ( [[[[vod objectAtIndex:0] objectForKey:@"contentGroupList"] objectForKey:@"contentGroup"] isKindOfClass:[NSArray class]] )
        {
            for ( NSDictionary *dic in  [[[vod objectAtIndex:0] objectForKey:@"contentGroupList"] objectForKey:@"contentGroup"] )
            {
                NSMutableDictionary *nDic = [[NSMutableDictionary alloc] init];
                
                [nDic setObject:[dic objectForKey:@"smallImageFileName"] forKey:@"smallImageFileName"];
                [nDic setObject:[dic objectForKey:@"title"] forKey:@"title"];
                [nDic setObject:[dic objectForKey:@"primaryAssetId"] forKey:@"primaryAssetId"];
                [nDic setObject:[dic objectForKey:@"assetSeriesLink"] forKey:@"assetSeriesLink"];
                [nDic setObject:[dic objectForKey:@"rating"] forKey:@"rating"];
                [pArr addObject:nDic];
                
                if ( nIndex % 4 == 0 || nIndex == nTotal)
                {
                    [self.pContentGroupArr addObject:[pArr copy]];
                    [pArr removeAllObjects];
                }
                
                nIndex++;
            }
            
            [self banPageControllerInit];
        }
        
    }];
    
    [UIAlertView showAlertViewForTaskWithErrorOnCompletion:tesk delegate:nil];
}


#pragma mark - 상세 데이터에 따라 화면 셋팅
- (void)setResponseViewInit
{
    
    NSString *sSeriesLink = [NSString stringWithFormat:@"%@", [[self.pAssetInfoDic objectForKey:@"asset"] objectForKey:@"seriesLink"]];     // 시리즈 인지 아닌지
    BOOL isPurchasedId = [[self.pAssetInfoDic objectForKey:@"asset"] objectForKey:@"purchasedId"];      // 구매하기 인지 아닌지
 
    NSString *sRating = [[self.pAssetInfoDic objectForKey:@"asset"] objectForKey:@"rating"];    // 시청 등급
    
    NSString *sReviewRatingTotal = [[self.pAssetInfoDic objectForKey:@"asset"] objectForKey:@"reviewRatingTotal"];  // 전체 별표
    NSString *sReviewRatingCount =  [[self.pAssetInfoDic objectForKey:@"asset"] objectForKey:@"reviewRatingCount"]; // 현재 별표
    
    int nReviewRatingTotal = [sReviewRatingTotal intValue];
    int nReviewRatingCount = [sReviewRatingCount intValue];
    
    [self setReviewRatingWithTotalCount:nReviewRatingTotal WithCount:nReviewRatingCount];
    
    if ( [sRating isEqualToString:@"19"] || [sRating isEqualToString:@"19세"])
    {
        [self.pRatingImageView setImage:[UIImage imageNamed:@"19.png"]];
    }
    else if ( [sRating isEqualToString:@"15"] )
    {
        [self.pRatingImageView setImage:[UIImage imageNamed:@"15.png"]];
    }
    else if ( [sRating isEqualToString:@"12"] )
    {
        [self.pRatingImageView setImage:[UIImage imageNamed:@"12.png"]];
    }
    else
    {
        // all?
        [self.pRatingImageView setImage:[UIImage imageNamed:@"all.png"]];
    }
    
    
    
    
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
    
    
    // 배열로 단독 아님 패키지 가격이 내려 오는데 패키지 일땐 어떻하지???
    NSObject *productObj = [[[[self pAssetInfoDic] objectForKey:@"asset"] objectForKey:@"productList"] objectForKey:@"product"];
    NSString *sPurchasedTime = @"";
    
    
    if ( [productObj isKindOfClass:[NSDictionary class]] )
    {
        sPurchasedTime = [NSString stringWithFormat:@"%@", [(NSDictionary *)productObj objectForKey:@"purchasedTime"]];
        
        // 단독
        NSString *sProduct = [NSString stringWithFormat:@"%@", [(NSDictionary *)productObj objectForKey:@"price"]];
        self.pPriceLbl.text = [NSString stringWithFormat:@"%@ [부가세 별도]", [[CMAppManager sharedInstance] insertComma:sProduct]];
        
        // 평생 소장인지 체크
        NSString *sViewablePeriodState = [NSString stringWithFormat:@"%@", [(NSDictionary *)productObj objectForKey:@"viewablePeriodState"]];
        
        NSString *sViewablePeriod = [NSString stringWithFormat:@"%@", [(NSDictionary *)productObj objectForKey:@"viewablePeriod"]];
        
        if ( [sViewablePeriodState isEqualToString:@"0"] )
        {
            // 평생 소장 아님
            self.pTermLbl.text = [NSString stringWithFormat:@"%@", [[CMAppManager sharedInstance] getSplitTermWithDateStr:sViewablePeriod]];
        }
        else
        {
            // 평생 소장
            self.pTermLbl.text = @"평생소장";
        }
    }
    else if ( [productObj isKindOfClass:[NSArray class]] )
    {
        sPurchasedTime = [NSString stringWithFormat:@"%@", [[(NSArray *)productObj objectAtIndex:0] objectForKey:@"purchasedTime"]];
        
        
        // 패키지
        NSString *sProduct = [NSString stringWithFormat:@"%@", [[(NSArray *)productObj objectAtIndex:0] objectForKey:@"price"]];
        self.pPriceLbl.text = [NSString stringWithFormat:@"%@ [부가세 별도]", [[CMAppManager sharedInstance] insertComma:sProduct]];
        
        // 평생 소장인지 체크
        NSString *sViewablePeriodState = [NSString stringWithFormat:@"%@", [[(NSArray *)productObj objectAtIndex:0] objectForKey:@"viewablePeriodState"]];
        
        NSString *sViewablePeriod = [NSString stringWithFormat:@"%@", [[(NSArray *)productObj objectAtIndex:0] objectForKey:@"viewablePeriod"]];
        
        if ( [sViewablePeriodState isEqualToString:@"0"] )
        {
            // 평생 소장 아님
            self.pTermLbl.text = [NSString stringWithFormat:@"%@", [[CMAppManager sharedInstance] getSplitTermWithDateStr:sViewablePeriod]];
        }
        else
        {
            // 평생 소장
            self.pTermLbl.text = @"평생소장";
        }
    }
    
    NSString *sPublicationRight = [NSString stringWithFormat:@"%@", [[self.pAssetInfoDic objectForKey:@"asset"] objectForKey:@"publicationRight"]];
    NSString *sPreviewPeriod = [NSString stringWithFormat:@"%@", [[self.pAssetInfoDic objectForKey:@"asset"] objectForKey:@"previewPeriod"]];
    
    if ( [sPublicationRight isEqualToString:@"2"] )
    {
        // tv 모바일
        self.pEquipmentImageView.image = [UIImage imageNamed:@"icon_tv.png"];
        self.pEquipmentImageView02.image = [UIImage imageNamed:@"icon_mobile.png"];
    }
    else
    {
        // tv 전용
        self.pEquipmentImageView.image = [UIImage imageNamed:@"icon_tv.png"];
        self.pEquipmentImageView02.image = [UIImage imageNamed:@""];
    }
    
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
    
    self.pManagerLbl.text = [NSString stringWithFormat:@"%@", [[[self pAssetInfoDic] objectForKey:@"asset"] objectForKey:@"director"]];
    
    
    if ( [sSeriesLink isEqualToString:@"0"] )
    {
        // 시리즈가 아니다
        if ( [sPurchasedTime length] == 0 || [sPurchasedTime isEqualToString:@"(null)"] )
        {
            // 구매 안한 사용자
            [self setViewInit22];
            if ( [sPreviewPeriod isEqualToString:@"0"] )
            {
                // 미리보기 없음
                self.pReviewBtn22.hidden = YES;
            }
        }
        else
        {
            // 구매 한 사용자
            if ( [sPublicationRight isEqualToString:@"2"] )
            {
                // 모바일 시청 가능
                [self setViewInit21];
            }
            else
            {
                // 1 tv 시청 가능
                [self setViewInit26];
            }
        }
    }
    else
    {
        int nTag = 0;
        // 시리즈다
        if ( [sPurchasedTime length] == 0 || [sPurchasedTime isEqualToString:@"(null)"] )
        {
            // 구매안한 사용자
            NSString *sProductType = @"";
            NSObject* itemObject = [[[self.pAssetInfoDic objectForKey:@"asset"] objectForKey:@"productList"] objectForKey:@"product"];
            
            if ([itemObject isKindOfClass:[NSDictionary class]]) {
                
                sProductType = [NSString stringWithFormat:@"%@", [(NSDictionary *)itemObject objectForKey:@"productType"]];
            
            } else if ([itemObject isKindOfClass:[NSArray class]]) {
                
                sProductType = [NSString stringWithFormat:@"%@", [[(NSArray *)itemObject objectAtIndex:0] objectForKey:@"productType"]];
                
            }
            
//            NSString *sProductType = [NSString stringWithFormat:@"%@", [[[[[self pAssetInfoDic] objectForKey:@"asset"] objectForKey:@"productList"] objectForKey:@"product"] objectForKey:@"productType"]]; // 무료시청 체크 FOD 이면 무료 시청
   
            
            if ( [sProductType isEqualToString:@"FOD"] )
            {
                // 무료시청
                nTag = 24;
                [self setViewInit24];
            }
            else
            {
                nTag = 23;
                [self setViewInit23];
            }
            
            if ( [sPreviewPeriod isEqualToString:@"0"] )
            {
                // 미리보기 없음
                self.pReviewBtn23.hidden = YES;
            }
        }
        else
        {
            // 구매한 사용자
            
            if ( [sPublicationRight isEqualToString:@"2"] )
            {
                nTag = 24;
                // 모바일 시청 가능
                [self setViewInit24];
                
            }
            else
            {
                nTag = 25;
                // 1 tv 시청 가능
                [self setViewInit25];
            }
        }
        
        [self requestWithGetSeriesAssetListWithViewTag:nTag];
    }
    
    
    
    // 시청기간 다시 봐야 함
//    NSString *sSeeDay = [NSString stringWithFormat:@"%@", [[[[[self pAssetInfoDic] objectForKey:@"asset"] objectForKey:@"productList"] objectForKey:@"product"] objectForKey:@"viewablePeriod"]];
//    NSArray *seeDayArr = [sSeeDay componentsSeparatedByString:@" "];
//    NSString *sNewSeeDay = [NSString stringWithFormat:@"%@", [seeDayArr objectAtIndex:0]];
//    NSArray *newSeeDayArr = [sNewSeeDay componentsSeparatedByString:@"-"];
//    if ( [newSeeDayArr count] == 0 )
//        return;
//    NSString *sDay = [NSString stringWithFormat:@"%@", [newSeeDayArr objectAtIndex:(int)([newSeeDayArr count] - 1)]];
//    int nDay = [sDay intValue];
//    self.pTermLbl.text = [NSString stringWithFormat:@"%d일", nDay];
    
    
}

- (void)CMContentGroupCollectionBtnClicked:(int)nSelect WithAssetId:(NSString *)assetId WithSeriesLink:(NSString *)seriesLint WithAdultCheck:(BOOL)isAdult
{
    self.pAssetIdStr = [NSString stringWithFormat:@"%@", assetId];
    
    if ( isAdult == YES )
    {
        // 성인 컨첸츠이면
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        CMAdultCertificationYN adultYN = [userDefault adultCertYN];
        if ( adultYN == CMAdultCertificationSuccess )
        {
            // 인증 받았으면
            if ( [seriesLint isEqualToString:@"0"] )
            {
                // 시리즈가 아니다
                VodDetailMainViewController *pViewController = [[VodDetailMainViewController alloc] initWithNibName:@"VodDetailMainViewController" bundle:nil];
                pViewController.pAssetIdStr = assetId;
                [self.navigationController pushViewController:pViewController animated:YES];
                
            }
            else
            {
                // 시리즈다
                [self requestWithAssetInfo];
                [self requestWithRecommendContentGroupByAssetId];
                
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
        if ( [seriesLint isEqualToString:@"0"] )
        {
            // 시리즈가 아니다
            VodDetailMainViewController *pViewController = [[VodDetailMainViewController alloc] initWithNibName:@"VodDetailMainViewController" bundle:nil];
            pViewController.pAssetIdStr = assetId;
            [self.navigationController pushViewController:pViewController animated:YES];
            
        }
        else
        {
            // 시리즈다
            [self requestWithAssetInfo];
            [self requestWithRecommendContentGroupByAssetId];
            
        }

    }

    
}

- (void)setReviewRatingWithTotalCount:(int)nTotal WithCount:(int)nCount
{
    int nTotals = nTotal * 10;
    
    int nStar = 0;
    if (nTotals > 0 && nCount > 0) {
        nStar = nTotals / nCount;
    }
    
    if ( nStar >= 50 )
    {
        // 별 5개
        self.pStarImage01.image = [UIImage imageNamed:@"star_full.png"];
        self.pStarImage02.image = [UIImage imageNamed:@"star_full.png"];
        self.pStarImage03.image = [UIImage imageNamed:@"star_full.png"];
        self.pStarImage04.image = [UIImage imageNamed:@"star_full.png"];
        self.pStarImage05.image = [UIImage imageNamed:@"star_full.png"];
    }
    else if ( nStar < 50 && nStar >= 45 )
    {
        // 별 4개반
        self.pStarImage01.image = [UIImage imageNamed:@"star_full.png"];
        self.pStarImage02.image = [UIImage imageNamed:@"star_full.png"];
        self.pStarImage03.image = [UIImage imageNamed:@"star_full.png"];
        self.pStarImage04.image = [UIImage imageNamed:@"star_full.png"];
        self.pStarImage05.image = [UIImage imageNamed:@"star_full.png"];
    }
    else if ( nStar < 45 && nStar >= 40 )
    {
        // 별 4개
        self.pStarImage01.image = [UIImage imageNamed:@"star_full.png"];
        self.pStarImage02.image = [UIImage imageNamed:@"star_full.png"];
        self.pStarImage03.image = [UIImage imageNamed:@"star_full.png"];
        self.pStarImage04.image = [UIImage imageNamed:@"star_full.png"];
        self.pStarImage05.image = [UIImage imageNamed:@"star_empty.png"];
    }
    else if ( nStar < 40 && nStar >= 35 )
    {
        // 별 3개반
        self.pStarImage01.image = [UIImage imageNamed:@"star_full.png"];
        self.pStarImage02.image = [UIImage imageNamed:@"star_full.png"];
        self.pStarImage03.image = [UIImage imageNamed:@"star_full.png"];
        self.pStarImage04.image = [UIImage imageNamed:@"star_half.png"];
        self.pStarImage05.image = [UIImage imageNamed:@"star_empty.png"];
    }
    else if ( nStar < 35 && nStar >= 30 )
    {
        // 별 3개
        self.pStarImage01.image = [UIImage imageNamed:@"star_full.png"];
        self.pStarImage02.image = [UIImage imageNamed:@"star_full.png"];
        self.pStarImage03.image = [UIImage imageNamed:@"star_full.png"];
        self.pStarImage04.image = [UIImage imageNamed:@"star_empty.png"];
        self.pStarImage05.image = [UIImage imageNamed:@"star_empty.png"];
    }
    else if ( nStar < 30 && nStar >= 25 )
    {
        // 별 2개반
        self.pStarImage01.image = [UIImage imageNamed:@"star_full.png"];
        self.pStarImage02.image = [UIImage imageNamed:@"star_full.png"];
        self.pStarImage03.image = [UIImage imageNamed:@"star_half.png"];
        self.pStarImage04.image = [UIImage imageNamed:@"star_empty.png"];
        self.pStarImage05.image = [UIImage imageNamed:@"star_empty.png"];
    }
    else if ( nStar < 25 && nStar >= 20 )
    {
        // 별 2개
        self.pStarImage01.image = [UIImage imageNamed:@"star_full.png"];
        self.pStarImage02.image = [UIImage imageNamed:@"star_full.png"];
        self.pStarImage03.image = [UIImage imageNamed:@"star_empty.png"];
        self.pStarImage04.image = [UIImage imageNamed:@"star_empty.png"];
        self.pStarImage05.image = [UIImage imageNamed:@"star_empty.png"];
    }
    else if ( nStar < 20 && nStar >= 15 )
    {
        // 별 1개반
        self.pStarImage01.image = [UIImage imageNamed:@"star_full.png"];
        self.pStarImage02.image = [UIImage imageNamed:@"star_half.png"];
        self.pStarImage03.image = [UIImage imageNamed:@"star_empty.png"];
        self.pStarImage04.image = [UIImage imageNamed:@"star_empty.png"];
        self.pStarImage05.image = [UIImage imageNamed:@"star_empty.png"];
    }
    else if ( nStar < 15 && nStar >= 10 )
    {
        // 별 1개
        self.pStarImage01.image = [UIImage imageNamed:@"star_full.png"];
        self.pStarImage02.image = [UIImage imageNamed:@"star_empty.png"];
        self.pStarImage03.image = [UIImage imageNamed:@"star_empty.png"];
        self.pStarImage04.image = [UIImage imageNamed:@"star_empty.png"];
        self.pStarImage05.image = [UIImage imageNamed:@"star_empty.png"];
    }
    else if ( nStar < 10 && nStar >= 5 )
    {
        // 별 반개
        self.pStarImage01.image = [UIImage imageNamed:@"star_half.png"];
        self.pStarImage02.image = [UIImage imageNamed:@"star_empty.png"];
        self.pStarImage03.image = [UIImage imageNamed:@"star_empty.png"];
        self.pStarImage04.image = [UIImage imageNamed:@"star_empty.png"];
        self.pStarImage05.image = [UIImage imageNamed:@"star_empty.png"];
    }
    else
    {
        // 별없음
        self.pStarImage01.image = [UIImage imageNamed:@"star_empty.png"];
        self.pStarImage02.image = [UIImage imageNamed:@"star_empty.png"];
        self.pStarImage03.image = [UIImage imageNamed:@"star_empty.png"];
        self.pStarImage04.image = [UIImage imageNamed:@"star_empty.png"];
        self.pStarImage05.image = [UIImage imageNamed:@"star_empty.png"];
    }
}

#pragma mark - 델리게이트
#pragma mark - VodBuyViewController 델리게이트
-(void)VodBuyViewWithTag:(int)nTag
{
//    switch (nTag) {
//        case VOD_BUY_VIEW_BTN_08:
//        {
//            [self.delegate VodDetailMainViewWithTag:VOD_BUY_VIEW_BTN_08];
//        }break;
//    }
    // reload
    [self requestWithAssetInfo];
    [self requestWithRecommendContentGroupByAssetId];
}

@end
