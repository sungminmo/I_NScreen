//
//  MyCMMainViewController.m
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 9. 16..
//  Copyright (c) 2015년 STVN. All rights reserved.
//

#import "MyCMMainViewController.h"

@interface MyCMMainViewController ()

@end

@implementation MyCMMainViewController

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setTagInit];
}

#pragma mark - 초기화
#pragma mark - 화면 태그값 초기화
- (void)setTagInit
{
    self.pBackBtn.tag = MY_CM_MAIN_VIEW_BTN_01;
    self.pTapBtn01.tag = MY_CM_MAIN_VIEW_BTN_02;
    self.pTapBtn02.tag = MY_CM_MAIN_VIEW_BTN_03;
    self.pTapBtn03.tag = MY_CM_MAIN_VIEW_BTN_04;
}

#pragma mark - 액션 이벤트
#pragma mark - 버튼 클릭 이벤트
- (IBAction)onBtnClick:(UIButton *)btn
{
    switch (btn.tag) {
        case MY_CM_MAIN_VIEW_BTN_01:
        {
            // back
            [self.navigationController popViewControllerAnimated:YES];
            
        }break;
        case MY_CM_MAIN_VIEW_BTN_02:
        {
            // vod 찜목록
            [self.pTapBtn01 setBackgroundImage:[UIImage imageNamed:@"3btn_select.png"] forState:UIControlStateNormal];
            [self.pTapBtn02 setBackgroundImage:[UIImage imageNamed:@"3btn_normal.png"] forState:UIControlStateNormal];
            [self.pTapBtn03 setBackgroundImage:[UIImage imageNamed:@"3btn_normal.png"] forState:UIControlStateNormal];
            
            [self.pTapBtn01 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.pTapBtn02 setTitleColor:[UIColor colorWithRed:123.0f/255.0f green:90.0f/255.0f blue:163.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
            [self.pTapBtn03 setTitleColor:[UIColor colorWithRed:123.0f/255.0f green:90.0f/255.0f blue:163.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
            
        }break;
        case MY_CM_MAIN_VIEW_BTN_03:
        {
            // vod 시청목록
            [self.pTapBtn01 setBackgroundImage:[UIImage imageNamed:@"3btn_normal.png"] forState:UIControlStateNormal];
            [self.pTapBtn02 setBackgroundImage:[UIImage imageNamed:@"3btn_select.png"] forState:UIControlStateNormal];
            [self.pTapBtn03 setBackgroundImage:[UIImage imageNamed:@"3btn_normal.png"] forState:UIControlStateNormal];
            
            [self.pTapBtn01 setTitleColor:[UIColor colorWithRed:123.0f/255.0f green:90.0f/255.0f blue:163.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
            [self.pTapBtn02 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.pTapBtn03 setTitleColor:[UIColor colorWithRed:123.0f/255.0f green:90.0f/255.0f blue:163.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];

        }break;
        case MY_CM_MAIN_VIEW_BTN_04:
        {
            // vod 구매목록
            [self.pTapBtn01 setBackgroundImage:[UIImage imageNamed:@"3btn_normal.png"] forState:UIControlStateNormal];
            [self.pTapBtn02 setBackgroundImage:[UIImage imageNamed:@"3btn_normal.png"] forState:UIControlStateNormal];
            [self.pTapBtn03 setBackgroundImage:[UIImage imageNamed:@"3btn_select.png"] forState:UIControlStateNormal];
            
            [self.pTapBtn01 setTitleColor:[UIColor colorWithRed:123.0f/255.0f green:90.0f/255.0f blue:163.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
            [self.pTapBtn02 setTitleColor:[UIColor colorWithRed:123.0f/255.0f green:90.0f/255.0f blue:163.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
            [self.pTapBtn03 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
        }break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *pCellIn = @"MyCMZimListTableViewCell";
    
    MyCMZimListTableViewCell *pCell = (MyCMZimListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:pCellIn];
    
    if (pCell == nil)
    {
        NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"MyCMZimListTableViewCell" owner:nil options:nil];
        pCell = [arr objectAtIndex:0];
    }
    
    [pCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    [pCell setListData:nil WithIndex:(int)indexPath.row];
    
    return pCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    EpgSubViewController *pViewController = [[EpgSubViewController alloc] initWithNibName:@"EpgSubViewController" bundle:nil];
    //    [self.navigationController pushViewController:pViewController animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 66;
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

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSLog(@"delete");
    }
}

@end
