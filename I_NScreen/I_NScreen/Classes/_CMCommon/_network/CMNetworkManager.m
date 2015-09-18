//
//  CMNetworkManager.m
//  I_NScreen
//
//  Created by 조백근 on 2015. 8. 18..
//  Copyright (c) 2015년 STVN. All rights reserved.
//

#import "CMNetworkManager.h"

@implementation CMDRMServerClient

@end

@implementation CMSMAppServerClient

@end

@implementation CMWebHasServerClient

@end


@interface CMNetworkManager()
/**
 C&M SMApplicationServer의 openAPI를 사용하기 위한 NSURL 타입의 URL 반환한다.
 
 @param interface C&M SMApplicationServer의 openAPI의 인터페이스.
 @return NSURL 타입의 URL 반환.
 */
+ (NSURL *)genURLWithInterface:(NSString *)interface;

/**
 네이버의 검색API를 사용하기 위한 NSURL 타입의 URL 반환한다.
 
 @param query 검색 키워드.
 @return NSURL 타입의 URL 반환.
 */
+ (NSURL *)genURLWithQuery:(NSString *)query;

/**
 NSString 타입의 쿼리스트링 반환한다.
 
 @param dict 쿼리스트링을 생성할 파라미터 목록.
 @return NSString 타입의 쿼리스트링 반환.
 */
+ (NSString *)genQueryStringWithDictionary:(NSDictionary *)dict;

+ (NSString *)genParameter:(NSString *)key andValue:(NSString *)value;
@end


@implementation CMNetworkManager

+ (CMNetworkManager *)sharedInstance {
    static CMNetworkManager *sharedInstanced = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstanced = [[self alloc] init];
    });
    return sharedInstanced;
}

- (id)init {
    if (self = [super init]) {
        
        self.drmClient = [[CMDRMServerClient alloc] initWithBaseURL:[NSURL URLWithString:@""]];
        self.drmClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];

        self.smClient = [[CMSMAppServerClient alloc] initWithBaseURL:[NSURL URLWithString:CNM_AIRCODE_OPEN_API_SERVER_URL]];
        self.smClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];

        self.webClient = [[CMWebHasServerClient alloc] initWithBaseURL:[NSURL URLWithString:@""]];
        self.webClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        
    }
    return self;
}

#pragma mar - from CMGenerator
+ (NSURL *)genURLWithInterface:(NSString *)interface
{
//    return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@.asp", CNM_OPEN_API_SERVER_URL, interface]];
//    return [NSURL URLWithString:[NSString stringWithFormat:@"%@.asp", interface]];
    // Add By BJK
     return [NSURL URLWithString:[NSString stringWithFormat:@"%@.xml", interface]];
}

// TODO: UI에서 페이징 처리 결정해야 함!
+ (NSURL *)genURLWithQuery:(NSString *)query
{
    // !!!: query는 UTF-8 인코딩.
    NSDictionary *dict = @{
                           @"key" : NAVER_SEARCH_API_KEY,
                           @"target" : @"webkr",
                           @"query" : [query stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                           @"start" : @"1",
                           @"display" : @"10"
                           };
    
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", NAVER_SEARCH_API_SERVER_URL, [self genQueryStringWithDictionary:dict]]];
}

+ (NSString *)genParameter:(NSString *)key andValue:(NSString *)value
{
    NSString *element = [NSString stringWithFormat:@"%@=%@&", key, value];
    
    return element;
}

+ (NSString *)genQueryStringWithDictionary:(NSDictionary *)dict
{
    NSMutableString *queryString = [NSMutableString string];
    
    [dict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [queryString appendString:[self genParameter:key andValue:obj]];
    }];
    
    return queryString;
}

#pragma mark - 



@end

@implementation CMNetworkManager(SEARCH)

