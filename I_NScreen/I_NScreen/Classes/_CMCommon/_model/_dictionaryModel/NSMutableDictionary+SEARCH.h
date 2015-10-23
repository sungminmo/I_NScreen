//
//  NSMutableDictionary+SEARCH.h
//  I_NScreen
//
//  Created by kimts on 2015. 10. 19..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (SEARCH)

+ (NSURLSessionDataTask *)programSearchListWithSearchString:(NSString *)searchString WithPageSize:(NSInteger)pageSize WithPageIndex:(NSInteger)pageIndex WithAreaCode:(NSString *)areaCode WithProductCode:(NSString *)productCode completion:(void (^)(NSArray *programs, NSError *error))block;

+ (NSURLSessionDataTask *)vodSerchListWithSearchString:(NSString *)searchString WithPageSize:(NSInteger)pageSize WithPageIndex:(NSInteger)pageIndex WithSortType:(NSString *)sortType completion:(void (^)(NSArray *programs, NSError *error))block;

+ (NSURLSessionDataTask*)searchWordListWithSearchString:(NSString*)searchString completion:(void (^)(NSArray *programs, NSError *error))block;

@end
