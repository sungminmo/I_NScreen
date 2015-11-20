//
//  NSMutableDictionary+PVR.m
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 10. 27..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import "NSMutableDictionary+PVR.h"

@implementation NSMutableDictionary (PVR)

+ (NSURLSessionDataTask *)pvrGetrecordlistCompletion:(void (^)(NSArray *pvr, NSError *error))block
{
    return [[CMNetworkManager sharedInstance] pvrGetrecordlistCompletion:block];
}

+ (NSURLSessionDataTask *)pvrGetrecordListWithSeriesId:(NSString *)seriesId completion:(void (^)(NSArray *pvr, NSError *error))block
{
    return [[CMNetworkManager sharedInstance] pvrGetrecordListWithSeriesId:seriesId completion:block];
}

+ (NSURLSessionDataTask *)pvrGetrecordReservelistCompletion:(void (^)(NSArray *pvr, NSError *error))block
{
    return [[CMNetworkManager sharedInstance] pvrGetrecordReservelistCompletion:block];
}

@end
