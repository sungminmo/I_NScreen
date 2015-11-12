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

@end
