//
//  NSMutableDictionary+Preference.h
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 11. 12..
//  Copyright © 2015년 STVN. All rights reserved.
//
/*/================================================================================================
 NScreen - 설정
 ================================================================================================/*/

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (Preference)

// 유료체널 리스트 정보
+ (NSURLSessionDataTask *)preferenceGetServiceJoinNListCompletion:(void (^)(NSArray *preference, NSError *error))block;

// 특정 유료체널 상세 정보
+ (NSURLSessionDataTask *)preferenceGetServiceJoinNInfoCompletion:(void (^)(NSArray *preference, NSError *error))block;

// 공지사항 리스트 및 상세 정보 ex)areaCode = 0 , productCode = 11
+ (NSURLSessionDataTask *)perferenceGetServiceNoticeInfoWithAreaCode:(NSString *)areaCode WithProductCode:(NSString *)productCode completion:(void (^)(NSArray *preference, NSError *error))block;


@end
