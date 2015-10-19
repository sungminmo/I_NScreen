//
//  NSMutableDictionary+EPG_SEARCH.m
//  I_NScreen
//
//  Created by JUNG KIL BAE on 2015. 10. 16..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import "NSMutableDictionary+EPG_SEARCH.h"

@implementation NSMutableDictionary (EPG_SEARCH)

+ (NSURLSessionDataTask *)epgSearchSearchChannelWithSearchString:(NSString *)searchString WithPageSize:(NSString *)pageSize WithPageIndex:(NSString *)pageIndex WithSortType:(NSString *)sortType completion:(void (^)(NSArray *, NSError *))block
{
    return [[CMNetworkManager sharedInstance] epgSearchChannelListWithSearchString:searchString WithPageSize:pageSize WithPageIndex:pageIndex WithSortType:sortType block:block];
}

@end
