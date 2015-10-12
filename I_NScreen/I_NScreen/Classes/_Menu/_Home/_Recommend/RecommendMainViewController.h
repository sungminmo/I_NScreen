//
//  RecommendMainViewController.h
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 10. 12..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMBaseViewController.h"

@interface RecommendMainViewController : CMBaseViewController

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

// 금주의 신작영화
@property (nonatomic, strong) IBOutlet UIView *pNewWorkView;
@property (nonatomic, strong) IBOutlet UIScrollView *pNewWorkScrollView;
@property (nonatomic, strong) IBOutlet UIPageControl *pNewWorkPgControl;
@property (nonatomic, strong) IBOutlet UIButton *pMoreNewWorkBtn;

// 이달의 추천 VOD
@property (nonatomic, strong) IBOutlet UIView *pRecommendView;
@property (nonatomic, strong) IBOutlet UIScrollView *pRecommendScrollView;
@property (nonatomic, strong) IBOutlet UIPageControl *pRecommendPgControl;
@property (nonatomic, strong) IBOutlet UIButton *pMoreRecommendBtn;

- (IBAction)onBtnClicked:(UIButton *)btn;

@end
