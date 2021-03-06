//
//  RootViewController.m
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 8. 12..
//  Copyright (c) 2015년 JUNG KIL BAE. All rights reserved.
//

#import "RootViewController.h"
#import "CMSearchHistory.h"
#import "EpgMainViewController.h"
#import "CMSearchMainViewController.h"//검색화면 메인
#import "CMPreferenceMainViewController.h"//설정화면 메인
#import "NSMutableDictionary+EPG.h"
#import "UIAlertView+AFNetworking.h"
#import "UIRefreshControl+AFNetworking.h"
#import "NSMutableDictionary+VOD.h"
#import "NSMutableDictionary+EPG_SEARCH.h"
#import "FXKeychain.h"
#import "CMDBDataManager.h"

@interface RootViewController ()

@property (nonatomic, strong) CMBaseViewController* homeController;
@end

@implementation RootViewController
@synthesize delegate;

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    // 성인인증후, 화면 이동 및 갱신 (FXKeychain버그로 인해 이런식으로 처리)
    if (APP_REFRESH_ADULT_TAB == [CMAppManager sharedInstance].appRefreshType)
    {
        [CMAppManager sharedInstance].appRefreshType = APP_REFRESH_NONE;
        
        if ([[CMAppManager sharedInstance] getKeychainAdultCertification] == YES)
        {
            [self refreshWithTab:[[CMAppManager sharedInstance].appRefreshInfo[CNM_REFRESH_TAP_TAG] integerValue]];
        }
    }
    else if (APP_REFRESH_VOD_DETAIL == [CMAppManager sharedInstance].appRefreshType)
    {
        [CMAppManager sharedInstance].appRefreshType = APP_REFRESH_NONE;
        
        if ([[CMAppManager sharedInstance] getKeychainAdultCertification] == YES)
        {
            [self refreshWithTab:self.pGnbViewController.currentTabTag];
            
            VodDetailMainViewController *pViewController = [[VodDetailMainViewController alloc] initWithNibName:@"VodDetailMainViewController" bundle:nil];
            pViewController.pAssetIdStr = [CMAppManager sharedInstance].appRefreshInfo[CNM_REFRESH_ASSET_ID];
            pViewController.pEpisodePeerExistence = [CMAppManager sharedInstance].appRefreshInfo[CNM_REFRESH_EPISODE_PEER_EXISTENCE];
            pViewController.pContentGroupId = [CMAppManager sharedInstance].appRefreshInfo[CNM_REFRESH_CONTENT_GROUP_ID];
            pViewController.delegate = [CMAppManager sharedInstance].appRefreshInfo[CNM_REFRESH_DELEGATE];
            [self.navigationController pushViewController:pViewController animated:YES];
        }
        
    }
    else if (APP_REFRESH_HOME == [CMAppManager sharedInstance].appRefreshType) {
        
        [CMAppManager sharedInstance].appRefreshType = APP_REFRESH_NONE;
        [self refreshWithTab:self.pGnbViewController.currentTabTag];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Gnb add
    self.pGnbViewController = [[HomeGnbViewController alloc] initWithNibName:@"HomeGnbViewController" bundle:nil];
    self.pGnbViewController.delegate = self;
    [self addChildViewController:self.pGnbViewController];
    [self.pGnbViewController didMoveToParentViewController:self];
    [self.pGnbView addSubview:self.pGnbViewController.view];
    
    // 추천 add
    RecommendMainViewController *pRecommendViewController = [[RecommendMainViewController alloc] initWithNibName:@"RecommendMainViewController" bundle:nil];
    pRecommendViewController.view.frame = CGRectMake(0, 0, self.pBodyView.frame.size.width, self.pBodyView.frame.size.height);
    pRecommendViewController.delegate = self;
    [self addChildViewController:pRecommendViewController];
    [pRecommendViewController didMoveToParentViewController:self];
    [self.pBodyView addSubview:pRecommendViewController.view];
    
    self.homeController = pRecommendViewController;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)onHomeGnbViewMenuList:(NSInteger)nTag
{
    switch (nTag) {
        case HOME_GNB_VIEW_BTN_01:
        {
            [[CMAppManager sharedInstance] onLeftMenuListOpen:self];
        }break;
        case HOME_GNB_VIEW_BTN_02:
        {
            // 검색
            CMSearchMainViewController* controller = [[CMSearchMainViewController alloc] initWithNibName:@"CMSearchMainViewController" bundle:nil];
            [self.navigationController pushViewController:controller animated:YES];
            
        }break;
        case HOME_GNB_VIEW_BTN_03:
        {
            // 추천
            [self.pGnbViewController selectTabTag:HOME_GNB_VIEW_BTN_03];
            
            [self bodySubViewsRemove];
            
            RecommendMainViewController *pViewController = [[RecommendMainViewController alloc] initWithNibName:@"RecommendMainViewController" bundle:nil];
            pViewController.view.frame = CGRectMake(0, 0, self.pBodyView.frame.size.width, self.pBodyView.frame.size.height);
            pViewController.delegate = self;
            [self addChildViewController:pViewController];
            [pViewController didMoveToParentViewController:self];
            [self.pBodyView addSubview:pViewController.view];
            
            self.homeController = pViewController;
            
        }break;
        case HOME_GNB_VIEW_BTN_04:
        {
            // 영화
            [self.pGnbViewController selectTabTag:HOME_GNB_VIEW_BTN_04];
            
            [self bodySubViewsRemove];
            
            MovieMainViewController *pViewController = [[MovieMainViewController alloc] initWithNibName:@"MovieMainViewController" bundle:nil];
            pViewController.delegate = self;
            pViewController.pDataDic = nil;
            pViewController.view.frame = CGRectMake(0, 0, self.pBodyView.frame.size.width, self.pBodyView.frame.size.height);
            
            [self addChildViewController:pViewController];
            [pViewController didMoveToParentViewController:self];
            [self.pBodyView addSubview:pViewController.view];
            
            self.homeController = pViewController;
            
        }break;
        case HOME_GNB_VIEW_BTN_05:
        {
            // 애니키즈
            [self.pGnbViewController selectTabTag:HOME_GNB_VIEW_BTN_05];
            
            [self bodySubViewsRemove];
            
            AniKidsMainViewController *pViewController = [[AniKidsMainViewController alloc] initWithNibName:@"AniKidsMainViewController" bundle:nil];
            pViewController.delegate = self;
            pViewController.pDataDic = nil;
            pViewController.view.frame = CGRectMake(0, 0, self.pBodyView.frame.size.width, self.pBodyView.frame.size.height);
            
            [self addChildViewController:pViewController];
            [pViewController didMoveToParentViewController:self];
            [self.pBodyView addSubview:pViewController.view];
            
            self.homeController = pViewController;
            
        }break;
        case HOME_GNB_VIEW_BTN_06:
        {
            // TV다시보기
            [self.pGnbViewController selectTabTag:HOME_GNB_VIEW_BTN_06];
            
            [self bodySubViewsRemove];
            
            TVReplayViewController *pViewController = [[TVReplayViewController alloc] initWithNibName:@"TVReplayViewController" bundle:nil];
            pViewController.delegate = self;
            pViewController.pDataDic = nil;
            pViewController.view.frame = CGRectMake(0, 0, self.pBodyView.frame.size.width, self.pBodyView.frame.size.height);
            [self addChildViewController:pViewController];
            [pViewController didMoveToParentViewController:self];
            [self.pBodyView addSubview:pViewController.view];
            
            self.homeController = pViewController;
            
        }break;
        case HOME_GNB_VIEW_BTN_07:
        {
            // 성인
            if ( [[CMAppManager sharedInstance] getKeychainAdultCertification] == YES )
            {
                [self.pGnbViewController selectTabTag:HOME_GNB_VIEW_BTN_07];
                
                [self bodySubViewsRemove];
                
                AdultMainViewController *pViewController = [[AdultMainViewController alloc] initWithNibName:@"AdultMainViewController" bundle:nil];
                pViewController.delegate = self;
                pViewController.pDataDic = nil;
                pViewController.view.frame = CGRectMake(0, 0, self.pBodyView.frame.size.width, self.pBodyView.frame.size.height);
                [self addChildViewController:pViewController];
                [pViewController didMoveToParentViewController:self];
                [self.pBodyView addSubview:pViewController.view];
                
                self.homeController = pViewController;
            }
            else
            {
                [SIAlertView alert:@"성인인증 필요" message:@"성인 인증이 필요한 콘텐츠입니다.\n성인 인증을 하시겠습니까?" cancel:@"취소" buttons:@[@"확인"]
                        completion:^(NSInteger buttonIndex, SIAlertView *alert) {
                    
                            if ( buttonIndex == 1 )
                            {
                                [[CMAppManager sharedInstance] setRefreshTabInfoWithTag:nTag];
                                // 설정 창으로 이동
                                CMPreferenceMainViewController* controller = [[CMPreferenceMainViewController alloc] initWithNibName:@"CMPreferenceMainViewController" bundle:nil];
                                [self.navigationController pushViewController:controller animated:YES];
                            }
                }];
            }
            
            
            
            
        }break;
        case HOME_GNB_VIEW_BTN_08:
        {
            // 테스트 버튼
            TestMainViewController *pViewController = [[TestMainViewController alloc] initWithNibName:@"TestMainViewController" bundle:nil];
            pViewController.view.frame = CGRectMake(0, 0, self.pBodyView.frame.size.width, self.pBodyView.frame.size.height);
            [self addChildViewController:pViewController];
            [pViewController didMoveToParentViewController:self];
            [self.pBodyView addSubview:pViewController.view];
        }break;
    }
}

