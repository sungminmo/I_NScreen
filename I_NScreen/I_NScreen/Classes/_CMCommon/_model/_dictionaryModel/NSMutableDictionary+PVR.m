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

+ (NSURLSessionDataTask *)pvrGetrecordReservelistWithSeriesId:(NSString *)seriesId completion:(void (^)(NSArray *pvr, NSError *error))block
{
    return [[CMNetworkManager sharedInstance] pvrGetrecordReservelistWithSeriesId:seriesId completion:block];
}

+ (NSURLSessionDataTask *)pvrSetRecordDeleWithChannelId:(NSString *)channeId WithStartTime:(NSString *)startTime WithRecordId:(NSString *)recordId completion:(void (^)(NSArray *pvr, NSError *error))block
{
    return [[CMNetworkManager sharedInstance] pvrSetRecordDeleWithChannelId:channeId WithStartTime:startTime WithRecordId:recordId completion:block];
}

+ (NSURLSessionDataTask *)pvrSetRecordSeriesDeleWithRecordId:(NSString *)recordId WithSeriesId:(NSString *)seriesId WithChannelId:(NSString *)channelId WithStartTime:(NSString *)startTime completion:(void (^)(NSArray *pvr, NSError *error))block
{
    return [[CMNetworkManager sharedInstance] pvrSetRecordSeriesDeleWithRecordId:recordId WithSeriesId:seriesId WithChannelId:channelId WithStartTime:startTime completion:block];
}

@end
