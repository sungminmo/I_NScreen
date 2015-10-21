//
//  TestMainViewController.m
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 10. 21..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import "TestMainViewController.h"

@interface TestMainViewController ()

@end

@implementation TestMainViewController

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setViewInit];
}

#pragma mark - 초기화
#pragma mark - 화면초기화
- (void)setViewInit
{
    [self.pMainScrollView addSubview:self.pBannerView];
    [self.pMainScrollView addSubview:self.pPopularityView];
    [self.pMainScrollView addSubview:self.pNewWorkView];
    [self.pMainScrollView addSubview:self.pRecommendView];
    
    self.pBannerView.frame = CGRectMake(0, 0, self.pBannerView.frame.size.width, self.pBannerView.frame.size.height);
    self.pPopularityView.frame = CGRectMake(0, self.pBannerView.frame.size.height + self.pBannerView.frame.origin.y, self.pPopularityView.frame.size.width, self.pPopularityView.frame.size.height);
    self.pNewWorkView.frame = CGRectMake(0, self.pPopularityView.frame.origin.y + self.pPopularityView.frame.size.height, self.pNewWorkView.frame.size.width, self.pNewWorkView.frame.size.height);
    self.pRecommendView.frame = CGRectMake(0, self.pNewWorkView.frame.origin.y + self.pNewWorkView.frame.size.height, self.pRecommendView.frame.size.width, self.pRecommendView.frame.size.height);
    
    int nHeight = self.pBannerView.frame.size.height + self.pPopularityView.frame.size.height + self.pNewWorkView.frame.size.height + self.pRecommendView.frame.size.height;
    
    [self.pMainScrollView setContentSize:CGSizeMake(self.pMainScrollView.frame.size.width, nHeight)];
}

@end
