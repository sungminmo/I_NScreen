//
//  NSMutableDictionary+Payment.h
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 11. 12..
//  Copyright © 2015년 STVN. All rights reserved.
//
/*/================================================================================================
 NScreen - 결제
 ================================================================================================/*/

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (Payment)

+ (NSURLSessionDataTask  *)paymentGetAvailablePaymentTypeWithDomainId:(NSString *)domainId completion:(void (^)(NSArray *preference, NSError *error))block;

+ (NSURLSessionDataTask *)paymentPurchaseByPointWithDomainId:(NSString *)domainId WithAssetId:(NSString *)assetId WithProductId:(NSString *)productId WithGoodId:(NSString *)goodId WithPrice:(NSString *)price WithCategoryId:(NSString *)categoryId completion:(void (^)(NSArray *preference, NSError *error))block;

//+ (NSURLSessionDataTask *)paymentPurchaseAssetEx2WithProductId:(NSString *)productId WithGoodId:(NSString *)goodId WithUiComponentDomain:(NSString *)uiComponentDomain WithUiComponentId:(NSString *)uiComponentId WithPrice:(NSString *)price completion:(void (^)(NSArray *preference, NSError *error))block;
+ (NSURLSessionDataTask *)paymentPurchaseAssetEx2WithAssetId:(NSString *)assetId WithProductId:(NSString *)productId WithGoodId:(NSString *)goodId WithPrice:(NSString *)price extraParam:(NSDictionary*)discountParam completion:(void (^)(NSArray *payment, NSError *error))block;

+ (NSURLSessionDataTask *)paymentPurchaseByCouponWithAssetId:(NSString *)assetId WithProductId:(NSString *)productId WithGoodId:(NSString *)goodId WithPrice:(NSString *)price WithCategoryId:(NSString *)categoryId completion:(void (^)(NSArray *payment, NSError *error))block;

+ (NSURLSessionDataTask *)paymentPurchaseByPointWithAssetId:(NSString *)assetId WithProductId:(NSString *)productId WithGoodId:(NSString *)goodId WithPrice:(NSString *)price WithCategoryId:(NSString *)categoryId completion:(void (^)(NSArray *payment, NSError *error))block;

+ (NSURLSessionDataTask *)paymentPurchaseByComplexMethodsWithAssetId:(NSString *)assetId WithProductId:(NSString *)productId WithGoodId:(NSString *)goodId WithPrice:(NSString *)price WithCouponPrice:(NSString *)couponPrice WithNomalPrice:(NSString *)normalPrice completion:(void (^)(NSArray *payment, NSError *error))block;

+ (NSURLSessionDataTask *)paymentPurchaseProductWithProductId:(NSString *)productId completion:(void (^)(NSArray *payment, NSError *error))block;

+ (NSURLSessionDataTask *)paymentPurchaseProductByCoupon2WithProductId:(NSString *)productId WithPrice:(NSString *)price completion:(void (^)(NSArray *payment, NSError *error))block;

+ (NSURLSessionDataTask *)paymentPurchaseProductByPointWithProductId:(NSString *)productId WithPrice:(NSString *)price completion:(void (^)(NSArray *payment, NSError *error))block;

+ (NSURLSessionDataTask *)paymentPurchaseProductByComplexMethodsWithProductId:(NSString *)productId WithPrice:(NSString *)price WithCouponPrice:(NSString *)couponPrice WithNormalPrice:(NSString *)normalPrice completion:(void (^)(NSArray *payment, NSError *error))block;

+ (NSURLSessionDataTask *)paymentGetBundleProductInfoWithProductId:(NSString *)productId completion:(void (^)(NSArray *payment, NSError *error))block;

@end
