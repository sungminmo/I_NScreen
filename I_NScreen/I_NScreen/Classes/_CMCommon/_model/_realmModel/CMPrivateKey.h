//
//  CMPrivateKey.h
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 11. 10..
//  Copyright © 2015년 STVN. All rights reserved.
//
/*/================================================================================================
 NScreen - 프라이빗 터미널 키를 관리하는 클래스
 ================================================================================================/*/

#import <Realm/Realm.h>

@interface CMPrivateKey : RLMObject

@property NSString* authPrivateTerminalKey; // 프라이빗 터미널 키

@end
