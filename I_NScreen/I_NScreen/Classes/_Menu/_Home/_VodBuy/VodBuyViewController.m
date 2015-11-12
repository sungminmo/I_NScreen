//
//  VodBuyViewController.m
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 11. 11..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import "VodBuyViewController.h"

@interface VodBuyViewController ()

@end

@implementation VodBuyViewController

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTagInit];
    [self setViewInit];
}


#pragma mark - 초기화
#pragma mark - 태그 초기화
- (void)setTagInit
{
    self.pStep1SubView02Btn.tag = VOD_BUY_VIEW_BTN_01;
    self.pStep1SubView03Btn.tag = VOD_BUY_VIEW_BTN_02;
    self.pStep1SubView04Btn.tag = VOD_BUY_VIEW_BTN_03;
    
    self.pStep2SubView02Btn.tag = VOD_BUY_VIEW_BTN_04;
    self.pStep2SubView03Btn.tag = VOD_BUY_VIEW_BTN_05;
    self.pStep2SubView04Btn.tag = VOD_BUY_VIEW_BTN_06;
    
    self.pCancelBtn.tag = VOD_BUY_VIEW_BTN_07;
    self.pOkBtn.tag = VOD_BUY_VIEW_BTN_08;
}

#pragma mark - 화면 초기화
- (void)setViewInit
{
    self.title = @"상세정보";
    self.isUseNavigationBar = YES;
    self.scrollContainer.contentSize = CGSizeMake(self.view.bounds.size.width, 642);
}

#pragma mark - 액션 이벤트
#pragma mark - 버튼 액션 이벤트
- (IBAction)onBtnClicked:(UIButton *)btn
{
    switch ([btn tag]) {
        case VOD_BUY_VIEW_BTN_01:
        {
            
        }break;
        case VOD_BUY_VIEW_BTN_02:
        {
            
        }break;
        case VOD_BUY_VIEW_BTN_03:
        {
            
        }break;
        case VOD_BUY_VIEW_BTN_04:
        {
            
        }break;
        case VOD_BUY_VIEW_BTN_05:
        {
            
        }break;
        case VOD_BUY_VIEW_BTN_06:
        {
            
        }break;
        case VOD_BUY_VIEW_BTN_07:
        {
            
        }break;
        case VOD_BUY_VIEW_BTN_08:
        {
            
        }break;
    }
}

@end
