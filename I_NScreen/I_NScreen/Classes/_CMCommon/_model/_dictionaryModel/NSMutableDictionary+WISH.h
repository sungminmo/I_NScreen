//
//  NSMutableDictionary+WISH.h
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 11. 19..
//  Copyright © 2015년 STVN. All rights reserved.
//
// 찜하기

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (WISH)

// 찜목록 가져오기
+ (NSURLSessionDataTask *)wishGetWishListCompletion:(void (^)(NSArray *wish, NSError *error))block;

// 찜하기
+ (NSURLSessionDataTask *)wishAddWishItemWithAssetId:(NSString *)assetId completion:(void (^)(NSArray *wish, NSError *error))block;

// 찜삭제하기
+ (NSURLSessionDataTask *)wishRemoveWishWithAssetId:(NSString *)assetId completion:(void (^)(NSArray *wish, NSError *error))block;

@end
