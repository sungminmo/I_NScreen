//
//  CMNetworkManager.m
//  I_NScreen
//
//  Created by 조백근 on 2015. 8. 18..
//  Copyright (c) 2015년 STVN. All rights reserved.
//

#import "CMNetworkManager.h"
#import "XMLDictionary.h"

@implementation CMDRMServerClient

@end

@implementation CMSMAppServerClient

@end

@implementation CMWebHasServerClient

@end

@implementation CMRUMPUSServerClient

@end

@implementation CMRUMPUSServerClientVPN

@end

@implementation CMAirCodeServerClient

@end



@interface CMNetworkManager() <NSXMLParserDelegate>
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

        self.smClient = [[CMSMAppServerClient alloc] initWithBaseURL:[NSURL URLWithString:CNM_OPEN_API_SERVER_URL]];
        self.smClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];

        self.webClient = [[CMWebHasServerClient alloc] initWithBaseURL:[NSURL URLWithString:@""]];
        self.webClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        
        self.rumClient = [[CMRUMPUSServerClient alloc] initWithBaseURL:[NSURL URLWithString:CNM_RUMPUS_OPEN_API_SERVER_URL]];
        self.rumClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        
        self.rumClientVpn = [[CMRUMPUSServerClientVPN alloc] initWithBaseURL:[NSURL URLWithString:CNM_RUMPUS_OPEN_API_SERVER_URL_VPN]];
        self.rumClientVpn.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];

        self.acodeClient = [[CMAirCodeServerClient alloc] initWithBaseURL:[NSURL URLWithString:CNM_AIRCODE_OPEN_API_SERVER_URL]];
        self.acodeClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];

        
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
    
    self.smClient.responseSerializer = [AFJSONResponseSerializer new];
    self.smClient.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json", @"text/json", @"text/javascript"]];
    
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

- (NSURLSessionDataTask *)programSearchListWithSearchString:(NSString *)searchString WithPageSize:(NSInteger)pageSize WithPageIndex:(NSInteger)pageIndex WithAreaCode:(NSString *)areaCode WithProductCode:(NSString *)productCode completion:(void (^)(NSArray *programs, NSError *error))block {
    
    self.rumClient.responseSerializer = [AFXMLParserResponseSerializer new];
    self.rumClient.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSString *sUrl = [NSString stringWithFormat:@"%@.asp", CNM_OPEN_API_INTERFACE_SearchProgram];
    NSDictionary *dict = @{
                           CNM_OPEN_API_VERSION_KEY : CNM_OPEN_API_VERSION,
                           CNM_OPEN_API_TERMINAL_KEY_KEY : CNM_REAL_TEST_TERMINAL_KEY,
                           @"Search_String" : searchString,
                           @"pageSize" : @(pageSize),
                           @"pageIndex" : @(pageIndex),
                           @"areaCode" : areaCode,
                           @"productCode" : productCode
                           };
    
    return [self.rumClient GET:sUrl parameters:dict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        NSDictionary* result = [NSDictionary dictionaryWithXMLParser:(NSXMLParser *)responseObject];
        
        block(@[result], nil);
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        block(nil, error);
    }];
}


- (NSURLSessionDataTask *)epgSearchChannelListWithSearchString:(NSString *)searchString WithPageSize:(NSString *)pageSize WithPageIndex:(NSString *)pageIndex WithSortType:(NSString *)sortType block:(void (^)(NSArray *, NSError *))block
{
    self.rumClient.responseSerializer = [AFXMLParserResponseSerializer new];
    self.rumClient.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSString *sUrl = [NSString stringWithFormat:@"%@.asp", CNM_OPEN_API_INTERFACE_SearchChannel];
    NSDictionary *dict = @{
                           CNM_OPEN_API_VERSION_KEY : CNM_OPEN_API_VERSION,
                           CNM_OPEN_API_TERMINAL_KEY_KEY : CNM_REAL_TEST_TERMINAL_KEY,
                           @"Search_String" : searchString,
                           @"pageSize" : pageSize,
                           @"pageIndex" : pageIndex,
                           @"sortType" : sortType
                           };
    
    return [self.rumClient GET:sUrl parameters:dict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        NSDictionary* result = [NSDictionary dictionaryWithXMLParser:(NSXMLParser *)responseObject];
        
        block(@[result], nil);
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        block(nil, error);
    }];
}

