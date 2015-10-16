//
//  CMNetworkManager.h
//  I_NScreen
//
//  Created by 조백근 on 2015. 8. 18..
//  Copyright (c) 2015년 STVN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"

@interface CMDRMServerClient : AFHTTPSessionManager
@end

@interface CMSMAppServerClient : AFHTTPSessionManager
@end

@interface CMWebHasServerClient : AFHTTPSessionManager
@end

@interface CMRUMPUSServerClient : AFHTTPSessionManager
@end

@interface CMNetworkManager : NSObject

@property (nonatomic, strong) CMDRMServerClient* drmClient;
@property (nonatomic, strong) CMSMAppServerClient* smClient;
@property (nonatomic, strong) CMWebHasServerClient* webClient;
@property (nonatomic, strong) CMRUMPUSServerClient* rumClient;

+ (CMNetworkManager *)sharedInstance;

@end


@interface CMNetworkManager(SEARCH)

- (NSURLSessionDataTask *)searchProgram:(NSString *)keyword block:(void (^)(NSArray *posts, NSError *error))block;

- (NSURLSessionDataTask *)epgSearchSearchChannelWithSearchString:(NSString *)searchString WithPageSize:(NSString *)pageSize WithPageIndex:(NSString *)pageIndex WithSortType:(NSString *)sortType block:(void (^)(NSArray *posts, NSError *error))block;

@end

@interface CMNetworkManager (EPG)

- (NSURLSessionDataTask *)epgGetChannelListAreaCode:(NSString *)areaCode block:(void (^)(NSArray *gets, NSError *error))block;

- (NSURLSessionDataTask *)epgGetChannelGenreBlock:(void (^)(NSArray *gets, NSError *error))block;

- (NSURLSessionDataTask *)epgGetChannelAreaBlock:(void (^)(NSArray *gets, NSError *error))block;

- (NSURLSessionDataTask *)epgGetChannelScheduleChannelId:(NSString *)channelId block:(void (^)(NSArray *gets, NSError *error))block;

- (NSURLSessionDataTask *)epgSearchScheduleAreaCode:(NSString *)areaCode WithSearch:(NSString *)search block:(void (^)(NSArray *gets, NSError *error))block;

@end

@interface CMNetworkManager (VOD)

// 인기순위 Top20
- (NSURLSessionDataTask *)vodGetPopularityChartWithCategoryId:(NSString *)categoryId WithRequestItems:(NSString *)requestItems block:(void (^)(NSArray *gets, NSError *error))block;

// 금주의 신작영화
- (NSURLSessionDataTask *)vodGetContentGroupListWithContentGroupProfile:(NSString *)contentGroupProfile WithPageIndex:(NSString *)pageIndex WithCategoryId:(NSString *)categoryId WithSortType:(NSString *)sortType WithPageSize:(NSString *)pageSize WithTransactionId:(NSString *)transactionId WithIndexRotaion:(NSString *)indexRotaion block:(void (^)(NSArray *gets, NSError *error))block;

@end