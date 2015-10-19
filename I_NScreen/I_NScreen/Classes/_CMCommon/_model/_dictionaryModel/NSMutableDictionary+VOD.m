//
//  NSMutableDictionary+VOD.m
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 10. 14..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import "NSMutableDictionary+VOD.h"

@implementation NSMutableDictionary (VOD)

+ (NSURLSessionDataTask *)vodGetPopularityChartWithCategoryId:(NSString *)categoryId WithRequestItems:(NSString *)requestItems completion:(void (^)(NSArray *, NSError *))block
{
    return [[CMNetworkManager sharedInstance] vodGetPopularityChartWithCategoryId:categoryId WithRequestItems:requestItems block:block];
}

+ (NSURLSessionDataTask *)vodGetContentGroupListWithContentGroupProfile:(NSString *)contentGroupProfile WithPageIndex:(NSString *)pageIndex WithCategoryId:(NSString *)categoryId WithSortType:(NSString *)sortType WithPageSize:(NSString *)pageSize WithTransactionId:(NSString *)transactionId WithIndexRotaion:(NSString *)indexRotaion completion:(void (^)(NSArray *, NSError *))block
{
    return [[CMNetworkManager sharedInstance] vodGetContentGroupListWithContentGroupProfile:contentGroupProfile WithPageIndex:pageIndex WithCategoryId:categoryId WithSortType:sortType WithPageSize:pageSize WithTransactionId:transactionId WithIndexRotaion:indexRotaion block:block];
}

@end