- (NSURLSessionDataTask *)searchProgram:(NSString *)keyword block:(void (^)(NSArray *posts, NSError *error))block {
    NSURL *url = [CMNetworkManager genURLWithInterface:CNM_OPEN_API_INTERFACE_SearchProgram];
    NSDictionary *dict = @{
                           CNM_OPEN_API_VERSION_KEY : CNM_OPEN_API_VERSION,
                           CNM_OPEN_API_TERMINAL_KEY_KEY : @""/*[CMHTTPClient sharedCMHTTPClient].terminalKey*/,
                           CNM_OPEN_API_TRANSACTION_ID_KEY : @"0",
                           @"areaCode" : CNM_DEFAULT_AREA_CODE,
                           @"productCode" : CNM_DEFAULT_PRODUCT_CODE,
                           @"pageSize" : @"0",
                           @"pageIndex" : @"0",
                           @"Search_String" : [keyword stringByUrlEncoding]
                           };
    
    return [self.smClient POST:url parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        //1차로 예외처리 및 공통처리할 때 사용.
        NSArray *response = [responseObject valueForKeyPath:@"data"];
        NSMutableArray *programs = [NSMutableArray arrayWithCapacity:[response count]];
        for (NSDictionary *item in response) {
        }
        if (block) {
            block([NSArray arrayWithArray:programs], nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (block) {
            block([NSArray array], error);
        }
    }];
}



@end

@implementation CMNetworkManager(EPG)
- (NSURLSessionDataTask *)epgGetChannelListProgram:(NSString *)keyword block:(void (^)(NSArray *posts, NSError *error))block
{
    NSString *sUrl = [NSString stringWithFormat:@"%@.xml", CNM_OPEN_API_INTERFACE_GetChannelList];
    NSDictionary *dict = @{
                           CNM_OPEN_API_VERSION_KEY : CNM_OPEN_API_VERSION,
                           @"areaCode" : @"0"
                           };
    
    return [self.smClient GET:sUrl parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

- (NSURLSessionDataTask *)epgGetChannelGenreProgram:(NSString *)keyword block:(void (^)(NSArray *posts, NSError *error))block
{
    NSString *sUrl = [NSString stringWithFormat:@"%@.xml", CNM_OPEN_API_INTERFACE_GetChannelGenre];
    NSDictionary *dict = @{
                           CNM_OPEN_API_VERSION_KEY : CNM_OPEN_API_VERSION
                           };
    
    return [self.smClient GET:sUrl parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

- (NSURLSessionDataTask *)epgGetChannelAreaProgram:(NSString *)keyword block:(void (^)(NSArray *posts, NSError *error))block
{
    NSString *sUrl = [NSString stringWithFormat:@"%@.xml", CNM_OPEN_API_INTERFACE_GetChannelArea];
    NSDictionary *dict = @{
                           CNM_OPEN_API_VERSION_KEY : CNM_OPEN_API_VERSION
                           };
    
    return [self.smClient GET:sUrl parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

- (NSURLSessionDataTask *)epgGetChannelScheduleProgram:(NSString *)keyword block:(void (^)(NSArray *posts, NSError *error))block
{
    NSString *sUrl = [NSString stringWithFormat:@"%@.xml", CNM_OPEN_API_INTERFACE_GetChannelSchedule];
    NSDictionary *dict = @{
                           CNM_OPEN_API_VERSION_KEY : CNM_OPEN_API_VERSION,
                           @"channelId" : @"1"
                           };
    
    return [self.smClient GET:sUrl parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

- (NSURLSessionDataTask *)epgSearchScheduleProgram:(NSString *)keyword block:(void (^)(NSArray *posts, NSError *error))block
{
    NSString *sUrl = [NSString stringWithFormat:@"%@.xml", CNM_OPEN_API_INTERFACE_SearchSchedule];
    NSDictionary *dict = @{
                           CNM_OPEN_API_VERSION_KEY : CNM_OPEN_API_VERSION,
                           @"areaCode" : @"1",
                           @"searchString" : @"data"
                           };
    
    return [self.smClient GET:sUrl parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

@end


