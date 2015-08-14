//
//  NetWorkPoolCtrl.h
//  HanaNWallet2
//
//  Created by 이창열 on 13. 8. 1..
//  Copyright (c) 2013년 nWalletTeam-이창열. All rights reserved.
//

/*/================================================================================================
 하나N월렛 - 통신을 관리하기 위한 Pool 컨트롤 클래스
 ================================================================================================/*/

#import <Foundation/Foundation.h>
#import "NetWorkCtrl.h"
#import "TransactionData.h"

@protocol NetWorkPoolCtrlDelegate;

@interface NetWorkPoolCtrl : NSObject <NetWorkCtrlDelegate>
{
    id<NetWorkPoolCtrlDelegate> delegate;
 
    NetWorkCtrl         *m_pNetWorkCtrl[20];
    int                 m_nExecuteCount;
}

@property (nonatomic, assign) id<NetWorkPoolCtrlDelegate> delegate;

// 초기화
- (id)init;
// 해제
- (void)dealloc;
// 외부에서 전문 요청 데이터를 넘김
- (void)requestWithData:(TransactionData *)pData;

@end



@protocol NetWorkPoolCtrlDelegate<NSObject>;

@optional
// 전문이 정상적으로 처리가 되었을때 일어나는 콜백함수
- (void)ResponeFinish:(int)nTrCode;
// 전문이 실패했을때 일어나는 콜백함수
- (void)ResponeError:(int)nTrCode;
@end
