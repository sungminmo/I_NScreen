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

@end
