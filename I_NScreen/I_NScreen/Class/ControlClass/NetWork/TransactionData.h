//
//  TransactionData.h
//  SHBWaitingNumber
//
//  Created by Chang Youl Lee on 12. 4. 12..
//  Copyright (c) 2012년 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 전문을 전송할때 공통으로 사용될 구조를 사용해서 네트웍에 넘겨주기 위해서 NSObject를 사용해서 클래스화 시켰음
 전문해더, 전문 바디를 구성할수있고 바디는 Dictionary, Array 두가지 형을 다 지원한다.
 */

@interface TransactionData : NSObject
{
    id instance;
    
    // 전문 코드
	int             nTrCode;
    
    // 공용으로 사용될 Dictionary
    NSMutableDictionary *p_RequestDic;
    // 공용으로 사용될 Array
    NSMutableArray      *p_RequestArray;
}

@property (nonatomic, retain) id instance;
@property (nonatomic, assign) int nTrCode;
@property (nonatomic, retain) NSMutableDictionary   *p_RequestDic;
@property (nonatomic, retain) NSMutableArray        *p_RequestArray;

@end
