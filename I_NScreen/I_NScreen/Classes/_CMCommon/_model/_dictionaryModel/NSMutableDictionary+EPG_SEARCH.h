//
//  NSMutableDictionary+EPG_SEARCH.h
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 10. 16..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (EPG_SEARCH)

//+ (NSURLSessionDataTask *)epgSearchScheduleAreaCode:(NSString *)areaCode WithSearch:(NSString *)search completion:(void (^)(NSArray *epgs, NSError *error))block;
//http://58.141.255.80/smapplicationserver/SearchChannel.asp?version=1&terminalKey=9CED3A20FB6A4D7FF35D1AC965F988D2&Search_String=MBC&pageSize=3&pageIndex=0&sortType=ChannelNoDesc

+ (NSURLSessionDataTask *)epgSearchSearchChannelWithSearchString:(NSString *)searchString WithPageSize:(NSString *)pageSize WithPageIndex:(NSString *)pageIndex WithSortType:(NSString *)sortType completion:(void (^)(NSArray *epgs, NSError *error))block;

@end
