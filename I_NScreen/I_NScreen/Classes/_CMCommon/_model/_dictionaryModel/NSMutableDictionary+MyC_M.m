//
//  NSMutableDictionary+MyC_M.m
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 11. 4..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import "NSMutableDictionary+MyC_M.h"

@implementation NSMutableDictionary (MyC_M)

+ (NSURLSessionDataTask *)myCmGetWishListCompletion:(void (^)(NSArray *myCm, NSError *error))block
{
    return [[CMNetworkManager sharedInstance] myCmGetWishListCompletion:block];
}

+ (NSURLSessionDataTask *)myCmGetValidPurchaseLogListCompletion:(void (^)(NSArray *myCm, NSError *error))block
{
    return [[CMNetworkManager sharedInstance] myCmGetValidPurchaseLogListCompletion:block];
}

@end
