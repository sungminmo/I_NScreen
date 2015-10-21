//
//  NSMutableDictionary+VOD.m
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 10. 14..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import "NSMutableDictionary+VOD.h"

@implementation NSMutableDictionary (VOD)

+ (NSURLSessionDataTask *)vodGetPopularityChartWithCategoryId:(NSString *)categoryId WithRequestItems:(NSString *)requestItems completion:(void (^)(NSArray *vod, NSError *error))block
{
    return [[CMNetworkManager sharedInstance] vodGetPopularityChartWithCategoryId:categoryId WithRequestItems:requestItems block:block];
}

+ (NSURLSessionDataTask *)vodGetContentGroupListWithContentGroupProfile:(NSString *)contentGroupProfile WithCategoryId:(NSString *)categoryId completion:(void (^)(NSArray *vod, NSError *error))block
{
    return [[CMNetworkManager sharedInstance] vodGetContentGroupListWithContentGroupProfile:contentGroupProfile WithCategoryId:categoryId block:block];
}

+ (NSURLSessionDataTask *)vodGetAssetInfoWithAssetId:(NSString *)assetId WithAssetProfile:(NSString *)assetProfile completion:(void (^)(NSArray *vod, NSError *error))block
{
    return [[CMNetworkManager sharedInstance] vodGetAssetInfoWithAssetId:assetId WithAssetProfile:assetProfile block:block];
}

@end