- (NSURLSessionDataTask *)vodSerchListWithSearchString:(NSString *)searchString WithPageSize:(NSInteger)pageSize WithPageIndex:(NSInteger)pageIndex WithSortType:(NSString *)sortType completion:(void (^)(NSArray *gets, NSError *error))block
{
    self.rumClient.responseSerializer = [AFXMLParserResponseSerializer new];
    self.rumClient.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSString *sUrl = [NSString stringWithFormat:@"%@.asp", CNM_OPEN_API_INTERFACE_SearchVod];
    NSDictionary *dict = @{
                           CNM_OPEN_API_VERSION_KEY : CNM_OPEN_API_VERSION,
                           CNM_OPEN_API_TERMINAL_KEY_KEY : CNM_REAL_TEST_TERMINAL_KEY,
                           @"Search_String" : searchString,
                           @"pageSize" : @(pageSize),
                           @"pageIndex" : @(pageIndex),
                           @"sortType" : sortType
                           };
    
    return [self.rumClient GET:sUrl parameters:dict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        NSDictionary* result = [NSDictionary dictionaryWithXMLParser:(NSXMLParser *)responseObject];
        
        block(@[result], nil);
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        block(nil, error);
    }];
}

- (NSURLSessionDataTask *)searchWordListWithSearchString:(NSString*)searchString completion:(void (^)(NSArray *gets, NSError *error))block
{
    self.smClient.responseSerializer = [AFXMLParserResponseSerializer new];
    self.smClient.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSString *sUrl = [NSString stringWithFormat:@"%@.xml", CNM_OPEN_API_INTERFACE_getSearchWord];
    NSDictionary *dict = @{
                           CNM_OPEN_API_VERSION_KEY : CNM_OPEN_API_VERSION,
                           CNM_OPEN_API_TERMINAL_KEY_KEY : CNM_REAL_TEST_TERMINAL_KEY,
                           @"searchKeyword" : searchString,
                           };
    
    return [self.smClient GET:sUrl parameters:dict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        NSDictionary* result = [NSDictionary dictionaryWithXMLParser:(NSXMLParser *)responseObject];
        
        block(@[result], nil);
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        block(nil, error);
    }];
}

@end

@implementation CMNetworkManager(EPG)

// http://58.141.255.69:8080/nscreen/getChannelList.xml?version=1&areaCode=0&genreCode=1
- (NSURLSessionDataTask *)epgGetChannelListAreaCode:(NSString *)areaCode WithGenreCode:(NSString *)genreCode block:(void (^)(NSArray *gets, NSError *error))block
{
    self.acodeClient.responseSerializer = [AFXMLParserResponseSerializer new];
    self.acodeClient.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/xml"];
    
    NSString *sUrl = [NSString stringWithFormat:@"%@.xml", CNM_OPEN_API_INTERFACE_GetChannelList];
    NSDictionary *dict = @{
                           CNM_OPEN_API_VERSION_KEY : CNM_OPEN_API_VERSION,
                           CNM_OPEN_API_TERMINAL_KEY_KEY : CNM_REAL_TEST_TERMINAL_KEY,
                           @"areaCode" : @"0",
                           @"genreCode" : genreCode
                           };
    
    return [self.acodeClient GET:sUrl parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary* result = [NSDictionary dictionaryWithXMLParser:(NSXMLParser *)responseObject];
        
        block(@[result], nil);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        block(nil, error);
    }];
}


