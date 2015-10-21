//
//  TestMainViewController.h
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 10. 21..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TestMainViewController : UIViewController

@property (nonatomic, strong) IBOutlet UIScrollView *pMainScrollView;

// 배너
@property (nonatomic, strong) IBOutlet UIView *pBannerView;

// 인기순위
@property (nonatomic, strong) IBOutlet UIView *pPopularityView;

// 금주의 신작영화
@property (nonatomic, strong) IBOutlet UIView *pNewWorkView;

// 이달의 추천 VOD
@property (nonatomic, strong) IBOutlet UIView *pRecommendView;

@end
