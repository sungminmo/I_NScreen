//
//  PopularProgramMainViewController.m
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 10. 12..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import "PopularProgramMainViewController.h"

@interface PopularProgramMainViewController ()

@end

@implementation PopularProgramMainViewController

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
    [self.pMainScrollView addSubview:self.pPopularView];
    
    self.pPopularView.frame = CGRectMake(0, 0, self.pPopularView.frame.size.width, self.pPopularView.frame.size.height);
}

#pragma mark - 액션이벤트
#pragma mark - 버튼 액션 이벤트
- (IBAction)onBtnClicked:(UIButton *)btn
{
    
}

@end