// http://58.141.255.69:8080/nscreen/getChannelGenre.xml?version=1
- (NSURLSessionDataTask *)epgGetChannelGenreBlock:(void (^)(NSArray *gets, NSError *error))block
{
    self.smClient.responseSerializer = [AFXMLParserResponseSerializer new];
    self.smClient.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/xml"];
    
    NSString *sUrl = [NSString stringWithFormat:@"%@.xml", CNM_OPEN_API_INTERFACE_GetChannelGenre];
    NSDictionary *dict = @{
                           CNM_OPEN_API_VERSION_KEY : CNM_OPEN_API_VERSION
                           };
    
    return [self.smClient GET:sUrl parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

// http://58.141.255.69:8080/nscreen/getChannelArea.xml?version=1
- (NSURLSessionDataTask *)epgGetChannelAreaBlock:(void (^)(NSArray *gets, NSError *error))block
{
    self.acodeClient.responseSerializer = [AFXMLParserResponseSerializer new];
    self.acodeClient.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/xml"];
    
    NSString *sUrl = [NSString stringWithFormat:@"%@.xml", CNM_OPEN_API_INTERFACE_GetChannelArea];
    NSDictionary *dict = @{
                           CNM_OPEN_API_VERSION_KEY : CNM_OPEN_API_VERSION
                           };
    
    return [self.acodeClient GET:sUrl parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        
/*
 <?xml version="1.0" encoding="utf-8" standalone="yes"?>
 <response>
 <version>1.0.0</version>
 <transactionId>-1</transactionId>
 <resultCode>100</resultCode>
 <errorString/>
 <areaItem>
 <areaCode>0</areaCode>
 <areaName>CnM TEST</areaName>
 </areaItem>
 <areaItem>
 <areaCode>19</areaCode>
 <areaName>울산JCN TEST</areaName>
 </areaItem>
 <areaItem>
 <areaCode>17</areaCode>
 <areaName>강남 TEST</areaName>
 </areaItem>
 </response>
 */
        NSDictionary* result = [NSDictionary dictionaryWithXMLParser:(NSXMLParser*)responseObject];
/*
 <__NSArrayI 0x7fdd60702ab0>(
 {
 __name = response;
 transactionId = -1;
 resultCode = 100;
 areaItem = (
 {
 areaCode = 0;
 areaName = CnM TEST;
 }
 ,
 {
 areaCode = 19;
 areaName = 울산JCN TEST;
 }
 ,
 {
 areaCode = 17;
 areaName = 강남 TEST;
 }
 
 );
 version = 1.0.0;
 }
 
 )
 */
        block(@[result], nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        block(nil, error);
    }];
}

//- (NSURLSessionDataTask *)epgGetChannelAreaBlock:(void (^)(NSArray *gets, NSError *error))block
//{
//    NSString *sUrl = [NSString stringWithFormat:@"%@.xml", CNM_OPEN_API_INTERFACE_GetChannelArea];
//    NSDictionary *dict = @{
//                           CNM_OPEN_API_VERSION_KEY : CNM_OPEN_API_VERSION
//                           };
//    
//    return [self.smClient GET:@"brand.html" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
//        
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        
//    }];
//}

// http://58.141.255.69:8080/nscreen/getChannelSchedule.xml?version=1&channelId=1000
- (NSURLSessionDataTask *)epgGetChannelScheduleChannelId:(NSString *)channelId block:(void (^)(NSArray *gets, NSError *error))block
{
    self.smClient.responseSerializer = [AFXMLParserResponseSerializer new];
    self.smClient.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/xml"];
    
    NSString *sUrl = [NSString stringWithFormat:@"%@.xml", CNM_OPEN_API_INTERFACE_GetChannelSchedule];
    NSDictionary *dict = @{
                           CNM_OPEN_API_VERSION_KEY : CNM_OPEN_API_VERSION,
                           @"channelId" : @"1"
                           };
    
    return [self.smClient GET:sUrl parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

// http://58.141.255.69:8080/nscreen/searchSchedule.xml?version=1&areaCode=1&searchString=aa
- (NSURLSessionDataTask *)epgSearchScheduleAreaCode:(NSString *)areaCode WithSearch:(NSString *)search block:(void (^)(NSArray *gets, NSError *error))block
{
    self.smClient.responseSerializer = [AFXMLParserResponseSerializer new];
    self.smClient.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/xml"];
    
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

@implementation CMNetworkManager (VOD)

- (NSURLSessionDataTask *)vodGetPopularityChartWithCategoryId:(NSString *)categoryId WithRequestItems:(NSString *)requestItems block:(void (^)(NSArray *, NSError *))block
{
    self.smClient.responseSerializer = [AFXMLParserResponseSerializer new];
    self.smClient.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/xml"];
    
    NSString *sUrl = [NSString stringWithFormat:@"%@.xml", CNM_OPEN_API_INTERFACE_GetPopularityChart];
    NSDictionary *dict = @{
                           CNM_OPEN_API_VERSION_KEY : CNM_OPEN_API_VERSION,
                           CNM_OPEN_API_TERMINAL_KEY_KEY : CNM_REAL_TEST_TERMINAL_KEY,
                           @"categoryId" : categoryId,
                           @"requestItems" : requestItems
                           };
    
    return [self.smClient GET:sUrl parameters:dict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        NSDictionary* result = [NSDictionary dictionaryWithXMLParser:(NSXMLParser*)responseObject];
        
        block(@[result], nil);
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        block(nil, error);
    }];
}

- (NSURLSessionDataTask *)vodGetContentGroupListWithContentGroupProfile:(NSString *)contentGroupProfile WithCategoryId:(NSString *)categoryId block:(void (^)(NSArray *, NSError *))block
{
    self.smClient.responseSerializer = [AFXMLParserResponseSerializer new];
    self.smClient.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/xml"];
    
    NSString *sUrl = [NSString stringWithFormat:@"%@.xml", CNM_OPEN_API_INTERFACE_GetContentGroupList];
    NSDictionary *dict = @{
                           CNM_OPEN_API_VERSION_KEY : CNM_OPEN_API_VERSION,
                           CNM_OPEN_API_TERMINAL_KEY_KEY : CNM_REAL_TEST_TERMINAL_KEY,
                           @"contentGroupProfile" : contentGroupProfile,
                           @"categoryId" : categoryId
                           };
    
    return [self.smClient GET:sUrl parameters:dict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        NSDictionary* result = [NSDictionary dictionaryWithXMLParser:(NSXMLParser *)responseObject];
        
        block(@[result], nil);
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        block(nil, error);
    }];
}

- (NSURLSessionDataTask *)vodGetAssetInfoWithAssetId:(NSString *)assetId WithAssetProfile:(NSString *)assetProfile block:(void (^)(NSArray *, NSError *))block
{
    self.smClient.responseSerializer = [AFXMLParserResponseSerializer new];
    self.smClient.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/xml"];
    
    NSString *sUrl = [NSString stringWithFormat:@"%@.xml", CNM_OPEN_API_INTERFACE_GetAssetInfo];
    NSDictionary *dict = @{
                          CNM_OPEN_API_VERSION_KEY : CNM_OPEN_API_VERSION,
                          CNM_OPEN_API_TERMINAL_KEY_KEY : CNM_REAL_TEST_TERMINAL_KEY,
                          @"assetId" : assetId,
                          @"assetProfile" : assetProfile
                          };
    
    return [self.smClient GET:sUrl parameters:dict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        NSDictionary* result = [NSDictionary dictionaryWithXMLParser:(NSXMLParser *)responseObject];
        
        block(@[result], nil);
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        block(nil, error);
    }];
}

- (NSURLSessionDataTask *)vodRecommendContentGroupByAssetId:(NSString *)assetId WithContentGroupProfile:(NSString *)contentGroupProfile block:(void (^)(NSArray *gets, NSError *error))block
{
    self.smClient.responseSerializer = [AFXMLParserResponseSerializer new];
    self.smClient.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/xml"];
    
    NSString *sUrl = [NSString stringWithFormat:@"%@.xml", CNM_OPEN_API_INTERFACE_RecommendContentGroupByAssetId];
    NSDictionary *dict = @{
                           CNM_OPEN_API_VERSION_KEY : CNM_OPEN_API_VERSION,
                           CNM_OPEN_API_TERMINAL_KEY_KEY : CNM_REAL_TEST_TERMINAL_KEY,
                           @"assetId" : assetId,
                           @"contentGroupProfile" : contentGroupProfile
                           };
    
    return [self.smClient GET:sUrl parameters:dict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        NSDictionary* result = [NSDictionary dictionaryWithXMLParser:(NSXMLParser *)responseObject];
        
        block(@[result], nil);
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        
        block(nil, error);
    }];
}

- (NSURLSessionDataTask *)vodGetBundleProductListWithProductProfile:(NSString *)productProfile block:(void (^)(NSArray *gets, NSError *error))block
{
    self.smClient.responseSerializer = [AFXMLParserResponseSerializer new];
    self.smClient.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/xml"];
    
    NSString *sUrl = [NSString stringWithFormat:@"%@.xml", CNM_OPEN_API_INTERFACE_GetBundleProductList];
    NSDictionary *dict = @{
                           CNM_OPEN_API_VERSION_KEY : CNM_OPEN_API_VERSION,
                           CNM_OPEN_API_TERMINAL_KEY_KEY : CNM_REAL_TEST_TERMINAL_KEY,
                           @"productProfile" : productProfile
                           };
    
    return [self.smClient GET:sUrl parameters:dict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
       
        NSDictionary* result = [NSDictionary dictionaryWithXMLParser:(NSXMLParser *)responseObject];
        
        block(@[result], nil);
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        
        block(nil, error);
    }];
}

