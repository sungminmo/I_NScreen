//
//  NSMutableDictionary+WISH.m
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 11. 19..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import "NSMutableDictionary+WISH.h"

@implementation NSMutableDictionary (WISH)

// 찜목록 가져오기
+ (NSURLSessionDataTask *)wishGetWishListCompletion:(void (^)(NSArray *wish, NSError *error))block
{
    return [[CMNetworkManager sharedInstance] wishGetWishListCompletion:block];
}

// 찜하기
+ (NSURLSessionDataTask *)wishAddWishItemWithAssetId:(NSString *)assetId completion:(void (^)(NSArray *wish, NSError *error))block
{
    return [[CMNetworkManager sharedInstance] wishAddWishItemWithAssetId:assetId completion:block];
}

// 찜삭제하기
+ (NSURLSessionDataTask *)wishRemoveWishWithAssetId:(NSString *)assetId completion:(void (^)(NSArray *wish, NSError *error))block
{
    return [[CMNetworkManager sharedInstance] wishRemoveWishWithAssetId:assetId completion:block];
}

@end
