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
+ (NSURLSessionDataTask *)preferenceGetServiceJoyNListCompletion:(void (^)(NSArray *preference, NSError *error))block;

// 특정 유료체널 상세 정보
+ (NSURLSessionDataTask *)preferenceGetServiceJoyNInfoCode:(NSString*)code completion:(void (^)(NSArray *preference, NSError *error))block;

// 공지사항 리스트 및 상세 정보 ex)areaCode = 0 , productCode = 11
+ (NSURLSessionDataTask *)perferenceGetServiceNoticeInfoCompletion:(void (^)(NSArray *preference, NSError *error))block;

//서비스 이용약관 및 공지사항 안내
//guideID = 1은 서비스이용약관
//guideID = 2은 고객센터 안내
+ (NSURLSessionDataTask *)perferenceGetServiceguideInfoWithCode:(NSString*)code completion:(void (^)(NSArray *preference, NSError *error))block;

//버전정보
+ (NSURLSessionDataTask *)perferenceGetAppVersionInfoCompletion:(void (^)(NSArray *preference, NSError *error))block;



@end
