//
//  NSMutableDictionary+SEARCH.h
//  I_NScreen
//
//  Created by 조백근 on 2015. 10. 19..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (SEARCH)

+ (NSURLSessionDataTask *)programSearchListWithSearchString:(NSString *)searchString WithPageSize:(NSInteger)pageSize WithPageIndex:(NSInteger)pageIndex WithAreaCode:(NSString *)areaCode WithProductCode:(NSString *)productCode completion:(void (^)(NSArray *programs, NSError *error))block;

+ (NSURLSessionDataTask *)programScheduleListWithSearchString:(NSString *)searchString WithPageSize:(NSInteger)pageSize WithPageIndex:(NSInteger)pageIndex WithAreaCode:(NSString *)areaCode completion:(void (^)(NSArray *programs, NSError *error))block;

+ (NSURLSessionDataTask *)vodSerchListWithSearchString:(NSString *)searchString WithPageSize:(NSInteger)pageSize WithPageIndex:(NSInteger)pageIndex WithSortType:(NSString *)sortType completion:(void (^)(NSArray *programs, NSError *error))block;

+ (NSURLSessionDataTask*)searchWordListWithSearchString:(NSString*)searchString WithIncludeAdultCategory:(NSString *)adultCategory completion:(void (^)(NSArray *programs, NSError *error))block;

+ (NSURLSessionDataTask *)searchContentGroupWithSearchKeyword:(NSString *)searchKeyword WithIncludeAdultCategory:(NSString *)includeAdultCategory completion:(void (^)(NSArray *gets, NSError *error))block;

@end