- (void)bodySubViewsRemove
{
    if (self.homeController) {
        
        [self.homeController.view removeFromSuperview];
        [self.homeController removeFromParentViewController];
        self.homeController = nil;
    }
    
//    for ( UIView *view in [[[self.view subviews] objectAtIndex:1] subviews] )
//    {
//        [view removeFromSuperview];
//    }
}

- (void)refreshWithTab:(NSInteger)tag
{
    [self.pGnbViewController selectTabTag:tag];
    [self onHomeGnbViewMenuList:tag];
}

#pragma mark - HomeGnbViewDelegate

- (void)onLeftMenuViewCloseCompletReflash:(int)nTag
{
    switch (nTag) {
        case 0:
        {
            // 닫기 버튼
            
        }break;
        case 1:
        {
            // EPG - 채널가이드
            EpgMainViewController *pViewController = [[EpgMainViewController alloc] initWithNibName:@"EpgMainViewController" bundle:nil];
            [self.navigationController pushViewController:pViewController animated:YES];
        }break;
        case 2:
        {
            // 리모컨
            RemoconMainViewController *pViewController = [[RemoconMainViewController alloc] initWithNibName:@"RemoconMainViewController" bundle:nil];
            [self.navigationController pushViewController:pViewController animated:YES];
            
        }break;
        case 3:
        {
            // PVR - 녹화
            PvrMainViewController *pViewController = [[PvrMainViewController alloc] initWithNibName:@"PvrMainViewController" bundle:nil];
            [self.navigationController pushViewController:pViewController animated:YES];
            //            // 검색
            //            CMSearchMainViewController* controller = [[CMSearchMainViewController alloc] initWithNibName:@"CMSearchMainViewController" bundle:nil];
            //            [self.navigationController pushViewController:controller animated:YES];
            
        }break;
        case 4:
        {
            // My C&M
            MyCMMainViewController *pViewController = [[MyCMMainViewController alloc] initWithNibName:@"MyCMMainViewController" bundle:nil];
            [self.navigationController pushViewController:pViewController animated:YES];
        }break;
        case 5:
        {
            // 설정
            CMPreferenceMainViewController* controller = [[CMPreferenceMainViewController alloc] initWithNibName:@"CMPreferenceMainViewController" bundle:nil];
            [self.navigationController pushViewController:controller animated:YES];
        }break;
        case 6:
        {
            // 페어링
            //            if ( [[FXKeychain defaultKeychain] objectForKey:CNM_OPEN_API_UUID_KEY]  != NULL )
            CMDBDataManager* manager= [CMDBDataManager sharedInstance];
            
            if ( [manager getPairingCheck] == YES )
            {
                PairingRePwViewController *controller = [[PairingRePwViewController alloc] initWithNibName:@"PairingRePwViewController" bundle:nil];
                controller.delegate = self;
                [self.navigationController pushViewController:controller animated:YES];
            }
            else
            {
                PairingMainViewController *controller = [[PairingMainViewController alloc] initWithNibName:@"PairingMainViewController" bundle:nil];
                controller.delegate = self;
                [self.navigationController pushViewController:controller animated:YES];
                
            }
            
        }break;
            //        case 6://임시
            //        {
            //            // 검색
            //            CMSearchMainViewController* controller = [[CMSearchMainViewController alloc] initWithNibName:@"CMSearchMainViewController" bundle:nil];
            //            [self.navigationController pushViewController:controller animated:YES];
            //            
            //        }break;
    }
}

