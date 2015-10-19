//
//  NSMutableDictionary+SEARCH.m
//  I_NScreen
//
//  Created by kimts on 2015. 10. 19..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import "NSMutableDictionary+SEARCH.h"

@implementation NSMutableDictionary (SEARCH)

+ (NSURLSessionDataTask *)programSearchListWithSearchString:(NSString *)searchString WithPageSize:(NSInteger)pageSize WithPageIndex:(NSInteger)pageIndex WithAreaCode:(NSString *)areaCode WithProductCode:(NSString *)productCode completion:(void (^)(NSArray *programs, NSError *error))block
{
    return [[CMNetworkManager sharedInstance] programSearchListWithSearchString:searchString WithPageSize:pageSize WithPageIndex:pageIndex WithAreaCode:areaCode WithProductCode:productCode completion:block];
}

+ (NSURLSessionDataTask *)vodSerchListWithSearchString:(NSString *)searchString WithPageSize:(NSInteger)pageSize WithPageIndex:(NSInteger)pageIndex WithSortType:(NSString *)sortType completion:(void (^)(NSArray *programs, NSError *error))block
{
    return [[CMNetworkManager sharedInstance] vodSerchListWithSearchString:searchString WithPageSize:pageSize WithPageIndex:pageIndex WithSortType:sortType completion:block];
}

@end
