//
//  NSMutableDictionary+VOD.m
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 10. 14..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import "NSMutableDictionary+VOD.h"

@implementation NSMutableDictionary (VOD)

+ (NSURLSessionDataTask *)epgGetChannelListAreaCode:(NSString *)areaCode completion:(void (^)(NSArray *epgs, NSError *error))block
{
    return [[CMNetworkManager sharedInstance] epgGetChannelListAreaCode:areaCode block:block];
}

+ (NSURLSessionDataTask *)vodGetPopularityChartWithCategoryId:(NSString *)categoryId WithRequestItems:(NSString *)requestItems completion:(void (^)(NSArray *, NSError *))block
{
    return [[CMNetworkManager sharedInstance] vodGetPopularityChartWithCategoryId:categoryId WithRequestItems:requestItems block:block];
}

@end
