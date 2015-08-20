//
//  RootViewController.m
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 8. 12..
//  Copyright (c) 2015년 JUNG KIL BAE. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // 네트워크 클래스를 생성한다.
    m_pNetWorkCtrl = [[NetWorkPoolCtrl alloc] init];
    m_pNetWorkCtrl.delegate = self;


    [self requestWithData:TRINFO_TEST];
}

#pragma mark -
#pragma mark - 전문
- (void)requestWithData:(int)nTRCode
{
    m_pData = [[TransactionData alloc] init];
    m_pData.nTrCode = nTRCode;
    
//    [[DataManager getInstance].p_gUserClass showLoading:YES];
    
    switch (nTRCode) {
        case TRINFO_TEST:
        {
            
            
        }break;
    }
    
    [m_pNetWorkCtrl requestWithData:m_pData];
}

#pragma mark - 전문 response
#pragma mark -전문처리후 콜백처리되는 함수
- (void)ResponeFinish:(int)nTrCode
{
//    [[DataManager getInstance].p_gUserClass showLoading:NO];
    
    switch (nTrCode) {
        case TRINFO_TEST:
        {
            
        }break;
    }
}

#pragma mark -전문처리가 실패했을 경우 발생하는 이벤트
- (void)ResponeError:(int)nTrCode
{
//    [[DataManager getInstance].p_gUserClass showLoading:NO];
    
    switch (nTrCode) {
        case TRINFO_TEST:
        {
            
        }break;
    }
}



@end
