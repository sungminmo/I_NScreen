//
//  RecommendMainViewController.h
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 10. 12..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMBaseViewController.h"
#import "CMPageViewController.h"
#import "CategoryTableViewCell.h"
#import "BannerTableViewCell.h"
#import "CMPageCollectionViewController.h"
#import "TestPageViewController.h"
#import "VodDetailMainViewController.h"
#import "CMPreferenceMainViewController.h"

// 화면 타입
typedef enum : NSInteger {
    TrinfoPopularity = 100000,
    TrinfoNewWork,
    TrinfoRecommend
}TrinfoType;

@protocol RecommendMainViewDelegate;

@interface RecommendMainViewController : CMBaseViewController<UIScrollViewDelegate, CMPageViewDelegate, CMPageCollectionViewDelegate, VodDetailMainViewDelegate>

@property (nonatomic, strong) IBOutlet UIScrollView *pMainScrollView;

// 배너
@property (nonatomic, strong) IBOutlet UIView *pBannerView;
@property (nonatomic, strong) IBOutlet UIScrollView *pBannerScrollView;
@property (nonatomic, strong) IBOutlet UIPageControl *pBannerPgControl;

// 인기순위
@property (nonatomic, strong) IBOutlet UIView *pPopularityView;
@property (nonatomic, strong) IBOutlet UIScrollView *pPopularityScrollView;
@property (nonatomic, strong) IBOutlet UIPageControl *pPopularityPgControl;
@property (nonatomic, strong) IBOutlet UIButton *pMorePopulariryBtn;
@property (nonatomic, strong) IBOutlet UILabel *pPopularityTitleLbl;

// 금주의 신작영화
@property (nonatomic, strong) IBOutlet UIView *pNewWorkView;
@property (nonatomic, strong) IBOutlet UIScrollView *pNewWorkScrollView;
@property (nonatomic, strong) IBOutlet UIPageControl *pNewWorkPgControl;
@property (nonatomic, strong) IBOutlet UIButton *pMoreNewWorkBtn;
@property (nonatomic, strong) IBOutlet UILabel *pNewWorkLbl;

// 이달의 추천 VOD
@property (nonatomic, strong) IBOutlet UIView *pRecommendView;
@property (nonatomic, strong) IBOutlet UIScrollView *pRecommendScrollView;
@property (nonatomic, strong) IBOutlet UIPageControl *pRecommendPgControl;
@property (nonatomic, strong) IBOutlet UIButton *pMoreRecommendBtn;
@property (nonatomic, strong) IBOutlet UILabel *pRecommendLbl;

@property (nonatomic, weak) id <RecommendMainViewDelegate>delegate;

- (IBAction)onBtnClicked:(UIButton *)btn;

@end

@protocol RecommendMainViewDelegate <NSObject>

@optional
- (void)RecommendMainViewWithTag:(int)nTag; // 더보기 갱신

@end