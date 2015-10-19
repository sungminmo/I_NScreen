//
//  NSMutableDictionary+Network.h
//  I_NScreen
//
//  Created by 조백근 on 2015. 8. 31..
//  Copyright (c) 2015년 STVN. All rights reserved.
//

/**
 *  데이타 모델을 필요하면 (Realm)으로 변경할 예정이지만 기본적으로 딕셔너리를 사용한다.
 *      해당 카테고리에서 통신에 필요한 요청을 기술한다. 
 *      다만, 특별히 일반적인 딕셔너리로 처리하기 어려운 경우 추가적인 카테고리를 생성해서 리퀘스트와 데이타 처리를 기술한다.
 *             아래의 NSMutableDictionary+PROGRAM_SEARCH.h 클래스를 참조하자. 
 */

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (Network)

@end
