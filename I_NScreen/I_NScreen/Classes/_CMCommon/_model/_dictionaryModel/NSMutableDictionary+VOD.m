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

+ (NSURLSessionDataTask *)vodRecommendContentGroupByAssetId:(NSString *)assetId WithContentGroupProfile:(NSString *)contentGroupProfile completion:(void (^)(NSArray *, NSError *))block
{
    return [[CMNetworkManager sharedInstance] vodRecommendContentGroupByAssetId:assetId WithContentGroupProfile:contentGroupProfile block:block];
}

+ (NSURLSessionDataTask *)vodGetBundleProductListWithProductProfile:(NSString *)productProfile completion:(void (^)(NSArray *, NSError *))block
{
    return [[CMNetworkManager sharedInstance] vodGetBundleProductListWithProductProfile:productProfile block:block];
}

+ (NSURLSessionDataTask *)vodGetServicebannerlistCompletion:(void (^)(NSArray *, NSError *))block
{
    return [[CMNetworkManager sharedInstance] vodGetServicebannerlistBlock:block];
}

+ (NSURLSessionDataTask *)vodGetCategoryTreeBlock:(void (^)(NSArray *vod, NSError *error))block
{
    return [[CMNetworkManager sharedInstance] vodGetCategoryTreeBlock:block];
}

+ (NSURLSessionDataTask *)vodGetCategoryTreeWithCategoryId:(NSString *)categoryId WithDepth:(NSString *)depth block:(void (^)(NSArray *vod, NSError *error))block
{
    return [[CMNetworkManager sharedInstance] vodGetCategoryTreeWithCategoryId:categoryId WithDepth:depth block:block];
}

+ (NSURLSessionDataTask *)vodRecommendAssetBySubscriberWithAssetProfile:(NSString *)assetProfile block:(void (^)(NSArray *vod, NSError *error))block
{
    return [[CMNetworkManager sharedInstance] vodRecommendAssetBySubscriberWithAssetProfile:assetProfile block:block];
}

+ (NSURLSessionDataTask *)vodGetAppInitializeCompletion:(void (^)(NSArray *pairing, NSError *error))block
{
    return [[CMNetworkManager sharedInstance] vodGetAppInitializeCompletion:block];
}

@end
