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
+ (NSURLSessionDataTask *)preferenceGetServiceJoinNListCompletion:(void (^)(NSArray *preference, NSError *error))block
{
    return [[CMNetworkManager sharedInstance] preferenceGetServiceJoinNListCompletion:block];
}

// 특정 유료체널 상세 정보
+ (NSURLSessionDataTask *)preferenceGetServiceJoinNInfoCompletion:(void (^)(NSArray *preference, NSError *error))block
{
    return [[CMNetworkManager sharedInstance] preferenceGetServiceJoinNInfoCompletion:block];
}

// 공지사항 리스트 및 상세 정보 ex)areaCode = 0 , productCode = 11
+ (NSURLSessionDataTask *)perferenceGetServiceNoticeInfoWithAreaCode:(NSString *)areaCode WithProductCode:(NSString *)productCode completion:(void (^)(NSArray *preference, NSError *error))block
{
    return [[CMNetworkManager sharedInstance] preferenceGetServiceNoticeInfoWithAreaCode:areaCode WithProductCode:productCode completion:block];
}

@end
