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

@end

@implementation RootViewController
@synthesize delegate;

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Gnb add
    HomeGnbViewController *pGnbViewController = [[HomeGnbViewController alloc] initWithNibName:@"HomeGnbViewController" bundle:nil];
    pGnbViewController.delegate = self;
    [self addChildViewController:pGnbViewController];
    [pGnbViewController didMoveToParentViewController:self];
    [self.pGnbView addSubview:pGnbViewController.view];
    
    // !! test bjk
//    NSURLSessionTask *tesk = [NSMutableDictionary epgGetChannelAreaCompletion:^(NSArray *epgs, NSError *error) {
//        id obj = [epgs valueForKeyPath:@"areaItem"];
//    }];
//
//    [UIAlertView showAlertViewForTaskWithErrorOnCompletion:tesk delegate:nil];
//    [self.refreshControl setRefreshingWithStateOfTask:tesk];
    
//    NSURLSessionDataTask *tesk = [NSMutableDictionary vodGetPopularityChartWithCategoryId:@"713230"
//                                                                         WithRequestItems:@"all"
//                                                                               completion:^(NSArray *vod, NSError *error) {
//                                                                                   id obj = [vod valueForKeyPath:@"weeklyChart"];
//                                                                                   NSLog(@"obj = [%@]", obj);
//                                                                               }];
//    [UIAlertView showAlertViewForTaskWithErrorOnCompletion:tesk delegate:nil];
//    NSURLSessionDataTask *tesk = [NSMutableDictionary epgSearchSearchChannelWithSearchString:@"MBC" WithPageSize:@"3" WithPageIndex:@"0" WithSortType:@"ChannelNoDesc" completion:^(NSArray *epgs, NSError *error) {
//        
//    }];
//
//    [UIAlertView showAlertViewForTaskWithErrorOnCompletion:tesk delegate:nil];
    
    // 추천 add
    RecommendMainViewController *pRecommendViewController = [[RecommendMainViewController alloc] initWithNibName:@"RecommendMainViewController" bundle:nil];
    pRecommendViewController.view.frame = CGRectMake(0, 0, self.pBodyView.frame.size.width, self.pBodyView.frame.size.height);
    pRecommendViewController.delegate = self;
    [self addChildViewController:pRecommendViewController];
    [pRecommendViewController didMoveToParentViewController:self];
    [self.pBodyView addSubview:pRecommendViewController.view];
}