//- (NSURLSessionDataTask *)vodGetServicebannerlistBlock:(void(^)(NSArray *vod, NSError *error))block
//{
//    self.smClient.responseSerializer = [AFXMLParserResponseSerializer new];
//    self.smClient.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/xml"];
//    
//    NSString *sUrl = [NSString stringWithFormat:@"%@.xml", ];
//}

@end

@implementation CMNetworkManager ( PAIRING )

- (NSURLSessionDataTask *)pairingAddUserWithAuthCode:(NSString *)authCode completion:(void (^)(NSArray *pairing, NSError *error))block
{
    self.smClient.responseSerializer = [AFXMLParserResponseSerializer new];
    self.smClient.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/xml"];
    
    NSString *sUrl = [NSString stringWithFormat:@"%@.xml", CNM_OPEN_API_INTERFACE_AddUser];
    NSDictionary *dict = @{
                           CNM_OPEN_API_VERSION_KEY : CNM_OPEN_API_VERSION,
                           CNM_OPEN_API_TERMINAL_KEY_KEY : CNM_PUBLIC_TERMINAL_KEY,
                           @"userId" : @"1234567899",
                           @"authCode" : authCode
                           };
    
    return [self.smClient GET:sUrl parameters:dict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
       
        NSDictionary* result = [NSDictionary dictionaryWithXMLParser:(NSXMLParser *)responseObject];
        
        block(@[result], nil);
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        
        block(nil, error);
    }];
}

