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
}

#pragma mark - 초기화
#pragma mark - 화면초기화
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
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
}

@end
