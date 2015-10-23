//
//  AniKidsMainViewController.m
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 10. 12..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import "AniKidsMainViewController.h"

@interface AniKidsMainViewController ()

@end

@implementation AniKidsMainViewController

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setTagInit];
    [self setViewInit];
}

#pragma mark - 초기화
#pragma mark - 테그 초기화
- (void)setTagInit
{
    
}

#pragma mark - 화면 초기화
- (void)setViewInit
{
    // 초기 인기 순위화면이 default
    self.pPopularView.hidden = NO;
    self.pElseView.hidden = YES;
}

#pragma mark - 액션이벤트
#pragma mark - 버튼 액션 이벤트
- (IBAction)onBtnClicked:(UIButton *)btn
{
    
}

@end
