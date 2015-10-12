//
//  AdultMainViewController.m
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 10. 12..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import "AdultMainViewController.h"

@interface AdultMainViewController ()

@end

@implementation AdultMainViewController

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
#pragma mark - 태그 초기화
- (void)setTagInit
{
    
}

#pragma mark - 화면 초기화
- (void)setViewInit
{
    [self.pMainScrollView addSubview:self.pAdultView];

    self.pAdultView.frame = CGRectMake(0, 0, self.pAdultView.frame.size.width, self.pAdultView.frame.size.height);
    
    int nHeight = self.pAdultView.frame.size.height;
    
    [self.pMainScrollView setContentSize:CGSizeMake(self.pMainScrollView.frame.size
                                                    .width, nHeight)];
}

#pragma mark - 액션 이벤트
#pragma mark - 버튼 액션 이벤트
- (IBAction)onBtnClicked:(UIButton *)btn
{
    
}

@end
