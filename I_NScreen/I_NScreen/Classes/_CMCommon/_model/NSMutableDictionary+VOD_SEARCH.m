//
//  NSMutableDictionary+VOD_SEARCH.m
//  I_NScreen
//
//  Created by 조백근 on 2015. 8. 31..
//  Copyright (c) 2015년 STVN. All rights reserved.
//

#import "NSMutableDictionary+VOD_SEARCH.h"

@implementation NSMutableDictionary (VOD_SEARCH)
+ (NSURLSessionDataTask *)programSearchListWithSearchString:(NSString *)searchString WithPageSize:(NSString *)pageSize WithPageIndex:(NSString *)pageIndex WithAreaCode:(NSString *)areaCode WithProductCode:(NSString *)productCode completion:(void (^)(NSArray *programs, NSError *error))block
{
    return [[CMNetworkManager sharedInstance] programSearchListWithSearchString:searchString WithPageSize:pageSize WithPageIndex:pageIndex WithAreaCode:areaCode WithProductCode:productCode completion:block];
}

+ (NSURLSessionDataTask *)vodSerchListWithSearchString:(NSString *)searchString WithPageSize:(NSString *)pageSize WithPageIndex:(NSString *)pageIndex WithSortType:(NSString *)sortType completion:(void (^)(NSArray *programs, NSError *error))block
{
    return [[CMNetworkManager sharedInstance] vodSerchListWithSearchString:searchString WithPageSize:pageSize WithPageIndex:pageIndex WithSortType:sortType completion:block];
}

@end