- (void)onHomeGnbViewMenuList:(int)nTag
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
            [self bodySubViewsRemove];
            
            RecommendMainViewController *pViewController = [[RecommendMainViewController alloc] initWithNibName:@"RecommendMainViewController" bundle:nil];
            pViewController.view.frame = CGRectMake(0, 0, self.pBodyView.frame.size.width, self.pBodyView.frame.size.height);
            pViewController.delegate = self;
            [self addChildViewController:pViewController];
            [pViewController didMoveToParentViewController:self];
            [self.pBodyView addSubview:pViewController.view];
            
        }break;
        case HOME_GNB_VIEW_BTN_04:
        {
            // 영화
            [self bodySubViewsRemove];
            
            MovieMainViewController *pViewController = [[MovieMainViewController alloc] initWithNibName:@"MovieMainViewController" bundle:nil];
            pViewController.delegate = self;
            pViewController.pDataDic = nil;
            pViewController.view.frame = CGRectMake(0, 0, self.pBodyView.frame.size.width, self.pBodyView.frame.size.height);
            
            [self addChildViewController:pViewController];
            [pViewController didMoveToParentViewController:self];
            [self.pBodyView addSubview:pViewController.view];
            
        }break;
        case HOME_GNB_VIEW_BTN_05:
        {
            // 애니키즈
            [self bodySubViewsRemove];
            
            AniKidsMainViewController *pViewController = [[AniKidsMainViewController alloc] initWithNibName:@"AniKidsMainViewController" bundle:nil];
            pViewController.delegate = self;
            pViewController.pDataDic = nil;
            pViewController.view.frame = CGRectMake(0, 0, self.pBodyView.frame.size.width, self.pBodyView.frame.size.height);
            
            [self addChildViewController:pViewController];
            [pViewController didMoveToParentViewController:self];
            [self.pBodyView addSubview:pViewController.view];
            
        }break;
        case HOME_GNB_VIEW_BTN_06:
        {
            // TV다시보기
            [self bodySubViewsRemove];
            
            TVReplayViewController *pViewController = [[TVReplayViewController alloc] initWithNibName:@"TVReplayViewController" bundle:nil];
            pViewController.delegate = self;
            pViewController.pDataDic = nil;
            pViewController.view.frame = CGRectMake(0, 0, self.pBodyView.frame.size.width, self.pBodyView.frame.size.height);
            [self addChildViewController:pViewController];
            [pViewController didMoveToParentViewController:self];
            [self.pBodyView addSubview:pViewController.view];
            
        }break;
        case HOME_GNB_VIEW_BTN_07:
        {
            // 성인
            [self bodySubViewsRemove];
            
            AdultMainViewController *pViewController = [[AdultMainViewController alloc] initWithNibName:@"AdultMainViewController" bundle:nil];
            pViewController.delegate = self;
            pViewController.pDataDic = nil;
            pViewController.view.frame = CGRectMake(0, 0, self.pBodyView.frame.size.width, self.pBodyView.frame.size.height);
            [self addChildViewController:pViewController];
            [pViewController didMoveToParentViewController:self];
            [self.pBodyView addSubview:pViewController.view];
            
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
                [self.navigationController pushViewController:controller animated:YES];
            }
            else
            {
                PairingMainViewController *controller = [[PairingMainViewController alloc] initWithNibName:@"PairingMainViewController" bundle:nil];
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

- (void)bodySubViewsRemove
{
    for ( UIView *view in [[[self.view subviews] objectAtIndex:1] subviews] )
    {
        [view removeFromSuperview];
    }
}

#pragma mark - 델리게이트
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
- (void) MovieMainViewWithBtnTag:(int)nTag
{
    switch (nTag) {
        case MOVIE_MAIN_VIEW_BTN_01:
        {
            MainPopUpViewController *pViewController = [[MainPopUpViewController alloc] initWithNibName:@"MainPopUpViewController" bundle:nil];
            pViewController.delegate = self;
            //            pViewController.pDataStr = str;
            pViewController.nViewTag = MOVIE_MAIN_VIEW_BTN_01;
            [self addChildViewController:pViewController];
            [pViewController didMoveToParentViewController:self];
            [self.view addSubview:pViewController.view];
        }break;
    }
}


#pragma mark - AniKidsMainViewController 델리게이트
- (void)AniKidsMainViewWithBtnTag:(int)nTag
{
    switch (nTag) {
        case ANI_KIDS_MAIN_VIEW_BTN_01:
        {
            MainPopUpViewController *pViewController = [[MainPopUpViewController alloc] initWithNibName:@"MainPopUpViewController" bundle:nil];
            pViewController.delegate = self;
//            pViewController.pDataStr = str;
            pViewController.nViewTag = ANI_KIDS_MAIN_VIEW_BTN_01;
            [self addChildViewController:pViewController];
            [pViewController didMoveToParentViewController:self];
            [self.view addSubview:pViewController.view];
        }break;
    }

}

#pragma mark - AdultMainViewController 델리게이트
- (void)AdultMainViewWithBtnTag:(int)nTag
{
    switch (nTag) {
        case ADULT_MAIN_VIEW_BTN_01:
        {
            MainPopUpViewController *pViewController = [[MainPopUpViewController alloc] initWithNibName:@"MainPopUpViewController" bundle:nil];
            pViewController.delegate = self;
//            pViewController.pDataStr = str;
            pViewController.nViewTag = ADULT_MAIN_VIEW_BTN_01;
            [self addChildViewController:pViewController];
            [pViewController didMoveToParentViewController:self];
            [self.view addSubview:pViewController.view];
        }break;
    }
}

#pragma mark - TVReplayMainViewController 델리게이트
- (void)TVReplayViewWithBtnTag:(int)nTag
{
    switch (nTag) {
        case TV_REPLAY_VIEW_BTN_01:
        {
            MainPopUpViewController *pViewController = [[MainPopUpViewController alloc] initWithNibName:@"MainPopUpViewController" bundle:nil];
            pViewController.delegate = self;
//            pViewController.pDataStr = str;
            pViewController.nViewTag = TV_REPLAY_VIEW_BTN_01;
            [self addChildViewController:pViewController];
            [pViewController didMoveToParentViewController:self];
            [self.view addSubview:pViewController.view];

        }break;
    }
}

#pragma mark - RecommendMainViewController 델리게이트
- (void)RecommendMainViewWithTag:(int)nTag
{
    
}

@end