#pragma mark - MainPopUpViewController 델리게이트
- (void)MainPopUpViewWithBtnData:(NSDictionary *)dataDic WithViewTag:(int)viewTag
{
    [self bodySubViewsRemove];
    
    switch (viewTag) {
        case MOVIE_MAIN_VIEW_BTN_01:
        {
            MovieMainViewController *pViewController = [[MovieMainViewController alloc] initWithNibName:@"MovieMainViewController" bundle:nil];
            pViewController.delegate = self;
            pViewController.pDataDic = dataDic;
            pViewController.view.frame = CGRectMake(0, 0, self.pBodyView.frame.size.width, self.pBodyView.frame.size.height);
            [self addChildViewController:pViewController];
            [pViewController didMoveToParentViewController:self];
            [self.pBodyView addSubview:pViewController.view];
        }break;
        case ANI_KIDS_MAIN_VIEW_BTN_01:
        {
            AniKidsMainViewController *pViewController = [[AniKidsMainViewController alloc] initWithNibName:@"AniKidsMainViewController" bundle:nil];
            pViewController.delegate = self;
            pViewController.pDataDic = dataDic;
            pViewController.view.frame = CGRectMake(0, 0, self.pBodyView.frame.size.width, self.pBodyView.frame.size.height);
            [self addChildViewController:pViewController];
            [pViewController didMoveToParentViewController:self];
            [self.pBodyView addSubview:pViewController.view];
        }break;
        case ADULT_MAIN_VIEW_BTN_01:
        {
            AdultMainViewController *pViewController = [[AdultMainViewController alloc] initWithNibName:@"AdultMainViewController" bundle:nil];
            pViewController.delegate = self;
            pViewController.pDataDic = dataDic;
            pViewController.view.frame = CGRectMake(0, 0, self.pBodyView.frame.size.width, self.pBodyView.frame.size.height);
            [self addChildViewController:pViewController];
            [pViewController didMoveToParentViewController:self];
            [self.pBodyView addSubview:pViewController.view];
        }break;
        case TV_REPLAY_VIEW_BTN_01:
        {
            TVReplayViewController *pViewController = [[TVReplayViewController alloc] initWithNibName:@"TVReplayViewController" bundle:nil];
            pViewController.delegate = self;
            pViewController.pDataDic = dataDic;
            pViewController.view.frame = CGRectMake(0, 0, self.pBodyView.frame.size.width, self.pBodyView.frame.size.height);
            [self addChildViewController:pViewController];
            [pViewController didMoveToParentViewController:self];
            [self.pBodyView addSubview:pViewController.view];
            
        }break;
    }
}

