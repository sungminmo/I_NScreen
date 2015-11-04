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

//+ (NSURLSessionDataTask *)epgSetRecordWithChannelId:(NSString *)channeId completion:(void (^)(NSArray *epgs, NSError *error))block
//{
//    
//}

@end
