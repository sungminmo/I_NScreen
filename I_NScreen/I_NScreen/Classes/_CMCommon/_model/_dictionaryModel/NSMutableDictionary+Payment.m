//
//  NSMutableDictionary+Payment.m
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 11. 12..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import "NSMutableDictionary+Payment.h"

@implementation NSMutableDictionary (Payment)

+ (NSURLSessionDataTask  *)paymentGetAvailablePaymentTypeWithDomainId:(NSString *)domainId completion:(void (^)(NSArray *preference, NSError *error))block
{
    return [[CMNetworkManager sharedInstance] paymentGetAvailablePaymentTypeWithDomainId:domainId completion:block];
}

+ (NSURLSessionDataTask *)paymentPurchaseByPointWithDomainId:(NSString *)domainId WithAssetId:(NSString *)assetId WithProductId:(NSString *)productId WithGoodId:(NSString *)goodId WithPrice:(NSString *)price WithCategoryId:(NSString *)categoryId completion:(void (^)(NSArray *preference, NSError *error))block
{
    return [[CMNetworkManager sharedInstance] paymentPurchaseByPointWithDomainId:domainId WithAssetId:assetId WithProductId:productId WithGoodId:goodId WithPrice:price WithCategoryId:categoryId completion:block];
}

//+ (NSURLSessionDataTask *)paymentPurchaseAssetEx2WithProductId:(NSString *)productId WithGoodId:(NSString *)goodId WithUiComponentDomain:(NSString *)uiComponentDomain WithUiComponentId:(NSString *)uiComponentId WithPrice:(NSString *)price completion:(void (^)(NSArray *preference, NSError *error))block
//{
//    return [[CMNetworkManager sharedInstance] paymentPurchaseAssetEx2WithProductId:productId WithGoodId:goodId WithUiComponentDomain:uiComponentDomain WithUiComponentId:uiComponentId WithPrice:price completion:block];
//}
+ (NSURLSessionDataTask *)paymentPurchaseAssetEx2WithAssetId:(NSString *)assetId WithProductId:(NSString *)productId WithGoodId:(NSString *)goodId WithPrice:(NSString *)price completion:(void (^)(NSArray *preference, NSError *error))block
{
    return [[CMNetworkManager sharedInstance] paymentPurchaseAssetEx2WithAssetId:assetId WithProductId:productId WithGoodId:goodId WithPrice:price completion:block];
}

+ (NSURLSessionDataTask *)paymentPurchaseByCouponWithAssetId:(NSString *)assetId WithProductId:(NSString *)productId WithGoodId:(NSString *)goodId WithPrice:(NSString *)price WithCategoryId:(NSString *)categoryId completion:(void (^)(NSArray *preference, NSError *error))block
{
    return [[CMNetworkManager sharedInstance] paymentPurchaseByCouponWithAssetId:assetId WithProductId:productId WithGoodId:goodId WithPrice:price WithCategoryId:categoryId completion:block];
}

+ (NSURLSessionDataTask *)paymentPurchaseByPointWithAssetId:(NSString *)assetId WithProductId:(NSString *)productId WithGoodId:(NSString *)goodId WithPrice:(NSString *)price WithCategoryId:(NSString *)categoryId completion:(void (^)(NSArray *preference, NSError *error))block
{
    return [[CMNetworkManager sharedInstance] paymentPurchaseByPointWithAssetId:assetId WithProductId:productId WithGoodId:goodId WithPrice:price WithCategoryId:categoryId completion:block];
}

+ (NSURLSessionDataTask *)paymentPurchaseByComplexMethodsWithAssetId:(NSString *)assetId WithProductId:(NSString *)productId WithGoodId:(NSString *)goodId WithPrice:(NSString *)price WithCouponPrice:(NSString *)couponPrice WithNomalPrice:(NSString *)normalPrice completion:(void (^)(NSArray *preference, NSError *error))block
{
    return [[CMNetworkManager sharedInstance] paymentPurchaseByComplexMethodsWithAssetId:assetId WithProductId:productId WithGoodId:goodId WithPrice:price WithCouponPrice:couponPrice WithNomalPrice:normalPrice completion:block];
}

@end