#pragma mark - MovieMainViewController 델리게이트
- (void) MovieMainViewWithBtnTag:(int)nTag WithCategoryId:(NSString *)categoryId currentData:(NSDictionary*)dataDic
{
    switch (nTag) {
        case MOVIE_MAIN_VIEW_BTN_01:
        {
            MainPopUpViewController *pViewController = [[MainPopUpViewController alloc] initWithNibName:@"MainPopUpViewController" bundle:nil];
            pViewController.delegate = self;
            pViewController.pCategoryId = categoryId;
            pViewController.selectedDataDic = dataDic;
            //            pViewController.pDataStr = str;
            pViewController.nViewTag = MOVIE_MAIN_VIEW_BTN_01;
            [self addChildViewController:pViewController];
            [pViewController didMoveToParentViewController:self];
            [self.view addSubview:pViewController.view];
        }break;
    }
}


#pragma mark - AniKidsMainViewController 델리게이트
- (void)AniKidsMainViewWithBtnTag:(int)nTag WithCategoryId:(NSString *)categoryId currentData:(NSDictionary*)dataDic
{
    switch (nTag) {
        case ANI_KIDS_MAIN_VIEW_BTN_01:
        {
            MainPopUpViewController *pViewController = [[MainPopUpViewController alloc] initWithNibName:@"MainPopUpViewController" bundle:nil];
            pViewController.delegate = self;
            pViewController.pCategoryId = categoryId;
            pViewController.selectedDataDic = dataDic;
//            pViewController.pDataStr = str;
            pViewController.nViewTag = ANI_KIDS_MAIN_VIEW_BTN_01;
            [self addChildViewController:pViewController];
            [pViewController didMoveToParentViewController:self];
            [self.view addSubview:pViewController.view];
        }break;
    }

}

