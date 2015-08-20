//
//  RootViewController.h
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 8. 12..
//  Copyright (c) 2015년 JUNG KIL BAE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetWorkPoolCtrl.h"

@interface RootViewController : UIViewController<NetWorkPoolCtrlDelegate>
{
    // 통신 처리를 위한 클래스 생성
    NetWorkPoolCtrl                 *m_pNetWorkCtrl;        // 네트워크 컨트롤 처리
    TransactionData                 *m_pData;                 // 전문 데이타
}

@end
