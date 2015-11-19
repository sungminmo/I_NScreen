//
//  NSMutableDictionary+EPG.m
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 9. 22..
//  Copyright (c) 2015년 STVN. All rights reserved.
//

#import "NSMutableDictionary+EPG.h"
#import "CMNetworkManager.h"

@implementation NSMutableDictionary (EPG)

+ (NSURLSessionDataTask *)epgGetChannelListAreaCode:(NSString *)areaCode block:(void (^)(NSArray *gets, NSError *error))block
{
    return [[CMNetworkManager sharedInstance] epgGetChannelListAreaCode:areaCode block:block];
}

+ (NSURLSessionDataTask *)epgGetChannelListAreaCode:(NSString *)areaCode WithGenreCode:(NSString *)genreCode completion:(void (^)(NSArray *epgs, NSError *error))block
{
    return [[CMNetworkManager sharedInstance] epgGetChannelListAreaCode:areaCode WithGenreCode:genreCode block:block];
}

+ (NSURLSessionDataTask *)epgGetChannelGenreAreCode:(NSString *)arecode Completion:(void (^)(NSArray *epgs, NSError *error))block
{
    return [[CMNetworkManager sharedInstance] epgGetChannelGenreArecode:arecode block:block];
}

+ (NSURLSessionDataTask *)epgGetChannelAreaCompletion:(void (^)(NSArray *epgs, NSError *error))block
{
    return [[CMNetworkManager sharedInstance] epgGetChannelAreaBlock:block];
}

+ (NSURLSessionDataTask *)epgGetChannelScheduleChannelId:(NSString *)channelId WithAreaCode:(NSString *)areaCode block:(void (^)(NSArray *gets, NSError *error))block
{
    return [[CMNetworkManager sharedInstance] epgGetChannelScheduleChannelId:channelId WithAreaCode:areaCode block:block];
}

+ (NSURLSessionDataTask *)epgSearchScheduleAreaCode:(NSString *)areaCode WithSearch:(NSString *)search completion:(void (^)(NSArray *epgs, NSError *error))block
{
    return [[CMNetworkManager sharedInstance] epgSearchScheduleAreaCode:areaCode WithSearch:search block:block];
}

+ (NSURLSessionDataTask *)epgSetRecordWithChannelId:(NSString *)channeId completion:(void (^)(NSArray *epgs, NSError *error))block
{
    return [[CMNetworkManager sharedInstance] epgSetRecordWithChannelId:channeId completion:block];
}

+ (NSURLSessionDataTask *)epgSetRecordStopWithChannelId:(NSString *)channeId completion:(void (^)(NSArray *epgs, NSError *error))block
{
    return [[CMNetworkManager sharedInstance] epgSetRecordStopWithChannelId:channeId completion:block];
}

+ (NSURLSessionDataTask *)epgSetRecordReserveWithChannelId:(NSString *)channeId WithStartTime:(NSString *)startTime completion:(void (^)(NSArray *epgs, NSError *error))block
{
    return [[CMNetworkManager sharedInstance] epgSetRecordReserveWithChannelId:channeId WithStartTime:startTime completion:block];
}

+ (NSURLSessionDataTask *)epgSetRecordSeriesReserveWithChannelId:(NSString *)channeId WithStartTime:(NSString *)startTime WithSeriesId:(NSString *)seriesId completion:(void (^)(NSArray *epgs, NSError *error))block
{
    return [[CMNetworkManager sharedInstance] epgSetRecordSeriesReserveWithChannelId:channeId WithStartTime:startTime WithSeriesId:seriesId completion:block];
}

+ (NSURLSessionDataTask *)epgSetRecordCancelReserveWithChannelId:(NSString *)channeId WithStartTime:(NSString *)startTime WithSeriesId:(NSString *)seriesId WithReserveCancel:(NSString *)reserveCancel completion:(void (^)(NSArray *epgs, NSError *error))block
{
    return [[CMNetworkManager sharedInstance] epgSetRecordCancelReserveWithChannelId:channeId WithStartTime:startTime WithSeriesId:seriesId WithReserveCancel:reserveCancel completion:block];
}


@end