#pragma mark - AdultMainViewController 델리게이트
- (void)AdultMainViewWithBtnTag:(int)nTag WithCategoryId:(NSString *)categoryId currentData:(NSDictionary*)dataDic
{
    switch (nTag) {
        case ADULT_MAIN_VIEW_BTN_01:
        {
            MainPopUpViewController *pViewController = [[MainPopUpViewController alloc] initWithNibName:@"MainPopUpViewController" bundle:nil];
            pViewController.delegate = self;
            pViewController.pCategoryId = categoryId;
            pViewController.selectedDataDic = dataDic;
//            pViewController.pDataStr = str;
            pViewController.nViewTag = ADULT_MAIN_VIEW_BTN_01;
            [self addChildViewController:pViewController];
            [pViewController didMoveToParentViewController:self];
            [self.view addSubview:pViewController.view];
        }break;
    }
}

#pragma mark - TVReplayMainViewController 델리게이트
- (void)TVReplayViewWithBtnTag:(int)nTag withCategoryId:(NSString *)categoryId currentData:(NSDictionary*)dataDic
{
    MainPopUpViewController *pViewController = [[MainPopUpViewController alloc] initWithNibName:@"MainPopUpViewController" bundle:nil];
    pViewController.delegate = self;
    pViewController.pCategoryId = categoryId;
    pViewController.selectedDataDic = dataDic;
    //            pViewController.pDataStr = str;
    pViewController.nViewTag = TV_REPLAY_VIEW_BTN_01;
    [self addChildViewController:pViewController];
    [pViewController didMoveToParentViewController:self];
    [self.view addSubview:pViewController.view];
}

#pragma mark - RecommendMainViewController 델리게이트
- (void)RecommendMainViewWithTag:(int)nTag
{
    switch (nTag) {
        case VOD_BUY_VIEW_BTN_08:
        {
            VodPopUpViewController *pViewController = [[VodPopUpViewController alloc] initWithNibName:@"VodPopUpViewController" bundle:nil];
            pViewController.view.frame = CGRectMake(0, 0, self.pBodyView.frame.size.width, self.pBodyView.frame.size.height);
            [self addChildViewController:pViewController];
            [pViewController didMoveToParentViewController:self];
            [self.pBodyView addSubview:pViewController.view];
            
        }break;
    }
}

