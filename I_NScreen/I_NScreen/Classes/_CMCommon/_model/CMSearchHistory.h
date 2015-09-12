//
//  CMSearchHistory.h
//  I_NScreen
//
//  Created by 조백근 on 2015. 9. 1..
//  Copyright (c) 2015년 STVN. All rights reserved.
//

/**
 *  검색내역 
 */

#import <Realm/Realm.h>

@interface CMSearchHistory : RLMObject
/**
 *  검색어
 */
@property NSString *keyword;
/**
 *  검색일자
 */
@property NSDate *searchDate;

@end

// This protocol enables typed collections. i.e.:
// RLMArray<EBZSMMenu>
RLM_ARRAY_TYPE(CMSearchHistory)