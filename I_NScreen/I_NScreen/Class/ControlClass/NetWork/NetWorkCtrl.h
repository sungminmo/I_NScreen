//
//  NetWorkCtrl.h
//  WaitingNumber
//
//  Created by Chang Youl Lee on 12. 4. 4..
//  Copyright (c) 2012년 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DefineData.h"
#import "TransactionData.h"
#import "DataManager.h"

@protocol NetWorkCtrlDelegate;

@interface NetWorkCtrl : NSObject
{
    id<NetWorkCtrlDelegate> delegate;
    
    // 서버로 전문을 전송하기 위해서 사용되는 패킷
//    NSMutableData   *recvData;
    
    NSMutableArray  *responseDataArr;
    NSMutableDictionary  *responseDataDic;
    
    // 전문 헤더 정의
    int             m_nTrCode;
    
    // 풀링에 사용될 데이터
    int             m_nTagCode;
    BOOL            m_bFinishCheck;
}

@property (nonatomic, assign) id<NetWorkCtrlDelegate> delegate;

// 초기화
- (id)init;
// 해제
- (void)dealloc;
// 외부에서 전문 요청 데이터를 넘김
- (void)requestWithData:(TransactionData *)pData;

// 풀링에 사용할 데이터
- (void)SetTag:(int)nTag;
- (int)GetTag;
- (void)SetFinish:(BOOL)nFinish;
- (BOOL)GetFinish;

@end



@protocol NetWorkCtrlDelegate<NSObject>;

@optional
// 전문이 정상적으로 처리가 되었을때 일어나는 콜백함수
- (void)ResponeFinish:(int)nTrCode netwrokID:(int)netID;
// 전문이 실패했을때 일어나는 콜백함수
- (void)ResponeError:(int)nTrCode netwrokID:(int)netID;
@end


