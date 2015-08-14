//
//  NetWorkPoolCtrl.m
//  HanaNWallet2
//
//  Created by 이창열 on 13. 8. 1..
//  Copyright (c) 2013년 nWalletTeam-이창열. All rights reserved.
//

#import "NetWorkPoolCtrl.h"

@implementation NetWorkPoolCtrl

@synthesize delegate;

- (id)init
{
    self = [super init];
    
    m_nExecuteCount = 0;
    
    if (self)
    {
        for (int i = 0 ; i < 20 ; i++)
        {
            m_pNetWorkCtrl[i] = [[NetWorkCtrl alloc] init];
            m_pNetWorkCtrl[i].delegate = self;
            [m_pNetWorkCtrl[i] SetFinish:FALSE];
            [m_pNetWorkCtrl[i] SetTag:i];
        }
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

#pragma mark - 외부에서 전문을 받아서 처리하는 모듈 requestWithData를 기준으로 분기한다.
// 외부에서 전문 요청 데이터를 넘김
- (void)requestWithData:(TransactionData *)pData
{
    NSLog(@"requestWithData m_nExecuteCount count : [%d]", m_nExecuteCount);
    
    for(int i = 0; i < 20 ; i++)
    {
        if([m_pNetWorkCtrl[i] GetFinish] == FALSE)
        {
            [m_pNetWorkCtrl[i] SetFinish:TRUE];
            m_nExecuteCount++;
            [m_pNetWorkCtrl[i] requestWithData:pData];
            break;
        }
    }
}

// 전문이 정상적으로 처리가 되었을때 일어나는 콜백함수
- (void)ResponeFinish:(int)nTrCode netwrokID:(int)netID
{
    m_nExecuteCount = m_nExecuteCount - 1;
    
    NSLog(@"ResponeFinish m_nExecuteCount count : [%d]", m_nExecuteCount);
    
    if(m_nExecuteCount <= 0)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ActivityIndicatorHide" object:nil userInfo:nil];
    }
    
    [m_pNetWorkCtrl[netID] SetFinish:FALSE];
    [delegate ResponeFinish:nTrCode]; }

// 전문이 실패했을때 일어나는 콜백함수
- (void)ResponeError:(int)nTrCode netwrokID:(int)netID
{
    m_nExecuteCount = m_nExecuteCount - 1;

    NSLog(@"ResponeError m_nExecuteCount count : [%d]", m_nExecuteCount);
    
    if(m_nExecuteCount <= 0)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ActivityIndicatorHide" object:nil userInfo:nil];
    }
    
    [m_pNetWorkCtrl[netID] SetFinish:FALSE];
    [delegate ResponeError:nTrCode];
}

@end