- (NSURLSessionDataTask *)pairingAuthenticateDeviceCompletion:(void (^)(NSArray *pairing, NSError *error))block
{
    self.smClient.responseSerializer = [AFXMLParserResponseSerializer new];
    self.smClient.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/xml"];
    
    NSString *sUrl = [NSString stringWithFormat:@"%@.xml", CNM_OPEN_API_INTERFACE_AuthenticateDevice];
    NSDictionary *dict = @{
                           CNM_OPEN_API_VERSION_KEY : CNM_OPEN_API_VERSION,
                           @"secondDeviceId" : @"1234567899"
                           };
    
    return [self.smClient GET:sUrl parameters:dict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
       
        NSDictionary* result = [NSDictionary dictionaryWithXMLParser:(NSXMLParser *)responseObject];
        
        block(@[result], nil);
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        
        block(nil, error);
    }];
}

// !! TEST BJK
// 현재 privte 터미널 키를 서버 이슈로 못받고 있기 때문에 public 터미널 키를 박음 수정 해야함
- (NSURLSessionDataTask *)pvrGetrecordlistCompletion:(void (^)(NSArray *pvr, NSError *error))block;
{

    self.rumClientVpn.responseSerializer = [AFXMLParserResponseSerializer new];
    self.rumClientVpn.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSString *sUrl = [NSString stringWithFormat:@"%@.asp", CNM_OPEN_API_INTERFACE_DEV_Getrecordlist];
    NSDictionary *dict = @{
                           CNM_OPEN_API_VERSION_KEY : CNM_OPEN_API_VERSION,
                           CNM_OPEN_API_TERMINAL_KEY_KEY : CNM_PUBLIC_TERMINAL_KEY,
                           @"deviceId" : @"1234567889"
                           };
    return [self.rumClientVpn GET:sUrl parameters:dict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
       
        NSDictionary* result = [NSDictionary dictionaryWithXMLParser:(NSXMLParser *)responseObject];
        
        block(@[result], nil);
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        
        block(nil, error);
    }];
}

- (NSURLSessionDataTask *)pvrGetrecordReservelistCompletion:(void (^)(NSArray *pvr, NSError *error))block;
{
    self.rumClientVpn.responseSerializer = [AFXMLParserResponseSerializer new];
    self.rumClientVpn.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSString *sUrl = [NSString stringWithFormat:@"%@.asp", CNM_OPEN_API_INTERFACE_DEV_GetrecordReservelist];
    NSDictionary *dict = @{
                           CNM_OPEN_API_VERSION_KEY : @"1",
                           CNM_OPEN_API_TERMINAL_KEY_KEY : CNM_REAL_TEST_TERMINAL_KEY,
                           @"deviceId" : @"739d8470f604cfceb13784ab94fc368256253477"
                           };
    return [self.rumClientVpn GET:sUrl parameters:dict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        NSDictionary* result = [NSDictionary dictionaryWithXMLParser:(NSXMLParser *)responseObject];
        
        block(@[result], nil);
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        
        block(nil, error);
    }];
    
    
//    
//    self.rumClientVpn.responseSerializer = [AFXMLParserResponseSerializer new];
//    self.rumClientVpn.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
//    
//    NSString *sUrl = [NSString stringWithFormat:@"%@.asp", CNM_OPEN_API_INTERFACE_DEV_GetrecordReservelist];
//    NSDictionary *dict = @{
//                           CNM_OPEN_API_VERSION_KEY : CNM_OPEN_API_VERSION,
//                           CNM_OPEN_API_TERMINAL_KEY_KEY : CNM_REAL_TEST_TERMINAL_KEY,
//                           @"deviceId" : @"739d8470f604cfceb13784ab94fc368256253477"
//                           };
//    
//    return [self.rumClientVpn GET:sUrl parameters:dict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
//        
//        NSDictionary* result = [NSDictionary dictionaryWithXMLParser:(NSXMLParser *)responseObject];
//        
//        block(@[result], nil);
//    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
//        block(nil, error);
//    }];

}

@end

