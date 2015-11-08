//
//  NSMutableDictionary+SEARCH.m
//  I_NScreen
//
//  Created by 조백근 on 2015. 10. 19..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import "NSMutableDictionary+SEARCH.h"

@implementation NSMutableDictionary (SEARCH)

+ (NSURLSessionDataTask *)programSearchListWithSearchString:(NSString *)searchString WithPageSize:(NSInteger)pageSize WithPageIndex:(NSInteger)pageIndex WithAreaCode:(NSString *)areaCode WithProductCode:(NSString *)productCode completion:(void (^)(NSArray *programs, NSError *error))block
{
    return [[CMNetworkManager sharedInstance] programSearchListWithSearchString:searchString WithPageSize:pageSize WithPageIndex:pageIndex WithAreaCode:areaCode WithProductCode:productCode completion:block];
}

+ (NSURLSessionDataTask *)programScheduleListWithSearchString:(NSString *)searchString WithPageSize:(NSInteger)pageSize WithPageIndex:(NSInteger)pageIndex WithAreaCode:(NSString *)areaCode completion:(void (^)(NSArray *programs, NSError *error))block {
    
    return [[CMNetworkManager sharedInstance] programScheduleListWithSearchString:searchString WithPageSize:pageSize WithPageIndex:pageIndex WithAreaCode:areaCode completion:block];
}

+ (NSURLSessionDataTask *)vodSerchListWithSearchString:(NSString *)searchString WithPageSize:(NSInteger)pageSize WithPageIndex:(NSInteger)pageIndex WithSortType:(NSString *)sortType completion:(void (^)(NSArray *programs, NSError *error))block
{
    return [[CMNetworkManager sharedInstance] vodSerchListWithSearchString:searchString WithPageSize:pageSize WithPageIndex:pageIndex WithSortType:sortType completion:block];
}

+ (NSURLSessionDataTask*)searchWordListWithSearchString:(NSString*)searchString WithIncludeAdultCategory:(NSString *)adultCategory completion:(void (^)(NSArray *programs, NSError *error))block
{
    return [[CMNetworkManager sharedInstance] searchWordListWithSearchString:searchString WithIncludeAdultCategory:adultCategory completion:block];
}

+ (NSURLSessionDataTask *)searchContentGroupWithSearchKeyword:(NSString *)searchKeyword WithIncludeAdultCategory:(NSString *)includeAdultCategory completion:(void (^)(NSArray *gets, NSError *error))block
{
    return [[CMNetworkManager sharedInstance] searchContentGroupWithSearchKeyword:searchKeyword WithIncludeAdultCategory:includeAdultCategory completion:block];
}
@end