- (void)RecommendMainViewWithTag:(int)nTag WithCategoryId:(NSString *)categoryId WithViewerType:(NSString *)viewerType WithTitleName:(NSString *)titleName
{
    [self.pGnbViewController.pMenu01 setTitleColor:[UIColor colorWithRed:195.0f/255.0f green:174.0f/255.0f blue:220.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
    [self.pGnbViewController.pMenu02 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.pGnbViewController.pMenu03 setTitleColor:[UIColor colorWithRed:195.0f/255.0f green:174.0f/255.0f blue:220.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
    [self.pGnbViewController.pMenu04 setTitleColor:[UIColor colorWithRed:195.0f/255.0f green:174.0f/255.0f blue:220.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
    [self.pGnbViewController.pMenu05 setTitleColor:[UIColor colorWithRed:195.0f/255.0f green:174.0f/255.0f blue:220.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
    
    [self bodySubViewsRemove];
    
    switch (nTag) {
        case RECOMMEND_MAIN_VIEW_BTN_01:
        {
            // 인기순위 TOP20
            MovieMainViewController *pViewController = [[MovieMainViewController alloc] initWithNibName:@"MovieMainViewController" bundle:nil];
            pViewController.delegate = self;
            pViewController.pDataDic = nil;
            pViewController.sRotCategoryId = categoryId;
            pViewController.sRotViewerType = viewerType;
            pViewController.sRotTitleName = titleName;
            pViewController.view.frame = CGRectMake(0, 0, self.pBodyView.frame.size.width, self.pBodyView.frame.size.height);
            [self addChildViewController:pViewController];
            [pViewController didMoveToParentViewController:self];
            [self.pBodyView addSubview:pViewController.view];
        }break;
        case RECOMMEND_MAIN_VIEW_BTN_02:
        {
            // 금주의 신작영화
            MovieMainViewController *pViewController = [[MovieMainViewController alloc] initWithNibName:@"MovieMainViewController" bundle:nil];
            pViewController.delegate = self;
            pViewController.pDataDic = nil;
            pViewController.sRotCategoryId = categoryId;
            pViewController.sRotViewerType = viewerType;
            pViewController.sRotTitleName = titleName;
            pViewController.view.frame = CGRectMake(0, 0, self.pBodyView.frame.size.width, self.pBodyView.frame.size.height);
            [self addChildViewController:pViewController];
            [pViewController didMoveToParentViewController:self];
            [self.pBodyView addSubview:pViewController.view];
        }break;
        case RECOMMEND_MAIN_VIEW_BTN_03:
        {
            // 이달의 추천
            MovieMainViewController *pViewController = [[MovieMainViewController alloc] initWithNibName:@"MovieMainViewController" bundle:nil];
            pViewController.delegate = self;
            pViewController.pDataDic = nil;
            pViewController.sRotCategoryId = categoryId;
            pViewController.sRotViewerType = viewerType;
            pViewController.sRotTitleName = titleName;
            pViewController.view.frame = CGRectMake(0, 0, self.pBodyView.frame.size.width, self.pBodyView.frame.size.height);
            [self addChildViewController:pViewController];
            [pViewController didMoveToParentViewController:self];
            [self.pBodyView addSubview:pViewController.view];
        }break;
    }
}

#pragma mark - PairingMainViewController 델리게이트
- (void)PairingMainViewWithTag:(int)nTag
{
    switch (nTag) {
        case PAIRING_FINISH_VIEW_BTN_01:
        {
            // 메인 리로딩
            [self onHomeGnbViewMenuList:HOME_GNB_VIEW_BTN_03];
        }break;
    }
}

#pragma mark - PairingRePwViewController 델리게이트
- (void)PairingRePwViewWithTag:(int)nTag
{
    switch (nTag) {
        case PAIRING_FINISH_VIEW_BTN_01:
        {
            // 메인 리로딩
            [self onHomeGnbViewMenuList:HOME_GNB_VIEW_BTN_03];
        }break;
    }
}

@end
