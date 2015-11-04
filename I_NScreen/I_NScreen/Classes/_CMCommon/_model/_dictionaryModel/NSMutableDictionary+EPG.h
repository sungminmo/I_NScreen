//
//  NSMutableDictionary+EPG.h
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 9. 22..
//  Copyright (c) 2015년 STVN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (EPG)
// http://58.141.255.69:8080/nscreen/getChannelList.xml?version=1&areaCode=0 전체
+ (NSURLSessionDataTask *)epgGetChannelListAreaCode:(NSString *)areaCode block:(void (^)(NSArray *gets, NSError *error))block;

// http://58.141.255.69:8080/nscreen/getChannelList.xml?version=1&areaCode=0&genreCode=1
+ (NSURLSessionDataTask *)epgGetChannelListAreaCode:(NSString *)areaCode WithGenreCode:(NSString *)genreCode completion:(void (^)(NSArray *epgs, NSError *error))block;

//http://58.141.255.69:8080/nscreen/getChannelGenre.xml?version=1&areaCode=0
+ (NSURLSessionDataTask *)epgGetChannelGenreAreCode:(NSString *)arecode Completion:(void (^)(NSArray *epgs, NSError *error))block;

// http://58.141.255.69:8080/nscreen/getChannelArea.xml?version=1
+ (NSURLSessionDataTask *)epgGetChannelAreaCompletion:(void (^)(NSArray *epgs, NSError *error))block;

// http://58.141.255.69:8080/nscreen/getChannelSchedule.xml?version=1&channelId=1000
+ (NSURLSessionDataTask *)epgGetChannelScheduleChannelId:(NSString *)channelId completion:(void (^)(NSArray *epgs, NSError *error))block;

// http://58.141.255.69:8080/nscreen/searchSchedule.xml?version=1&areaCode=1&searchString=aa
+ (NSURLSessionDataTask *)epgSearchScheduleAreaCode:(NSString *)areaCode WithSearch:(NSString *)search completion:(void (^)(NSArray *epgs, NSError *error))block;

// SetRecord
//http://58.141.255.80/smapplicationserver/SMApplicationServer/SetRecord.asp?Version=1&terminalKey=9CED3A20FB6A4D7FF35D1AC965F988D2&deviceId=739d8470f604cfceb13784ab94fc368256253477&ChannelId=10
+ (NSURLSessionDataTask *)epgSetRecordWithChannelId:(NSString *)channeId completion:(void (^)(NSArray *epgs, NSError *error))block;


@end
