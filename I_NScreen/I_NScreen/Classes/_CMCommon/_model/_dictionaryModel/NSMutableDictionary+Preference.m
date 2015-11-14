//
//  NSMutableDictionary+Preference.m
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 11. 12..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import "NSMutableDictionary+Preference.h"

@implementation NSMutableDictionary (Preference)

// 유료체널 리스트 정보
+ (NSURLSessionDataTask *)preferenceGetServiceJoyNListCompletion:(void (^)(NSArray *preference, NSError *error))block
{
    return [[CMNetworkManager sharedInstance] preferenceGetServiceJoyNListCompletion:block];
}

// 특정 유료체널 상세 정보
+ (NSURLSessionDataTask *)preferenceGetServiceJoyNInfoCode:(NSString*)code completion:(void (^)(NSArray *preference, NSError *error))block
{
    return [[CMNetworkManager sharedInstance] preferenceGetServiceJoyNInfoCode:code completion:block];
}

// 공지사항 리스트 및 상세 정보 ex)areaCode = 0 , productCode = 11
+ (NSURLSessionDataTask *)perferenceGetServiceNoticeInfoCompletion:(void (^)(NSArray *preference, NSError *error))block
{
    return [[CMNetworkManager sharedInstance] preferenceGetServiceNoticeInfoCompletion:block];
}

//서비스 이용약관/고객센터
+ (NSURLSessionDataTask *)perferenceGetServiceguideInfoWithCode:(NSString*)code completion:(void (^)(NSArray *preference, NSError *error))block {
    return [[CMNetworkManager sharedInstance] perferenceGetServiceguideInfoWithCode:code completion:block];
}


//버전정보
+ (NSURLSessionDataTask *)perferenceGetAppVersionInfoCompletion:(void (^)(NSArray *preference, NSError *error))block {
    return [[CMNetworkManager sharedInstance] perferenceGetAppVersionInfoCompletion:block];
}

@end
