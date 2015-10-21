//
//  NSMutableDictionary+EPG.h
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 9. 22..
//  Copyright (c) 2015년 STVN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (EPG)

// http://58.141.255.69:8080/nscreen/getChannelList.xml?version=1&areaCode=0&genreCode=1 전체는 머지??
+ (NSURLSessionDataTask *)epgGetChannelListAreaCode:(NSString *)areaCode WithGenreCode:(NSString *)genreCode completion:(void (^)(NSArray *epgs, NSError *error))block;

// http://58.141.255.69:8080/nscreen/getChannelGenre.xml?version=1
+ (NSURLSessionDataTask *)epgGetChannelGenreCompletion:(void (^)(NSArray *epgs, NSError *error))block;

// http://58.141.255.69:8080/nscreen/getChannelArea.xml?version=1
+ (NSURLSessionDataTask *)epgGetChannelAreaCompletion:(void (^)(NSArray *epgs, NSError *error))block;

// http://58.141.255.69:8080/nscreen/getChannelSchedule.xml?version=1&channelId=1000
+ (NSURLSessionDataTask *)epgGetChannelScheduleChannelId:(NSString *)channelId completion:(void (^)(NSArray *epgs, NSError *error))block;

// http://58.141.255.69:8080/nscreen/searchSchedule.xml?version=1&areaCode=1&searchString=aa
+ (NSURLSessionDataTask *)epgSearchScheduleAreaCode:(NSString *)areaCode WithSearch:(NSString *)search completion:(void (^)(NSArray *epgs, NSError *error))block;

@end
