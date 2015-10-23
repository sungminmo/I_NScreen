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
    self.pPopularBtn.tag = ANI_KIDS_MAIN_VIEW_BTN_01;
    self.pRealTimePopularBtn.tag = ANI_KIDS_MAIN_VIEW_BTN_02;
    self.pWeekPopularBtn.tag = ANI_KIDS_MAIN_VIEW_BTN_03;
    self.pElseBtn.tag = ANI_KIDS_MAIN_VIEW_BTN_04;
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
    switch ([btn tag]) {
        case ANI_KIDS_MAIN_VIEW_BTN_01:
        {
            // 인기 순위 버튼
            
        }break;
        case ANI_KIDS_MAIN_VIEW_BTN_02:
        {
            // 실시간 인기 순위 버튼
            
        }break;
        case ANI_KIDS_MAIN_VIEW_BTN_03:
        {
            // 주간 인기 순위 버튼
            
        }break;
        case ANI_KIDS_MAIN_VIEW_BTN_04:
        {
            // 그외 순위 버튼
            
        }break;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 인기순위 일때 pPopularView , else pPopularView
    
    static NSString *pCellIn = @"AnikidsMainTableViewCellIn";
    
    AnikidsMainTableViewCell *pCell = (AnikidsMainTableViewCell *)[tableView dequeueReusableCellWithIdentifier:pCellIn];
    
    if (pCell == nil)
    {
        NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"AnikidsMainTableViewCell" owner:nil options:nil];
        pCell = [arr objectAtIndex:0];
    }
    
    [pCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
//    [pCell setListData:nil WithIndex:(int)indexPath.row];
    
    return pCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 24;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

@end
