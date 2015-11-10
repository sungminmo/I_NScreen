//
//  CMPairingInfo.h
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 11. 10..
//  Copyright © 2015년 STVN. All rights reserved.
//
/*/================================================================================================
 NScreen - 페어링정보를 관리하는 클래스
 ================================================================================================/*/

#import <Realm/Realm.h>

@interface CMPairingInfo : RLMObject

@property BOOL isPairing;       // 페어링 유무 체크
@property NSString *sSetTopBoxKind; // 셋탑 박스 종류 HD/SD/PVR

@end
