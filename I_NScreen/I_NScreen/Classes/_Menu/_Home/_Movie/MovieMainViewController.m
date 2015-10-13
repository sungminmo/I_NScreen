//
//  MovieMainViewController.m
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 10. 12..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import "MovieMainViewController.h"

@interface MovieMainViewController ()

@end

@implementation MovieMainViewController
@synthesize delegate;

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
#pragma mark - 버튼 태그 초기화
- (void) setTagInit
{
    self.pListBtn.tag = MOVIE_MAIN_VIEW_BTN_01;
}

#pragma mark - 화면 초기화
- (void) setViewInit
{
    [self.pScrollView addSubview:self.pView01];
    [self.pScrollView addSubview:self.pView02];
    
    self.pView01.frame = CGRectMake(0, 0, self.pView01.frame.size.width, self.pView01.frame.size.height);
    self.pView02.frame = CGRectMake(0, self.pView01.frame.origin.y + self.pView01.frame.size.height, self.pView02.frame.size.width, self.pView02.frame.size.height);
    
    int nHeight = self.pView01.frame.size.height + self.pView02.frame.size.height;
    
    [self.pScrollView setContentSize:CGSizeMake(self.pScrollView.frame.size.width, nHeight)];
}

#pragma mark - 액션 이벤트
#pragma mark - 버튼 액션 이벤트
- (IBAction)onBtnClicked:(UIButton *)btn
{
    switch ([btn tag]) {
        case MOVIE_MAIN_VIEW_BTN_01:
        {
            [self.delegate MovieMainViewWithBtnTag:MOVIE_MAIN_VIEW_BTN_01];
        }break;
    }
}

@end
